import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
      colorScheme: ColorScheme(
        primary: const Color(0xFFCBE4EB),
        onPrimary: const Color(0xFFCBE4EB),
        secondary: const Color(0xFFE5F1F6),
        onSecondary: const Color(0xFFFAFFFF),
        error: Colors.red,
        onError: Colors.red.shade900,
        background: const Color(0xFFCBE4EB),
        onBackground: const Color(0xFFCBE4EB),
        surface: Colors.black,
        onSurface: Colors.black,
        tertiary: Colors.black45,
        brightness: Brightness.light,
      ),
      brightness: Brightness.light,
      useMaterial3: true);

  static final darkTheme = ThemeData(
      colorScheme: ColorScheme(
          primary: const Color(0xFF4C465B),
          onPrimary: const Color(0xFF4C465B),
          secondary: const Color(0xFF655F6D),
          onSecondary: const Color(0xFF655F6D),
          error: Colors.red,
          onError: Colors.red.shade900,
          background: const Color(0xFF4C465B),
          onBackground: const Color(0xFF4C465B),
          surface: Colors.white,
          onSurface: Colors.white,
          tertiary: Colors.white60,
          brightness: Brightness.dark),
      brightness: Brightness.dark,
      useMaterial3: true);
}
