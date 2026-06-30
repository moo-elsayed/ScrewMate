import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';

class CustomScoreButton extends StatelessWidget {
  const CustomScoreButton({super.key, this.onTap, this.icon});

  final void Function()? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isEdit = icon != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 32.sp,
        height: 32.sp,
        decoration: BoxDecoration(
          color: isEdit ? colors.surfaceHighest : colors.primary,
          shape: BoxShape.circle,
          boxShadow: isEdit
              ? null
              : [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        margin: EdgeInsets.only(left: 8.w),
        child: Icon(
          icon ?? Icons.add,
          color: isEdit ? colors.mainText : Colors.white,
          size: isEdit ? 14.sp : 18.sp,
        ),
      ),
    );
  }
}
