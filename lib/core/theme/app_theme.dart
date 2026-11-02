import 'package:flutter/material.dart';

/// Equilibra-U Design System
/// Estética editorial, minimalista y orgánica. Tonos arena/papel cálido mate para cero fatiga visual.
class AppTheme {
  // ─── Colores Principales: Equilibrio, Calma y Foco ────────────────────────
  static const Color primary       = Color(0xFF284B3E); // Verde bosque profundo (equilibrio)
  static const Color primaryLight  = Color(0xFF3F6A5B); // Salvia medio
  static const Color accentRose    = Color(0xFFD87D65); // Terracota cálido sutil
  static const Color accentSand    = Color(0xFFD4A373); // Arena dorada sutil

  // ─── Hábitos & Salud (Tonos mate no chillones) ─────────────────────────────
  static const Color healthWater   = Color(0xFF4A7C7D); // Azul pizarra mineral
  static const Color healthSleep   = Color(0xFF5B507A); // Índigo crepuscular
  static const Color healthActive  = Color(0xFFC86D51); // Arcilla activa
  static const Color canvasBrand   = Color(0xFFC0392B); // Canvas LMS

  // ─── Superficies & Fondos (Elimina el blanco puro agresivo) ───────────────
  static const Color bgSand        = Color(0xFFF5F2EB); // Arena suave mate (cero brillo blanco)
  static const Color surfaceCard   = Color(0xFFFFFFFF); // Blanco cálido para tarjetas
  static const Color surfaceSubtle = Color(0xFFECE7DE); // Contraste sutil para botones y píldoras
  static const Color borderSubtle  = Color(0xFFE2DDD2); // Línea fina y limpia

  // ─── Tipografía ───────────────────────────────────────────────────────────
  static const Color textMain      = Color(0xFF1B201E); // Grafito bosque muy legible
  static const Color textSub       = Color(0xFF6E7570); // Gris mineral suave
  static const Color textLight     = Color(0xFF9EA39F); // Para detalles discretos

  // Alias compatibles
  static const Color healthGreen   = primary;
  static const Color waterGreen    = healthWater;
  static const Color sleepLavender = healthSleep;
  static const Color exerciseAmber = healthActive;
  static const Color xpHoney       = accentSand;
  static const Color streakFire    = accentRose;
  static const Color canvasRose    = canvasBrand;
  static const Color textDark      = textMain;
  static const Color textMuted     = textSub;
  static const Color bgLight       = bgSand;
  static const Color cardLight     = surfaceCard;
  static const Color divider       = borderSubtle;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: bgSand,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: accentRose,
        tertiary: accentSand,
        surface: surfaceCard,
        error: canvasBrand,
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderSubtle, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgSand,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textMain,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: textMain),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: bgSand,
        indicatorColor: primary.withOpacity(0.12),
        elevation: 0,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 11,
            color: textMain,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),
    );
  }
}
