import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';
import 'custom_button.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    this.name,
    this.onDelete,
    this.fullText,
    this.delete = true,
    this.textOkButton,
  });

  final String? name;
  final void Function()? onDelete;
  final String? fullText;
  final bool delete;
  final String? textOkButton;

  static Future<T?> show<T>(
    BuildContext context, {
    String? name,
    void Function()? onDelete,
    String? fullText,
    bool delete = true,
    String? textOkButton,
  }) => showCupertinoDialog<T>(
    context: context,
    builder: (context) => ConfirmationDialog(
      name: name,
      onDelete: onDelete,
      fullText: fullText,
      delete: delete,
      textOkButton: textOkButton,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: colors.surfaceElevated,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: colors.border.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon header
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: (delete ? colors.error : colors.primary).withValues(
                  alpha: 0.1,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                delete
                    ? Icons.delete_outline_rounded
                    : Icons.info_outline_rounded,
                color: delete ? colors.error : colors.primary,
                size: 28.sp,
              ),
            ),
            Gap(16.h),

            // Title
            Text(
              delete ? 'Delete Confirmation' : 'Confirmation',
              style: GoogleFonts.lato(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: colors.mainText,
              ),
            ),
            Gap(12.h),

            // Content
            if (fullText != null)
              Text(
                fullText!,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 14.sp,
                  color: colors.bodyText,
                  height: 1.4,
                ),
              )
            else
              Text.rich(
                TextSpan(
                  style: GoogleFonts.lato(
                    fontSize: 14.sp,
                    color: colors.bodyText,
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(text: 'Are you sure you want to delete '),
                    TextSpan(
                      text: name,
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        color: colors.mainText,
                      ),
                    ),
                    const TextSpan(text: '?\nThis action cannot be undone.'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            Gap(24.h),

            // Buttons
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: CustomButton(
                    onTap: () => context.pop(),
                    label: 'Cancel',
                    notActiveColor: colors.surfaceHighest,
                  ),
                ),
                Gap(12.w),
                // Confirm/Action button
                Expanded(
                  child: CustomButton(
                    onTap: onDelete ?? () {},
                    label: textOkButton ?? (delete ? 'Delete' : 'Confirm'),
                    backgroundColor: delete ? colors.error : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
