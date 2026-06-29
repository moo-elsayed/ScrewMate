import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';
import 'package:skru_mate/features/game/presentation/widgets/selector_action_button.dart';

class AnimatedNumberSelector extends StatelessWidget {
  const AnimatedNumberSelector({
    super.key,
    required this.title,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    required this.icon,
  });

  final String title;
  final int value;
  final int minValue;
  final int maxValue;
  final ValueChanged<int> onChanged;
  final IconData icon;

  void _decrement() {
    if (value > minValue) {
      HapticFeedback.lightImpact();
      onChanged(value - 1);
    }
  }

  void _increment() {
    if (value < maxValue) {
      HapticFeedback.lightImpact();
      onChanged(value + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8.w,
            children: [
              Icon(icon, color: colors.primaryLight, size: 20.sp),
              Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.bodyText,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SelectorActionButton(
                icon: Icons.remove_rounded,
                onPressed: value > minValue ? _decrement : null,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                        value.toString(),
                        style: GoogleFonts.lato(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w800,
                          color: colors.mainText,
                        ),
                      )
                      .animate(target: value.toDouble())
                      .swap(
                        builder: (context, child) => child!
                            .animate()
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1.0, 1.0),
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeOutBack,
                            )
                            .fadeIn(),
                      ),
                  SizedBox(width: 6.w),
                  Text(
                    title.toLowerCase().contains('player')
                        ? 'players'
                        : 'rounds',
                    style: GoogleFonts.lato(
                      fontSize: 14.sp,
                      color: colors.subText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SelectorActionButton(
                icon: Icons.add_rounded,
                onPressed: value < maxValue ? _increment : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
