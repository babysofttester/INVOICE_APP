// lib/services/saf_permission_channel.dart
//
// Ported from Spendly's working implementation. Calls Android's
// `takePersistableUriPermission` directly via a native MethodChannel,
// instead of trusting `saf_util`'s pickDirectory() to have persisted
// the grant. This is the actual root cause fix: saf_util's pick call
// does NOT reliably persist the permission across app restarts on all
// OEMs, which is why auto-backup here was dying silently after the
// first successful write.
//
// Requires the matching native handler in MainActivity.kt (Android) —
// see android_saf_channel.kt in this same delivery for the Kotlin side.
// IMPORTANT: update the channel name below to match whatever you
// register in MainActivity.kt (they must be identical strings).

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class SafPermissionChannel {
  // ★ CHANGE if you pick a different channel name in MainActivity.kt —
  // must match exactly on both sides.
  static const _channel = MethodChannel('com.invoicenow.app/saf_persist');

  /// Pick + persist in a single native call, using the exact same
  /// flags that come back in the picker's Intent result. Returns the
  /// picked folder's tree URI as a String, or null if the user
  /// cancelled the picker. Throws [PlatformException] if persisting
  /// genuinely fails — callers must surface this to the user rather
  /// than silently swallowing it.
  static Future<String?> pickDirectoryAndPersist() async {
    final result =
        await _channel.invokeMethod<String>('pickDirectoryAndPersist');
    return result;
  }

  static Future<bool> persist(String uri) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'persistUriPermission',
        {'uri': uri},
      );
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('❌ persistUriPermission FAILED: code=${e.code} message=${e.message}');
      return false;
    }
  }

  static Future<bool> hasPermission(String uri) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'hasPersistedPermission',
        {'uri': uri},
      );
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('❌ hasPersistedPermission FAILED: code=${e.code} message=${e.message}');
      return false;
    }
  }
}