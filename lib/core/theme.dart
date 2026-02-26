import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF000000);
  static const Color surfaceMuted = Color(0xFF111111);
  static const Color border = Color(0xFF333333);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF888888);

  static const Color accent = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFFF0000);

  static const TextTheme _textTheme = TextTheme(
    displaySmall: TextStyle(
      color: textPrimary,
      fontSize: 24,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.8,
    ),
    headlineMedium: TextStyle(
      color: textPrimary,
      fontSize: 32,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.2,
    ),
    titleMedium: TextStyle(
      color: textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    ),
    bodyLarge: TextStyle(
      color: textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.1,
    ),
    bodyMedium: TextStyle(
      color: textPrimary,
      fontSize: 14,
      letterSpacing: -0.1,
    ),
    bodySmall: TextStyle(
      color: textSecondary,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
    ),
    labelSmall: TextStyle(
      color: textSecondary,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      height: 1.5,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.dark(
      primary: textPrimary,
      onPrimary: background,
      secondary: textSecondary,
      onSecondary: textPrimary,
      surface: surface,
      onSurface: textPrimary,
      error: error,
      onError: textPrimary,
      outline: border,
    ),
    textTheme: _textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      iconTheme: IconThemeData(color: textPrimary, size: 20),
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: border, width: 1),
      ),
    ),
    dividerTheme: const DividerThemeData(color: border, thickness: 1, space: 1),
    useMaterial3: true,
    visualDensity: VisualDensity.standard,
  );
}
