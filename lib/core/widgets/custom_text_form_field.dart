import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/theming/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.maxLength,
    this.inputFormatters,
    this.contentPadding,
    this.isObscureText,
    this.label,
    this.focusNode,
    this.fillColor,
    this.cursorColor,
  });

  final TextEditingController controller;
  final Widget? prefixIcon;
  final String? hintText;
  final Widget? label;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;
  final bool? isObscureText;
  final FocusNode? focusNode;
  final Color? fillColor;
  final Color? cursorColor;

  @override
  Widget build(BuildContext context) => TextFormField(
      controller: controller,
      validator: validator,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      obscureText: isObscureText ?? false,
      cursorColor: cursorColor ?? AppColors.purple,
      keyboardType: keyboardType,
      style: GoogleFonts.lato(),
      cursorErrorColor: cursorColor ?? AppColors.purple,
      focusNode: focusNode,
      decoration: InputDecoration(
        isDense: true,
        contentPadding:
            contentPadding ??
            EdgeInsetsGeometry.symmetric(vertical: 17.h, horizontal: 20.w),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: GoogleFonts.lato(),
        label: label,
        border: buildOutlineInputBorder(),
        enabledBorder: buildOutlineInputBorder(),
        focusedBorder: buildOutlineInputBorder(),
        focusedErrorBorder: buildOutlineInputBorder(),
        errorBorder: buildOutlineInputBorder(Colors.red),
        filled: true,
        fillColor: fillColor,
      ),
    );

  OutlineInputBorder buildOutlineInputBorder([Color? color]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color ?? AppColors.purple, width: 1.3),
    );
}
