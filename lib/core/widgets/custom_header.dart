import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../theming/app_colors.dart';
import '../theming/app_text_styles.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key, required this.title, this.lineWidth});

  final String title;
  final double? lineWidth;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(title, style: AppTextStyles.font22PurpleBold),
      Gap(6.h),
      Container(
        height: 1.h,
        width: lineWidth ?? 60.w,
        color: AppColors.purple.withValues(alpha: 0.5),
      ),
    ],
  );
}
