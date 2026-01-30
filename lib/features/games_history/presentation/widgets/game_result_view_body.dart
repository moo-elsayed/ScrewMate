import 'dart:developer';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skru_mate/core/database/shared_models/game_model.dart';
import 'package:skru_mate/core/database/shared_models/game_player_model.dart';
import 'package:skru_mate/core/database/shared_models/round_model.dart';
import 'package:skru_mate/core/helpers/functions.dart';
import 'package:skru_mate/features/games_history/presentation/managers/cubits/games_history_cubit/games_history_cubit.dart';
import 'package:skru_mate/features/games_history/presentation/managers/cubits/games_history_cubit/games_history_states.dart';
import 'package:skru_mate/features/games_history/presentation/widgets/winner_card.dart';
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

  late ConfettiController _confettiController;

  Map<int, List<GamePlayerModel>> rankedPlayers = {};

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    final args = widget.gameResultViewArgs;
    context.read<GamesHistoryCubit>().getGameDetails(gameId: args.gameId);
    playerNamesById = {for (var p in args.allPlayersList) p.id!: p.name};
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _processRankings() {
    rankedPlayers.clear();
    if (players.isEmpty) return;

    players.sort((a, b) => a.totalScore.compareTo(b.totalScore));

    int currentRank = 1;
    for (int i = 0; i < players.length; i++) {
      if (i > 0 && players[i].totalScore != players[i - 1].totalScore) {
        currentRank = i + 1;
      }

      if (!rankedPlayers.containsKey(currentRank)) {
        rankedPlayers[currentRank] = [];
      }
      rankedPlayers[currentRank]!.add(players[i]);
    }
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      BlocConsumer<GamesHistoryCubit, GamesHistoryStates>(
        listener: (context, state) {
          if (state is GetGameDetailsSuccess) {
            game = state.gameDetails.game;
            players = List.from(state.gameDetails.players);
            rounds = state.gameDetails.rounds;
            r = state.gameDetails.roundScoresByRoundId;

            _processRankings();
            _confettiController.play();
          } else if (state is GetGameDetailsFailure) {
            log(state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state is GetGameDetailsSuccess) {
            final winners = rankedPlayers[1] ?? [];

            final restOfRanks = rankedPlayers.keys.where((k) => k != 1).toList()
              ..sort();

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // === Header ===
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Column(
                      children: [
                        Text(
                          winners.length > 1 ? '🏆 WINNERS 🏆' : '🏆 WINNER 🏆',
                          style: AppTextStyles.font22PurpleBold.copyWith(
                            fontSize: 28.sp,
                            color: AppColors.purple,
                            letterSpacing: 2,
                          ),
                        ),
                        Gap(20.h),
                        Wrap(
                          spacing: 12.w,
                          runSpacing: 12.h,
                          alignment: WrapAlignment.center,
                          children: winners
                              .map(
                                (player) => WinnerCard(
                                  player: player,
                                  playerName:
                                      playerNamesById[player.playerId] ??
                                      'Unknown',
                                  rounds: rounds,
                                  r: r,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                // === فاصل ===
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.w,
                      vertical: 10.h,
                    ),
                    child: const Divider(color: Colors.white24),
                  ),
                ),

                // === قائمة باقي اللاعبين ===
                if (restOfRanks.isNotEmpty)
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final flatList = <MapEntry<int, GamePlayerModel>>[];
                          for (var rank in restOfRanks) {
                            for (var player in rankedPlayers[rank]!) {
                              flatList.add(MapEntry(rank, player));
                            }
                          }

                          final rank = flatList[index].key;
                          final player = flatList[index].value;

                          return Padding(
                            padding: EdgeInsets.only(bottom: 14.h),
                            child: _buildStandardPlayerCard(player, rank),
                          );
                        },
                        childCount: restOfRanks.fold(
                          0,
                          (sum, rank) => sum! + rankedPlayers[rank]!.length,
                        ),
                      ),
                    ),
                  ),

                SliverToBoxAdapter(child: Gap(30.h)),
              ],
            );
          }
          return const Center(child: CupertinoActivityIndicator());
        },
      ),

      // Confetti Overlay
      Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple,
            AppColors.gold,
          ],
          numberOfParticles: 30,
          gravity: 0.3,
        ),
      ),
    ],
  );

  Widget _buildStandardPlayerCard(GamePlayerModel player, int rank) =>
      CustomGamePlayerCard(
        playerRank: rank,
        playerNamesById: playerNamesById,
        player: player,
        rounds: rounds,
        r: r,
        rankColor: getRankColor(rank),
      );
}
