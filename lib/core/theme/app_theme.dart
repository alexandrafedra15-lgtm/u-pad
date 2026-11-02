import 'package:flutter/material.dart';

/// U-Pad Color System — Opción A: "Enfoque Orgánico & Calma"
/// Psicología aplicada: calor humano, antiestrés, recompensa y cero fatiga visual.
class AppTheme {
  // ─── Primario: Terracota Suave — Motivación cálida, sin ansiedad ───────────
  static const Color primary      = Color(0xFFE07A5F); // Terracota suave
  static const Color primaryLight = Color(0xFFEB9F8A); // Melocotón claro
  static const Color primaryDark  = Color(0xFFC45E44); // Terracota profundo

  // ─── Salud & Hábitos: Verde Sabio — Serenidad, concentración, bienestar ───
  static const Color healthGreen   = Color(0xFF81B29A); // Verde sabio principal
  static const Color waterGreen    = Color(0xFF6AAF92); // Agua y naturaleza
  static const Color sleepLavender = Color(0xFFB8A9C9); // Lavanda cálido para sueño
  static const Color exerciseAmber = Color(0xFFF4A261); // Miel dorada para ejercicio

  // ─── Gamificación & Recompensas: Miel Dorada — Dopamina positiva ──────────
  static const Color xpHoney    = Color(0xFFF4A261); // Recompensas, XP, rachas
  static const Color streakFire = Color(0xFFFA8231); // Racha activa, urgencia suave
  static const Color canvasRose = Color(0xFFD64045); // Badge Canvas LMS

  // ─── Texto ────────────────────────────────────────────────────────────────
  static const Color textDark  = Color(0xFF2B2D42); // Carbón cálido — alta legibilidad
  static const Color textMuted = Color(0xFF8D8FA1); // Gris suave para subtítulos

  // ─── Superficies Light: Crema Avena — Cero fatiga visual ─────────────────
  static const Color bgLight   = Color(0xFFFDFBF7); // Crema avena
  static const Color cardLight = Color(0xFFFFFFFF); // Blanco limpio para cards
  static const Color divider   = Color(0xFFEEEBE4); // Separadores cálidos

  // ─── Superficies Dark: Oscuro cálido — No frío ni clínico ────────────────
  static const Color bgDark    = Color(0xFF1E1B18); // Marrón oscuro profundo
  static const Color cardDark  = Color(0xFF2C2823); // Card oscura cálida
  static const Color textLight = Color(0xFFFDFBF7); // Crema para texto en dark

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: bgLight,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: healthGreen,
        tertiary: xpHoney,
        surface: cardLight,
        error: canvasRose,
      ),
      cardTheme: CardThemeData(
        color: cardLight,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: divider),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: textDark),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardLight,
        indicatorColor: const Color(0xFFF5DDD6), // Terracota muy suave
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF5F2EC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryLight,
      scaffoldBackgroundColor: bgDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryLight,
        secondary: healthGreen,
        tertiary: xpHoney,
        surface: cardDark,
        error: canvasRose,
      ),
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withOpacity(0.07)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textLight,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: textLight),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardDark,
        indicatorColor: primary.withOpacity(0.25),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
