// lib/services/auto_backup_service.dart
//
// "No Google API key" auto-backup using Android's Storage Access
// Framework (SAF), via `saf_util` (folder picker) + `saf_stream`
// (file read/write). The user picks a folder once — they can navigate
// into their Google Drive there, since the Drive app registers itself
// as a Documents Provider. SAF persists that permission automatically.
//
// Unlike a single combined export, this app backs up EVERY invoice as
// its own PDF file (same bytes as `invoice.pdfBase64`, same file the
// user already gets from "Preview / Print / Save as PDF"). Each time a
// new invoice is generated, or an existing one is edited, only that one
// PDF is (re)written — cheap, and the Drive folder always mirrors what's
// on the device.
//
// LIMITATION: Android only (same as Spendly's implementation) — iOS
// doesn't expose Drive this way, so this is gated behind
// AutoBackupService.instance.available in the UI.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:saf_stream/saf_stream.dart';
import 'package:saf_util/saf_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/invoice.dart';
import 'invoice_storage_service.dart';

class AutoBackupService {
  AutoBackupService._();
  static final AutoBackupService instance = AutoBackupService._();

  static const _kEnabledKey = 'auto_backup_enabled';
  static const _kDirUriKey = 'auto_backup_dir_uri';

  final SafUtil _safUtil = SafUtil();
  final SafStream _safStream = SafStream();

  /// Drives the Settings switch.
  final ValueNotifier<bool> isEnabled = ValueNotifier<bool>(false);

  /// Timestamp of the last successful sync, for "Last synced: ..." in UI.
  final ValueNotifier<DateTime?> lastSyncedAt = ValueNotifier<DateTime?>(null);

  /// True if the last sync attempt failed (e.g. folder access revoked).
  /// Doesn't silently flip [isEnabled] off — same reasoning as Spendly's
  /// version: a transient failure shouldn't make the toggle lie to the
  /// user about being on.
  final ValueNotifier<bool> lastSyncFailed = ValueNotifier<bool>(false);

  /// True while a backup (single invoice or full resync) is in progress.
  final ValueNotifier<bool> isSyncing = ValueNotifier<bool>(false);

  SharedPreferences? _prefs;
  bool _initialized = false;

  bool get available => !kIsWeb && Platform.isAndroid;

  /// Call once at app start (main.dart, alongside
  /// InvoiceStorageService.instance.init()) so `isEnabled` is loaded
  /// before the first invoice is generated. Safe to call again from the
  /// Settings screen too — it's a no-op after the first successful run.
  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    isEnabled.value = available && (_prefs!.getBool(_kEnabledKey) ?? false);
    _initialized = true;
  }

  Future<void> _ensureInit() async {
    if (!_initialized) await init();
  }

  /// Shows the native folder picker. Returns false if the user cancels.
  /// On success, immediately does a full resync so any invoices that
  /// were already generated before auto-backup was turned on also show
  /// up in the Drive folder right away.
  Future<bool> enable() async {
    if (!available) {
      throw Exception('Auto-backup is only available on Android right now.');
    }
    await _ensureInit();

    final dir = await _safUtil.pickDirectory();
    if (dir == null) return false; // user cancelled the picker

    await _prefs!.setString(_kDirUriKey, dir.uri);
    await _prefs!.setBool(_kEnabledKey, true);
    isEnabled.value = true;
    lastSyncFailed.value = false;

    await backupAll();
    return true;
  }

  /// Turns auto-backup off. (saf_util doesn't expose an explicit
  /// "release permission" call — Android naturally drops grants the app
  /// stops using; clearing our stored reference is enough to stop.)
  Future<void> disable() async {
    await _ensureInit();
    await _prefs!.remove(_kDirUriKey);
    await _prefs!.setBool(_kEnabledKey, false);
    isEnabled.value = false;
  }

  /// Backs up a single invoice's PDF — call this right after
  /// saveInvoice() in NewInvoiceScreen so every "Generate" / "Update"
  /// immediately syncs, without waiting for the user to open Settings.
  Future<void> backupInvoice(Invoice invoice) async {
    if (!available) return;
    await _ensureInit();
    if (!isEnabled.value) return;

    final treeUri = _prefs!.getString(_kDirUriKey);
    if (treeUri == null || invoice.pdfBase64.isEmpty) return;

    isSyncing.value = true;
    try {
      final bytes = base64Decode(invoice.pdfBase64);
      final fileName = '${_safeFileName(invoice.number)}.pdf';

      await _safStream.writeFileBytes(
        treeUri,
        fileName,
        'application/pdf',
        Uint8List.fromList(bytes),
        overwrite: true,
      );

      lastSyncedAt.value = DateTime.now();
      lastSyncFailed.value = false;
    } catch (_) {
      lastSyncFailed.value = true;
    } finally {
      isSyncing.value = false;
    }
  }

  /// Re-writes every saved invoice's PDF. Called once right after the
  /// user turns auto-backup on; also exposed as a manual "Backup All
  /// Now" action in Settings.
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
        final bytes = base64Decode(invoice.pdfBase64);
        final fileName = '${_safeFileName(invoice.number)}.pdf';
        await _safStream.writeFileBytes(
          treeUri,
          fileName,
          'application/pdf',
          Uint8List.fromList(bytes),
          overwrite: true,
        );
      }
      lastSyncedAt.value = DateTime.now();
      lastSyncFailed.value = false;
    } catch (_) {
      lastSyncFailed.value = true;
    } finally {
      isSyncing.value = false;
    }
  }

  /// Invoice numbers can end up in a file name as-is (e.g.
  /// "INV-AB12CD-000004"), but strip anything a filesystem would choke
  /// on just in case.
  String _safeFileName(String raw) =>
      raw.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
}