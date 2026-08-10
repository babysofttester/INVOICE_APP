import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:invoice_generator/screens/main_shell.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/business_profile_screen.dart';
import '../screens/storage_data_screen.dart';
import '../theme/app_theme.dart';

// ============================================================
// PUBLISH-TIME CONFIG — Only edit these two lines when you publish.
// Leave them empty ('') for now during testing — the app will
// automatically skip the online check and just show the version.
// ============================================================
class _UpdateConfig {
  static const String githubRepo = ''; // e.g. 'yourname/invoice_generator'
  static const String downloadPageUrl = ''; // e.g. 'https://github.com/yourname/invoice_generator/releases/latest'
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = '';
  bool _checkingUpdate = false;

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = '${info.version} (${info.buildNumber})';
    });
  }

  bool get _isStoreSupportedPlatform {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  Future<void> _checkForUpdate() async {
    setState(() => _checkingUpdate = true);

    try {
      if (_isStoreSupportedPlatform) {
        await _checkMobileStoreUpdate();
      } else {
        await _checkDesktopUpdate();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not check for updates')),
        );
      }
    } finally {
      if (mounted) setState(() => _checkingUpdate = false);
    }
  }

  // --- Android / iOS: Play Store / App Store check ---
  Future<void> _checkMobileStoreUpdate() async {
    final upgrader = Upgrader(
      debugLogging: true,
      countryCode: 'IN',
      durationUntilAlertAgain: const Duration(minutes: 1),
    );

    final isUpdateAvailable = await upgrader.isUpdateAvailable();

    if (!mounted) return;

    if (isUpdateAvailable) {
      showDialog(
        context: context,
        builder: (context) => UpgradeAlert(
          upgrader: upgrader,
          showLater: true,
          showIgnore: false,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are using the latest version ✓')),
      );
    }
  }

  // --- macOS / Windows / Linux: GitHub Releases check (auto-skips if not configured) ---
  Future<void> _checkDesktopUpdate() async {
    final repo = _UpdateConfig.githubRepo;

    // Not configured yet (testing phase) — just show current version.
    if (repo.isEmpty) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('App Version'),
          content: Text(
            'You are running version $_appVersion.\n\n'
            'Online update checks will be available once the app is published.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Configured (post-publish) — do the real check.
    try {
      final response = await http.get(
        Uri.parse('https://api.github.com/repos/$repo/releases/latest'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch latest release');
      }

      final data = jsonDecode(response.body);
      final latestVersion = (data['tag_name'] as String).replaceAll('v', '');
      final currentVersion = _appVersion.split(' ').first;

      if (!mounted) return;

      if (latestVersion != currentVersion) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Update Available'),
            content: Text(
              'A new version ($latestVersion) is available.\nYou have $currentVersion.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Later'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final uri = Uri.parse(_UpdateConfig.downloadPageUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                child: const Text('Download'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You are using the latest version ✓')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not check for updates')),
        );
      }
    }
  }

 @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
        children: [
          _buildSettingsTile(
            icon: Icons.business_rounded,
            title: 'Business Details',
            subtitle: 'Name, logo, address, phone & GST',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const BusinessProfileScreen()),
            ),
          ),

          const SizedBox(height: 8),

          _buildSettingsTile(
            icon: Icons.receipt_long_outlined,
            title: 'All Invoices',
            subtitle: 'View, search & manage saved invoices',
            onTap: () => MainShell.currentTab.value = 1,
          ),

          const SizedBox(height: 8),

          _buildSettingsTile(
            icon: Icons.storage_rounded,
            title: 'Storage & Data',
            subtitle: 'Local storage, backup & data safety',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const StorageDataScreen()),
            ),
          ),

          if (!kIsWeb) ...[
            const SizedBox(height: 8),
            _buildSettingsTile(
              icon: Icons.system_update_rounded,
              title: 'Check for Updates',
              subtitle: 'Current version: $_appVersion',
              onTap: _checkForUpdate,
              trailing: _checkingUpdate
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5))
                  : null,
            ),
          ],

          const SizedBox(height: 8),

          _buildSettingsTile(
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            subtitle: 'How to use the app',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help section coming soon')),
              );
            },
          ),

          const SizedBox(height: 40),
          if (!kIsWeb) ...[
            Center(
              child: Text(
                'InvoiceNow • Version $_appVersion',
                style: const TextStyle(fontSize: 13.5, color: AppColors.slateLight),
              ),
            ),
          ]
        ],
      ),
    );
  }
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.paperCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.brand, size: 26),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.inkNavy)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(fontSize: 13, color: AppColors.slateLight)),
                ],
              ),
            ),
            trailing ?? const Icon(Icons.chevron_right_rounded, color: AppColors.slateLight),
          ],
        ),
      ),
    );
  }
}