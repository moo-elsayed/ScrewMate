import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';

class HomeStatItem extends StatelessWidget {
  const HomeStatItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: [
        Icon(
          icon,
          color: colors.primaryLight,
          size: 22.sp,
        ),
        Gap(6.h),
        Text(
          value,
          style: GoogleFonts.lato(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: colors.mainText,
          ),
        ),
        Gap(2.h),
        Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 11.sp,
            color: colors.subText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
