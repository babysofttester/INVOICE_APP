// lib/services/auto_backup_service.dart
//
// ★ ROOT-CAUSE FIX vs your previous version: `enable()` / `reconnectFolder()`
// used to call `_safUtil.pickDirectory()` (from the `saf_util` package)
// and just trust that it persisted the folder grant. It often doesn't,
// reliably, across app restarts — that's why writes worked right after
// picking a folder but silently died later ("access lost" / never
// synced again), even though the retry/backoff logic below was already
// correct.
//
// Fix (same one Spendly uses): pick + persist via a native MethodChannel
// that calls Android's `takePersistableUriPermission` directly — see
// `saf_permission_channel.dart` + `MainActivity.kt`. Everything else
// (single-file-per-invoice backup, retry-before-fail, "Permission
// Denial" detection, delete+recreate fallback) is unchanged.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:saf_stream/saf_stream.dart';
import 'package:saf_util/saf_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'saf_permission_channel.dart';
import '../models/invoice.dart';
import 'invoice_storage_service.dart';

class AutoBackupService {
  AutoBackupService._();
  static final AutoBackupService instance = AutoBackupService._();

  static const _kEnabledKey = 'auto_backup_enabled';
  static const _kDirUriKey = 'auto_backup_dir_uri';

  final SafUtil _safUtil = SafUtil();
  final SafStream _safStream = SafStream();

  final ValueNotifier<bool> isEnabled = ValueNotifier<bool>(false);
  final ValueNotifier<DateTime?> lastSyncedAt = ValueNotifier<DateTime?>(null);
  final ValueNotifier<bool> lastSyncFailed = ValueNotifier<bool>(false);
  final ValueNotifier<String?> lastSyncError = ValueNotifier<String?>(null);
  final ValueNotifier<bool> isSyncing = ValueNotifier<bool>(false);

  SharedPreferences? _prefs;
  bool _initialized = false;

  bool get available => !kIsWeb && Platform.isAndroid;

  String? get currentFolderUri => _prefs?.getString(_kDirUriKey);

  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    isEnabled.value = available && (_prefs!.getBool(_kEnabledKey) ?? false);
    _initialized = true;

    if (isEnabled.value) {
      unawaited(backupAll());
    }
  }

  Future<void> _ensureInit() async {
    if (!_initialized) await init();
  }

  /// ★ FIXED — now picks AND persists via the native channel in one
  /// call, instead of `_safUtil.pickDirectory()`.
  Future<bool> enable() async {
    if (!available) {
      throw Exception('Auto-backup is only available on Android right now.');
    }
    await _ensureInit();

    String? treeUri;
    try {
      treeUri = await SafPermissionChannel.pickDirectoryAndPersist();
    } on PlatformException catch (e) {
      debugPrint('❌ pickDirectoryAndPersist FAILED: ${e.code} - ${e.message}');
      lastSyncFailed.value = true;
      lastSyncError.value =
          'Could not save folder permission permanently (${e.code}). Please try again.';
      return false;
    }

    if (treeUri == null) return false; // user cancelled the picker

    await _prefs!.setString(_kDirUriKey, treeUri);
    await _prefs!.setBool(_kEnabledKey, true);
    isEnabled.value = true;
    lastSyncFailed.value = false;
    lastSyncError.value = null;

    await backupAll();
    return true;
  }

  /// ★ FIXED — same native pick+persist call, so a genuine reconnect
  /// actually sticks this time instead of dying again after restart.
  Future<bool> reconnectFolder() async {
    if (!available) return false;
    await _ensureInit();

    String? treeUri;
    try {
      treeUri = await SafPermissionChannel.pickDirectoryAndPersist();
    } on PlatformException catch (e) {
      debugPrint('❌ pickDirectoryAndPersist FAILED: ${e.code} - ${e.message}');
      lastSyncFailed.value = true;
      lastSyncError.value =
          'Could not save folder permission permanently (${e.code}). Please try again.';
      return false;
    }

    if (treeUri == null) return false;

    await _prefs!.setString(_kDirUriKey, treeUri);
    await _prefs!.setBool(_kEnabledKey, true);
    isEnabled.value = true;
    lastSyncFailed.value = false;
    lastSyncError.value = null;

    await backupAll();
    return true;
  }

  Future<void> disable() async {
    await _ensureInit();
    await _prefs!.remove(_kDirUriKey);
    await _prefs!.setBool(_kEnabledKey, false);
    isEnabled.value = false;
    lastSyncFailed.value = false;
    lastSyncError.value = null;
  }

  Future<void> backupInvoice(Invoice invoice) async {
    if (!available) return;
    await _ensureInit();
    if (!isEnabled.value) return;

    final treeUri = _prefs!.getString(_kDirUriKey);
    if (treeUri == null || invoice.pdfBase64.isEmpty) return;

    isSyncing.value = true;
    try {
      await _attemptWriteSingle(treeUri, invoice);
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> backupAll() async {
    if (!available) return;
    await _ensureInit();
    if (!isEnabled.value) return;

    final treeUri = _prefs!.getString(_kDirUriKey);
    if (treeUri == null) return;

    isSyncing.value = true;
    try {
      final invoices = InvoiceStorageService.instance.getAll();
      for (final invoice in invoices) {
        if (invoice.pdfBase64.isEmpty) continue;
        final ok = await _attemptWriteSingle(treeUri, invoice);
        if (!ok) return;
      }
      lastSyncedAt.value = DateTime.now();
      lastSyncFailed.value = false;
      lastSyncError.value = null;
    } finally {
      isSyncing.value = false;
    }
  }

  Future<bool> _attemptWriteSingle(
    String treeUri,
    Invoice invoice, {
    int retriesLeft = 2,
  }) async {
    final fileName = '${_safeFileName(invoice.number)}.pdf';

    try {
      final bytes = base64Decode(invoice.pdfBase64);

      await _safStream.writeFileBytes(
        treeUri,
        fileName,
        'application/pdf',
        Uint8List.fromList(bytes),
        overwrite: true,
      );

      lastSyncedAt.value = DateTime.now();
      lastSyncFailed.value = false;
      lastSyncError.value = null;
      return true;
    } catch (e, stack) {
      debugPrint('❌ AutoBackupService write FAILED for $fileName: $e');
      debugPrint('$stack');

      final msg = e.toString();

      if (msg.contains('Permission Denial')) {
        lastSyncFailed.value = true;
        lastSyncError.value =
            'Your phone revoked the folder access (common on some phones to save battery). '
            'Tap "Reconnect Folder" below to fix it.';
        return false;
      }

      if (retriesLeft > 0) {
        final delaySeconds = (3 - retriesLeft) * 2 + 2;
        await Future.delayed(Duration(seconds: delaySeconds));
        return _attemptWriteSingle(treeUri, invoice, retriesLeft: retriesLeft - 1);
      }

      if (msg.contains('File creation failed')) {
        try {
          final existing = await _safUtil.child(treeUri, [fileName]);
          if (existing != null) {
            await _safUtil.delete(existing.uri, false);
          }

          final bytes = base64Decode(invoice.pdfBase64);
          await _safStream.writeFileBytes(
            treeUri,
            fileName,
            'application/pdf',
            Uint8List.fromList(bytes),
            overwrite: true,
          );

          lastSyncedAt.value = DateTime.now();
          lastSyncFailed.value = false;
          lastSyncError.value = null;
          return true;
        } catch (e2, s2) {
          debugPrint('❌ AutoBackupService delete+recreate fallback FAILED: $e2');
          debugPrint('$s2');
          lastSyncFailed.value = true;
          lastSyncError.value = e2.toString();
          return false;
        }
      }

      lastSyncFailed.value = true;
      lastSyncError.value = msg;
      return false;
    }
  }

  String _safeFileName(String raw) =>
      raw.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
}