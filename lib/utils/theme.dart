import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color errorColor = Color(0xFFB00020);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primarySwatch: MaterialColor(0xFF6C63FF, {
      50: Color(0xFFEEEDFF),
      100: Color(0xFFD4D1FF),
      200: Color(0xFFB8B3FF),
      300: Color(0xFF9C95FF),
      400: Color(0xFF847DFF),
      500: Color(0xFF6C63FF),
      600: Color(0xFF5A52E6),
      700: Color(0xFF4840CC),
      800: Color(0xFF362FB3),
      900: Color(0xFF1F1A99),
    }),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      surface: Colors.white,
      background: Color(0xFFF8F9FA),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primarySwatch: MaterialColor(0xFF6C63FF, {
      50: Color(0xFFEEEDFF),
      100: Color(0xFFD4D1FF),
      200: Color(0xFFB8B3FF),
      300: Color(0xFF9C95FF),
      400: Color(0xFF847DFF),
      500: Color(0xFF6C63FF),
      600: Color(0xFF5A52E6),
      700: Color(0xFF4840CC),
      800: Color(0xFF362FB3),
      900: Color(0xFF1F1A99),
    }),
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      surface: Color(0xFF1E1E1E),
      background: Color(0xFF121212),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      color: const Color(0xFF2D2D2D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
