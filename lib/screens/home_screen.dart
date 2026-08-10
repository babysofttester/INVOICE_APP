import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:invoice_generator/screens/business_profile_screen.dart';
import 'package:invoice_generator/services/invoice_storage_service.dart';

import '../theme/app_theme.dart';
import '../utils/pdf_utils.dart';
import '../widgets/receipt_card.dart';
import 'new_invoice_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _openBusinessProfile(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const BusinessProfileScreen()),
    );
    // No manual refresh needed — nothing on this screen reads business
    // profile data directly, but if you show the business name here
    // later, wrap it the same way the invoice list is wrapped below.
  }

  @override
  Widget build(BuildContext context) {
    final currency =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return ValueListenableBuilder<int>(
      // Rebuilds instantly the moment any invoice is saved/edited/deleted
      // anywhere in the app — fixes stale data when switching tabs.
      valueListenable: InvoiceStorageService.revision,
      builder: (context, _, __) {
        final invoices = InvoiceStorageService.instance.getAll();
        final recent = invoices.take(3).toList();
        final now = DateTime.now();
        final thisMonthTotal = invoices
            .where((inv) => inv.date.year == now.year && inv.date.month == now.month)
            .fold<double>(0, (sum, inv) => sum + inv.grandTotal);

        return RefreshIndicator(
          onRefresh: () async {},
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            children: [
              _BusinessHeaderCard(
                onTap: () => _openBusinessProfile(context),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'This Month',
                      value: currency.format(thisMonthTotal),
                      icon: Icons.trending_up_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Total Invoices',
                      value: '${invoices.length}',
                      icon: Icons.description_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              _GenerateButton(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NewInvoiceScreen()),
                  );
                },
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Invoices',
                      style:
                          GoogleFonts.lora(fontSize: 16, fontWeight: FontWeight.w700)),
                  const Text('See all',
                      style: TextStyle(
                          color: AppColors.brand,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                ],
              ),
              const SizedBox(height: 14),
              if (recent.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text('No invoices yet — generate your first one above.',
                      style: TextStyle(color: AppColors.slateLight)),
                )
              else
                ...recent.map(
                  (inv) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: ReceiptCard(
                      invoice: inv,
                      onView: () => openInvoicePdf(inv),
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

class _BusinessHeaderCard extends StatelessWidget {
  final VoidCallback onTap;

  const _BusinessHeaderCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.paperCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.brand.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.storefront_rounded,
                color: AppColors.brand, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Business Profile',
                  style: GoogleFonts.lora(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.inkNavy,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Manage business details & logo',
                  style: TextStyle(fontSize: 12, color: AppColors.slateLight),
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.edit_outlined, size: 14, color: AppColors.brand),
            label: const Text('Setup',
                style: TextStyle(
                    fontSize: 12, color: AppColors.brand, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.brand.withOpacity(0.3)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.paperCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.brand, size: 20),
          const SizedBox(height: 10),
          Text(value, style: AppTheme.mono(18, weight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.slateLight)),
        ],
      ),
    );
  }
}

class _GenerateButton extends StatelessWidget {
  final VoidCallback onTap;
  const _GenerateButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.brand,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'New Invoice',
                style: GoogleFonts.lora(
                    fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}