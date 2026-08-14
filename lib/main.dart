import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator/screens/splash_screen.dart';
import 'package:invoice_generator/services/auto_backup_service.dart';
import 'package:invoice_generator/services/business_profile_service.dart';
import 'package:invoice_generator/services/device_id_service.dart';
import 'package:invoice_generator/services/invoice_storage_service.dart';
import 'package:invoice_generator/theme/app_theme.dart';
import 'package:upgrader/upgrader.dart';
// ★ Force update — checks the live Play Store / App Store listing on
// every app launch and blocks the app with a non-dismissible dialog if
// the installed version is older than what's published. Same setup as
// Spendly. (pubspec.yaml already has `upgrader` — used by the manual
// "Check for Updates" tile in SettingsScreen too.)

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DeviceIdService.instance.init();
  await InvoiceStorageService.instance.init();
  await BusinessProfileService.instance.init();
  await AutoBackupService.instance.init();

  runApp(const InvoiceApp());
}

// ★ Force-update config, shared by the whole app (built once so it's
// not recreated on every rebuild — upgrader keeps its own internal
// state/cache tied to this instance).
//
// - durationUntilAlertAgain: Duration.zero → no "ask me again in 3
//   days" cooldown. The moment a new version goes live, the VERY NEXT
//   time any user opens the app they see the prompt — not days later.
// - checkOnResume: false → only checks on cold-start, not every time
//   the app comes back from background.
// - debugLogging: false → keep it quiet in release; flip to true
//   temporarily if you need to debug why a version isn't detected.
final upgrader = Upgrader(
  debugLogging: false,
  durationUntilAlertAgain: Duration.zero,
  checkOnResume: false,
);

class InvoiceApp extends StatelessWidget {
  const InvoiceApp({super.key});

  /// Play Store / App Store listings are what `upgrader` checks against,
  /// so the force-update dialog only makes sense on Android/iOS. On web
  /// and desktop this app already has its own GitHub-release-based
  /// check (see SettingsScreen → "Check for Updates"), triggered
  /// manually instead of forced at launch.
  bool get _isStoreSupportedPlatform {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InvoiceNow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashScreen(),
      // ★ `builder` wraps EVERY screen in the app (it sits above the
      // Navigator), so the update check/dialog works no matter which
      // route the user is currently on — not just the splash screen.
      builder: (context, child) {
        if (!_isStoreSupportedPlatform) {
          return child ?? const SizedBox.shrink();
        }
        return UpgradeAlert(
          upgrader: upgrader,
          // ★ These three flags together are what make it a TRUE force
          // update: no "Ignore this version" button, no "Remind me
          // later" button, and the dialog can't be dismissed by
          // tapping outside it or pressing back. The only way forward
          // is tapping "Update Now", which sends the user to the
          // Play Store / App Store listing.
          showIgnore: false,
          showLater: false,
          barrierDismissible: false,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}