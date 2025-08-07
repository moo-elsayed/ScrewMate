import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skru_mate/core/widgets/custom_app_bar.dart';
import 'package:skru_mate/features/players/presentation/managers/cubits/players_cubit/players_cubit.dart';
import 'package:skru_mate/features/players/presentation/widgets/top_players_view_body.dart';

import '../../../../core/database/shared_models/player_model.dart';

class TopPlayersView extends StatelessWidget {
  const TopPlayersView({super.key, required this.playersList});

  final List<PlayerModel> playersList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: 'Top Players',
        actions: [
          IconButton(
            icon: const Icon(
              CupertinoIcons.arrow_up_arrow_down,
              color: Colors.white,
            ),
            onPressed: () {
              context.read<PlayersCubit>().reverseList();
            },
          ),
        ],
      ),
      body: TopPlayersViewBody(playersList: playersList),
    );
  }
}
