import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator/screens/splash_screen.dart';
import 'package:invoice_generator/services/business_profile_service.dart';
import 'package:invoice_generator/services/device_id_service.dart';
import 'package:invoice_generator/services/invoice_storage_service.dart';
import 'package:invoice_generator/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DeviceIdService.instance.init();
  await InvoiceStorageService.instance.init();
  await BusinessProfileService.instance.init();

  runApp(const InvoiceApp());
}

class InvoiceApp extends StatelessWidget {
  const InvoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InvoiceNow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}