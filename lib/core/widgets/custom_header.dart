import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../theming/colors.dart';
import '../theming/styles.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: TextStyles.font22PurpleBold),
        Gap(6.h),
        Container(
          height: 1.h,
          width: 60.w,
          color: ColorsManager.purple.withValues(alpha: 0.5),
        ),
      ],
    );
  }
}