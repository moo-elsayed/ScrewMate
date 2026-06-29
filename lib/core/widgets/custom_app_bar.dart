import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.text,
    this.centerTitle = true,
    this.actions,
    this.leading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  final String? text;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Widget build(BuildContext context) => AppBar(
      title: Text(text ?? 'ScrewMate'),
      leading: leading,
      centerTitle: centerTitle,
      actions: actions,
    );
}
