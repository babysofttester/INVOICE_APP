// import 'dart:math';

// import 'package:hive_ce_flutter/hive_flutter.dart';

// /// Generates and permanently stores a short, random "Install ID" the
// /// very first time the app runs — on Android, iOS, macOS, Windows,
// /// Linux, or in a browser (Web).
// ///
// /// This exists because there's no reliable, privacy-safe way to get a
// /// true hardware device ID that works identically everywhere:
// /// - `device_info_plus` doesn't give a stable ID on Web (browsers don't
// ///   expose one, by design, for privacy).
// /// - Even on mobile, hardware IDs require extra permissions and can
// ///   change after a factory reset.
// ///
// /// A random locally-generated ID sidesteps all of that: it doesn't need
// /// any permission, works the same on every platform, and is stable for
// /// as long as the app's local storage isn't cleared/uninstalled.
// class DeviceIdService {
//   DeviceIdService._();
//   static final DeviceIdService instance = DeviceIdService._();

//   static const _boxName = 'app_meta';
//   static const _key = 'install_id';

//   // Uppercase letters + digits, with visually-confusable characters
//   // removed (0/O and 1/I) so a human reading it off an invoice or a
//   // support screenshot never mistypes it.
//   static const _charset = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

//   Box<String>? _box;
//   String? _cachedId;

//   Future<void> init() async {
//     await Hive.initFlutter();
//     _box = await Hive.openBox<String>(_boxName);

//     final existing = _box!.get(_key);
//     if (existing != null && existing.isNotEmpty) {
//       _cachedId = existing;
//     } else {
//       final generated = _generate();
//       await _box!.put(_key, generated);
//       _cachedId = generated;
//     }
//   }

//   String _generate() {
//     final rand = Random.secure();
//     return List.generate(4, (_) => _charset[rand.nextInt(_charset.length)]).join();
//   }

//   /// The persistent 4-character install ID for this device/browser.
//   /// e.g. "LK82". Stable across app restarts; only changes if local
//   /// storage is cleared or the app is reinstalled.
//   String get id {
//     final cached = _cachedId;
//     if (cached == null) {
//       throw StateError(
//           'DeviceIdService.init() must be awaited before use (call it in main()).');
//     }
//     return cached;
//   }
// }
import 'dart:math';

import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// Generates and permanently stores a short, random "Install ID" the
/// very first time the app runs — on Android, iOS, macOS, Windows,
/// Linux, or in a browser (Web).
///
/// Now backed by Drift/SQLite instead of Hive, but the public API is
/// unchanged: `init()` once in main(), then read the synchronous `id`
/// getter anywhere.
class DeviceIdService {
  DeviceIdService._();
  static final DeviceIdService instance = DeviceIdService._();

  // Uppercase letters + digits, with visually-confusable characters
  // removed (0/O and 1/I) so a human reading it off an invoice or a
  // support screenshot never mistypes it.
  static const _charset = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  static const _rowId = 0;

  AppDatabase get _db => AppDatabase.instance;

  String? _cachedId;

  Future<void> init() async {
    final existing = await (_db.select(_db.deviceMeta)
          ..where((t) => t.id.equals(_rowId)))
        .getSingleOrNull();

    if (existing != null && existing.installId.isNotEmpty) {
      _cachedId = existing.installId;
    } else {
      final generated = _generate();
      await _db.into(_db.deviceMeta).insertOnConflictUpdate(
            DeviceMetaCompanion.insert(id: Value(_rowId),
installId: generated,),
          );
      _cachedId = generated;
    }
  }

  String _generate() {
    final rand = Random.secure();
    return List.generate(4, (_) => _charset[rand.nextInt(_charset.length)]).join();
  }

  /// The persistent 4-character install ID for this device/browser.
  /// e.g. "LK82". Stable across app restarts; only changes if local
  /// storage is cleared or the app is reinstalled.
  String get id {
    final cached = _cachedId;
    if (cached == null) {
      throw StateError(
          'DeviceIdService.init() must be awaited before use (call it in main()).');
    }
    return cached;
  }
}