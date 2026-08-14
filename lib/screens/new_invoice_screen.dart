import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:invoice_generator/screens/business_profile_screen.dart';
import 'package:printing/printing.dart';

import '../models/invoice.dart';
import '../models/invoice_item_data.dart';
import '../services/business_profile_service.dart';
import '../services/invoice_pdf_service.dart';
import '../services/invoice_storage_service.dart';
import '../theme/app_theme.dart';

class InvoiceItemInput {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController qtyController = TextEditingController(text: '1');
  TextEditingController discountController = TextEditingController(text: '0');

  void dispose() {
    nameController.dispose();
    priceController.dispose();
    qtyController.dispose();
    discountController.dispose();
  }
}

class NewInvoiceScreen extends StatefulWidget {
  /// When non-null, the screen edits this existing invoice in place
  /// (same id/number) instead of creating a new one.
  final Invoice? editingInvoice;

  const NewInvoiceScreen({super.key, this.editingInvoice});

  @override
  State<NewInvoiceScreen> createState() => _NewInvoiceScreenState();
}

class _NewInvoiceScreenState extends State<NewInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  late final String _invoiceNumber;

  final List<InvoiceItemInput> _items = [];
  bool _generating = false;
  PaymentMode _paymentMode = PaymentMode.unpaid;

  // --- GST state -------------------------------------------------------
  GstType _gstType = GstType.none;
  final _gstRateController = TextEditingController(text: '18');
  // ----------------------------------------------------------------------

  bool get _isEditing => widget.editingInvoice != null;

  @override
  void initState() {
    super.initState();
    _gstRateController.addListener(_calculateTotals);

    final editing = widget.editingInvoice;
    if (editing != null) {
      _invoiceNumber = editing.number;
      _nameController.text = editing.customerName;
      _phoneController.text = editing.customerPhone;
      _addressController.text = editing.customerAddress;
      _selectedDate = editing.date;
      _paymentMode = editing.paymentMode;
      _gstType = editing.gstType;
      if (editing.gstRate > 0) {
        _gstRateController.text = _trimNum(editing.gstRate);
      }
      for (final item in editing.items) {
        final input = InvoiceItemInput();
        input.nameController.text = item.name;
        input.priceController.text = _trimNum(item.price);
        input.qtyController.text = item.qty.toString();
        input.discountController.text = _trimNum(item.discount);
        input.priceController.addListener(_calculateTotals);
        input.qtyController.addListener(_calculateTotals);
        input.discountController.addListener(_calculateTotals);
        _items.add(input);
      }
    } else {
      _invoiceNumber = InvoiceStorageService.instance.nextInvoiceNumber();
      _addItem();
    }
  }

  static String _trimNum(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  void _addItem() {
    setState(() {
      final item = InvoiceItemInput();
      item.priceController.addListener(_calculateTotals);
      item.qtyController.addListener(_calculateTotals);
      item.discountController.addListener(_calculateTotals);
      _items.add(item);
    });
  }

  void _removeItem(int index) {
    if (_items.length > 1) {
      setState(() {
        _items[index].dispose();
        _items.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least one item is required')),
      );
    }
  }

  void _calculateTotals() {
    setState(() {});
  }

  double get _subtotal {
    double total = 0;
    for (var item in _items) {
      double price = double.tryParse(item.priceController.text) ?? 0;
      int qty = int.tryParse(item.qtyController.text) ?? 0;
      total += (price * qty);
    }
    return total;
  }

  double get _totalDiscount {
    double discount = 0;
    for (var item in _items) {
      double disc = double.tryParse(item.discountController.text) ?? 0;
      discount += disc;
    }
    return discount;
  }

  /// Amount GST is calculated on: subtotal after discount, never negative.
  double get _taxableAmount {
    final t = _subtotal - _totalDiscount;
    return t < 0 ? 0 : t;
  }

  double get _gstRateValue => double.tryParse(_gstRateController.text) ?? 0;

  double get _cgstAmount => _gstType == GstType.cgstSgst
      ? _taxableAmount * (_gstRateValue / 2) / 100
      : 0;

  double get _sgstAmount => _gstType == GstType.cgstSgst
      ? _taxableAmount * (_gstRateValue / 2) / 100
      : 0;

  double get _igstAmount =>
      _gstType == GstType.igst ? _taxableAmount * _gstRateValue / 100 : 0;

  double get _totalGst => _cgstAmount + _sgstAmount + _igstAmount;

  double get _grandTotal {
    final grand = _taxableAmount + _totalGst;
    return grand < 0 ? 0 : grand;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(DateTime.now().year + 50),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.brand,
              onPrimary: Colors.white,
              surface: AppColors.paperCard,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Invoice _buildInvoiceModel(String pdfBase64) {
    final itemData = _items
        .map((i) => InvoiceItemData(
              name: i.nameController.text.trim(),
              price: double.tryParse(i.priceController.text) ?? 0,
              qty: int.tryParse(i.qtyController.text) ?? 0,
              discount: double.tryParse(i.discountController.text) ?? 0,
            ))
        .toList();

    final profile = BusinessProfileService.instance.get();

    return Invoice(
      id: _invoiceNumber,
      number: _invoiceNumber,
      date: _selectedDate,
      customerName: _nameController.text.trim(),
      customerPhone: _phoneController.text.trim(),
      customerAddress: _addressController.text.trim(),
      items: itemData,
      subtotal: _subtotal,
      totalDiscount: _totalDiscount,
      gstType: _gstType,
      gstRate: _gstType == GstType.none ? 0 : _gstRateValue,
      cgstAmount: _cgstAmount,
      sgstAmount: _sgstAmount,
      igstAmount: _igstAmount,
      grandTotal: _grandTotal,
      pdfBase64: pdfBase64,
      paymentMode: _paymentMode,
      businessName: profile.name,
      businessSubtitle: profile.subtitle,
      businessPhone: profile.phone,
      businessAddress: profile.address,
      businessLogoBase64: profile.logoBase64,
    );
  }

  Future<void> _generateInvoice() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _generating = true);
    try {
      final draft = _buildInvoiceModel('');
      final bytes = await InvoicePdfService.generate(invoice: draft);
      final invoice = _buildInvoiceModel(base64Encode(bytes));

      await InvoiceStorageService.instance.saveInvoice(invoice);

      if (!mounted) return;
      setState(() => _generating = false);
      await _showResultSheet(bytes, invoice);
    } catch (e) {
      if (!mounted) return;
      setState(() => _generating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not generate PDF: $e')),
      );
    }
  }

  Future<void> _showResultSheet(List<int> bytes, Invoice invoice) async {
    final pdfBytes = Uint8List.fromList(bytes);
    if (!mounted) return;
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.paperCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: AppColors.success),
                  const SizedBox(width: 8),
                  Text(
                    _isEditing
                        ? '${invoice.number} updated'
                        : '${invoice.number} generated',
                    style: GoogleFonts.lora(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Saved inside the app. You can also preview, print, or save/share it anywhere on your device.',
                style: TextStyle(fontSize: 13, color: AppColors.slate),
              ),
              const SizedBox(height: 18),
              _sheetButton(
                icon: Icons.visibility_outlined,
                label: 'Preview / Print / Save as PDF',
                onTap: () async {
                  Navigator.pop(ctx);
                  await Printing.layoutPdf(
                    onLayout: (format) async => pdfBytes,
                    name: '${invoice.number}.pdf',
                  );
                },
              ),
              const SizedBox(height: 10),
              _sheetButton(
                icon: Icons.ios_share_rounded,
                label: 'Share / Export to Downloads, Drive, WhatsApp...',
                onTap: () async {
                  Navigator.pop(ctx);
                  await Printing.sharePdf(
                    bytes: pdfBytes,
                    filename: '${invoice.number}.pdf',
                  );
                },
              ),
              const SizedBox(height: 10),
              _sheetButton(
                icon: Icons.list_alt_rounded,
                label: 'Done — back to invoice list',
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context, invoice);
                },
                filled: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool filled = true,
  }) {
    return SizedBox(
      width: double.infinity,
      child: filled
          ? ElevatedButton.icon(
              onPressed: onTap,
              icon: Icon(icon, size: 18, color: Colors.white),
              label: Text(label, style: const TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brand,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onTap,
              icon: Icon(icon, size: 18, color: AppColors.brand),
              label: Text(label, style: const TextStyle(color: AppColors.brand)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.brand),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _gstRateController.dispose();
    for (var item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currency =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
    final needsProfile = BusinessProfileService.instance.isUnset;

    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Invoice' : 'New Invoice'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (needsProfile) ...[
                 InkWell(
  onTap: () async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const BusinessProfileScreen(),
      ),
    );
    setState(() {});
  },
  borderRadius: BorderRadius.circular(12),
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    decoration: BoxDecoration(
      color: AppColors.brand.withOpacity(0.08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: AppColors.brand.withOpacity(0.20),
      ),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.brand.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.storefront_rounded,
            color: AppColors.brand,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personalize Your Invoices',
                style: GoogleFonts.lora(
                  fontSize: 14,
                  height: 1,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2, // Letter gap kam
                  color: AppColors.inkNavy,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Set up your business profile so every invoice is branded with your business information and looks professional.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.25,
                  color: AppColors.slate,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.chevron_right_rounded,
          size: 20,
          color: AppColors.brand,
        ),
      ],
    ),
  ),
),
                    const SizedBox(height: 14),
                ],

                _buildCard(
                  title: 'Customer Details',
                  icon: Icons.person_outline_rounded,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        label: 'Customer Name',
                        hint: 'Enter customer name',
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        hint: 'Enter 10 digit phone number',
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _addressController,
                        label: 'Address (Optional)',
                        hint: 'Enter customer address',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Invoice No.',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.slate)),
                                const SizedBox(height: 6),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.paper,
                                    borderRadius: BorderRadius.circular(12),
                                    border:
                                        Border.all(color: AppColors.divider),
                                  ),
                                  child: Text(
                                    _invoiceNumber,
                                    style: AppTheme.mono(14,
                                        weight: FontWeight.w700,
                                        color: AppColors.brand),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Invoice Date',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.slate)),
                                const SizedBox(height: 6),
                                InkWell(
                                  onTap: _pickDate,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: AppColors.paperCard,
                                      borderRadius: BorderRadius.circular(12),
                                      border:
                                          Border.all(color: AppColors.divider),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                            Icons.calendar_today_rounded,
                                            size: 16,
                                            color: AppColors.brand),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            DateFormat('d MMM yyyy')
                                                .format(_selectedDate),
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                _buildCard(
                  title: 'Items',
                  icon: Icons.inventory_2_outlined,
                  child: Column(
                    children: [
                      ..._items.asMap().entries.map((entry) {
                        int index = entry.key;
                        var item = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.paper,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('Item #${index + 1}',
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.inkNavy)),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () => _removeItem(index),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete_outline_rounded,
                                              size: 18, color: Colors.red),
                                          SizedBox(width: 4),
                                          Text('Remove',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.red,
                                                  fontWeight:
                                                      FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _buildTextField(
                                controller: item.nameController,
                                label: 'Item Name',
                                hint: 'e.g. Cotton Shirt',
                                validator: (v) =>
                                    v == null || v.isEmpty ? 'Required' : null,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: _buildTextField(
                                      controller: item.priceController,
                                      label: 'Price (₹)',
                                      hint: '0.00',
                                      keyboardType: TextInputType.number,
                                      validator: (v) =>
                                          v == null || v.isEmpty ? 'Required' : null,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 2,
                                    child: _buildTextField(
                                      controller: item.qtyController,
                                      label: 'Qty',
                                      hint: '1',
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 3,
                                    child: _buildTextField(
                                      controller: item.discountController,
                                      label: 'Discount (₹)',
                                      hint: '0.00',
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _addItem,
                          icon: const Icon(Icons.add_rounded,
                              color: AppColors.brand),
                          label: const Text('+ Add Another Item',
                              style: TextStyle(
                                  color: AppColors.brand,
                                  fontWeight: FontWeight.w700)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.brand),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                _buildCard(
                  title: 'Payment Status',
                  icon: Icons.payments_outlined,
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: PaymentMode.values.map((mode) {
                      final selected = _paymentMode == mode;
                      return ChoiceChip(
                        label: Text(mode.label),
                        selected: selected,
                        selectedColor: AppColors.brand,
                        backgroundColor: AppColors.paper,
                        side: const BorderSide(color: AppColors.divider),
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : AppColors.inkNavy,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
                        onSelected: (_) => setState(() => _paymentMode = mode),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 18),

                // --- GST card ------------------------------------------------
                _buildCard(
                  title: 'GST Details',
                  icon: Icons.receipt_long_outlined,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: GstType.values.map((type) {
                          final selected = _gstType == type;
                          return ChoiceChip(
                            label: Text(type.label),
                            selected: selected,
                            selectedColor: AppColors.brand,
                            backgroundColor: AppColors.paper,
                            side: const BorderSide(color: AppColors.divider),
                            labelStyle: TextStyle(
                              color:
                                  selected ? Colors.white : AppColors.inkNavy,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.5,
                            ),
                            onSelected: (_) =>
                                setState(() => _gstType = type),
                          );
                        }).toList(),
                      ),
                      if (_gstType != GstType.none) ...[
                        const SizedBox(height: 14),
                        _buildTextField(
                          controller: _gstRateController,
                          label: _gstType == GstType.cgstSgst
                              ? 'GST Rate (%) — split equally as CGST + SGST'
                              : 'IGST Rate (%)',
                          hint: 'e.g. 18',
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _gstType == GstType.cgstSgst
                              ? 'CGST ${_fmtRate(_gstRateValue / 2)}% + SGST ${_fmtRate(_gstRateValue / 2)}% will be added on ${currency.format(_taxableAmount)}'
                              : 'IGST ${_fmtRate(_gstRateValue)}% will be added on ${currency.format(_taxableAmount)}',
                          style: const TextStyle(
                              fontSize: 11.5, color: AppColors.slate),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // ---------------------------------------------------------------

                _buildCard(
  title: 'Payment Summary',
  icon: Icons.calculate_outlined,
  child: Column(
    children: [
      _summaryRow('Subtotal', currency.format(_subtotal)),
      const SizedBox(height: 8),
      _summaryRow(
        'Total Discount',
        '- ${currency.format(_totalDiscount)}',
        valueColor: Colors.red,
      ),
      if (_gstType == GstType.cgstSgst) ...[
        const SizedBox(height: 8),
        _summaryRow(
          'CGST (${_fmtRate(_gstRateValue / 2)}%)',
          currency.format(_cgstAmount),
        ),
        const SizedBox(height: 8),
        _summaryRow(
          'SGST (${_fmtRate(_gstRateValue / 2)}%)',
          currency.format(_sgstAmount),
        ),
      ] else if (_gstType == GstType.igst) ...[
        const SizedBox(height: 8),
        _summaryRow(
          'IGST (${_fmtRate(_gstRateValue)}%)',
          currency.format(_igstAmount),
        ),
      ],
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Divider(color: AppColors.divider),
      ),
      Row(
        children: [
          Expanded(
            child: Text(
              'Grand Total',
              style: GoogleFonts.lora(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.inkNavy,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                currency.format(_grandTotal),
                style: AppTheme.mono(20,
                    weight: FontWeight.w800, color: AppColors.brand),
              ),
            ),
          ),
        ],
      ),
    ],
  ),
),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _generating ? null : _generateInvoice,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brand,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _generating
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.picture_as_pdf_rounded,
                                  color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                _isEditing ? 'Update Invoice' : 'Generate Invoice',
                                style: GoogleFonts.lora(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Widget _buildCard(
    {required String title, required IconData icon, required Widget child}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.paperCard,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.divider),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.brand),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lora(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.inkNavy,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        child,
      ],
    ),
  );
}

Widget _summaryRow(String label, String value, {Color? valueColor}) {
  return Row(
    children: [
      Expanded(
        child: Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.slate),
        ),
      ),
      const SizedBox(width: 12),
      Flexible(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.inkNavy,
            ),
          ),
        ),
      ),
    ],
  );
}

  static String _fmtRate(double rate) =>
      rate == rate.roundToDouble() ? rate.toInt().toString() : rate.toStringAsFixed(1);

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.slate)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          validator: validator,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            counterText: '',
            hintStyle:
                const TextStyle(color: AppColors.slateLight, fontSize: 13),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            filled: true,
            fillColor: AppColors.paperCard,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.brand, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}