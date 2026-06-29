import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Abstract contract for theme-aware colors.
/// Access via `context.colors` extension.
abstract class ColorsManager {
  // Brand
  Color get primary;
  Color get primaryLight;
  Color get primaryDark;
  Color get accentGlow;

  // Surfaces
  Color get scaffold;
  Color get surface;
  Color get surfaceElevated;
  Color get surfaceHighest;

  // Text
  Color get mainText;
  Color get bodyText;
  Color get subText;

  // Borders
  Color get border;

  // Rank
  Color get gold;
  Color get silver;
  Color get bronze;
  Color get unranked;

  // Status
  Color get error;
  Color get success;
  Color get warning;
  Color get info;
}

// ══════════════════════════════════════════
// Dark Mode Implementation
// ══════════════════════════════════════════

class DarkColors extends ColorsManager {
  @override
  Color get primary => AppPalette.primary;
  @override
  Color get primaryLight => AppPalette.primaryLight;
  @override
  Color get primaryDark => AppPalette.primaryDark;
  @override
  Color get accentGlow => AppPalette.accentGlow;

  @override
  Color get scaffold => AppPalette.darkScaffold;
  @override
  Color get surface => AppPalette.darkSurface;
  @override
  Color get surfaceElevated => AppPalette.darkSurfaceElevated;
  @override
  Color get surfaceHighest => AppPalette.darkSurfaceHighest;

  @override
  Color get mainText => AppPalette.darkTextMain;
  @override
  Color get bodyText => AppPalette.darkTextBody;
  @override
  Color get subText => AppPalette.darkTextSub;

  @override
  Color get border => AppPalette.darkBorder;

  @override
  Color get gold => AppPalette.gold;
  @override
  Color get silver => AppPalette.silver;
  @override
  Color get bronze => AppPalette.bronze;
  @override
  Color get unranked => AppPalette.unranked;

  @override
  Color get error => AppPalette.error;
  @override
  Color get success => AppPalette.success;
  @override
  Color get warning => AppPalette.warning;
  @override
  Color get info => AppPalette.info;
}

// ══════════════════════════════════════════
// Light Mode Implementation
// ══════════════════════════════════════════

class LightColors extends ColorsManager {
  @override
  Color get primary => AppPalette.primary;
  @override
  Color get primaryLight => AppPalette.primaryMuted;
  @override
  Color get primaryDark => AppPalette.primaryDark;
  @override
  Color get accentGlow => AppPalette.primaryLight;

  @override
  Color get scaffold => AppPalette.lightScaffold;
  @override
  Color get surface => AppPalette.lightSurface;
  @override
  Color get surfaceElevated => AppPalette.lightSurfaceElevated;
  @override
  Color get surfaceHighest => AppPalette.lightSurfaceHighest;

  @override
  Color get mainText => AppPalette.lightTextMain;
  @override
  Color get bodyText => AppPalette.lightTextBody;
  @override
  Color get subText => AppPalette.lightTextSub;

  @override
  Color get border => AppPalette.lightBorder;

  @override
  Color get gold => AppPalette.gold;
  @override
  Color get silver => AppPalette.silver;
  @override
  Color get bronze => AppPalette.bronze;
  @override
  Color get unranked => AppPalette.unranked;

  @override
  Color get error => AppPalette.error;
  @override
  Color get success => AppPalette.success;
  @override
  Color get warning => AppPalette.warning;
  @override
  Color get info => AppPalette.info;
}

// ══════════════════════════════════════════
// BuildContext Extensions
// ══════════════════════════════════════════

extension ThemeContextExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  ThemeData get theme => Theme.of(this);

  ColorsManager get colors => isDarkMode ? DarkColors() : LightColors();
}
