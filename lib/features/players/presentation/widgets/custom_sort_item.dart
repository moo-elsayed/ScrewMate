import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skru_mate/core/theming/app_text_styles.dart';
import '../../../../core/theming/app_colors.dart';

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
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          left: 12.w,
          right: marginToRight ? 12.w : 0,
          top: 8.h,
          // bottom: 8.h,
        ),
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.purple : AppColors.appbarColor,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Text(
          sortOption,
          style: AppTextStyles.font16WhiteRegular,
        ),
      ),
    );
}