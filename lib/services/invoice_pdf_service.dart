import 'dart:convert';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/invoice.dart';

/// Builds the invoice PDF. Works identically on Android, iOS, desktop and
/// web because the `pdf` package renders bytes in pure Dart — no native
/// platform code involved.
///
/// Business name/phone/address are read from `invoice.businessName` etc
/// (a snapshot taken at generation time — see `Invoice`), NOT from the
/// live business profile, so this PDF never changes retroactively if the
/// user edits their business details later. GST (CGST/SGST/IGST) is the
/// same kind of snapshot — whatever was chosen when the invoice was
/// generated is what prints, even if the GST rate changes later.
///
/// The items table is built from `invoice.items` at generation time, so
/// it automatically grows/shrinks with however many rows the user added
/// on the form. Nothing here assumes a fixed number of fields.
class InvoicePdfService {
  static Future<Uint8List> generate({required Invoice invoice}) async {
    final doc = pw.Document();
    final currency =
        NumberFormat.currency(locale: 'en_IN', symbol: 'Rs. ', decimalDigits: 2);
    final dateStr = DateFormat('d MMM yyyy').format(invoice.date);

    const brand = PdfColor.fromInt(0xFF1E3A5F);
    const slate = PdfColor.fromInt(0xFF64748B);
    const divider = PdfColor.fromInt(0xFFE2E8F0);
    const paidColor = PdfColor.fromInt(0xFF16A34A);
    const unpaidColor = PdfColor.fromInt(0xFFD97706);

    final businessName =
        invoice.businessName.isEmpty ? 'Your Business Name' : invoice.businessName;
    final businessSubtitle = invoice.businessSubtitle;
    final businessPhone = invoice.businessPhone;
    final businessAddress = invoice.businessAddress;

    pw.MemoryImage? logoImage;
    if (invoice.businessLogoBase64.isNotEmpty) {
      try {
        logoImage = pw.MemoryImage(base64Decode(invoice.businessLogoBase64));
      } catch (_) {
        logoImage = null; // corrupt/invalid data — fall back to no logo
      }
    }

    // GST rate split for display (e.g. 18% -> 9% CGST + 9% SGST).
    final halfGstRate = invoice.gstRate / 2;

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (logoImage != null) ...[
                      pw.ClipRRect(
                        horizontalRadius: 8,
                        verticalRadius: 8,
                        child: pw.SizedBox(
                          width: 44,
                          height: 44,
                          child: pw.Image(logoImage, fit: pw.BoxFit.cover),
                        ),
                      ),
                      pw.SizedBox(width: 10),
                    ],
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(businessName,
                            style: const pw.TextStyle(
                                fontSize: 20,
                                fontWeight: pw.FontWeight.bold,
                                color: brand)),
                        if (businessSubtitle.isNotEmpty) ...[
                          pw.SizedBox(height: 2),
                          pw.Text(businessSubtitle,
                              style: const pw.TextStyle(fontSize: 10, color: slate)),
                        ],
                        if (businessPhone.isNotEmpty)
                          pw.Text(businessPhone,
                              style: const pw.TextStyle(fontSize: 10, color: slate)),
                        if (businessAddress.isNotEmpty)
                          pw.Text(businessAddress,
                              style: const pw.TextStyle(fontSize: 10, color: slate)),
                      ],
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('INVOICE',
                        style: const pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                            color: brand)),
                    pw.SizedBox(height: 4),
                    pw.Text(invoice.number,
                        style: const pw.TextStyle(
                            fontSize: 11, fontWeight: pw.FontWeight.bold)),
                    pw.Text(dateStr, style: const pw.TextStyle(fontSize: 10, color: slate)),
                    pw.SizedBox(height: 6),
                    pw.Container(
                      padding:
                          const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: pw.BoxDecoration(
                        color: invoice.paid ? paidColor : unpaidColor,
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                      child: pw.Text(
                        invoice.paymentMode.label.toUpperCase(),
                        style: const pw.TextStyle(
                            fontSize: 9,
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 14),
            pw.Divider(color: divider, thickness: 1),
            pw.SizedBox(height: 10),
          ],
        ),
        footer: (context) => pw.Column(
          children: [
            pw.Divider(color: divider),
            pw.SizedBox(height: 4),
            pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}  •  Generated with Invoice Generator',
              style: const pw.TextStyle(fontSize: 8, color: slate),
            ),
          ],
        ),
        build: (context) => [
          // Bill To block
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: const PdfColor.fromInt(0xFFF8FAFC),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('BILL TO',
                    style: const pw.TextStyle(
                        fontSize: 9, color: slate, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text(
                    invoice.customerName.isEmpty ? 'Unnamed Customer' : invoice.customerName,
                    style:
                        const pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
                if (invoice.customerPhone.isNotEmpty)
                  pw.Text(invoice.customerPhone, style: const pw.TextStyle(fontSize: 10)),
                if (invoice.customerAddress.isNotEmpty)
                  pw.Text(invoice.customerAddress, style: const pw.TextStyle(fontSize: 10)),
              ],
            ),
          ),
          pw.SizedBox(height: 18),

          // Dynamic items table - grows with invoice.items, any length
          pw.TableHelper.fromTextArray(
            headerDecoration: const pw.BoxDecoration(color: brand),
            headerStyle: const pw.TextStyle(
                color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 10),
            cellStyle: const pw.TextStyle(fontSize: 10),
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerRight,
              2: pw.Alignment.center,
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerRight,
            },
            headerAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerRight,
              2: pw.Alignment.center,
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerRight,
            },
            cellPadding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            border: const pw.TableBorder(
              horizontalInside: pw.BorderSide(color: divider, width: 0.5),
            ),
            headers: const ['Item', 'Price', 'Qty', 'Discount', 'Total'],
            data: invoice.items
                .map((item) => [
                      item.name,
                      currency.format(item.price),
                      item.qty.toString(),
                      currency.format(item.discount),
                      currency.format(item.lineTotal),
                    ])
                .toList(),
          ),
          pw.SizedBox(height: 16),

          // Totals block
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Container(
              width: 220,
              child: pw.Column(
                children: [
                  _totalRow('Subtotal', currency.format(invoice.subtotal), slate),
                  pw.SizedBox(height: 6),
                  _totalRow('Discount', '- ${currency.format(invoice.totalDiscount)}', slate),
                  if (invoice.gstType == GstType.cgstSgst) ...[
                    pw.SizedBox(height: 6),
                    _totalRow(
                      'CGST (${_fmtRate(halfGstRate)}%)',
                      currency.format(invoice.cgstAmount),
                      slate,
                    ),
                    pw.SizedBox(height: 6),
                    _totalRow(
                      'SGST (${_fmtRate(halfGstRate)}%)',
                      currency.format(invoice.sgstAmount),
                      slate,
                    ),
                  ] else if (invoice.gstType == GstType.igst) ...[
                    pw.SizedBox(height: 6),
                    _totalRow(
                      'IGST (${_fmtRate(invoice.gstRate)}%)',
                      currency.format(invoice.igstAmount),
                      slate,
                    ),
                  ],
                  pw.SizedBox(height: 8),
                  pw.Divider(color: divider),
                  _totalRow(
                    'Grand Total',
                    currency.format(invoice.grandTotal),
                    brand,
                    bold: true,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
          pw.SizedBox(height: 24),
          pw.Text('Thank you! We appreciate your trust.',
              style: const pw.TextStyle(fontSize: 10, color: slate, fontStyle: pw.FontStyle.italic)),
        ],
      ),
    );

    return doc.save();
  }

  static String _fmtRate(double rate) =>
      rate == rate.roundToDouble() ? rate.toInt().toString() : rate.toStringAsFixed(1);

  static pw.Widget _totalRow(String label, String value, PdfColor color,
      {bool bold = false, double size = 11}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label,
            style: pw.TextStyle(
                fontSize: size, color: bold ? color : PdfColors.grey800)),
        pw.Text(value,
            style: pw.TextStyle(
                fontSize: size,
                color: color,
                fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal)),
      ],
    );
  }
}