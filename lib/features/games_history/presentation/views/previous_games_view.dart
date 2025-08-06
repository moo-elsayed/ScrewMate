import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skru_mate/core/widgets/custom_app_bar.dart';
import 'package:skru_mate/features/games_history/presentation/managers/cubits/games_history_cubit/games_history_cubit.dart';
import 'package:skru_mate/features/games_history/presentation/widgets/previous_games_view_body.dart';

class PreviousGamesView extends StatelessWidget {
  const PreviousGamesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: 'Previous Games',
        actions: [
          IconButton(
            icon: const Icon(
              CupertinoIcons.arrow_up_arrow_down,
              color: Colors.white,
            ),
            onPressed: () {
              context.read<GamesHistoryCubit>().reverseList();
            },
          ),
        ],
      ),
      body: const PreviousGamesViewBody(),
    );
  }
}
