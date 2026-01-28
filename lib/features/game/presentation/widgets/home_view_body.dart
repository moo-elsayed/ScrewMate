import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/widgets/custom_button.dart';
import 'package:skru_mate/features/game/presentation/managers/cubits/game_cubit/game_cubit.dart';
import 'package:skru_mate/features/game/presentation/managers/cubits/game_cubit/game_states.dart';
import 'package:skru_mate/features/game/presentation/widgets/select_number_of_players.dart';
import 'package:skru_mate/features/game/presentation/widgets/select_number_of_rounds.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../data/models/add_players_args.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  int selectedPlayers = 4;
  int selectedRounds = 5;

  @override
  Widget build(BuildContext context) => BlocListener<GameCubit, GameStates>(
    listener: (context, state) {
      if (state is InsertRoundScoresSuccess) {
        Future.delayed(const Duration(seconds: 2, milliseconds: 500), () {
          if (context.mounted) {
            showCustomToast(
              context: context,
              message: 'Players stats updated successfully!',
              contentType: ContentType.success,
            );
          }
        });
      }
    },
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SelectNumberOfPlayers(
            onSelected: (int value) {
              selectedPlayers = value;
            },
          ),
          Divider(height: 48.h, indent: 40.w, endIndent: 40.w),
          SelectNumberOfRounds(
            onSelected: (int value) {
              selectedRounds = value;
            },
          ),
          Gap(48.h),
          CustomButton(
            onTap: () {
              context.pushNamed(
                Routes.addPlayersView,
                arguments: AddPlayersArgs(
                  playersCount: selectedPlayers,
                  roundsCount: selectedRounds,
                ),
              );
            },
            label: 'Next',
          ),
        ],
      ),
    ),
  );
}
