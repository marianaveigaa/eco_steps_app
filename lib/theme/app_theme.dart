import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF16A34A);
  static const Color secondary = Color(0xFF14B8A6);
  static const Color accent = Color(0xFFFBBF24);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF0B1220);
  static const Color textLight = Color(0xFF374151);
  static const Color textDark = Color(0xFFE2E8F0);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: secondary,
      tertiary: accent,
      surface: surfaceLight,
      onSurface: textLight,
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(),
      bodyMedium: TextStyle(),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      tertiary: accent,
      surface: surfaceDark,
      onSurface: textDark,
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(),
      bodyMedium: TextStyle(),
    ),
  );
}
