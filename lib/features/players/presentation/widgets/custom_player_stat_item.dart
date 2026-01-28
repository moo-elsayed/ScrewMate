import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/functions.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';

class CustomPlayerStatItem extends StatelessWidget {
  const CustomPlayerStatItem({
    super.key,
    required this.title,
    required this.value,
    required this.rank,
  });

  final String title;
  final String value;
  final int rank;

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.appbarColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart_rounded, color: Colors.white70, size: 16.sp),
              Gap(6.w),
              Text(title, style: AppTextStyles.font14White70Medium),
            ],
          ),
          const Spacer(),
          // Value & Rank
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Rank #$rank',
                  style: AppTextStyles.font12SemiBold.copyWith(
                    color: getRankColor(rank),
                  ),
                ),
              ),
              Text(value, style: AppTextStyles.font20WhiteBold),
            ],
          ),
        ],
      ),
    );
}
