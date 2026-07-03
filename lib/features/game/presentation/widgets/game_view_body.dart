import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/database/shared_entities/game_entity.dart';
import 'package:skru_mate/core/database/shared_entities/player_entity.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/routing/routes.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';
import 'package:skru_mate/core/widgets/app_toasts.dart';
import 'package:skru_mate/core/widgets/custom_button.dart';
import 'package:skru_mate/features/game/presentation/managers/cubits/game_cubit/game_cubit.dart';
import 'package:skru_mate/features/game/presentation/managers/cubits/game_cubit/game_states.dart';
import 'package:skru_mate/features/game/presentation/widgets/custom_player_card.dart';
import 'package:skru_mate/features/games_history/data/models/game_result_view_args.dart';
import 'package:skru_mate/features/games_history/presentation/managers/cubits/games_history_cubit/games_history_cubit.dart';
import 'package:skru_mate/features/players/presentation/managers/cubits/players_cubit/players_cubit.dart';
import '../../../../core/database/shared_entities/game_player_entity.dart';
import '../../../../core/database/shared_entities/round_entity.dart';
import '../../../../core/database/shared_entities/round_score_entity.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../data/models/game_args.dart';

class GameViewBody extends StatefulWidget {
  const GameViewBody({super.key, required this.gameArgs});

  final GameArgs gameArgs;

  @override
  State<GameViewBody> createState() => _GameViewBodyState();
}

class _GameViewBodyState extends State<GameViewBody> {
  late final ValueNotifier<int> roundNotifier;
  late final ValueNotifier<bool> isDoubleRoundNotifier;
  late final ValueNotifier<int> scoresChangeNotifier;
  late List<List<int>> roundScores;
  late ValueNotifier<List<bool>> areWeAddScoreToPlayer;
  late int gameId;
  late List<int> insertedRoundIds;
  late List<int> sortedIndices;

  @override
  void initState() {
    super.initState();
    roundNotifier = ValueNotifier(1);
    isDoubleRoundNotifier = ValueNotifier(false);
    scoresChangeNotifier = ValueNotifier(0);
    areWeAddScoreToPlayer = ValueNotifier(
      List.generate(widget.gameArgs.players.length, (_) => false),
    );
    roundScores = List.generate(
      widget.gameArgs.players.length,
      (_) => List.generate(widget.gameArgs.roundsCount, (__) => 0),
    );
    sortedIndices = List.generate(widget.gameArgs.players.length, (i) => i);
    setAreWeAddScoreToPlayerToFalse();
    if (roundNotifier.value == widget.gameArgs.roundsCount) {
      isDoubleRoundNotifier.value = true;
    }
  }

  @override
  void dispose() {
    roundNotifier.dispose();
    isDoubleRoundNotifier.dispose();
    scoresChangeNotifier.dispose();
    areWeAddScoreToPlayer.dispose();
    super.dispose();
  }

  int get minScore {
    if (widget.gameArgs.players.isEmpty) return 0;
    int min = getTotalScore(0);
    for (int i = 1; i < widget.gameArgs.players.length; i++) {
      final int s = getTotalScore(i);
      if (s < min) min = s;
    }
    return min;
  }

  int get maxScore {
    if (widget.gameArgs.players.isEmpty) return 0;
    int max = getTotalScore(0);
    for (int i = 1; i < widget.gameArgs.players.length; i++) {
      final int s = getTotalScore(i);
      if (s > max) max = s;
    }
    return max;
  }

  int getTotalScore(int playerIndex) =>
      roundScores[playerIndex].fold(0, (a, b) => a + b);

  int getPlayerRank(int index) {
    final List<int> totalScores = List.generate(
      widget.gameArgs.players.length,
      (i) => getTotalScore(i),
    );

    final List<int> sorted = [...totalScores]..sort((b, a) => b.compareTo(a));
    return totalScores.map((s) => sorted.indexOf(s) + 1).toList()[index];
  }

  int getRoundsWonByPlayer(PlayerEntity player) {
    final int playerIndex = widget.gameArgs.players.indexOf(player);
    int roundsWon = 0;
    final List<int> playerScores = roundScores[playerIndex];

    for (int i = 0; i < widget.gameArgs.roundsCount; i++) {
      bool f = true;
      for (int k = 0; k < roundScores.length; k++) {
        if (roundScores[k][i] < playerScores[i]) {
          f = false;
          break;
        }
      }
      if (f) {
        roundsWon++;
      }
      f = true;
    }

    return roundsWon;
  }

  void setAreWeAddScoreToPlayerToFalse() => areWeAddScoreToPlayer.value =
      List.generate(widget.gameArgs.players.length, (_) => false);

  String getWinnersIds() => widget.gameArgs.players
      .where(
        (p) => getTotalScore(widget.gameArgs.players.indexOf(p)) == minScore,
      )
      .map((p) => p.id)
      .join(',');

  bool areWeAddScoreToAllPlayers() =>
      areWeAddScoreToPlayer.value.every((element) => element == true);

  bool areWeAddScoreToAnyPlayer() =>
      areWeAddScoreToPlayer.value.any((element) => element == true);

  @override
  Widget build(BuildContext context) {
    final gameCubit = context.read<GameCubit>();
    final colors = context.colors;
    return BlocListener<GameCubit, GameStates>(
      listener: (context, state) async {
        if (state is InsertGameSuccess) {
          gameId = state.gameId;

          int index = 0;
          final List<GamePlayerEntity> gamePlayers = widget.gameArgs.players
              .map(
                (player) => GamePlayerEntity(
                  gameId: gameId,
                  playerId: player.id!,
                  totalScore: getTotalScore(index++),
                  roundsWon: getRoundsWonByPlayer(player),
                ),
              )
              .toList();
          await gameCubit.insertGamePlayers(players: gamePlayers);
        } else if (state is InsertGamePlayersSuccess) {
          final List<RoundEntity> rounds = List.generate(
            widget.gameArgs.roundsCount,
            (index) =>
                RoundEntity(gameId: gameId, roundNumber: roundNotifier.value),
          );

          await gameCubit.insertRounds(rounds: rounds);
        } else if (state is InsertRoundsSuccess) {
          insertedRoundIds = state.roundsIds;

          final List<RoundScoreEntity> roundScoreModels = [];

          for (
            int roundIndex = 0;
            roundIndex < widget.gameArgs.roundsCount;
            roundIndex++
          ) {
            for (
              int playerIndex = 0;
              playerIndex < widget.gameArgs.players.length;
              playerIndex++
            ) {
              roundScoreModels.add(
                RoundScoreEntity(
                  roundId: insertedRoundIds[roundIndex],
                  playerId: widget.gameArgs.players[playerIndex].id!,
                  score: roundScores[playerIndex][roundIndex],
                ),
              );
            }
          }

          await gameCubit.insertRoundScores(scores: roundScoreModels);
        } else if (state is InsertRoundScoresSuccess) {
          Future.delayed(const Duration(milliseconds: 600), () {
            if (context.mounted) {
              AppToast.show(
                context: context,
                title: 'Game saved successfully!',
                type: .success,
              );
            }
          });

          int x = 0;
          debugPrint('=== GAME OVER STATS ===');
          debugPrint('Min Score (Winner): $minScore');
          debugPrint('Max Score (Loser): $maxScore');

          for (PlayerEntity player in widget.gameArgs.players) {
            final int playerScore = getTotalScore(x);
            final bool winner = playerScore == minScore;
            final bool loser = playerScore == maxScore;

            final int newWinsCount = winner ? player.wins + 1 : player.wins;
            final int newLossesCount = loser
                ? player.losses + 1
                : player.losses;

            debugPrint('Player: ${player.name}');
            debugPrint('  - Total Score: $playerScore');
            debugPrint('  - Is Winner: $winner (Wins: ${player.wins} -> $newWinsCount)');
            debugPrint('  - Is Loser: $loser (Losses: ${player.losses} -> $newLossesCount)');

            final updatedPlayer = PlayerEntity(
              id: player.id,
              name: player.name,
              gamesPlayed: player.gamesPlayed + 1,
              wins: newWinsCount,
              losses: newLossesCount,
              roundWins: player.roundWins + getRoundsWonByPlayer(player),
              winRate: newWinsCount / (player.gamesPlayed + 1) * 100,
            );

            await gameCubit.updatePlayerStats(player: updatedPlayer);
            x++;
          }
          debugPrint('=======================');

          await Future.delayed(const Duration(milliseconds: 500));

          if (context.mounted) {
            final gamesHistoryCubit = context.read<GamesHistoryCubit>();
            final playersCubit = context.read<PlayersCubit>();

            await gamesHistoryCubit.getAllGames();
            await playersCubit.getAllPlayers();

            if (context.mounted) {
              context.pop();
              await context.pushReplacementNamed(
                Routes.gameResultView,
                arguments: GameResultViewArgs(
                  gameId: gameId,
                  allPlayersList: widget.gameArgs.players,
                  fromHistory: false,
                ),
              );
            }
          }
        } else if (state is InsertGameFailure) {
          log(state.errorMessage);
        } else if (state is InsertGamePlayersFailure) {
          log(state.errorMessage);
        } else if (state is InsertRoundsFailure) {
          log(state.errorMessage);
        } else if (state is InsertRoundScoresFailure) {
          log(state.errorMessage);
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([
          roundNotifier,
          isDoubleRoundNotifier,
          areWeAddScoreToPlayer,
          scoresChangeNotifier,
        ]),
        builder: (context, _) {
          final currentRound = roundNotifier.value;
          final currentIsDoubleRound = isDoubleRoundNotifier.value;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 4.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Round $currentRound',
                      style: GoogleFonts.lato(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900,
                        color: colors.mainText,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Double Round',
                          style: GoogleFonts.lato(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.mainText,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Transform.scale(
                          scale: 0.82,
                          child: Switch(
                            value: currentIsDoubleRound,
                            onChanged: (value) {
                              isDoubleRoundNotifier.value = value;
                              AppToast.show(
                                context: context,
                                title: value
                                    ? 'Double round activated'
                                    : 'Double round deactivated',
                                type: .success,
                              );
                            },
                            activeThumbColor: colors.primary,
                            activeTrackColor: colors.primary.withValues(
                              alpha: 0.4,
                            ),
                            inactiveThumbColor: colors.subText,
                            inactiveTrackColor: colors.border.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: widget.gameArgs.players.length,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  separatorBuilder: (context, index) => Gap(12.h),
                  itemBuilder: (context, index) {
                    final int originalIndex = sortedIndices[index];
                    final PlayerEntity player =
                        widget.gameArgs.players[originalIndex];
                    final int playerRank = getPlayerRank(originalIndex);
                    final bool isRank1 = playerRank == 1;
                    final int playerScore = getTotalScore(originalIndex);
                    return CustomPlayerCard(
                      dialogOnSave: () {
                        areWeAddScoreToPlayer.value[originalIndex] = true;
                        areWeAddScoreToPlayer.value = List.from(
                          areWeAddScoreToPlayer.value,
                        );
                        scoresChangeNotifier.value++;
                      },
                      areWeAddScoreToAllPlayers: areWeAddScoreToAllPlayers(),
                      isRank1: isRank1,
                      player: player,
                      playerRank: playerRank,
                      areWeAddScoreToThisPlayer:
                          areWeAddScoreToPlayer.value[originalIndex],
                      round: currentRound,
                      roundScore: roundScores[originalIndex],
                      isDoubleRound: currentIsDoubleRound,
                      playerScore: playerScore,
                      areWeAddScoreToAnyPlayer: areWeAddScoreToAnyPlayer(),
                    );
                  },
                ),
              ),
              bottomButtons(gameCubit, context),
            ],
          );
        },
      ),
    );
  }

  Widget bottomButtons(GameCubit gameCubit, BuildContext context) {
    final colors = context.colors;
    final currentRound = roundNotifier.value;
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h, bottom: 8.h),
      child: Row(
        spacing: 8.w,
        children: [
          if (areWeAddScoreToAllPlayers() ||
              (currentRound > 1 && !areWeAddScoreToAnyPlayer()) ||
              currentRound == widget.gameArgs.roundsCount)
            Expanded(
              child: CustomButton(
                notActiveColor:
                    (!areWeAddScoreToAnyPlayer() && currentRound != 1) ||
                        areWeAddScoreToAllPlayers()
                    ? null
                    : colors.surfaceHighest,
                onTap: () {
                  final int numberOfPlayedRounds = !areWeAddScoreToAnyPlayer()
                      ? currentRound - 1
                      : currentRound;
                  if (areWeAddScoreToAllPlayers() ||
                      !areWeAddScoreToAnyPlayer()) {
                    ConfirmationDialog.show(
                      context,
                      fullText:
                          'Are you sure you want to end the game? You will be taken to the results screen.',
                      delete: false,
                      textOkButton: 'Finish',
                      onDelete: () {
                        final winnersIds = getWinnersIds();
                        log(winnersIds);
                        final game = GameEntity(
                          date: DateTime.now().toIso8601String(),
                          roundsCount: numberOfPlayedRounds,
                          winnersId: winnersIds,
                          // because of NOT NULL condition in database
                          winnerName: '',
                        );
                        gameCubit.insertGame(game: game);
                        context.pop();
                      },
                    );
                  } else {
                    AppToast.show(
                      context: context,
                      title: 'Add Score to all players first!',
                      type: .error,
                    );
                    return;
                  }
                },
                label: currentRound < widget.gameArgs.roundsCount
                    ? 'Finish Game'
                    : 'Finish & View Results',
              ),
            ),

          if (currentRound < widget.gameArgs.roundsCount)
            Expanded(
              child: CustomButton(
                onTap: () {
                  if (!areWeAddScoreToAllPlayers()) {
                    AppToast.show(
                      context: context,
                      title: 'Add Score to all players first!',
                      type: .error,
                    );
                  } else {
                    roundNotifier.value++;
                    if (roundNotifier.value == widget.gameArgs.roundsCount) {
                      isDoubleRoundNotifier.value = true;
                    }
                    setAreWeAddScoreToPlayerToFalse();
                    sortedIndices.sort((a, b) {
                      final int scoreA = getTotalScore(a);
                      final int scoreB = getTotalScore(b);
                      return scoreA.compareTo(scoreB);
                    });
                  }
                },
                notActiveColor: !areWeAddScoreToAllPlayers()
                    ? colors.surfaceHighest
                    : null,
                label: 'Next Round',
              ),
            ),
        ],
      ),
    );
  }
}
