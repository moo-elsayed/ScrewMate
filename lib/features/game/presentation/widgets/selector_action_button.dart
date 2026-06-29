import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';

class SelectorActionButton extends StatelessWidget {
  const SelectorActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDisabled = onPressed == null;

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: isDisabled
              ? colors.surfaceHighest.withValues(alpha: 0.3)
              : colors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDisabled
                ? colors.border.withValues(alpha: 0.1)
                : colors.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: isDisabled
              ? colors.subText.withValues(alpha: 0.3)
              : colors.primaryLight,
          size: 24.sp,
        ),
      ),
    );
  }
}
