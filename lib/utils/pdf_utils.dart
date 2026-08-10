import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:printing/printing.dart';

import '../models/invoice.dart';

Future<void> openInvoicePdf(Invoice invoice) async {
  final bytes = Uint8List.fromList(base64Decode(invoice.pdfBase64));

  try {
    // Works on iOS, Android, macOS (with entitlement), Windows
    await Printing.layoutPdf(
      onLayout: (format) async => bytes,
      name: '${invoice.number}.pdf',
    );
  } catch (e) {
    // Fallback: save to disk and open with default viewer
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${invoice.number}.pdf');
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }
}