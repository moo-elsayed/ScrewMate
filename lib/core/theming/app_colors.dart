import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Legacy color constants.
/// Prefer using `context.colors` from [ColorsManager] for theme-aware colors.
class AppColors {
  // Surfaces — dark mode defaults (for backward compatibility)
  static const backgroundColor = AppPalette.darkScaffold;
  static const appbarColor = AppPalette.darkSurfaceHighest;
  static const roundDetailsForPlayerColor = AppPalette.darkSurfaceElevated;

  // Brand
  static const purple = AppPalette.primary;

  // Rank
  static const gold = AppPalette.gold;
  static const sliver = AppPalette.silver;
  static const bronze = AppPalette.bronze;
  static const unranked = AppPalette.unranked;

  // Status
  static const Color error = AppPalette.error;
  static const Color success = AppPalette.success;
  static const Color warning = AppPalette.warning;
  static const Color info = AppPalette.info;
}
