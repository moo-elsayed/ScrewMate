import 'package:flutter/material.dart';
import 'package:skru_mate/core/theming/colors.dart';
import 'package:skru_mate/core/theming/styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('ScrewMate', style: TextStyles.font22WhiteSemiRegular),
      centerTitle: true,
      backgroundColor: ColorsManager.appbarColor,
      surfaceTintColor: ColorsManager.appbarColor,
    );
  }
}
