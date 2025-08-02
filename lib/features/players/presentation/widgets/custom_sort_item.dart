import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skru_mate/core/theming/styles.dart';
import '../../../../core/theming/colors.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          left: 10.w,
          right: marginToRight ? 10.w : 0,
          top: 16.h,
          bottom: 8.h,
        ),
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: isSelected ? ColorsManager.purple : ColorsManager.appbarColor,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Text(
          sortOption,
          style: TextStyles.font16WhiteRegular,
        ),
      ),
    );
  }
}