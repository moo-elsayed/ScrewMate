import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';

class CustomBottomNavigationItem extends StatelessWidget {
  const CustomBottomNavigationItem({
    super.key,
    required this.isSelected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool isSelected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final activeColor = colors.primaryLight;
    final inactiveColor = colors.subText;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: isSelected ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.primary.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSelected
                  ? colors.primaryLight.withValues(alpha: 0.3)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? activeColor : inactiveColor,
                size: 22.sp,
              ),
              if (isSelected) ...[
                SizedBox(width: 6.w),
                (Text(
                  label,
                  style: TextStyle(
                    color: activeColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ))
                    .animate()
                    .fadeIn(duration: const Duration(milliseconds: 200))
                    .slideX(
                      begin: -0.2,
                      end: 0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                    ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
