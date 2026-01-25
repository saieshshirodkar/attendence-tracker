import 'package:flutter/material.dart';

class AppTheme {
  // Dracula-inspired palette based on provided theme tokens.
  static const Color background = Color(0xFF1E1F2B); // base-100
  static const Color surface = Color(0xFF24263B); // base-200
  static const Color surfaceMuted = Color(0xFF2A2D42); // base-300
  static const Color textPrimary = Color(0xFFF8F8F2); // base-content
  static const Color textSecondary = Color(0xFFB9BBC6);

  static const Color primary = Color(0xFFFF79C6);
  static const Color primaryContent = Color(0xFF1A0F18);
  static const Color secondary = Color(0xFFBD93F9);
  static const Color accent = Color(0xFF8BE9FD);
  static const Color accentContent = Color(0xFF0E1F25);
  static const Color neutral = Color(0xFF44475A);
  static const Color info = Color(0xFF8BE9FD);
  static const Color success = Color(0xFF50FA7B);
  static const Color warning = Color(0xFFF1FA8C);
  static const Color error = Color(0xFFFF5555);

  static const String monoFont = 'Fira Code';
  static const List<String> monoStack = <String>[
    'Fira Code',
    'Fira Mono',
    'Menlo',
    'Consolas',
    'DejaVu Sans Mono',
    'monospace',
  ];

  static const TextTheme _textTheme = TextTheme(
    bodyLarge: TextStyle(
      fontFamily: monoFont,
      fontFamilyFallback: monoStack,
      color: textPrimary,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    ),
    bodyMedium: TextStyle(
      fontFamily: monoFont,
      fontFamilyFallback: monoStack,
      color: textPrimary,
      fontSize: 16,
      letterSpacing: 0.1,
    ),
    bodySmall: TextStyle(
      fontFamily: monoFont,
      fontFamilyFallback: monoStack,
      color: textSecondary,
      fontSize: 14,
      letterSpacing: 0.05,
    ),
    headlineSmall: TextStyle(
      fontFamily: monoFont,
      fontFamilyFallback: monoStack,
      color: textPrimary,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
    ),
    titleMedium: TextStyle(
      fontFamily: monoFont,
      fontFamilyFallback: monoStack,
      color: textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    fontFamily: monoFont,
    fontFamilyFallback: monoStack,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: primary,
      onPrimary: primaryContent,
      secondary: secondary,
      onSecondary: textPrimary,
      surface: surface,
      onSurface: textPrimary,
      background: background,
      onBackground: textPrimary,
      error: error,
      onError: Colors.white,
      tertiary: accent,
      onTertiary: accentContent,
    ),
    textTheme: _textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: monoFont,
        fontFamilyFallback: monoStack,
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: IconThemeData(color: textPrimary),
    ),
    cardColor: surface,
    shadowColor: Colors.black54,
    dividerColor: neutral,
    useMaterial3: true,
    visualDensity: VisualDensity.comfortable,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
  );
}
