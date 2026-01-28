import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skru_mate/core/theming/app_text_styles.dart';
import '../theming/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.label,
    this.notActiveColor,
  });

  final void Function() onTap;
  final String label;
  final Color? notActiveColor;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsGeometry.symmetric(vertical: 14.h),
        width: double.infinity,
        decoration: BoxDecoration(
          color: notActiveColor ?? AppColors.purple,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.font16WhiteBold,
        ),
      ),
    );
}
