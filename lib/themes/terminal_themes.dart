import 'package:flutter/material.dart';

class TerminalThemes {
  // Dark Theme (Default)
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF0D9488), // Teal 600
      scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
      cardColor: const Color(0xFF1E293B), // Slate 800
      dividerColor: const Color(0xFF334155), // Slate 700
      disabledColor: const Color(0xFF64748B), // Slate 500
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF0D9488),
        secondary: Color(0xFF38BDF8), // Sky 400
        surface: Color(0xFF1E293B),
        background: const Color(0xFF0F172A),
        error: Color(0xFFEF4444), // Red 500
      ),
      textTheme: const TextTheme(
        headline5: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22),
        headline6: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        bodyText1: TextStyle(color: Color(0xFFE2E8F0), fontSize: 16),
        bodyText2: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
      ),
    );
  }

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFF0F766E), // Teal 700
      scaffoldBackgroundColor: const Color(0xFFF8FAFC), // Slate 50
      cardColor: Colors.white,
      dividerColor: const Color(0xFFE2E8F0), // Slate 200
      disabledColor: const Color(0xFF94A3B8), // Slate 400
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF0F766E),
        secondary: Color(0xFF0284C7), // Sky 600
        surface: Colors.white,
        background: const Color(0xFFF8FAFC),
        error: Color(0xFFDC2626), // Red 600
      ),
      textTheme: const TextTheme(
        headline5: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A), fontSize: 22),
        headline6: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A), fontSize: 18),
        bodyText1: TextStyle(color: Color(0xFF334155), fontSize: 16),
        bodyText2: TextStyle(color: Color(0xFF64748B), fontSize: 14),
      ),
    );
  }

  // Glasses Mode Theme (Ultra High Contrast)
  static ThemeData get glassesTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFF000000), // Pure Black for sharp contrast
      scaffoldBackgroundColor: const Color(0xFFFFFFFF), // Pure White
      cardColor: const Color(0xFFF1F5F9), // Light Slate for separation
      dividerColor: const Color(0xFF000000), // Thick lines
      disabledColor: const Color(0xFF475569), // Darker gray for disabled
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF000000),
        secondary: Color(0xFF2563EB), // Intense Blue
        surface: Color(0xFFFFFFFF),
        background: const Color(0xFFFFFFFF),
        error: Color(0xFFD00000), // Intense Red
      ),
      textTheme: const TextTheme(
        headline5: TextStyle(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 24, letterSpacing: 1.0),
        headline6: TextStyle(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 20, letterSpacing: 0.5),
        bodyText1: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
        bodyText2: TextStyle(color: Color(0xFF1E293B), fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }
}
