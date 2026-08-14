import 'dart:convert';
import 'invoice_item_data.dart';

/// Payment status/mode for an invoice.
enum PaymentMode { unpaid, cash, online, bankTransfer }

extension PaymentModeX on PaymentMode {
  String get label {
    switch (this) {
      case PaymentMode.unpaid:
        return 'Unpaid';
      case PaymentMode.cash:
        return 'Paid (Cash)';
      case PaymentMode.online:
        return 'Paid (Online)';
      case PaymentMode.bankTransfer:
        return 'Paid (Bank Transfer)';
    }
  }

  String get storageValue => name;

  static PaymentMode fromStorage(String? value) {
    return PaymentMode.values.firstWhere(
      (e) => e.storageValue == value,
      orElse: () => PaymentMode.unpaid,
    );
  }
}

/// GST type applied on an invoice.
/// - [none]: no GST at all.
/// - [cgstSgst]: intra-state sale — the entered rate is split equally
///   into CGST + SGST (e.g. 18% -> 9% CGST + 9% SGST).
/// - [igst]: inter-state sale — the full rate is charged as IGST.
enum GstType { none, cgstSgst, igst }

extension GstTypeX on GstType {
  String get label {
    switch (this) {
      case GstType.none:
        return 'No GST';
      case GstType.cgstSgst:
        return 'CGST + SGST';
      case GstType.igst:
        return 'IGST';
    }
  }

  String get storageValue => name;

  static GstType fromStorage(String? value) {
    return GstType.values.firstWhere(
      (e) => e.storageValue == value,
      orElse: () => GstType.none,
    );
  }
}

/// Full invoice record. Keeps the PDF bytes (base64) alongside the data
/// so a saved invoice can be re-opened / re-shared later without
/// regenerating it.
class Invoice {
  final String id; // unique key used for storage, e.g. the invoice number
  final String number;
  final DateTime date;

  final String customerName;
  final String customerPhone;
  final String customerAddress;

  final List<InvoiceItemData> items;

  final double subtotal;
  final double totalDiscount;

  /// GST snapshot at generation time — never recalculated later, so an
  /// already-generated invoice doesn't change if tax rates change.
  final GstType gstType;
  final double gstRate; // percentage entered by the user, e.g. 18 for 18%
  final double cgstAmount;
  final double sgstAmount;
  final double igstAmount;

  /// subtotal - totalDiscount + cgstAmount + sgstAmount + igstAmount
  final double grandTotal;

  /// Payment status selected at generation time (or later edit).
  PaymentMode paymentMode;

  /// Snapshot of the business details AT THE TIME this invoice was made,
  /// so editing the business profile later never changes an already
  /// generated/shared invoice.
  final String businessName;
  final String businessSubtitle;
  final String businessPhone;
  final String businessAddress;
  final String businessLogoBase64;

  /// Base64-encoded PDF bytes. Storing the PDF itself (not just a file
  /// path) is what makes "permanent local storage" work identically on
  /// Android, iOS, desktop AND web.
  String pdfBase64;

  Invoice({
    required this.id,
    required this.number,
    required this.date,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.items,
    required this.subtotal,
    required this.totalDiscount,
    required this.grandTotal,
    required this.pdfBase64,
    this.gstType = GstType.none,
    this.gstRate = 0,
    this.cgstAmount = 0,
    this.sgstAmount = 0,
    this.igstAmount = 0,
    this.paymentMode = PaymentMode.unpaid,
    this.businessName = 'Your Business Name',
    this.businessSubtitle = '',
    this.businessPhone = '',
    this.businessAddress = '',
    this.businessLogoBase64 = '',
  });

  /// Convenience getter: true for any paid mode.
  bool get paid => paymentMode != PaymentMode.unpaid;

  /// Combined GST amount (CGST + SGST, or IGST alone).
  double get totalGst => cgstAmount + sgstAmount + igstAmount;

  /// True when GST was actually applied on this invoice.
  bool get hasGst => gstType != GstType.none && totalGst > 0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'number': number,
        'date': date.toIso8601String(),
        'customerName': customerName,
        'customerPhone': customerPhone,
        'customerAddress': customerAddress,
        'items': items.map((e) => e.toJson()).toList(),
        'subtotal': subtotal,
        'totalDiscount': totalDiscount,
        'gstType': gstType.storageValue,
        'gstRate': gstRate,
        'cgstAmount': cgstAmount,
        'sgstAmount': sgstAmount,
        'igstAmount': igstAmount,
        'grandTotal': grandTotal,
        'paymentMode': paymentMode.storageValue,
        'businessName': businessName,
        'businessSubtitle': businessSubtitle,
        'businessPhone': businessPhone,
        'businessAddress': businessAddress,
        'businessLogoBase64': businessLogoBase64,
        'pdfBase64': pdfBase64,
      };

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        id: json['id'] as String,
        number: json['number'] as String,
        date: DateTime.parse(json['date'] as String),
        customerName: json['customerName'] as String? ?? '',
        customerPhone: json['customerPhone'] as String? ?? '',
        customerAddress: json['customerAddress'] as String? ?? '',
        items: (json['items'] as List<dynamic>? ?? [])
            .map((e) => InvoiceItemData.fromJson(e as Map<String, dynamic>))
            .toList(),
        subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
        totalDiscount: (json['totalDiscount'] as num?)?.toDouble() ?? 0,
        gstType: GstTypeX.fromStorage(json['gstType'] as String?),
        gstRate: (json['gstRate'] as num?)?.toDouble() ?? 0,
        cgstAmount: (json['cgstAmount'] as num?)?.toDouble() ?? 0,
        sgstAmount: (json['sgstAmount'] as num?)?.toDouble() ?? 0,
        igstAmount: (json['igstAmount'] as num?)?.toDouble() ?? 0,
        grandTotal: (json['grandTotal'] as num?)?.toDouble() ?? 0,
        // Backward compat: older saved invoices only had `paid: bool`.
        paymentMode: json.containsKey('paymentMode')
            ? PaymentModeX.fromStorage(json['paymentMode'] as String?)
            : ((json['paid'] as bool? ?? false)
                ? PaymentMode.cash
                : PaymentMode.unpaid),
        businessName: json['businessName'] as String? ?? 'Your Business Name',
        businessSubtitle: json['businessSubtitle'] as String? ?? '',
        businessPhone: json['businessPhone'] as String? ?? '',
        businessAddress: json['businessAddress'] as String? ?? '',
        businessLogoBase64: json['businessLogoBase64'] as String? ?? '',
        pdfBase64: json['pdfBase64'] as String? ?? '',
      );

  String encode() => jsonEncode(toJson());
  factory Invoice.decode(String raw) =>
      Invoice.fromJson(jsonDecode(raw) as Map<String, dynamic>);

  Invoice copyWith({
    PaymentMode? paymentMode,
    String? pdfBase64,
  }) =>
      Invoice(
        id: id,
        number: number,
        date: date,
        customerName: customerName,
        customerPhone: customerPhone,
        customerAddress: customerAddress,
        items: items,
        subtotal: subtotal,
        totalDiscount: totalDiscount,
        gstType: gstType,
        gstRate: gstRate,
        cgstAmount: cgstAmount,
        sgstAmount: sgstAmount,
        igstAmount: igstAmount,
        grandTotal: grandTotal,
        pdfBase64: pdfBase64 ?? this.pdfBase64,
        paymentMode: paymentMode ?? this.paymentMode,
        businessName: businessName,
        businessSubtitle: businessSubtitle,
        businessPhone: businessPhone,
        businessAddress: businessAddress,
        businessLogoBase64: businessLogoBase64,
      );
}