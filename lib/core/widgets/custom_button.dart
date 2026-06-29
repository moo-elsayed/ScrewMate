import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theming/app_decorations.dart';
import '../theming/colors_manager.dart';

/// A premium button with gradient, press animation, and haptic feedback.
class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.label,
    this.notActiveColor,
    this.icon,
  });

  final VoidCallback onTap;
  final String label;
  final Color? notActiveColor;
  final IconData? icon;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isActive => widget.notActiveColor == null;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 14.h),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: _isActive ? AppDecorations.primaryGradient : null,
            color: _isActive ? null : widget.notActiveColor ?? colors.surfaceHighest,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: _isActive ? AppDecorations.primaryGlow(opacity: 0.2) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: Colors.white, size: 18.sp),
                SizedBox(width: 8.w),
              ],
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: _isActive
                      ? Colors.white
                      : colors.subText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
