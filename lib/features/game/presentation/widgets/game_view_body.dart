import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skru_mate/core/database/shared_models/game_model.dart';
import 'package:skru_mate/core/database/shared_models/player_model.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/theming/colors.dart';
import 'package:skru_mate/core/theming/styles.dart';
import 'package:skru_mate/core/widgets/custom_button.dart';
import 'package:skru_mate/core/widgets/custom_header.dart';
import 'package:skru_mate/core/widgets/custom_toast.dart';
import 'package:skru_mate/features/game/presentation/managers/cubits/game_cubit/game_cubit.dart';
import 'package:skru_mate/features/game/presentation/managers/cubits/game_cubit/game_states.dart';
import '../../../../core/database/shared_models/game_player_model.dart';
import '../../../../core/database/shared_models/round_model.dart';
import '../../../../core/database/shared_models/round_score_model.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import 'custom_score_dialog.dart';
import '../../data/models/game_args.dart';
import 'custom_score_button.dart';

class GameViewBody extends StatefulWidget {
  const GameViewBody({super.key, required this.gameArgs});

  final GameArgs gameArgs;

  @override
  State<GameViewBody> createState() => _GameViewBodyState();
}

class _GameViewBodyState extends State<GameViewBody> {
  int round = 1;
  late List<List<int>> roundScores;
  late List<bool> areWeAddScoreToPlayer;
  late int gameId;
  late List<int> insertedRoundIds;
  late int winnerIndex;
  late int loserIndex;
  bool isDoubleRound = false;

  int getTotalScore(int playerIndex) {
    return roundScores[playerIndex].fold(0, (a, b) => a + b);
  }

  List<int> getPlayerRanks() {
    List<int> totalScores = List.generate(
      widget.gameArgs.players.length,
      (i) => getTotalScore(i),
    );

    List<int> sorted = [...totalScores]..sort((b, a) => b.compareTo(a));
    return totalScores.map((s) => sorted.indexOf(s) + 1).toList();
  }

  int getRoundsWonByPlayer(PlayerModel player) {
    int playerIndex = widget.gameArgs.players.indexOf(player);
    int roundsWon = 0;
    List<int> playerScores = roundScores[playerIndex];

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

  @override
  void initState() {
    super.initState();
    roundScores = List.generate(
      widget.gameArgs.players.length,
      (_) => List.generate(widget.gameArgs.roundsCount, (__) => 0),
    );
    setAreWeAddScoreToPlayerToFalse();
    if (round == widget.gameArgs.roundsCount) isDoubleRound = true;
  }

  void setAreWeAddScoreToPlayerToFalse() {
    areWeAddScoreToPlayer = List.generate(
      widget.gameArgs.players.length,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameCubit = context.read<GameCubit>();
    return BlocListener<GameCubit, GameStates>(
      listener: (context, state) async {
        if (state is InsertGameSuccess) {
          gameId = state.gameId;

          int index = 0;
          final List<GamePlayerModel> gamePlayers = widget.gameArgs.players.map(
            (player) {
              return GamePlayerModel(
                gameId: gameId,
                playerId: player.id!,
                totalScore: getTotalScore(index++),
                roundsWon: getRoundsWonByPlayer(player),
              );
            },
          ).toList();
          gameCubit.insertGamePlayers(players: gamePlayers);
        } else if (state is InsertGamePlayersSuccess) {
          final List<RoundModel> rounds = List.generate(
            widget.gameArgs.roundsCount,
            (index) {
              return RoundModel(gameId: gameId, roundNumber: round);
            },
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

          for (PlayerModel player in widget.gameArgs.players) {
            int newWinsCount =
                widget.gameArgs.players[winnerIndex].id == player.id
                ? player.wins + 1
                : player.wins;
            int newLossesCount =
                widget.gameArgs.players[loserIndex].id == player.id
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
          }

          await Future.delayed(const Duration(milliseconds: 500));

          context.pop();
          context.pop();
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            Gap(12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomHeader(title: 'Round $round', lineWidth: 65.w),
                Row(
                  children: [
                    Text(
                      'Double Round',
                      style: TextStyle(fontSize: 14.sp, color: Colors.white),
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
                          contentType: ContentType.success,
                        );
                      },
                      activeColor: ColorsManager.purple,
                      inactiveThumbColor: Colors.grey[600],
                      inactiveTrackColor: Colors.grey[800],
                    ),
                  ],
                ),
              ],
            ),
            Gap(12.h),
            Expanded(
              child: ListView.builder(
                itemCount: widget.gameArgs.players.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  PlayerModel player = widget.gameArgs.players[index];
                  bool isRank1 = getPlayerRanks()[index] == 1;
                  int playerRank = getPlayerRanks()[index];
                  if (playerRank == 1) {
                    winnerIndex = index;
                  } else if (playerRank == widget.gameArgs.players.length) {
                    loserIndex = index;
                  }
                  return Padding(
                    padding: EdgeInsets.only(
                      top: 12.h,
                      bottom: index == widget.gameArgs.players.length - 1
                          ? 12.h
                          : 0,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        border: !areWeAddScoreToAllPlayers()
                            ? null
                            : areWeAddScoreToAllPlayers() && isRank1
                            ? null
                            : Border.all(color: Colors.white54, width: 0.5),
                        color: !areWeAddScoreToAllPlayers()
                            ? ColorsManager.purple.withValues(alpha: 0.9)
                            : areWeAddScoreToAllPlayers() && isRank1
                            ? ColorsManager.purple.withValues(alpha: 0.9)
                            : Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16.h,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                player.name,
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
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 180.w),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(
                                      areWeAddScoreToPlayer[index] ? round : round - 1,
                                          (i) {
                                        return Padding(
                                          padding: EdgeInsets.only(right: 4.w),
                                          child: Column(
                                            children: [
                                              Text('R${i + 1}'),
                                              Text('${roundScores[index][i]}'),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              CustomScoreButton(
                                icon: areWeAddScoreToPlayer[index]
                                    ? Icons.edit
                                    : null,
                                onTap: () {
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return GestureDetector(
                                        onTap: () => context.pop(),
                                        child: CustomScoreDialog(
                                          onSave: (int score) {
                                            roundScores[index][round - 1] =
                                                score;
                                            areWeAddScoreToPlayer[index] = true;
                                            setState(() {});
                                          },
                                          player: player,
                                          round: round,
                                          isDoubleRound: isDoubleRound,
                                          scoreOfPlayer:
                                              areWeAddScoreToPlayer[index]
                                              ? roundScores[index][round - 1]
                                              : null,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              const Spacer(),
                              Padding(
                                padding: EdgeInsets.only(left: 8.w),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 60.w),
                                  child: Text(
                                    '= ${getTotalScore(index)}',
                                    style: TextStyles.font20WhiteBold,
                                    textAlign: TextAlign.end,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
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
            bottomButtons(gameCubit, context),
          ],
        ),
      ),
    );
  }

  Padding bottomButtons(GameCubit gameCubit, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        spacing: 8.w,
        children: [
          if (areWeAddScoreToAllPlayers() ||
              (round > 1 && !areWeAddScoreToAnyPlayer()))
            Expanded(
              child: CustomButton(
                onTap: () {
                  int numberOfPlayedRounds = !areWeAddScoreToAnyPlayer()
                      ? round - 1
                      : round;
                  if (numberOfPlayedRounds != widget.gameArgs.roundsCount) {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => ConfirmationDialog(
                        fullText:
                            'Are you sure you want to finish the game after round $numberOfPlayedRounds?',
                        delete: false,
                        textOkButton: 'Finish',
                        onDelete: () {
                          final game = GameModel(
                            date: DateTime.now().toIso8601String(),
                            roundsCount: numberOfPlayedRounds,
                            winnerId: widget.gameArgs.players[winnerIndex].id,
                            winnerName:
                                widget.gameArgs.players[winnerIndex].name,
                          );
                          log('numberOfPlayedRounds = $numberOfPlayedRounds');
                          gameCubit.insertGame(game: game);
                          context.pop();
                        },
                      ),
                    );
                  } else {
                    final game = GameModel(
                      date: DateTime.now().toIso8601String(),
                      roundsCount: numberOfPlayedRounds,
                      winnerId: widget.gameArgs.players[winnerIndex].id,
                      winnerName: widget.gameArgs.players[winnerIndex].name,
                    );
                    log('numberOfPlayedRounds = $numberOfPlayedRounds');
                    gameCubit.insertGame(game: game);
                  }
                },
                label: 'Finish Game',
              ),
            ),

          if (round < widget.gameArgs.roundsCount)
            Expanded(
              child: CustomButton(
                onTap: () {
                  bool temp = areWeAddScoreToAllPlayers();

                  if (!temp) {
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
                    ? ColorsManager.appbarColor
                    : null,
                label: 'Next Round',
              ),
            ),
        ],
      ),
    );
  }

  bool areWeAddScoreToAllPlayers() {
    bool temp = true;

    for (bool y in areWeAddScoreToPlayer) {
      if (y == false) {
        temp = y;
        break;
      }
    }
    return temp;
  }

  bool areWeAddScoreToAnyPlayer() {
    bool temp = false;

    for (bool y in areWeAddScoreToPlayer) {
      if (y == true) {
        temp = y;
        break;
      }
    }
    return temp;
  }
}
