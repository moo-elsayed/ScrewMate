import 'dart:developer';
import 'dart:math' hide log;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/database/shared_models/game_model.dart';
import 'package:skru_mate/core/database/shared_models/player_model.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/routing/routes.dart';
import 'package:skru_mate/core/theming/colors.dart';
import 'package:skru_mate/core/widgets/custom_button.dart';
import 'package:skru_mate/core/widgets/custom_toast.dart';
import 'package:skru_mate/features/game/presentation/managers/cubits/game_cubit/game_cubit.dart';
import 'package:skru_mate/features/game/presentation/managers/cubits/game_cubit/game_states.dart';
import '../../../../core/database/shared_models/game_player_model.dart';
import '../../../../core/database/shared_models/round_model.dart';
import '../../../../core/database/shared_models/round_score_model.dart';
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
  late List<bool> areWeAddScoreToPlayer;
  late int gameId;
  late List<int> insertedRoundIds;
  late int winnerIndex;
  late int loserIndex;

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

    log(roundsWon.toString());

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
    log(widget.gameArgs.roundsCount.toString());
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

          // Step 2: Insert GamePlayers
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
          // Step 3: Insert Rounds
          final List<RoundModel> rounds = List.generate(
            widget.gameArgs.roundsCount,
            (index) {
              return RoundModel(gameId: gameId, roundNumber: round);
            },
          );

          gameCubit.insertRounds(rounds: rounds);
        } else if (state is InsertRoundsSuccess) {
          insertedRoundIds = state.roundsIds;

          // Step 4: Insert RoundScores
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

          context.pop();
          context.pop();

          // Future.delayed(
          //   const Duration(seconds: 4),
          //   () => showCustomToast(
          //     context: widget.gameArgs.scaffoldKey.currentContext!,
          //     message: 'Players stats updated successfully!',
          //     contentType: ContentType.success,
          //   ),
          // );

//           showCustomToast(
//             context: widget.gameArgs.scaffoldKey.currentContext!,
//             message: 'Players stats updated successfully!',
//             contentType: ContentType.success,
//           );
//
// // انتظر 500ms قبل ما تعمل pop مرتين علشان الـ Scaffold لسه عايش
//           Future.delayed(const Duration(milliseconds: 500), () {
//             context.pop(); // Pop GameView
//             context.pop(); // Pop AddPlayerView
//           });


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
            // Round Title
            Column(
              children: [
                Text(
                  'Round $round',
                  style: GoogleFonts.lato(
                    color: ColorsManager.purple.withValues(alpha: 0.9),
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(6.h),
                Container(
                  height: 1.h,
                  width: 60.w,
                  color: ColorsManager.purple.withValues(alpha: 0.5),
                ),
              ],
            ),
            Gap(12.h),
            // Players List
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
                        border: isRank1
                            ? null
                            : Border.all(color: Colors.white54, width: 0.5),
                        color: isRank1
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
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Rank #$playerRank',
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SingleChildScrollView(
                                child: Row(
                                  children: List.generate(
                                    areWeAddScoreToPlayer[index]
                                        ? round
                                        : round - 1,
                                    (i) {
                                      return Padding(
                                        padding: EdgeInsets.only(right: 4.w),
                                        child: Column(
                                          spacing: 4.h,
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
                              if (!areWeAddScoreToPlayer[index])
                                GestureDetector(
                                  onTap: () {
                                    var random = Random();
                                    int randomNumber = random.nextInt(100);
                                    roundScores[index][round - 1] =
                                        randomNumber;
                                    areWeAddScoreToPlayer[index] = true;
                                    setState(() {});
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    margin: EdgeInsets.only(left: 4.w),
                                    child: Icon(
                                      Icons.add,
                                      color: ColorsManager.purple.withValues(
                                        alpha: 0.9,
                                      ),
                                      size: 22,
                                    ),
                                  ),
                                ),
                              const Spacer(),
                              Text(
                                '= ${getTotalScore(index)}',
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: CustomButton(
                onTap: () {
                  bool temp = true;

                  for (bool y in areWeAddScoreToPlayer) {
                    if (y == false) {
                      temp = y;
                      break;
                    }
                  }

                  if (!temp) {
                    showCustomToast(
                      context: context,
                      message: 'Add Score to all players first!',
                      contentType: ContentType.failure,
                    );
                  } else {
                    if (round < widget.gameArgs.roundsCount) {
                      round++;
                      setAreWeAddScoreToPlayerToFalse();
                      setState(() {});
                    } else {
                      // Step 1: Insert Game
                      final game = GameModel(
                        date: DateTime.now().toIso8601String(),
                        roundsCount: widget.gameArgs.roundsCount,
                        winnerId: widget.gameArgs.players[winnerIndex].id,
                        winnerName: widget.gameArgs.players[winnerIndex].name,
                      );

                      gameCubit.insertGame(game: game);
                    }
                  }
                },
                label: round < widget.gameArgs.roundsCount
                    ? 'Next Round'
                    : 'Finish Game',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
