import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Defined Color Palette
  static const Color backgroundBlack = Color(0xFF0A0A0A);
  static const Color cardGray = Color(0xFF1E1E1E);
  static const Color cardGrayLight = Color(0xFF2C2C2C);
  
  // Accents
  static const Color primaryOrange = Color(0xFFFF6D00); // Trend indicator
  static const Color alertRed = Color(0xFFFF3B30); // Alerts & error
  static const Color successGreen = Color(0xFF00E676); // Positive status
  
  // Text Colors
  static const Color textPrimary = Color(0xFFE0E0E0);
  static const Color textSecondary = Color(0xFFA0A0A0);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundBlack,
      primaryColor: primaryOrange,
      colorScheme: const ColorScheme.dark(
        primary: primaryOrange,
        secondary: successGreen,
        surface: cardGray,
        error: alertRed,
        onPrimary: backgroundBlack,
        onSecondary: backgroundBlack,
        onSurface: textPrimary,
        onError: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundBlack,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: cardGray,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        margin: const EdgeInsets.all(8),
      ),
      // High-contrast monochrome font scheme using JetBrains Mono
      textTheme: GoogleFonts.jetBrainsMonoTextTheme(
        ThemeData.dark().textTheme.copyWith(
          displayLarge: const TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
          displayMedium: const TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
          displaySmall: const TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
          headlineMedium: const TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
          titleLarge: const TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
          titleMedium: const TextStyle(color: textPrimary, fontWeight: FontWeight.w500),
          bodyLarge: const TextStyle(color: textPrimary),
          bodyMedium: const TextStyle(color: textSecondary),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: backgroundBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.jetBrainsMono(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardGrayLight,
        hintStyle: const TextStyle(color: textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryOrange, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: alertRed, width: 2),
        ),
      ),
    );
  }
}
