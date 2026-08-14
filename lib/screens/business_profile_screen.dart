import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../services/business_profile_service.dart';
import '../theme/app_theme.dart';
import 'camera_capture_screen.dart';

class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _subtitle;
  late final TextEditingController _phone;
  late final TextEditingController _address;

  String _logoBase64 = '';
  bool _pickingLogo = false;

  @override
  void initState() {
    super.initState();
    final profile = BusinessProfileService.instance.get();
    _name = TextEditingController(
        text: profile.name == 'Your Business Name' ? '' : profile.name);
    _subtitle = TextEditingController(text: profile.subtitle);
    _phone = TextEditingController(text: profile.phone);
    _address = TextEditingController(text: profile.address);
    _logoBase64 = profile.logoBase64;
  }

  @override
  void dispose() {
    _name.dispose();
    _subtitle.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  /// Camera capture: on Web and mobile (Android/iOS) we use the
  /// `camera` package's live getUserMedia/native preview via
  /// CameraCaptureScreen — this gives a real "Take Photo" experience
  /// instead of image_picker's file-input fallback (which desktop
  /// browsers silently treat as a regular file picker).
  /// On macOS/Windows/Linux desktop there's no plug-and-play camera
  /// delegate for image_picker, so we skip camera and go straight to
  /// the file picker there.
  bool get _cameraAvailable =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  Future<void> _pickLogoFrom(ImageSource source) async {
    setState(() => _pickingLogo = true);
    try {
      if (source == ImageSource.camera) {
        // Live camera preview screen — works on Web + Android + iOS.
        final bytes = await Navigator.of(context).push<Uint8List>(
          MaterialPageRoute(builder: (_) => const CameraCaptureScreen()),
        );
        if (bytes != null) {
          setState(() => _logoBase64 = base64Encode(bytes));
        }
        return;
      }

      // Gallery / file picker path — image_picker handles this fine
      // on every platform.
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() => _logoBase64 = base64Encode(bytes));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not pick image: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _pickingLogo = false);
    }
  }

  Future<void> _showImageSourceSheet() async {
    // Desktop has no working camera path without custom native code —
    // skip the sheet entirely and open the file picker directly.
    if (!_cameraAvailable) {
      await _pickLogoFrom(ImageSource.gallery);
      return;
    }

    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.paperCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Add Business Logo',
                style: GoogleFonts.lora(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              _sourceOption(
                icon: Icons.photo_camera_outlined,
                label: 'Take Photo',
                onTap: () {
                  Navigator.pop(ctx);
                  _pickLogoFrom(ImageSource.camera);
                },
              ),
              const SizedBox(height: 10),
              _sourceOption(
                icon: Icons.image_outlined,
                label: 'Choose from Gallery',
                onTap: () {
                  Navigator.pop(ctx);
                  _pickLogoFrom(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 19, color: AppColors.brand),
        label: Text(label,
            style: const TextStyle(color: AppColors.brand, fontWeight: FontWeight.w600)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.brand),
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  void _removeLogo() {
    setState(() => _logoBase64 = '');
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final profile = BusinessProfileService.instance.get().copyWith(
          name: _name.text.trim(),
          subtitle: _subtitle.text.trim(),
          phone: _phone.text.trim(),
          address: _address.text.trim(),
          logoBase64: _logoBase64,
        );

    await BusinessProfileService.instance.save(profile);

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.paperCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.green, size: 60),
            SizedBox(height: 16),
            Text(
              'Success!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.inkNavy),
            ),
            SizedBox(height: 8),
            Text(
              'Business details saved successfully',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        title: const Text('Business Details'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.brand.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.brand.withValues(alpha: 0.15)),
                ),
                child: const Text(
                  'These details will appear on every invoice. '
                  'Your customers will see this information, so please fill it accurately.',
                  style: TextStyle(fontSize: 13.5, height: 1.4, color: AppColors.inkNavy),
                ),
              ),
              const SizedBox(height: 16),
              _buildLogoPicker(),
              const SizedBox(height: 18),
              _field(
                _name,
                'Business Name',
                'Enter your business name',
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Business name is required' : null,
              ),
              const SizedBox(height: 14),
              _field(_subtitle, 'Tagline (optional)', 'Enter a short tagline'),
              const SizedBox(height: 14),
              _field(
                _phone,
                'Phone Number',
                'Enter your phone number',
                keyboardType: TextInputType.phone,
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Phone number is required';
                  if (v.trim().length != 10) return 'Enter a valid 10 digit phone number';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              _field(_address, 'Address', 'Enter your business address', maxLines: 2),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Business Logo (optional)',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.slate)),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.paperCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
              ),
              clipBehavior: Clip.antiAlias,
              child: _logoBase64.isEmpty
                  ? const Icon(Icons.storefront_outlined, color: AppColors.slateLight, size: 28)
                  : Image.memory(
                      Uint8List.fromList(base64Decode(_logoBase64)),
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _pickingLogo ? null : _showImageSourceSheet,
                      icon: _pickingLogo
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.image_outlined, size: 18, color: AppColors.brand),
                      label: Text(
                        _logoBase64.isEmpty ? 'Upload Logo' : 'Change Logo',
                        style: const TextStyle(color: AppColors.brand, fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.brand),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  if (_logoBase64.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed: _removeLogo,
                        icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Colors.red),
                        label: const Text('Remove',
                            style: TextStyle(color: Colors.red, fontSize: 12.5)),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _field(
    TextEditingController c,
    String label,
    String hint, {
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
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.slate)),
        const SizedBox(height: 5),
        TextFormField(
          controller: c,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          validator: validator,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            counterText: '',
            hintStyle: const TextStyle(color: AppColors.slateLight, fontSize: 13),
            filled: true,
            fillColor: AppColors.paperCard,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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