import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/invoice.dart';
import '../services/invoice_storage_service.dart';
import '../theme/app_theme.dart';
import '../utils/pdf_utils.dart';
import '../widgets/receipt_card.dart';
import 'new_invoice_screen.dart';

enum _QuickFilter { all, today, yesterday, thisMonth, last3Months, custom }

extension on _QuickFilter {
  String get label {
    switch (this) {
      case _QuickFilter.all:
        return 'All';
      case _QuickFilter.today:
        return 'Today';
      case _QuickFilter.yesterday:
        return 'Yesterday';
      case _QuickFilter.thisMonth:
        return 'This Month';
      case _QuickFilter.last3Months:
        return 'Last 3 Months';
      case _QuickFilter.custom:
        return 'Custom Range';
    }
  }

  IconData get icon {
    switch (this) {
      case _QuickFilter.all:
        return Icons.all_inclusive_rounded;
      case _QuickFilter.today:
        return Icons.today_rounded;
      case _QuickFilter.yesterday:
        return Icons.history_rounded;
      case _QuickFilter.thisMonth:
        return Icons.calendar_view_month_rounded;
      case _QuickFilter.last3Months:
        return Icons.calendar_month_rounded;
      case _QuickFilter.custom:
        return Icons.date_range_rounded;
    }
  }
}

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  final _searchController = TextEditingController();
  final GlobalKey _filterButtonKey = GlobalKey();
  _QuickFilter _filter = _QuickFilter.all;
  DateTimeRange? _customRange;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  (DateTime?, DateTime?) get _range {
    final now = DateTime.now();
    switch (_filter) {
      case _QuickFilter.all:
        return (null, null);
      case _QuickFilter.today:
        return (now, now);
      case _QuickFilter.yesterday:
        final y = now.subtract(const Duration(days: 1));
        return (y, y);
      case _QuickFilter.thisMonth:
        return (DateTime(now.year, now.month, 1), now);
      case _QuickFilter.last3Months:
        return (DateTime(now.year, now.month - 3, now.day), now);
      case _QuickFilter.custom:
        return (_customRange?.start, _customRange?.end);
    }
  }

  String get _activeFilterLabel {
    if (_filter == _QuickFilter.custom && _customRange != null) {
      return '${DateFormat('d MMM').format(_customRange!.start)} - '
          '${DateFormat('d MMM').format(_customRange!.end)}';
    }
    return _filter.label;
  }

  Future<void> _pickCustomRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _customRange,
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
      setState(() {
        _customRange = picked;
        _filter = _QuickFilter.custom;
      });
    }
  }

  Future<void> _openFilterMenu() async {
    final box = _filterButtonKey.currentContext?.findRenderObject() as RenderBox?;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    RelativeRect position = const RelativeRect.fromLTRB(1000, 140, 20, 0);
    if (box != null) {
      final offset = box.localToGlobal(Offset.zero, ancestor: overlay);
      position = RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + box.size.height + 6,
        overlay.size.width - offset.dx - box.size.width,
        0,
      );
    }

    final selected = await showMenu<_QuickFilter>(
      context: context,
      position: position,
      color: AppColors.paperCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      items: _QuickFilter.values.map((f) {
        final isSelected = _filter == f;
        return PopupMenuItem<_QuickFilter>(
          value: f,
          height: 44,
          child: Row(
            children: [
              Icon(f.icon,
                  size: 18,
                  color: isSelected ? AppColors.brand : AppColors.slateLight),
              const SizedBox(width: 12),
              Text(
                f.label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.brand : AppColors.inkNavy,
                ),
              ),
              if (isSelected) ...[
                const Spacer(),
                const Icon(Icons.check_rounded, size: 16, color: AppColors.brand),
              ],
            ],
          ),
        );
      }).toList(),
    );

    if (selected == null) return;
    if (selected == _QuickFilter.custom) {
      await _pickCustomRange();
    } else {
      setState(() => _filter = selected);
    }
  }

  Future<void> _editInvoice(Invoice invoice) async {
    await Navigator.of(context).push<Invoice>(
      MaterialPageRoute(
        builder: (_) => NewInvoiceScreen(editingInvoice: invoice),
      ),
    );
  }

  Future<void> _deleteInvoice(Invoice invoice) async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          decoration: BoxDecoration(
            color: AppColors.paperCard,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: invoice.paid
                      ? AppColors.amber.withOpacity(0.15)
                      : Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  invoice.paid
                      ? Icons.warning_amber_rounded
                      : Icons.delete_outline_rounded,
                  color: invoice.paid ? AppColors.amberDeep : Colors.red,
                  size: 30,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Delete Invoice?',
                style: GoogleFonts.lora(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.inkNavy,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                invoice.paid
                    ? '${invoice.number} is marked as "${invoice.paymentMode.label}". '
                        'The shop has already recorded a payment for it. '
                        'Deleting cannot be undone — delete anyway?'
                    : '${invoice.number} for ${invoice.customerName.isEmpty ? 'this customer' : invoice.customerName} '
                        'will be removed permanently.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: AppColors.slate,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.inkNavy,
                        side: const BorderSide(color: AppColors.divider, width: 1.4),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Cancel',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_outline_rounded, size: 17),
                          SizedBox(width: 6),
                          Text('Delete',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirm == true) {
      await InvoiceStorageService.instance.deleteInvoice(invoice.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: InvoiceStorageService.revision,
      builder: (context, _, __) {
        final (from, to) = _range;
        final invoices = InvoiceStorageService.instance
            .searchWithRange(_searchController.text, from: from, to: to);

        return RefreshIndicator(
          onRefresh: () async => setState(() {}),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            children: [
              Text('My Invoices',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(fontSize: 26)),
              const SizedBox(height: 8),

              // ── Search box + separate filter button, side by side ──
              // NOTE: no `crossAxisAlignment: stretch` here. This Row
              // lives inside a ListView (unbounded height), so `stretch`
              // tries to force children to infinite height and crashes.
              // Both children already have their own fixed height (52),
              // so the default `center` alignment is all that's needed.
              SizedBox(
                height: 52,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),                        decoration: BoxDecoration(
                          color: AppColors.paperCard,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search_rounded,
                                color: AppColors.slateLight, size: 21),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: const TextStyle(fontSize: 14.5),
                                decoration: const InputDecoration(
                                  hintText: 'Search by name, invoice no...',
                                  hintStyle: TextStyle(
                                      color: AppColors.slateLight, fontSize: 13.5),
                                  border: InputBorder.none,
                                  isCollapsed: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Material(
                      key: _filterButtonKey,
                      color: _filter == _QuickFilter.all
                          ? AppColors.paperCard
                          : AppColors.brand.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        onTap: _openFilterMenu,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _filter == _QuickFilter.all
                                  ? AppColors.divider
                                  : AppColors.brand.withOpacity(0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _filter.icon,
                                size: 17,
                                color: _filter == _QuickFilter.all
                                    ? AppColors.slateLight
                                    : AppColors.brand,
                              ),
                              const SizedBox(width: 6),
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 78),
                                child: Text(
                                  _activeFilterLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: _filter == _QuickFilter.all
                                        ? AppColors.inkNavy
                                        : AppColors.brand,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 18,
                                color: _filter == _QuickFilter.all
                                    ? AppColors.slateLight
                                    : AppColors.brand,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

             const SizedBox(height: 18),
const SizedBox(height: 18),
if (invoices.isEmpty)
  Padding(
    padding: const EdgeInsets.only(top: 30),
    child: Column(
      children: [
        Image.asset(
          'assets/images/notfoundinvoice.png',
          width: 220,
          height: 220,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Falls back to the icon if the image is missing or not
            // yet added to pubspec.yaml — screen never breaks either way.
            return const Icon(Icons.receipt_long_outlined,
                size: 64, color: AppColors.slateLight);
          },
        ),
        const SizedBox(height: 10),
        Text(
          _searchController.text.isEmpty && _filter == _QuickFilter.all
              ? 'Generate your first invoice from the Home tab.'
              : 'Try a different search or filter.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, color: AppColors.slateLight),
        ),
      ],
    ),
  )
else
  ...invoices.map(
    (inv) => Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: ReceiptCard(
        invoice: inv,
        onView: () => openInvoicePdf(inv),
        onEdit: () => _editInvoice(inv),
        onDelete: () => _deleteInvoice(inv),
      ),
    ),
  ),

 ],
          ),
        );
      },
    );
  }
}