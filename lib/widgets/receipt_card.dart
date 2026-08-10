import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/invoice.dart';
import '../theme/app_theme.dart';

class ReceiptEdgeClipper extends CustomClipper<Path> {
  final double notchRadius;
  const ReceiptEdgeClipper({this.notchRadius = 6});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - notchRadius);

    final count = (size.width / (notchRadius * 2.4)).floor().clamp(4, 100);
    final step = size.width / count;
    double x = 0;
    for (int i = 0; i < count; i++) {
      path.quadraticBezierTo(
        x + step / 2,
        size.height,
        x + step,
        size.height - notchRadius,
      );
      x += step;
    }
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class ReceiptCard extends StatelessWidget {
  final Invoice invoice;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ReceiptCard({
    super.key,
    required this.invoice,
    this.onView,
    this.onEdit,
    this.onDelete,
  });

  Color get _statusColor => invoice.paid ? AppColors.success : AppColors.amberDeep;

  IconData get _statusIcon =>
      invoice.paid ? Icons.check_circle_rounded : Icons.schedule_rounded;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final dateStr = DateFormat('d MMM yyyy').format(invoice.date);
    final showActionRow = onView != null || onEdit != null || onDelete != null;

    return ClipPath(
      clipper: const ReceiptEdgeClipper(),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.paperCard,
          border: Border(
            top: BorderSide(color: AppColors.divider),
            right: BorderSide(color: AppColors.divider),
            bottom: BorderSide(color: AppColors.divider),
            // The accent strip is now just a fat left border — no
            // second widget, no IntrinsicHeight, no height-matching
            // math that can be off by a pixel or two.
            left: BorderSide(color: _statusColor.withOpacity(0.9), width: 5),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 14, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Content
              GestureDetector(
                onTap: onView,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.brand.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.receipt_long_rounded, color: AppColors.brand, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            invoice.customerName.isEmpty ? 'Unnamed Customer' : invoice.customerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lora(fontSize: 14.5, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "${invoice.number} • $dateStr",
                            style: const TextStyle(fontSize: 11.5, color: AppColors.slateLight),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          currency.format(invoice.grandTotal),
                          style: AppTheme.mono(16.5, weight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_statusIcon, size: 12, color: _statusColor),
                              const SizedBox(width: 4),
                              Text(
                                invoice.paid ? 'Paid' : 'Unpaid',
                                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: _statusColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (showActionRow) ...[
                const SizedBox(height: 12),
                const Divider(height: 1, color: AppColors.divider),
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (onView != null)
                      Expanded(
                        child: SizedBox(
                          height: 34,
                          child: ElevatedButton.icon(
                            onPressed: onView,
                            icon: const Icon(Icons.visibility_outlined, size: 15),
                            label: const Text('View', style: TextStyle(fontSize: 12.5)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.brand.withOpacity(0.08),
                              foregroundColor: AppColors.brand,
                              elevation: 0,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ),
                    if (onEdit != null) ...[
                      const SizedBox(width: 8),
                      _ActionIcon(
                        icon: Icons.edit_outlined,
                        tooltip: 'Edit',
                        background: AppColors.brand.withOpacity(0.1),
                        color: AppColors.brand,
                        onTap: onEdit!,
                      ),
                    ],
                    if (onDelete != null) ...[
                      const SizedBox(width: 8),
                      _ActionIcon(
                        icon: Icons.delete_outline_rounded,
                        tooltip: 'Delete',
                        background: Colors.red.withOpacity(0.1),
                        color: Colors.red,
                        onTap: onDelete!,
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color background;
  final Color color;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    required this.tooltip,
    required this.background,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            child: Icon(icon, size: 17, color: color),
          ),
        ),
      ),
    );
  }
}