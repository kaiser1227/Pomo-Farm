import 'package:flutter/material.dart';

class AppTheme {
  // Leafy Green & Tomato Red colors
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color darkGreen = Color(0xFF1B5E20);
  static const Color lightGreen = Color(0xFF4CAF50);
  
  static const Color tomatoRed = Color(0xFFE53935);
  static const Color lightTomato = Color(0xFFFF5252);
  static const Color darkTomato = Color(0xFFC62828);
  static const Color backgroundDark = Color(0xFF1E1E1E);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFFF5F5F5);
  static const Color textGrey = Color(0xFFAAAAAA);
  
  static const Color error = Color(0xFFCF6679);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      primaryColor: primaryGreen,
      colorScheme: const ColorScheme.dark(
        primary: primaryGreen,
        secondary: tomatoRed,
        surface: surfaceDark,
        background: backgroundDark,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: textLight,
        onBackground: textLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textLight),
      ),
      cardTheme: CardTheme(
        color: surfaceDark,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
