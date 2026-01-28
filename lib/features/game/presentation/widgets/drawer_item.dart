import 'package:flutter/material.dart';
import 'package:skru_mate/core/theming/app_text_styles.dart';

class DrawerItem extends StatelessWidget {

  const DrawerItem({super.key, required this.title, required this.onTap});
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Text(title, style: AppTextStyles.font18WhiteMedium),
    );
}
