// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// /// ---------------------------------------------------------------
// /// Design tokens — "Ledger" theme
// /// A calmer, paper-and-ink look: warm ivory page, deep-ink text and
// /// a single terracotta seal-wax accent. No gradients, no glow
// /// shadows — flat colour and honest borders, closer to a real
// /// invoice book than a generic app.
// /// ---------------------------------------------------------------
// class AppColors {
//   static const inkNavy = Color(0xFF2B241D); // primary ink (warm near-black)
//   static const deepNavy = Color(0xFF1C1712); // darkest ink, used on splash
//   static const paper = Color(0xFFF6F1E7); // page background
//   static const paperCard = Color(0xFFFFFDF9); // card surface
//   static const brand = Color(0xFFA8432B); // terracotta / wax-seal red
//   static const brandDeep = Color(0xFF7C2F1D); // pressed / deep accent
//   static const amber = Color(0xFFC48A2E);
//   static const amberDeep = Color(0xFF95681E);
//   static const success = Color(0xFF3C7A55);
//   static const slate = Color(0xFF6B6055);
//   static const slateLight = Color(0xFFA69B8B);
//   static const divider = Color(0xFFE6DCC8);
// }

// class AppTheme {
//   static ThemeData get light {
//     final base = ThemeData.light(useMaterial3: true);
//     return base.copyWith(
//       scaffoldBackgroundColor: AppColors.paper,
//       colorScheme: base.colorScheme.copyWith(
//         primary: AppColors.brand,
//         secondary: AppColors.inkNavy,
//         surface: AppColors.paperCard,
//       ),
//       textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
//         displayLarge: GoogleFonts.lora(
//           fontSize: 28,
//           fontWeight: FontWeight.w600,
//           color: AppColors.inkNavy,
//         ),
//         headlineMedium: GoogleFonts.lora(
//           fontSize: 21,
//           fontWeight: FontWeight.w600,
//           color: AppColors.inkNavy,
//         ),
//         titleMedium: GoogleFonts.lora(
//           fontSize: 17,
//           fontWeight: FontWeight.w600,
//           color: AppColors.inkNavy,
//         ),
//         bodyMedium: GoogleFonts.inter(
//           fontSize: 14,
//           color: AppColors.slate,
//           height: 1.5,
//         ),
//         bodySmall: GoogleFonts.inter(fontSize: 12, color: AppColors.slateLight),
//         labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
//       ),
//       appBarTheme: AppBarTheme(
//         backgroundColor: AppColors.paper,
//         foregroundColor: AppColors.inkNavy,
//         elevation: 0,
//         surfaceTintColor: Colors.transparent,
//         centerTitle: false,
//         titleTextStyle: GoogleFonts.lora(
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//           color: AppColors.inkNavy,
//         ),
//       ),
//       navigationBarTheme: NavigationBarThemeData(
//         backgroundColor: AppColors.paperCard,
//         indicatorColor: AppColors.brand.withOpacity(0.14),
//         surfaceTintColor: Colors.transparent,
//         elevation: 0,
//       ),
//       splashFactory: NoSplash.splashFactory,
//     );
//   }

//   /// Figures face — invoice numbers & amounts, like a typewritten
//   /// ledger column.
//   static TextStyle mono(double size, {Color? color, FontWeight? weight}) =>
//       GoogleFonts.jetBrainsMono(
//         fontSize: size,
//         color: color ?? AppColors.inkNavy,
//         fontWeight: weight ?? FontWeight.w500,
//       );
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ---------------------------------------------------------------
/// Design tokens — "Ledger" theme
/// A calmer, paper-and-ink look: warm ivory page, deep-ink text and
/// a single terracotta seal-wax accent. No gradients, no glow
/// shadows — flat colour and honest borders, closer to a real
/// invoice book than a generic app.
/// ---------------------------------------------------------------
class AppColors {
  // Sampled from the envelope logo: dark navy flap + teal body.
  static const inkNavy = Color(0xFF0B2F45); // primary ink / dark navy
  static const deepNavy = Color(0xFF072536); // darkest navy, used on splash
  static const paper = Color(0xFFF5F7F9); // cool, near-white page background
  static const paperCard = Color(0xFFFFFFFF); // card surface
  static const brand = Color(0xFF11809E); // logo teal
  static const brandDeep = Color(0xFF0B5C74); // pressed / deep teal
  static const amber = Color(0xFFC48A2E);
  static const amberDeep = Color(0xFF95681E);
  static const success = Color(0xFF2E9169);
  static const slate = Color(0xFF57626F);
  static const slateLight = Color(0xFF97A2AD);
  static const divider = Color(0xFFDFE4E8);
}

class AppTheme {
  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.paper,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.brand,
        secondary: AppColors.inkNavy,
        surface: AppColors.paperCard,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.lora(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.inkNavy,
        ),
        headlineMedium: GoogleFonts.lora(
          fontSize: 21,
          fontWeight: FontWeight.w600,
          color: AppColors.inkNavy,
        ),
        titleMedium: GoogleFonts.lora(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.inkNavy,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.slate,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.inter(fontSize: 12, color: AppColors.slateLight),
        labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.paper,
        foregroundColor: AppColors.inkNavy,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: GoogleFonts.lora(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.inkNavy,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.paperCard,
        indicatorColor: AppColors.brand.withOpacity(0.14),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      splashFactory: NoSplash.splashFactory,
    );
  }

  /// Figures face — invoice numbers & amounts, like a typewritten
  /// ledger column.
  static TextStyle mono(double size, {Color? color, FontWeight? weight}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: size,
        color: color ?? AppColors.inkNavy,
        fontWeight: weight ?? FontWeight.w500,
      );
}