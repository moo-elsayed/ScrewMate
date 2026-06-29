import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';
import 'package:skru_mate/features/game/data/models/custom_bottom_navigation_item_data.dart';
import 'package:skru_mate/features/game/presentation/widgets/custom_bottom_navigation_item.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final List<CustomBottomNavigationItemData> items;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.only(bottom: 12.h, left: 10.w, right: 10.w),
      color: Colors.transparent,
      child: Container(
        height: 54.h,
        decoration: BoxDecoration(
          color: colors.surfaceElevated.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: colors.border.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            items.length,
            (index) => CustomBottomNavigationItem(
              isSelected: currentIndex == index,
              icon: items[index].icon,
              label: items[index].label,
              onTap: () => onTabSelected(index),
            ),
          ),
        ),
      ),
    );
  }
}
