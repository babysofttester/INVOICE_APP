import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/invoice_storage_service.dart';
import '../theme/app_theme.dart';

class StorageDataScreen extends StatelessWidget {
  const StorageDataScreen({super.key});

  ({int count, double kb}) _storageStats() {
    final invoices = InvoiceStorageService.instance.getAll();
    int bytes = 0;
    for (final inv in invoices) {
      bytes += inv.encode().length;
    }
    return (count: invoices.length, kb: bytes / 1024);
  }

  String _formatSize(double kb) {
    if (kb < 1024) return '${kb.toStringAsFixed(kb < 10 ? 1 : 0)} KB';
    return '${(kb / 1024).toStringAsFixed(1)} MB';
  }

  String get _platformLabel {
    if (kIsWeb) return 'Web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'iOS';
      case TargetPlatform.android:
        return 'Android';
      default:
        return 'Desktop';
    }
  }

  String get _dataLossTrigger {
    if (kIsWeb) {
      return 'clear your browser\'s site data/cache for this app, or use a different browser or private/incognito window';
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'delete the app, or use "Offload App" / "Reset iPhone" in iOS Settings';
      case TargetPlatform.android:
        return 'uninstall the app, or clear its storage from Android Settings → Apps';
      default:
        return 'uninstall the app or clear its local data folder';
    }
  }

@override
Widget build(BuildContext context) {
  final stats = _storageStats();

  return Scaffold(
    backgroundColor: AppColors.paper,
    appBar: AppBar(
      title: const Text('Storage & Data'),
    ),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Live stats hero card (compact) ───────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.brand,
                  AppColors.brand.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brand.withOpacity(0.22),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lock_outline_rounded, color: Colors.white.withOpacity(0.9), size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Everything stays on this device',
                        style: GoogleFonts.lora(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: _statBlock(
                          icon: Icons.description_outlined,
                          label: 'Invoices',
                          value: '${stats.count}',
                        ),
                      ),
                      Container(width: 1, color: Colors.white.withOpacity(0.25)),
                      Expanded(
                        child: _statBlock(
                          icon: Icons.sd_storage_outlined,
                          label: 'Storage',
                          value: _formatSize(stats.kb),
                        ),
                      ),
                      Container(width: 1, color: Colors.white.withOpacity(0.25)),
                      Expanded(
                        child: _statBlock(
                          icon: Icons.devices_rounded,
                          label: 'Platform',
                          value: _platformLabel,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _infoCard(
            icon: Icons.storage_rounded,
            iconColor: AppColors.brand,
            title: 'Local Storage Only',
            description:
                'All your invoices, customer details, and business profile are saved only on this device using an offline database. No data is ever sent to a server or the cloud — the app works fully without internet.',
          ),
          const SizedBox(height: 12),

          _infoCard(
            icon: Icons.warning_amber_rounded,
            iconColor: AppColors.amberDeep,
            title: 'What Can Cause Data Loss',
            description:
                'On this device ($_platformLabel), your invoices will be deleted only if you $_dataLossTrigger. Simply closing the app, restarting your phone, or losing internet connection does NOT affect your saved data.',
          ),
          const SizedBox(height: 12),

          _infoCard(
            icon: Icons.verified_user_outlined,
            iconColor: AppColors.success,
            title: 'Privacy by Design',
            description:
                'Since nothing leaves your device, no one else — including us — can see your customer names, amounts, or business details. This also means we cannot recover your data remotely if it\'s lost, which is why regular backups (below) matter.',
          ),
          const SizedBox(height: 12),

          // ── Backup steps (compact) ────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
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
                    Icon(Icons.backup_rounded, color: AppColors.brand, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'How to Back Up Your Invoices',
                        style: GoogleFonts.lora(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.inkNavy,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _backupStep(
                  number: '1',
                  text: 'Open any invoice from "My Invoices" and tap View or Share',
                ),
                _backupStep(
                  number: '2',
                  text: kIsWeb
                      ? 'Save the PDF via your browser\'s download prompt, or print to Drive'
                      : 'Save the PDF to Drive, WhatsApp, email, or any folder on your phone',
                ),
                _backupStep(
                  number: '3',
                  text: 'Repeat regularly — e.g. once a week or after a big sale',
                  isLast: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Center(
            child: Column(
              children: [
                Icon(Icons.cloud_off_rounded, size: 20, color: AppColors.slateLight),
                SizedBox(height: 6),
                Text(
                  'No automatic cloud backup is available.\nThis keeps your data completely private and offline.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.slateLight, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}
  Widget _statBlock({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.9), size: 15),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: GoogleFonts.robotoMono(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.85)),
          ),
        ],
      ),
    );
  }

  Widget _backupStep({required String number, required String text, bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.brand.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.brand,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12.5, height: 1.35, color: AppColors.slate),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.paperCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.lora(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.inkNavy,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12.5, height: 1.4, color: AppColors.slate),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}