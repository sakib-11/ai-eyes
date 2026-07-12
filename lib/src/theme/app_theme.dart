import 'package:flutter/material.dart';

/// Centralised pastel colour palette for AI Eyes.
///
/// Soft, calming tones chosen for accessibility: dark slate text on light
/// pastel surfaces keeps strong contrast for low-vision users while keeping
/// the interface gentle and friendly.
class AppColors {
  AppColors._();

  // Background gradient (top -> mid -> bottom)
  static const Color backgroundTop = Color(0xFFFDF2F8); // soft blush pink
  static const Color backgroundMid = Color(0xFFF3E8FF); // lavender
  static const Color backgroundBottom = Color(0xFFE3F4F1); // mint mist

  // Primary pastels
  static const Color primary = Color(0xFFB8A1E3); // lavender
  static const Color primarySoft = Color(0xFFD9CCF2); // light lavender
  static const Color secondary = Color(0xFFF7B7D2); // pastel pink
  static const Color secondarySoft = Color(0xFFFBDDE9); // light pink

  // Accent pastels
  static const Color accentMint = Color(0xFFA8E6CF);
  static const Color accentPeach = Color(0xFFFFD3B6);
  static const Color accentBlue = Color(0xFFAED9F0);
  static const Color accentYellow = Color(0xFFFCE7A6);

  // Surfaces
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceTint = Color(0xFFF8F4FF); // near-white lavender

  // Text
  static const Color textPrimary = Color(0xFF3D3A4B); // deep slate
  static const Color textSecondary = Color(0xFF6B6580); // muted slate
  static const Color textOnAccent = Color(0xFF3D3A4B); // readable on pastel

  // Status
  static const Color danger = Color(0xFFF6A6B2); // soft coral for "stop"
  static const Color success = Color(0xFFB5E8C9); // soft green
}

/// Light, pastel [ThemeData] used across the whole app.
class AppTheme {
  AppTheme._();

  static const String fontFamily = 'Roboto';

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: AppColors.surfaceTint,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        surface: AppColors.surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnAccent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
