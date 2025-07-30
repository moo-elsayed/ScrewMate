import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';

class SelectNumberOfRounds extends StatefulWidget {
  const SelectNumberOfRounds({super.key});

  @override
  State<SelectNumberOfRounds> createState() => _SelectNumberOfRoundsState();
}

class _SelectNumberOfRoundsState extends State<SelectNumberOfRounds> {
  final List<int> rounds = List.generate(5, (index) => index + 1); // [1..5]

  int selectedRoundsIndex = 4;

  void setRoundsIndex(int index) {
    setState(() => selectedRoundsIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            'Select the number of rounds:',
            style: TextStyles.font18WhiteBold,
          ),
        ),
        Gap(16.h),
        Wrap(
          spacing: 8.h,
          runSpacing: 4.h,
          children: List.generate(rounds.length, (index) {
            return ChoiceChip(
              label: Text(
                rounds[index].toString(),
                style: TextStyles.font14WhiteRegular,
              ),
              selected: selectedRoundsIndex == index,
              onSelected: (_) => setRoundsIndex(index),
              selectedColor: ColorsManager.purple,
            );
          }),
        ),
      ],
    );
  }
}
