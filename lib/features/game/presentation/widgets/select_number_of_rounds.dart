import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/theming/colors_manager.dart';

class SelectNumberOfRounds extends StatefulWidget {
  const SelectNumberOfRounds({super.key, required this.onSelected});

  final Function(int) onSelected;

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
    final colors = context.colors;
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            'Select the number of rounds:',
            style: AppTextStyles.font18Bold.copyWith(color: colors.mainText),
          ),
        ),
        Gap(16.h),
        Wrap(
          spacing: 8.h,
          runSpacing: 4.h,
          children: List.generate(rounds.length, (index) {
            final isSelected = selectedRoundsIndex == index;
            return ChoiceChip(
              label: Text(
                rounds[index].toString(),
                style: AppTextStyles.font14Regular.copyWith(
                  color: isSelected ? Colors.white : colors.mainText,
                ),
              ),
              selected: isSelected,
              onSelected: (_) {
                widget.onSelected(rounds[index]);
                setRoundsIndex(index);
              },
              selectedColor: colors.primary,
            );
          }),
        ),
      ],
    );
  }
}
