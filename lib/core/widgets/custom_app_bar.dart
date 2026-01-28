import 'package:flutter/material.dart';
import 'package:skru_mate/core/theming/app_colors.dart';
import 'package:skru_mate/core/theming/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.text,
    this.centerTitle = true,
    this.actions,
    this.leading,
  });

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  final String? text;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Widget build(BuildContext context) => AppBar(
      title: Text(text ?? 'ScrewMate', style: AppTextStyles.font22WhiteRegular),
      leading: leading,
      centerTitle: centerTitle,
      backgroundColor: AppColors.appbarColor,
      surfaceTintColor: AppColors.appbarColor,
      actions: actions,
    );
}
