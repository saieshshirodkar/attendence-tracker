import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF0D1117);
  static const Color surface = Color(0xFF161B22);
  static const Color accent = Color(0xFF5DE28F);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF9BA4B5);

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: accent,
      secondary: accent,
      surface: surface,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(color: textPrimary, fontSize: 16),
      bodySmall: TextStyle(color: textSecondary, fontSize: 14),
      headlineSmall: TextStyle(
        color: textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardColor: surface,
    useMaterial3: true,
  );
}
