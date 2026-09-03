import 'package:flutter/material.dart';

class AppTheme {
  static const green = Color(0xFF2F6B4F);
  static const navy = Color(0xFF102A43);
  static const cream = Color(0xFFF7F9F7);
  static const line = Color(0xFFE3E9E5);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(seedColor: green, brightness: Brightness.light);
    return ThemeData(useMaterial3: true, colorScheme: scheme.copyWith(primary: green, onPrimary: Colors.white, surface: Colors.white), scaffoldBackgroundColor: cream, fontFamily: 'Roboto', appBarTheme: const AppBarTheme(backgroundColor: cream, foregroundColor: navy, elevation: 0), cardTheme: CardThemeData(color: Colors.white, elevation: 0, margin: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)), side: BorderSide(color: line))), inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: line)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: line)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: green, width: 1.5))));
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(seedColor: green, brightness: Brightness.dark);
    return ThemeData(useMaterial3: true, colorScheme: scheme.copyWith(primary: const Color(0xFF6FB08D), surface: const Color(0xFF15221D)), scaffoldBackgroundColor: const Color(0xFF0D1713), fontFamily: 'Roboto', appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0D1713), foregroundColor: Colors.white, elevation: 0), cardTheme: CardThemeData(color: const Color(0xFF15221D), elevation: 0, margin: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), side: BorderSide(color: Colors.white12))), inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: const Color(0xFF15221D), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.white12)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.white12)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF6FB08D), width: 1.5))));
  }
}
