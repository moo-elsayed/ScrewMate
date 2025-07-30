import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skru_mate/core/widgets/custom_button.dart';
import 'package:skru_mate/features/home/presentation/widgets/select_number_of_players.dart';
import 'package:skru_mate/features/home/presentation/widgets/select_number_of_rounds.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SelectNumberOfPlayers(),
          Divider(height: 48.h, indent: 40.w, endIndent: 40.w),
          const SelectNumberOfRounds(),
          Gap(48.h),
          CustomButton(onTap: () {}, label: 'Next'),
        ],
      ),
    );
  }
}
