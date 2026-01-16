import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF0D47A1); // Deep Navy Blue
  static const Color secondaryColor = Color(0xFF00C853); // Emerald Green
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFD32F2F);
  
  // Dark Colors
  static const Color primaryDarkColor = Color(0xFF90CAF9); // Light Blue for Dark Mode
  static const Color surfaceDarkColor = Color(0xFF121212);
  static const Color backgroundDarkColor = Color(0xFF1E1E1E);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: surfaceColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        surface: surfaceColor,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.light().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: _inputDecorationTheme(isDark: false),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryDarkColor,
      scaffoldBackgroundColor: surfaceDarkColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryDarkColor,
        primary: primaryDarkColor,
        secondary: secondaryColor,
        error: errorColor,
        surface: backgroundDarkColor,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceDarkColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDarkColor,
          foregroundColor: Colors.black,
          textStyle: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: _inputDecorationTheme(isDark: true),
    );
  }

  static InputDecorationTheme _inputDecorationTheme({required bool isDark}) {
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade400;
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: isDark ? primaryDarkColor : primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorColor, width: 1.5),
      ),
      labelStyle: GoogleFonts.cairo(color: isDark ? Colors.white70 : Colors.black87),
      hintStyle: GoogleFonts.cairo(color: isDark ? Colors.white54 : Colors.black54),
    );
  }
}
