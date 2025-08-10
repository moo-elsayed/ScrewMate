import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import '../../../../core/database/shared_models/player_model.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';
import '../../../games_history/data/models/game_result_view_args.dart';
import '../../data/models/player_games_states_model.dart';

class PreviousGamesForPlayerListView extends StatelessWidget {
  const PreviousGamesForPlayerListView({
    super.key,
    required this.playerGameStatsList,
    required this.players,
    this.showAll = false,
  });

  final List<PlayerGameStatsModel> playerGameStatsList;
  final List<PlayerModel> players;
  final bool showAll;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: showAll
          ? playerGameStatsList.length
          : min(playerGameStatsList.length, 5),
      separatorBuilder: (_, __) =>
          Divider(color: ColorsManager.purple, height: 0.h),
      itemBuilder: (context, index) {
        final playerGameStatsModel = playerGameStatsList[index];

        return GestureDetector(
          onTap: () {
            context.pushNamed(
              Routes.gameResultView,
              arguments: GameResultViewArgs(
                gameId: playerGameStatsModel.gameId,
                allPlayersList: players,
              ),
            );
          },
          child:
              ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Game #${playerGameStatsModel.gameId}'),
                    titleTextStyle: TextStyles.font15WhiteBold,
                    trailing: Text(
                      'Rank #${playerGameStatsModel.rank}',
                      style: TextStyles.font14WhiteBold.copyWith(
                        color: getRankColor(playerGameStatsModel.rank),
                      ),
                    ),
                  )
                  .animate(delay: Duration(milliseconds: 50 * index))
                  .slideY(begin: 0.2, duration: 300.ms)
                  .fadeIn(duration: 300.ms),
        );
      },
    );
  }
}
