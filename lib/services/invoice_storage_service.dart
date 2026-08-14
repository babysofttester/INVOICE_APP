import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../database/app_database.dart';
import '../models/invoice.dart';
import '../models/invoice_item_data.dart';
import 'device_id_service.dart';

/// Local, offline invoice database.
///
/// This used to be a Hive box; it's now a Drift/SQLite database (see
/// `database/app_database.dart`), which gives real relational storage
/// (invoices + a proper `invoice_items` table with a foreign key)
/// instead of one big JSON blob per invoice.
///
/// IMPORTANT: every screen in this app (HomeScreen, InvoicesScreen,
/// NewInvoiceScreen) calls getAll()/search()/nextInvoiceNumber()
/// *synchronously*, the same way it did with Hive's in-memory box. SQL
/// queries are inherently async, so this service keeps an in-memory
/// `List<Invoice>` cache that mirrors the database and is updated on
/// every write. Reads are served from that cache — nothing else in the
/// app had to change.
class InvoiceStorageService {
  InvoiceStorageService._();
  static final InvoiceStorageService instance = InvoiceStorageService._();

  static const _boxName = 'invoices'; // kept only as a comment anchor

  /// Bumps every time data changes (save/delete/payment update).
  /// Screens listen to this with ValueListenableBuilder so they refresh
  /// instantly — even while offstage inside an IndexedStack (fixes the
  /// "switch tabs and don't see the new invoice" issue).
  static final ValueNotifier<int> revision = ValueNotifier<int>(0);
  void _notifyChanged() => revision.value++;

  AppDatabase get _db => AppDatabase.instance;

  final List<Invoice> _cache = [];
  bool _loaded = false;

  Future<void> init() async {
    await _reloadCache();
    _loaded = true;
  }

  void _requireLoaded() {
    if (!_loaded) {
      throw StateError(
          'InvoiceStorageService.init() must be awaited before use (call it in main()).');
    }
  }

  Future<void> _reloadCache() async {
    final invoiceRows = await _db.select(_db.invoices).get();
    final itemRows = await _db.select(_db.invoiceItems).get();

    final itemsByInvoice = <String, List<InvoiceItemData>>{};
    for (final item in itemRows) {
      itemsByInvoice.putIfAbsent(item.invoiceId, () => []).add(
            InvoiceItemData(
              name: item.name,
              price: item.price,
              qty: item.qty,
              discount: item.discount,
            ),
          );
    }

    final invoices = invoiceRows
        .map((row) => Invoice(
              id: row.id,
              number: row.number,
              date: row.date,
              customerName: row.customerName,
              customerPhone: row.customerPhone,
              customerAddress: row.customerAddress,
              items: itemsByInvoice[row.id] ?? [],
              subtotal: row.subtotal,
              totalDiscount: row.totalDiscount,
              gstType: GstTypeX.fromStorage(row.gstType),
              gstRate: row.gstRate,
              cgstAmount: row.cgstAmount,
              sgstAmount: row.sgstAmount,
              igstAmount: row.igstAmount,
              grandTotal: row.grandTotal,
              pdfBase64: row.pdfBase64,
              paymentMode: PaymentModeX.fromStorage(row.paymentMode),
              businessName: row.businessName,
              businessSubtitle: row.businessSubtitle,
              businessPhone: row.businessPhone,
              businessAddress: row.businessAddress,
              businessLogoBase64: row.businessLogoBase64,
            ))
        .toList();

    invoices.sort((a, b) => b.date.compareTo(a.date));

    _cache
      ..clear()
      ..addAll(invoices);
  }

  String nextInvoiceNumber() {
    _requireLoaded();
    final prefix = 'INV-${DeviceIdService.instance.id}-';
    final existing = _cache.where((inv) => inv.number.startsWith(prefix));

    int highest = 0;
    for (final inv in existing) {
      final numPart = inv.number.substring(prefix.length);
      final n = int.tryParse(numPart);
      if (n != null && n > highest) highest = n;
    }

    return '$prefix${(highest + 1).toString().padLeft(6, '0')}';
  }

  Future<void> saveInvoice(Invoice invoice) async {
    await _db.transaction(() async {
      await _db.into(_db.invoices).insertOnConflictUpdate(
            InvoicesCompanion.insert(
              id: invoice.id,
              number: invoice.number,
              date: invoice.date,
              customerName: Value(invoice.customerName),
              customerPhone: Value(invoice.customerPhone),
              customerAddress: Value(invoice.customerAddress),
              subtotal: Value(invoice.subtotal),
              totalDiscount: Value(invoice.totalDiscount),
              gstType: Value(invoice.gstType.storageValue),
              gstRate: Value(invoice.gstRate),
              cgstAmount: Value(invoice.cgstAmount),
              sgstAmount: Value(invoice.sgstAmount),
              igstAmount: Value(invoice.igstAmount),
              grandTotal: Value(invoice.grandTotal),
              paymentMode: Value(invoice.paymentMode.storageValue),
              businessName: Value(invoice.businessName),
              businessSubtitle: Value(invoice.businessSubtitle),
              businessPhone: Value(invoice.businessPhone),
              businessAddress: Value(invoice.businessAddress),
              businessLogoBase64: Value(invoice.businessLogoBase64),
              pdfBase64: Value(invoice.pdfBase64),
            ),
          );

      // Items are fully replaced on every save — simplest way to stay
      // correct regardless of how many rows the form currently has
      // (items added/removed/edited all collapse to the same path).
      await (_db.delete(_db.invoiceItems)
            ..where((t) => t.invoiceId.equals(invoice.id)))
          .go();

      if (invoice.items.isNotEmpty) {
        await _db.batch((batch) {
          batch.insertAll(
            _db.invoiceItems,
            invoice.items.map(
              (item) => InvoiceItemsCompanion.insert(
                invoiceId: invoice.id,
                name: item.name,
                price: item.price,
                qty: item.qty,
                discount: item.discount,
              ),
            ),
          );
        });
      }
    });

    _cache.removeWhere((inv) => inv.id == invoice.id);
    _cache.add(invoice);
    _cache.sort((a, b) => b.date.compareTo(a.date));
    _notifyChanged();
  }

  Future<void> deleteInvoice(String id) async {
    // The invoice_items foreign key is ON DELETE CASCADE, so its line
    // items are removed automatically — no manual cleanup query needed.
    await (_db.delete(_db.invoices)..where((t) => t.id.equals(id))).go();

    _cache.removeWhere((inv) => inv.id == id);
    _notifyChanged();
  }

  Future<void> setPaymentMode(String id, PaymentMode mode) async {
    final updated = await (_db.update(_db.invoices)
          ..where((t) => t.id.equals(id)))
        .write(InvoicesCompanion(paymentMode: Value(mode.storageValue)));

    if (updated == 0) return;

    final index = _cache.indexWhere((inv) => inv.id == id);
    if (index != -1) {
      _cache[index] = _cache[index].copyWith(paymentMode: mode);
    }
    _notifyChanged();
  }

  List<Invoice> getAll() {
    _requireLoaded();
    return List.unmodifiable(_cache);
  }

  /// Plain text search (name / invoice number), no date filter.
  List<Invoice> search(String query) {
    _requireLoaded();
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return getAll();
    return _cache.where((inv) {
      return inv.customerName.toLowerCase().contains(q) ||
          inv.number.toLowerCase().contains(q);
    }).toList();
  }

  /// Search + strict date filter. When [from]/[to] are given, ONLY
  /// invoices with a date inside [from, to] (inclusive, whole days) are
  /// returned — never fewer, never more than that window, regardless of
  /// the text query. Pass both null to disable date filtering entirely.
  List<Invoice> searchWithRange(String query, {DateTime? from, DateTime? to}) {
    _requireLoaded();
    Iterable<Invoice> result = _cache;

    if (from != null) {
      final start = DateTime(from.year, from.month, from.day);
      result = result.where((inv) => !inv.date.isBefore(start));
    }
    if (to != null) {
      final end = DateTime(to.year, to.month, to.day, 23, 59, 59, 999);
      result = result.where((inv) => !inv.date.isAfter(end));
    }

    final q = query.trim().toLowerCase();
    if (q.isNotEmpty) {
      result = result.where((inv) =>
          inv.customerName.toLowerCase().contains(q) ||
          inv.number.toLowerCase().contains(q));
    }

    final list = result.toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }
}