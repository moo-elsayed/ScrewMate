import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/app_colors.dart';

class CustomScoreButton extends StatelessWidget {
  const CustomScoreButton({super.key, this.onTap, this.icon});

  final void Function()? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        margin: EdgeInsets.only(left: 4.w),
        padding: EdgeInsets.all(icon != null ? 4.r : 0),
        child: Icon(
          icon ?? Icons.add,
          color: AppColors.purple.withValues(alpha: 0.9),
          size: icon != null ? 16 : 22,
        ),
      ),
    );
}
