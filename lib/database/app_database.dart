import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
 
part 'app_database.g.dart';
 
// ---------------------------------------------------------------------
// Tables
// ---------------------------------------------------------------------
//
// @DataClassName is important here: by default Drift would name the
// generated row class for `Invoices` as `Invoice`, which collides with
// the app's own `Invoice` model in models/invoice.dart. Renaming the
// generated classes keeps the two completely separate — the Drift row
// classes never leave `invoice_storage_service.dart`.
 
@DataClassName('InvoiceRow')
class Invoices extends Table {
  // Same value as Invoice.id/number in the app model — used as the
  // primary key so saveInvoice() can just upsert.
  TextColumn get id => text()();
  TextColumn get number => text()();
  DateTimeColumn get date => dateTime()();
 
  TextColumn get customerName => text().withDefault(const Constant(''))();
  TextColumn get customerPhone => text().withDefault(const Constant(''))();
  TextColumn get customerAddress => text().withDefault(const Constant(''))();
 
  RealColumn get subtotal => real().withDefault(const Constant(0))();
  RealColumn get totalDiscount => real().withDefault(const Constant(0))();

  // --- GST snapshot at generation time -----------------------------
  // gstType is one of PaymentMode-style storage strings:
  // 'none' | 'cgstSgst' | 'igst' (see GstType in models/invoice.dart).
  TextColumn get gstType => text().withDefault(const Constant('none'))();
  RealColumn get gstRate => real().withDefault(const Constant(0))();
  RealColumn get cgstAmount => real().withDefault(const Constant(0))();
  RealColumn get sgstAmount => real().withDefault(const Constant(0))();
  RealColumn get igstAmount => real().withDefault(const Constant(0))();
  // -------------------------------------------------------------------

  RealColumn get grandTotal => real().withDefault(const Constant(0))();
 
  // Stored as PaymentMode.name (same as the old Hive `storageValue`).
  TextColumn get paymentMode => text().withDefault(const Constant('unpaid'))();
 
  // Business-details snapshot at generation time (unchanged behaviour
  // from the Hive version — editing the profile later never changes an
  // already-generated invoice).
  TextColumn get businessName =>
      text().withDefault(const Constant('Your Business Name'))();
  TextColumn get businessSubtitle => text().withDefault(const Constant(''))();
  TextColumn get businessPhone => text().withDefault(const Constant(''))();
  TextColumn get businessAddress => text().withDefault(const Constant(''))();
  TextColumn get businessLogoBase64 => text().withDefault(const Constant(''))();
 
  TextColumn get pdfBase64 => text().withDefault(const Constant(''))();
 
  @override
  Set<Column> get primaryKey => {id};
}
 
@DataClassName('InvoiceItemRow')
class InvoiceItems extends Table {
  IntColumn get itemId => integer().autoIncrement()();
 
  // Cascades on delete so wiping an invoice automatically wipes its
  // line items — no manual cleanup needed in deleteInvoice().
  TextColumn get invoiceId =>
      text().references(Invoices, #id, onDelete: KeyAction.cascade)();
 
  TextColumn get name => text()();
  RealColumn get price => real()();
  IntColumn get qty => integer()();
  RealColumn get discount => real()();
}
 
@DataClassName('BusinessProfileRow')
class BusinessProfileTable extends Table {
  // Single-row "table" (id is always 0) — same trick the Hive version
  // used with a single fixed key.
  IntColumn get id => integer()();
  TextColumn get name =>
      text().withDefault(const Constant('Your Business Name'))();
  TextColumn get subtitle => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get logoBase64 => text().withDefault(const Constant(''))();
 
  @override
  Set<Column> get primaryKey => {id};
}
 
@DataClassName('DeviceMetaRow')
class DeviceMeta extends Table {
  IntColumn get id => integer()();
  TextColumn get installId => text()();
 
  @override
  Set<Column> get primaryKey => {id};
}
 
/// Tracks whether the one-time Hive → Drift data migration has already
/// run (see `services/hive_migration_service.dart`), so it never
/// re-imports the same data twice.
@DataClassName('MigrationStateRow')
class MigrationState extends Table {
  IntColumn get id => integer()();
  BoolColumn get hiveMigrated => boolean().withDefault(const Constant(false))();
 
  @override
  Set<Column> get primaryKey => {id};
}
 
// ---------------------------------------------------------------------
// Database
// ---------------------------------------------------------------------
 
@DriftDatabase(
  tables: [Invoices, InvoiceItems, BusinessProfileTable, DeviceMeta, MigrationState],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(_openConnection());
 
  static final AppDatabase instance = AppDatabase._();
 
  @override
  int get schemaVersion => 3;
 
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Added after the initial schema — needed by anyone who
            // already had a v1 Drift database on disk.
            await m.createTable(migrationState);
          }
          if (from < 3) {
            // GST feature — new columns on an already-existing
            // Invoices table. Existing rows get the column defaults
            // ('none' / 0), so old invoices simply show no GST.
            await m.addColumn(invoices, invoices.gstType);
            await m.addColumn(invoices, invoices.gstRate);
            await m.addColumn(invoices, invoices.cgstAmount);
            await m.addColumn(invoices, invoices.sgstAmount);
            await m.addColumn(invoices, invoices.igstAmount);
          }
        },
      );
 
  // `drift_flutter`'s driftDatabase() picks the right backend for you:
  // NativeDatabase (via sqlite3_flutter_libs) on Android/iOS/desktop,
  // and a WASM database (via sqlite3.wasm + a worker) on Web — the
  // same "works identically everywhere" property the old Hive setup
  // was chosen for.
  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'invoicenow',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}