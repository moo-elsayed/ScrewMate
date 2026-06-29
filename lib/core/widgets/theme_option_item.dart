import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';
import 'package:skru_mate/core/theming/theme_cubit.dart';

class ThemeOptionItem extends StatelessWidget {
  const ThemeOptionItem({
    super.key,
    required this.mode,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
  });

  final ThemeMode mode;
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.pop();
        context.read<ThemeCubit>().setThemeMode(mode);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.1)
              : colors.surfaceElevated,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? colors.primaryLight
                : colors.border.withValues(alpha: 0.2),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? colors.primaryLight : colors.subText,
              size: 24.sp,
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: colors.mainText,
                    ),
                  ),
                  Gap(2.h),
                  Text(
                    description,
                    style: GoogleFonts.lato(
                      fontSize: 12.sp,
                      color: colors.subText,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: colors.primaryLight,
                size: 22.sp,
              )
            else
              Container(
                width: 22.sp,
                height: 22.sp,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.border.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
