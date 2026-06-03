import 'package:flutter/material.dart';

class AppTheme {
  // Color palette matching the web design
  static const Color ink = Color(0xFF1A1A2E);
  static const Color ink2 = Color(0xFF4A4A6A);
  static const Color ink3 = Color(0xFF8888AA);
  static const Color paper = Color(0xFFFAF9F6);
  static const Color paper2 = Color(0xFFF3F1EB);
  static const Color paper3 = Color(0xFFEBE8DF);
  static const Color accent = Color(0xFFC84B31);
  static const Color accentLight = Color(0xFFE8A87C);
  static const Color accentGreen = Color(0xFF4A7C59);
  static const Color blue = Color(0xFF2D6A9F);
  static const Color purple = Color(0xFF7C4D9F);
  static const Color lineColor = Color(0xFFE0DDD4);
  static const Color sidebarBg = Color(0xFF1A1A2E);
  static const Color highRed = Color(0xFFFFF0ED);
  static const Color highYellow = Color(0xFFFFFBE0);
  static const Color highGreen = Color(0xFFEDF7F0);

  static const Color priorityHigh = Color(0xFFC84B31);
  static const Color priorityMed = Color(0xFFE8A87C);
  static const Color priorityLow = Color(0xFF4A7C59);

  static const Map<String, Color> noteColors = {
    'red': Color(0xFFC84B31),
    'yellow': Color(0xFFE8A87C),
    'green': Color(0xFF4A7C59),
    'blue': Color(0xFF2D6A9F),
    'purple': Color(0xFF7C4D9F),
  };

  static TextTheme get textTheme => const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Lora',
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Lora',
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: ink,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Lora',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: ink,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Lora',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: ink,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 15,
          color: ink,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 14,
          color: ink2,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 12,
          color: ink3,
        ),
        labelLarge: TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ink,
        ),
        labelSmall: TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 10,
          letterSpacing: 1.5,
          color: ink3,
        ),
      );

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        fontFamily: 'DM Sans',
        colorScheme: const ColorScheme.light(
          primary: accent,
          secondary: accentLight,
          tertiary: accentGreen,
          surface: paper,
          onPrimary: Colors.white,
          onSurface: ink,
        ),
        scaffoldBackgroundColor: paper2,
        textTheme: textTheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: paper,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: ink),
          titleTextStyle: TextStyle(
            fontFamily: 'Lora',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: ink,
          ),
        ),
        cardTheme: CardThemeData(
          color: paper,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: lineColor, width: 1),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: paper,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: lineColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: lineColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: accent, width: 1.5),
          ),
          hintStyle: const TextStyle(fontFamily: 'DM Sans', color: ink3, fontSize: 14),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accent,
            foregroundColor: Colors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: const TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: sidebarBg,
          selectedItemColor: accentLight,
          unselectedItemColor: Colors.white.withValues(alpha: 0.4),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(fontFamily: 'DM Sans', fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontFamily: 'DM Sans', fontSize: 11),
        ),
        dividerTheme: const DividerThemeData(
          color: lineColor,
          thickness: 1,
          space: 0,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: paper2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: lineColor),
          ),
          labelStyle: const TextStyle(fontFamily: 'DM Sans', fontSize: 12, color: ink2),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        ),
      );
}
