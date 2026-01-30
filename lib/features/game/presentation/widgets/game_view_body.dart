import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skru_mate/core/database/shared_models/game_model.dart';
import 'package:skru_mate/core/database/shared_models/player_model.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/routing/routes.dart';
import 'package:skru_mate/core/theming/app_colors.dart';
import 'package:skru_mate/core/theming/app_text_styles.dart';
import 'package:skru_mate/core/widgets/custom_button.dart';
import 'package:skru_mate/core/widgets/custom_header.dart';
import 'package:skru_mate/core/widgets/custom_toast.dart';
import 'package:skru_mate/features/game/presentation/managers/cubits/game_cubit/game_cubit.dart';
import 'package:skru_mate/features/game/presentation/managers/cubits/game_cubit/game_states.dart';
import 'package:skru_mate/features/game/presentation/widgets/custom_player_card.dart';
import 'package:skru_mate/features/games_history/data/models/game_result_view_args.dart';
import '../../../../core/database/shared_models/game_player_model.dart';
import '../../../../core/database/shared_models/round_model.dart';
import '../../../../core/database/shared_models/round_score_model.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../data/models/game_args.dart';

class GameViewBody extends StatefulWidget {
  const GameViewBody({super.key, required this.gameArgs});

  final GameArgs gameArgs;

  @override
  State<GameViewBody> createState() => _GameViewBodyState();
}

class _GameViewBodyState extends State<GameViewBody> {
  int round = 1;
  late List<List<int>> roundScores;
  late ValueNotifier<List<bool>> areWeAddScoreToPlayer;
  late int gameId;
  late List<int> insertedRoundIds;
  bool isDoubleRound = false;
  late int minScore;
  late int maxScore;

  @override
  void initState() {
    super.initState();
    areWeAddScoreToPlayer = ValueNotifier(
      List.generate(widget.gameArgs.players.length, (_) => false),
    );
    roundScores = List.generate(
      widget.gameArgs.players.length,
      (_) => List.generate(widget.gameArgs.roundsCount, (__) => 0),
    );
    setAreWeAddScoreToPlayerToFalse();
    if (round == widget.gameArgs.roundsCount) isDoubleRound = true;
  }

  @override
  void dispose() {
    areWeAddScoreToPlayer.dispose();
    super.dispose();
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

  int getRoundsWonByPlayer(PlayerModel player) {
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
    final List<int> sortedIndices = List.generate(
      widget.gameArgs.players.length,
      (i) => i,
    );
    sortedIndices.sort((a, b) {
      final int scoreA = getTotalScore(a);
      final int scoreB = getTotalScore(b);
      return scoreA.compareTo(scoreB);
    });
    if (widget.gameArgs.players.isNotEmpty) {
      minScore = getTotalScore(0);
      maxScore = getTotalScore(0);
      for (int i = 0; i < widget.gameArgs.players.length; i++) {
        final int s = getTotalScore(i);
        if (s < minScore) minScore = s;
        if (s > maxScore) maxScore = s;
      }
    }
    return BlocListener<GameCubit, GameStates>(
      listener: (context, state) async {
        if (state is InsertGameSuccess) {
          gameId = state.gameId;

          int index = 0;
          final List<GamePlayerModel> gamePlayers = widget.gameArgs.players
              .map(
                (player) => GamePlayerModel(
                  gameId: gameId,
                  playerId: player.id!,
                  totalScore: getTotalScore(index++),
                  roundsWon: getRoundsWonByPlayer(player),
                ),
              )
              .toList();
          gameCubit.insertGamePlayers(players: gamePlayers);
        } else if (state is InsertGamePlayersSuccess) {
          final List<RoundModel> rounds = List.generate(
            widget.gameArgs.roundsCount,
            (index) => RoundModel(gameId: gameId, roundNumber: round),
          );

          gameCubit.insertRounds(rounds: rounds);
        } else if (state is InsertRoundsSuccess) {
          insertedRoundIds = state.roundsIds;

          final List<RoundScoreModel> roundScoreModels = [];

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
                RoundScoreModel(
                  roundId: insertedRoundIds[roundIndex],
                  playerId: widget.gameArgs.players[playerIndex].id!,
                  score: roundScores[playerIndex][roundIndex],
                ),
              );
            }
          }

          gameCubit.insertRoundScores(scores: roundScoreModels);
        } else if (state is InsertRoundScoresSuccess) {
          showCustomToast(
            context: context,
            message: 'Game saved successfully!',
            contentType: ContentType.success,
          );

          int x = 0;

          for (PlayerModel player in widget.gameArgs.players) {
            final bool winner = getTotalScore(x) == minScore;
            final bool loser = getTotalScore(x) == maxScore;

            final int newWinsCount = winner ? player.wins + 1 : player.wins;
            final int newLossesCount = loser
                ? player.losses + 1
                : player.losses;

            final updatedPlayer = PlayerModel(
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

          await Future.delayed(const Duration(milliseconds: 500));

          if (context.mounted) {
            context.pushReplacementNamed(
              Routes.gameResultView,
              arguments: GameResultViewArgs(
                gameId: gameId,
                allPlayersList: widget.gameArgs.players,
                fromHistory: false,
              ),
            );
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
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 24.w),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                CustomHeader(title: 'Round $round', lineWidth: 65.w),
                Row(
                  children: [
                    Text(
                      'Double Round',
                      style: AppTextStyles.font14WhiteRegular,
                    ),
                    SizedBox(width: 8.w),
                    Switch(
                      value: isDoubleRound,
                      onChanged: (value) {
                        isDoubleRound = value;
                        setState(() {});
                        showCustomToast(
                          context: context,
                          message: isDoubleRound
                              ? 'Double round activated'
                              : 'Double round deactivated',
                          contentType: .success,
                        );
                      },
                      activeThumbColor: AppColors.purple,
                      inactiveThumbColor: Colors.grey[600],
                      inactiveTrackColor: Colors.grey[800],
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
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              separatorBuilder: (context, index) => Gap(14.h),
              itemBuilder: (context, index) {
                final int originalIndex = sortedIndices[index];
                final PlayerModel player =
                    widget.gameArgs.players[originalIndex];
                final int playerRank = getPlayerRank(originalIndex);
                final bool isRank1 = playerRank == 1;
                final int playerScore = getTotalScore(originalIndex);
                return ValueListenableBuilder(
                  valueListenable: areWeAddScoreToPlayer,
                  builder: (context, value, child) => CustomPlayerCard(
                    dialogOnSave: () {
                      value[originalIndex] = true;
                      setState(() {});
                    },
                    areWeAddScoreToAllPlayers: areWeAddScoreToAllPlayers(),
                    isRank1: isRank1,
                    player: player,
                    playerRank: playerRank,
                    areWeAddScoreToThisPlayer: value[originalIndex],
                    round: round,
                    roundScore: roundScores[originalIndex],
                    isDoubleRound: isDoubleRound,
                    playerScore: playerScore,
                    areWeAddScoreToAnyPlayer: areWeAddScoreToAnyPlayer(),
                  ),
                );
              },
            ),
          ),
          if (MediaQuery.of(context).viewInsets.bottom == 0)
            bottomButtons(gameCubit, context),
        ],
      ),
    );
  }

  Padding bottomButtons(GameCubit gameCubit, BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 24.w),
    child: Row(
      spacing: 8.w,
      children: [
        if (areWeAddScoreToAllPlayers() ||
            (round > 1 && !areWeAddScoreToAnyPlayer()) ||
            round == widget.gameArgs.roundsCount)
          Expanded(
            child: CustomButton(
              notActiveColor:
                  (!areWeAddScoreToAnyPlayer() && round != 1) ||
                      areWeAddScoreToAllPlayers()
                  ? null
                  : AppColors.appbarColor,
              onTap: () {
                final int numberOfPlayedRounds = !areWeAddScoreToAnyPlayer()
                    ? round - 1
                    : round;
                if (areWeAddScoreToAllPlayers() || !areWeAddScoreToAnyPlayer()) {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => ConfirmationDialog(
                      fullText:
                          'Are you sure you want to end the game? You will be taken to the results screen.',
                      delete: false,
                      textOkButton: 'Finish',
                      onDelete: () {
                        final winnersIds = getWinnersIds();
                        log(winnersIds);
                        final game = GameModel(
                          date: DateTime.now().toIso8601String(),
                          roundsCount: numberOfPlayedRounds,
                          winnersId: winnersIds,
                          // because of NOT NULL condition in database
                          winnerName: '',
                        );
                        gameCubit.insertGame(game: game);
                        context.pop();
                      },
                    ),
                  );
                } else {
                  showCustomToast(
                    context: context,
                    message: 'Add Score to all players first!',
                    contentType: ContentType.failure,
                  );
                  return;
                }
              },
              label: round < widget.gameArgs.roundsCount
                  ? 'Finish Game'
                  : 'Finish & View Results',
            ),
          ),

        if (round < widget.gameArgs.roundsCount)
          Expanded(
            child: CustomButton(
              onTap: () {
                if (!areWeAddScoreToAllPlayers()) {
                  showCustomToast(
                    context: context,
                    message: 'Add Score to all players first!',
                    contentType: ContentType.failure,
                  );
                } else {
                  round++;
                  if (round == widget.gameArgs.roundsCount) {
                    isDoubleRound = true;
                  }
                  setAreWeAddScoreToPlayerToFalse();
                  setState(() {});
                }
              },
              notActiveColor: !areWeAddScoreToAllPlayers()
                  ? AppColors.appbarColor
                  : null,
              label: 'Next Round',
            ),
          ),
      ],
    ),
  );
}
