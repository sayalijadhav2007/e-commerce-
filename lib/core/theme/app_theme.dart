import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData? light;

  // Wagba Dark Theme
  static ThemeData get lightTheme {
    const background = Color(0xFF0E0E0E);
    const surface = Color(0xFF1C1C1E);
    const primaryOrange = Color(0xFFFF6A00);
    const accentRed = Color(0xFFFF3B30);
    const outline = Color(0xFF2C2C2E);
    const secondaryText = Color(0xFFB3B3B3);

    final baseScheme = ColorScheme.fromSeed(
      seedColor: primaryOrange,
      brightness: Brightness.dark,
    );

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      cardColor: surface,
      colorScheme: baseScheme.copyWith(
        primary: primaryOrange,
        onPrimary: Colors.white,
        secondary: accentRed,
        onSecondary: Colors.white,
        surface: surface,
        onSurface: Colors.white,
        outline: outline,
        error: accentRed,
        onError: Colors.white,
      ),
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
        headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        bodySmall: TextStyle(fontSize: 12, color: secondaryText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          shape: const StadiumBorder(),
          backgroundColor: primaryOrange,
          foregroundColor: Colors.white,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          shape: const StadiumBorder(),
          foregroundColor: Colors.white,
          side: const BorderSide(color: outline),
        ),
      ),
      cardTheme: const CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF121212),
        selectedItemColor: primaryOrange,
        unselectedItemColor: Color(0xFF8A8A96),
        type: BottomNavigationBarType.fixed,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1C1C1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: primaryOrange),
        ),
        hintStyle: const TextStyle(color: secondaryText),
      ),
    );
  }

  static ThemeData get darkTheme {
    return lightTheme;
  }
}
