// import 'dart:convert';
// import 'package:hive_ce_flutter/hive_flutter.dart';

// /// The shop/business info the user sets once and reuses on every invoice
// /// (name, tagline, phone, address, logo) so every generated PDF looks
// /// consistent and professional without retyping details each time.
// class BusinessProfile {
//   final String name;
//   final String subtitle; // e.g. "Retail & Wholesale"
//   final String phone;
//   final String address;

//   /// Base64-encoded logo image (png/jpg bytes). Stored as base64 —
//   /// same reason as PDFs: works identically on Android, iOS, desktop
//   /// AND web with no writable file system.
//   final String logoBase64;

//   const BusinessProfile({
//     this.name = 'Your Business Name',
//     this.subtitle = '',
//     this.phone = '',
//     this.address = '',
//     this.logoBase64 = '',
//   });

//   bool get hasLogo => logoBase64.isNotEmpty;

//   Map<String, dynamic> toJson() => {
//         'name': name,
//         'subtitle': subtitle,
//         'phone': phone,
//         'address': address,
//         'logoBase64': logoBase64,
//       };

//   factory BusinessProfile.fromJson(Map<String, dynamic> json) => BusinessProfile(
//         name: json['name'] as String? ?? 'Your Business Name',
//         subtitle: json['subtitle'] as String? ?? '',
//         phone: json['phone'] as String? ?? '',
//         address: json['address'] as String? ?? '',
//         logoBase64: json['logoBase64'] as String? ?? '',
//       );

//   BusinessProfile copyWith({
//     String? name,
//     String? subtitle,
//     String? phone,
//     String? address,
//     String? logoBase64,
//   }) =>
//       BusinessProfile(
//         name: name ?? this.name,
//         subtitle: subtitle ?? this.subtitle,
//         phone: phone ?? this.phone,
//         address: address ?? this.address,
//         logoBase64: logoBase64 ?? this.logoBase64,
//       );

//   /// Explicit removal helper, since copyWith can't distinguish
//   /// "leave as is" from "clear it" for a String field.
//   BusinessProfile clearLogo() => BusinessProfile(
//         name: name,
//         subtitle: subtitle,
//         phone: phone,
//         address: address,
//         logoBase64: '',
//       );
// }

// class BusinessProfileService {
//   BusinessProfileService._();
//   static final BusinessProfileService instance = BusinessProfileService._();

//   static const _boxName = 'business_profile';
//   static const _key = 'profile';
//   Box<String>? _box;

//   Future<void> init() async {
//     // Hive.initFlutter() is already called once by InvoiceStorageService.init(),
//     // so we only need to open our own box here.
//     _box = await Hive.openBox<String>(_boxName);
//   }

//   Box<String> get _requireBox {
//     final box = _box;
//     if (box == null) {
//       throw StateError(
//           'BusinessProfileService.init() must be awaited before use (call it in main()).');
//     }
//     return box;
//   }

//   BusinessProfile get() {
//     final raw = _requireBox.get(_key);
//     if (raw == null) return const BusinessProfile();
//     return BusinessProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
//   }

//   Future<void> save(BusinessProfile profile) async {
//     await _requireBox.put(_key, jsonEncode(profile.toJson()));
//   }

//   /// True until the user has saved anything — used to show a one-time
//   /// "set up your business details" nudge.
//   bool get isUnset => _requireBox.get(_key) == null;
// }
import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// The shop/business info the user sets once and reuses on every invoice
/// (name, tagline, phone, address, logo) so every generated PDF looks
/// consistent and professional without retyping details each time.
///
/// Unchanged from the Hive version — only the storage backend moved.
class BusinessProfile {
  final String name;
  final String subtitle; // e.g. "Retail & Wholesale"
  final String phone;
  final String address;

  /// Base64-encoded logo image (png/jpg bytes). Stored as base64 —
  /// same reason as PDFs: works identically on Android, iOS, desktop
  /// AND web with no writable file system.
  final String logoBase64;

  const BusinessProfile({
    this.name = 'Your Business Name',
    this.subtitle = '',
    this.phone = '',
    this.address = '',
    this.logoBase64 = '',
  });

  bool get hasLogo => logoBase64.isNotEmpty;

  BusinessProfile copyWith({
    String? name,
    String? subtitle,
    String? phone,
    String? address,
    String? logoBase64,
  }) =>
      BusinessProfile(
        name: name ?? this.name,
        subtitle: subtitle ?? this.subtitle,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        logoBase64: logoBase64 ?? this.logoBase64,
      );

  /// Explicit removal helper, since copyWith can't distinguish
  /// "leave as is" from "clear it" for a String field.
  BusinessProfile clearLogo() => BusinessProfile(
        name: name,
        subtitle: subtitle,
        phone: phone,
        address: address,
        logoBase64: '',
      );
}

class BusinessProfileService {
  BusinessProfileService._();
  static final BusinessProfileService instance = BusinessProfileService._();

  static const _rowId = 0;

  AppDatabase get _db => AppDatabase.instance;

  // Cached in memory so `get()` and `isUnset` can stay synchronous —
  // exactly how every screen already calls them (BusinessProfileScreen,
  // NewInvoiceScreen, etc. all read this outside of any FutureBuilder).
  BusinessProfile _cached = const BusinessProfile();
  bool _isSet = false;

  Future<void> init() async {
    final row = await (_db.select(_db.businessProfileTable)
          ..where((t) => t.id.equals(_rowId)))
        .getSingleOrNull();

    if (row != null) {
      _cached = BusinessProfile(
        name: row.name,
        subtitle: row.subtitle,
        phone: row.phone,
        address: row.address,
        logoBase64: row.logoBase64,
      );
      _isSet = true;
    }
  }

  BusinessProfile get() => _cached;

  Future<void> save(BusinessProfile profile) async {
    _cached = profile;
    _isSet = true;

    await _db.into(_db.businessProfileTable).insertOnConflictUpdate(
          BusinessProfileTableCompanion.insert(
               id: Value(_rowId),                    // ← yahan Value() lagao            name: Value(profile.name),
            subtitle: Value(profile.subtitle),
            phone: Value(profile.phone),
            address: Value(profile.address),
            logoBase64: Value(profile.logoBase64),
          ),
        );
  }

  /// True until the user has saved anything — used to show a one-time
  /// "set up your business details" nudge.
  bool get isUnset => !_isSet;
}