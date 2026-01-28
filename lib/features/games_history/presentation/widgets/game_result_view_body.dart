import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skru_mate/core/database/shared_models/game_model.dart';
import 'package:skru_mate/core/database/shared_models/game_player_model.dart';
import 'package:skru_mate/core/database/shared_models/round_model.dart';
import 'package:skru_mate/features/games_history/data/models/game_details_model.dart';
import 'package:skru_mate/features/games_history/presentation/managers/cubits/games_history_cubit/games_history_cubit.dart';
import 'package:skru_mate/features/games_history/presentation/managers/cubits/games_history_cubit/games_history_states.dart';
import '../../../../core/database/shared_models/round_score_model.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../data/models/game_result_view_args.dart';
import 'custom_game_player_card.dart';

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

  @override
  void initState() {
    super.initState();
    final GameResultViewArgs gameResultViewArgs = widget.gameResultViewArgs;
    context.read<GamesHistoryCubit>().getGameDetails(
      gameId: gameResultViewArgs.gameId,
    );
    playerNamesById = {
      for (var p in gameResultViewArgs.allPlayersList) p.id!: p.name,
    };
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<GamesHistoryCubit, GamesHistoryStates>(
        listener: (context, state) {
          if (state is GetGameDetailsSuccess) {
            final GameDetailsModel gameDetailsModel = state.gameDetails;
            game = gameDetailsModel.game;
            players = List.from(gameDetailsModel.players);
            players.sort((a, b) => a.totalScore.compareTo(b.totalScore));
            rounds = gameDetailsModel.rounds;
            r = gameDetailsModel.roundScoresByRoundId;
            playersScores = players.map((e) => e.totalScore).toList();
          } else if (state is GetGameDetailsFailure) {
            log(state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state is GetGameDetailsSuccess) {
            final top3 = players.take(3).toList();
            final restOfPlayers = players.skip(3).toList();

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Column(
                      children: [
                        Text(
                          '🏆 GAME OVER 🏆',
                          style: AppTextStyles.font22PurpleBold.copyWith(
                            fontSize: 28.sp,
                            color: AppColors.purple,
                            letterSpacing: 2,
                          ),
                        ),
                        Gap(24.h),
                        if (top3.isNotEmpty)
                          SizedBox(
                            height: 220.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (top3.length > 1)
                                  _buildPodiumPlayer(
                                    player: top3[1],
                                    rank: 2,
                                    height: 140.h,
                                    color: AppColors.sliver,
                                  ),
                                _buildPodiumPlayer(
                                  player: top3[0],
                                  rank: 1,
                                  height: 180.h,
                                  color: AppColors.gold,
                                  isWinner: true,
                                ),
                                if (top3.length > 2)
                                  _buildPodiumPlayer(
                                    player: top3[2],
                                    rank: 3,
                                    height: 120.h,
                                    color: AppColors.bronze,
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (restOfPlayers.isNotEmpty)
                  SliverPadding(
                    padding: .symmetric(horizontal: 24.w, vertical: 12.h),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final GamePlayerModel player = restOfPlayers[index];
                        final int realRank = index + 4;
                        return Padding(
                          padding: .only(bottom: 14.h),
                          child: CustomGamePlayerCard(
                            playerRank: realRank,
                            playerNamesById: playerNamesById,
                            player: player,
                            rounds: rounds,
                            r: r,
                          ),
                        );
                      }, childCount: restOfPlayers.length),
                    ),
                  ),
                SliverToBoxAdapter(child: Gap(30.h)),
              ],
            );
          } else {
            return const Center(child: CupertinoActivityIndicator());
          }
        },
      );

  Widget _buildPodiumPlayer({
    required GamePlayerModel player,
    required int rank,
    required double height,
    required Color color,
    bool isWinner = false,
  }) => Padding(
    padding: .symmetric(horizontal: 8.w),
    child: Column(
      mainAxisAlignment: .end,
      children: [
        Text(
          playerNamesById[player.playerId] ?? 'Unknown',
          style: AppTextStyles.font14WhiteBold.copyWith(
            color: isWinner ? Colors.amber : Colors.white,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${player.totalScore} pts',
          style: AppTextStyles.font12WhiteMedium.copyWith(
            color: Colors.white70,
          ),
        ),
        Gap(8.h),
        Container(
          width: isWinner ? 90.w : 75.w,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withValues(alpha: 0.8),
                color.withValues(alpha: 0.3),
              ],
            ),
            borderRadius: .only(
              topLeft: .circular(12.r),
              topRight: .circular(12.r),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isWinner)
                Icon(Icons.emoji_events, color: Colors.white, size: 30.sp),
              Text('$rank', style: AppTextStyles.font36WhiteBold),
            ],
          ),
        ),
      ],
    ),
  );
}
