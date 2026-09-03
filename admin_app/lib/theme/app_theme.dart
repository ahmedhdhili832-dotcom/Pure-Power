import 'package:flutter/material.dart';

class AppTheme {
  static const green = Color(0xFF2F6B4F);
  static const navy = Color(0xFF102A43);
  static const cream = Color(0xFFF7F9F7);
  static const line = Color(0xFFE3E9E5);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(seedColor: green, brightness: Brightness.light);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(primary: green, onPrimary: Colors.white, surface: Colors.white),
      scaffoldBackgroundColor: cream,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(backgroundColor: cream, foregroundColor: navy, elevation: 0),
      cardTheme: CardThemeData(color: Colors.white, elevation: 0, margin: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)), side: BorderSide(color: line))),
      inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: line)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: line)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: green, width: 1.5))),
    );
  }
}
