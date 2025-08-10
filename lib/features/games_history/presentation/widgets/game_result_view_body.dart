import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skru_mate/core/database/shared_models/game_model.dart';
import 'package:skru_mate/core/database/shared_models/game_player_model.dart';
import 'package:skru_mate/core/database/shared_models/round_model.dart';
import 'package:skru_mate/core/widgets/custom_header.dart';
import 'package:skru_mate/features/games_history/data/models/game_details_model.dart';
import 'package:skru_mate/features/games_history/presentation/managers/cubits/games_history_cubit/games_history_cubit.dart';
import 'package:skru_mate/features/games_history/presentation/managers/cubits/games_history_cubit/games_history_states.dart';
import '../../../../core/database/shared_models/round_score_model.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';
import '../../data/models/game_result_view_args.dart';

class GameResultViewBody extends StatefulWidget {
  const GameResultViewBody({super.key, required this.gameResultViewArgs});

  final GameResultViewArgs gameResultViewArgs;

  @override
  State<GameResultViewBody> createState() => _GameResultViewBodyState();
}

class _GameResultViewBodyState extends State<GameResultViewBody> {
  late GameModel game;
  late List<GamePlayerModel> players;
  late List<RoundModel> rounds;
  late Map<int, List<RoundScoreModel>> r;
  late Map<int, String> playerNamesById;
  List<int> playersScores = [];

  void getPlayersTotalScore() {
    for (GamePlayerModel player in players) {
      playersScores.add(player.totalScore);
    }
    playersScores.sort();
  }

  @override
  void initState() {
    super.initState();
    GameResultViewArgs gameResultViewArgs = widget.gameResultViewArgs;
    context.read<GamesHistoryCubit>().getGameDetails(
      gameId: gameResultViewArgs.gameId,
    );
    playerNamesById = {
      for (var p in gameResultViewArgs.allPlayersList) p.id!: p.name,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GamesHistoryCubit, GamesHistoryStates>(
      listener: (context, state) {
        if (state is GetGameDetailsSuccess) {
          GameDetailsModel gameDetailsModel = state.gameDetails;
          game = gameDetailsModel.game;
          players = gameDetailsModel.players;
          rounds = gameDetailsModel.rounds;
          r = gameDetailsModel.roundScoresByRoundId;
          getPlayersTotalScore();
        } else if (state is GetGameDetailsFailure) {
          log(state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is GetGameDetailsSuccess) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                Gap(12.h),
                CustomHeader(title: 'Final Scores', lineWidth: 95.w),
                Gap(12.h),
                Expanded(
                  child: ListView.builder(
                    itemCount: players.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      GamePlayerModel player = players[index];
                      int playerRank =
                          playersScores.indexOf(player.totalScore) + 1;
                      return Padding(
                        padding: EdgeInsets.only(
                          top: 12.h,
                          bottom: index == players.length - 1 ? 12.h : 0,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            border: playerRank == 1
                                ? null
                                : Border.all(color: Colors.white54, width: 0.5),
                            color: playerRank == 1
                                ? ColorsManager.purple.withValues(alpha: 0.9)
                                : Theme.of(context).scaffoldBackgroundColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 16.h,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    playerNamesById[player.playerId] != null
                                        ? '${playerNamesById[player.playerId]}'
                                        : 'Deleted player',
                                    style: TextStyles.font18WhiteBold,
                                  ),
                                  Text(
                                    'Rank #$playerRank',
                                    style: TextStyles.font18WhiteRegular,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SingleChildScrollView(
                                    child: Row(
                                      children: List.generate(rounds.length, (
                                        i,
                                      ) {
                                        final scoresInRound =
                                            r[rounds[i].id] ?? [];
                                        final scoreForThisPlayer = scoresInRound
                                            .firstWhere(
                                              (s) =>
                                                  s.playerId == player.playerId,
                                              orElse: () => RoundScoreModel(
                                                roundId: rounds[i].id!,
                                                playerId: player.playerId,
                                                score: 0,
                                              ),
                                            );
                                        return Padding(
                                          padding: EdgeInsets.only(right: 4.w),
                                          child: Column(
                                            spacing: 4.h,
                                            children: [
                                              Text('R${i + 1}'),
                                              Text(
                                                '${scoreForThisPlayer.score}',
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '= ${player.totalScore}',
                                    style: TextStyles.font20WhiteBold,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
