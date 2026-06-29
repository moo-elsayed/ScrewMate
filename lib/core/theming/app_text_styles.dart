import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_palette.dart';

/// Text styles for the app.
///
/// Legacy styles (with hardcoded colors) are kept for backward compatibility.
/// Prefer using `context.theme.textTheme` for theme-aware text in new code.
class AppTextStyles {
  AppTextStyles._();

  // ══════════════════════════════════════════
  // Base Styles (no color — use with .copyWith(color:))
  // ══════════════════════════════════════════

  static TextStyle font10Regular = GoogleFonts.lato(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle font12Regular = GoogleFonts.lato(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle font12Medium = GoogleFonts.lato(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle font12SemiBold = GoogleFonts.lato(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle font13Regular = GoogleFonts.lato(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle font14Regular = GoogleFonts.lato(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle font14Medium = GoogleFonts.lato(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle font14Bold = GoogleFonts.lato(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle font15Bold = GoogleFonts.lato(
    fontSize: 15.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle font16Regular = GoogleFonts.lato(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle font16Bold = GoogleFonts.lato(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle font17Bold = GoogleFonts.lato(
    fontSize: 17.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle font18Regular = GoogleFonts.lato(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle font18Medium = GoogleFonts.lato(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle font18Bold = GoogleFonts.lato(
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle font20Bold = GoogleFonts.lato(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle font22Regular = GoogleFonts.lato(
    fontSize: 22,
    fontWeight: FontWeight.w400,
  );

  static TextStyle font22Bold = GoogleFonts.lato(
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  static TextStyle font24Semibold = GoogleFonts.lato(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static TextStyle font24Bold = GoogleFonts.lato(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static TextStyle font36Bold = GoogleFonts.lato(
    fontSize: 36,
    fontWeight: FontWeight.w700,
  );

  // ══════════════════════════════════════════
  // Legacy Styles (hardcoded colors — backward compat)
  // ══════════════════════════════════════════

  static TextStyle font10WhiteRegular = font10Regular.copyWith(
    color: Colors.white,
  );

  static TextStyle font12White54Regular = font12Regular.copyWith(
    color: Colors.white54,
  );

  static TextStyle font12White70Medium = font12Medium.copyWith(
    color: Colors.white70,
  );

  static TextStyle font12WhiteMedium = font12Medium.copyWith(
    color: Colors.white,
  );

  static TextStyle font13White70Regular = font13Regular.copyWith(
    color: Colors.white70,
  );

  static TextStyle font14WhiteRegular = font14Regular.copyWith(
    color: Colors.white,
  );

  static TextStyle font14BlackRegular = font14Regular.copyWith(
    color: Colors.black,
  );

  static TextStyle font14White70Medium = font14Medium.copyWith(
    color: Colors.white70,
  );

  static TextStyle font14WhiteMedium = font14Medium.copyWith(
    color: Colors.white,
  );

  static TextStyle font14WhiteBold = font14Bold.copyWith(
    color: Colors.white,
  );

  static TextStyle font15WhiteBold = font15Bold.copyWith(
    color: Colors.white,
  );

  static TextStyle font16WhiteBold = font16Bold.copyWith(
    color: Colors.white,
  );

  static TextStyle font16WhiteRegular = font16Regular.copyWith(
    color: Colors.white,
  );

  static TextStyle font17WhiteBold = font17Bold.copyWith(
    color: Colors.white,
  );

  static TextStyle font18WhiteRegular = font18Regular.copyWith(
    color: Colors.white,
  );

  static TextStyle font18WhiteMedium = font18Medium.copyWith(
    color: Colors.white,
  );

  static TextStyle font18WhiteBold = font18Bold.copyWith(
    color: Colors.white,
  );

  static TextStyle font20WhiteBold = font20Bold.copyWith(
    color: Colors.white,
  );

  static TextStyle font22WhiteRegular = font22Regular.copyWith(
    color: Colors.white,
  );

  static TextStyle font22PurpleBold = font22Bold.copyWith(
    color: AppPalette.primary.withValues(alpha: 0.9),
  );

  static TextStyle font24WhiteSemibold = font24Semibold.copyWith(
    color: Colors.white,
  );

  static TextStyle font24WhiteBold = font24Bold.copyWith(
    color: Colors.white,
  );

  static TextStyle font36WhiteBold = font36Bold.copyWith(
    color: Colors.white,
  );
}
