import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';

class CustomSortItem extends StatelessWidget {
  const CustomSortItem({
    super.key,
    this.onTap,
    required this.isSelected,
    required this.sortOption,
    required this.marginToRight,
  });

  final void Function()? onTap;
  final bool isSelected;
  final String sortOption;
  final bool marginToRight;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(
          left: 12.w,
          right: marginToRight ? 12.w : 0,
        ),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surfaceElevated,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border.withValues(alpha: 0.4),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        child: Text(
          sortOption,
          style: GoogleFonts.lato(
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : colors.subText,
          ),
        ),
      ),
    );
  }
}
