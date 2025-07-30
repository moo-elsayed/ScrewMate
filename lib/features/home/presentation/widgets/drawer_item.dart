import 'package:flutter/material.dart';
import 'package:skru_mate/core/theming/styles.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final void Function() onTap;

  const DrawerItem({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(title, style: TextStyles.font18WhiteMedium),
    );
  }
}
