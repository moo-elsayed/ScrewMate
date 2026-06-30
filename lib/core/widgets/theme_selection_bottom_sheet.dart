import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';
import 'package:skru_mate/core/theming/theme_cubit.dart';
import 'package:skru_mate/core/widgets/theme_option_item.dart';

class ThemeSelectionBottomSheet extends StatelessWidget {
  const ThemeSelectionBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      isScrollControlled: true,
      builder: (context) => const ThemeSelectionBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      decoration: BoxDecoration(
        color: colors.scaffold,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(16.h, 10.h, 16.h, 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: colors.border.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Gap(12.h),
          Text(
            'App Theme',
            style: GoogleFonts.lato(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: colors.mainText,
            ),
          ),
          Gap(4.h),
          Text(
            'Select how you want SkruMate to look.',
            style: GoogleFonts.lato(fontSize: 13.sp, color: colors.subText),
          ),
          Gap(20.h),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, currentMode) => Column(
              children: [
                ThemeOptionItem(
                  mode: ThemeMode.light,
                  title: 'Light Mode',
                  description: 'Clean and bright view',
                  icon: Icons.wb_sunny_outlined,
                  isSelected: currentMode == ThemeMode.light,
                ),
                Gap(10.h),
                ThemeOptionItem(
                  mode: ThemeMode.dark,
                  title: 'Dark Mode',
                  description: 'Easy on the eyes, sleek and modern',
                  icon: Icons.nightlight_round_outlined,
                  isSelected: currentMode == ThemeMode.dark,
                ),
                Gap(10.h),
                ThemeOptionItem(
                  mode: ThemeMode.system,
                  title: 'System Default',
                  description: 'Syncs automatically with your device settings',
                  icon: Icons.brightness_auto_outlined,
                  isSelected: currentMode == ThemeMode.system,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
