import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';

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
  Widget build(BuildContext context) => Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            'Select the number of players:',
            style: AppTextStyles.font18WhiteBold,
          ),
        ),
        Gap(16.h),
        Wrap(
          spacing: 8.h,
          runSpacing: 4.h,
          children: List.generate(players.length, (index) => ChoiceChip(
              label: Text(
                players[index].toString(),
                style: AppTextStyles.font14WhiteRegular,
              ),
              selected: selectedPlayersIndex == index,
              onSelected: (_) {
                widget.onSelected(players[index]);
                setPlayersIndex(index);
              },
              selectedColor: AppColors.purple,
            )),
        ),
      ],
    );
}
