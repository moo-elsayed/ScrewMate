import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/routing/routes.dart';
import 'package:skru_mate/core/theming/styles.dart';
import 'drawer_item.dart';

class DrawerBody extends StatelessWidget {
  const DrawerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('ScrewMate', style: TextStyles.font24WhiteSemibold),
          ),
          Divider(height: 64.h, indent: 10.w, endIndent: 10.w),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DrawerItem(title: 'Previous Games', onTap: () {}),
          ),
          Gap(24.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DrawerItem(
              title: 'Top Players',
              onTap: () {
                context.pushNamed(Routes.topPlayersView);
              },
            ),
          ),
        ],
      ),
    );
  }
}
