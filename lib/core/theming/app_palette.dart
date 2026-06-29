import 'package:flutter/material.dart';

/// Raw color constants for the entire app.
/// Never use these directly in widgets — use [ColorsManager] via `context.colors` instead.
class AppPalette {
  AppPalette._();

  // ══════════════════════════════════════════
  // Primary Brand — Gaming Violet
  // ══════════════════════════════════════════
  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryLight = Color(0xFF8B5CF6);
  static const Color primaryDark = Color(0xFF6D28D9);
  static const Color primaryMuted = Color(0xFFA78BFA);
  static const Color accentGlow = Color(0xFFC084FC);
  static const Color primaryFaint = Color(0xFFDDD6FE);

  // ══════════════════════════════════════════
  // Dark Mode Surfaces (purple-tinted blacks)
  // ══════════════════════════════════════════
  static const Color darkScaffold = Color(0xFF0A0A12);
  static const Color darkSurface = Color(0xFF13111C);
  static const Color darkSurfaceElevated = Color(0xFF1C1928);
  static const Color darkSurfaceHighest = Color(0xFF252236);

  // ══════════════════════════════════════════
  // Light Mode Surfaces (purple-tinted whites)
  // ══════════════════════════════════════════
  static const Color lightScaffold = Color(0xFFFAF8FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFF3F0FA);
  static const Color lightSurfaceHighest = Color(0xFFEBE5F6);

  // ══════════════════════════════════════════
  // Text — Dark Mode
  // ══════════════════════════════════════════
  static const Color darkTextMain = Color(0xFFF0ECF9);
  static const Color darkTextBody = Color(0xFFA09BB0);
  static const Color darkTextSub = Color(0xFF6E6880);

  // ══════════════════════════════════════════
  // Text — Light Mode
  // ══════════════════════════════════════════
  static const Color lightTextMain = Color(0xFF1A1625);
  static const Color lightTextBody = Color(0xFF5C5670);
  static const Color lightTextSub = Color(0xFF8A849C);

  // ══════════════════════════════════════════
  // Borders
  // ══════════════════════════════════════════
  static const Color darkBorder = Color(0xFF2D2740);
  static const Color lightBorder = Color(0xFFE0DBF0);

  // ══════════════════════════════════════════
  // Rank Colors (shared across themes)
  // ══════════════════════════════════════════
  static const Color gold = Color(0xFFF59E0B);
  static const Color goldBright = Color(0xFFFBBF24);
  static const Color silver = Color(0xFF94A3B8);
  static const Color silverBright = Color(0xFFCBD5E1);
  static const Color bronze = Color(0xFFD97706);
  static const Color bronzeBright = Color(0xFFF59E0B);
  static const Color unranked = Color(0xFF475569);

  // ══════════════════════════════════════════
  // Status Colors (shared across themes)
  // ══════════════════════════════════════════
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
}
