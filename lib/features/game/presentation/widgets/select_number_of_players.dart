import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/theming/colors_manager.dart';

class SelectNumberOfPlayers extends StatefulWidget {
  const SelectNumberOfPlayers({super.key, required this.onSelected});

  final Function(int) onSelected;

  @override
  State<SelectNumberOfPlayers> createState() => _SelectNumberOfPlayersState();
}

class _SelectNumberOfPlayersState extends State<SelectNumberOfPlayers> {
  final List<int> players = List.generate(11, (index) => index + 2); // [2..12]
  int selectedPlayersIndex = 2;

  void setPlayersIndex(int index) {
    setState(() => selectedPlayersIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            'Select the number of players:',
            style: AppTextStyles.font18Bold.copyWith(color: colors.mainText),
          ),
        ),
        Gap(16.h),
        Wrap(
          spacing: 8.h,
          runSpacing: 4.h,
          children: List.generate(players.length, (index) {
            final isSelected = selectedPlayersIndex == index;
            return ChoiceChip(
              label: Text(
                players[index].toString(),
                style: AppTextStyles.font14Regular.copyWith(
                  color: isSelected ? Colors.white : colors.mainText,
                ),
              ),
              selected: isSelected,
              onSelected: (_) {
                widget.onSelected(players[index]);
                setPlayersIndex(index);
              },
              selectedColor: colors.primary,
            );
          }),
        ),
      ],
    );
  }
}
