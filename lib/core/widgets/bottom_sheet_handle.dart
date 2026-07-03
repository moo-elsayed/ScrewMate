import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';

class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: 36.w,
    height: 4.h,
    decoration: BoxDecoration(
      color: context.colors.border.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(2.r),
    ),
  );
}
