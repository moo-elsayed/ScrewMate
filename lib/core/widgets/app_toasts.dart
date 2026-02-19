import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skru_mate/core/theming/app_colors.dart';
import 'package:skru_mate/core/theming/app_text_styles.dart';
import 'package:toastification/toastification.dart';

import '../helpers/extentions.dart';

class AppToast {
  static void show({
    required BuildContext context,
    required String title,
    String? description,
    required ToastificationType type,
  }) {
    toastification.showCustom(
      context: context,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 2),
      animationBuilder: (context, animation, alignment, child) =>
          FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, -0.5),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  ),
              child: child,
            ),
          ),
      builder: (BuildContext context, ToastificationItem holder) => Material(
        type: MaterialType.transparency,
        child: GestureDetector(
          onTap: () {
            toastification.dismiss(holder);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.roundDetailsForPlayerColor,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                  spreadRadius: 2,
                ),
              ],
              border: Border(
                left: BorderSide(color: type.getColor(context), width: 4.w),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  type.stateIcon,
                  color: type.getColor(context),
                  size: 28.sp,
                ),
                Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.font16WhiteBold.copyWith(
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      if (description != null && description.isNotEmpty) ...[
                        Gap(4.h),
                        Text(
                          description,
                          style: AppTextStyles.font14WhiteRegular.copyWith(
                            color: Colors.white70,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Gap(8.w),
                InkWell(
                  onTap: () => toastification.dismiss(holder),
                  child: Icon(Icons.close, color: Colors.white54, size: 20.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
