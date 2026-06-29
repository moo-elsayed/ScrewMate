import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_palette.dart';

class AppTheme {
  AppTheme._();

  // ══════════════════════════════════════════
  // ☀️ Light Theme
  // ══════════════════════════════════════════
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    primaryColor: AppPalette.primary,
    scaffoldBackgroundColor: AppPalette.lightScaffold,
    useMaterial3: true,
    fontFamily: GoogleFonts.lato().fontFamily,

    colorScheme: const ColorScheme.light(
      primary: AppPalette.primary,
      onPrimary: Colors.white,
      secondary: AppPalette.primaryMuted,
      onSecondary: Colors.white,
      surface: AppPalette.lightSurface,
      onSurface: AppPalette.lightTextMain,
      surfaceContainerHighest: AppPalette.lightSurfaceHighest,
      error: AppPalette.error,
      onError: Colors.white,
      outline: AppPalette.lightBorder,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppPalette.lightSurfaceHighest,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppPalette.lightTextMain),
      titleTextStyle: GoogleFonts.lato(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        color: AppPalette.lightTextMain,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppPalette.lightSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppPalette.lightBorder, width: 0.5),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppPalette.lightSurfaceElevated,
      selectedColor: AppPalette.primary,
      labelStyle: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppPalette.lightTextMain,
      ),
      secondaryLabelStyle: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      side: const BorderSide(color: AppPalette.lightBorder, width: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: AppPalette.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppPalette.primary;
        }
        return AppPalette.lightTextSub;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppPalette.primaryFaint;
        }
        return AppPalette.lightSurfaceElevated;
      }),
    ),

    dividerTheme: const DividerThemeData(
      color: AppPalette.lightBorder,
      thickness: 0.5,
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppPalette.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppPalette.lightSurfaceElevated,
      hintStyle: GoogleFonts.lato(color: AppPalette.lightTextSub),
      contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppPalette.lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppPalette.lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppPalette.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppPalette.error),
      ),
    ),

    textTheme: _buildTextTheme(AppPalette.lightTextMain, AppPalette.lightTextBody),
  );

  // ══════════════════════════════════════════
  // 🌙 Dark Theme
  // ══════════════════════════════════════════
  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppPalette.primary,
    scaffoldBackgroundColor: AppPalette.darkScaffold,
    useMaterial3: true,
    fontFamily: GoogleFonts.lato().fontFamily,

    colorScheme: const ColorScheme.dark(
      primary: AppPalette.primaryLight,
      onPrimary: Colors.white,
      secondary: AppPalette.primaryMuted,
      onSecondary: Colors.white,
      surface: AppPalette.darkSurface,
      onSurface: AppPalette.darkTextMain,
      surfaceContainerHighest: AppPalette.darkSurfaceHighest,
      error: AppPalette.error,
      onError: Colors.white,
      outline: AppPalette.darkBorder,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppPalette.darkSurfaceHighest,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppPalette.darkTextMain),
      titleTextStyle: GoogleFonts.lato(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        color: AppPalette.darkTextMain,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppPalette.darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppPalette.darkBorder, width: 0.5),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppPalette.darkSurfaceElevated,
      selectedColor: AppPalette.primary,
      labelStyle: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppPalette.darkTextMain,
      ),
      secondaryLabelStyle: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      side: const BorderSide(color: AppPalette.darkBorder, width: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: AppPalette.darkSurfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppPalette.primaryLight;
        }
        return AppPalette.darkTextSub;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppPalette.primaryDark;
        }
        return AppPalette.darkSurfaceHighest;
      }),
    ),

    dividerTheme: const DividerThemeData(
      color: AppPalette.darkBorder,
      thickness: 0.5,
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppPalette.darkSurfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppPalette.darkSurfaceHighest,
      hintStyle: GoogleFonts.lato(color: AppPalette.darkTextSub),
      contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppPalette.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppPalette.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppPalette.primaryLight, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppPalette.error),
      ),
    ),

    textTheme: _buildTextTheme(AppPalette.darkTextMain, AppPalette.darkTextBody),
  );

  // ══════════════════════════════════════════
  // Shared Text Theme Builder
  // ══════════════════════════════════════════
  static TextTheme _buildTextTheme(Color mainColor, Color bodyColor) =>
      TextTheme(
        displayLarge: GoogleFonts.lato(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: mainColor,
        ),
        headlineLarge: GoogleFonts.lato(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: mainColor,
        ),
        headlineMedium: GoogleFonts.lato(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: mainColor,
        ),
        titleLarge: GoogleFonts.lato(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: mainColor,
        ),
        titleMedium: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: mainColor,
        ),
        bodyLarge: GoogleFonts.lato(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: mainColor,
        ),
        bodyMedium: GoogleFonts.lato(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: bodyColor,
        ),
        bodySmall: GoogleFonts.lato(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: bodyColor,
        ),
        labelSmall: GoogleFonts.lato(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: bodyColor,
        ),
      );
}
