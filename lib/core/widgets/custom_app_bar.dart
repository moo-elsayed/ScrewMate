import 'package:flutter/material.dart';
import 'package:skru_mate/core/theming/colors.dart';
import 'package:skru_mate/core/theming/styles.dart';

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
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(text ?? 'ScrewMate', style: TextStyles.font22WhiteRegular),
      leading: leading,
      centerTitle: centerTitle,
      backgroundColor: ColorsManager.appbarColor,
      surfaceTintColor: ColorsManager.appbarColor,
      actions: actions,
    );
  }
}
