import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';
import '../../../../core/database/shared_models/game_player_model.dart';
import '../../../../core/database/shared_models/round_model.dart';
import '../../../../core/database/shared_models/round_score_model.dart';

class CustomGamePlayerCard extends StatelessWidget {
  const CustomGamePlayerCard({
    super.key,
    required this.playerRank,
    required this.playerNamesById,
    required this.player,
    required this.rounds,
    required this.r,
    required this.rankColor,
  });

  final int playerRank;
  final Map<int, String> playerNamesById;
  final GamePlayerModel player;
  final List<RoundModel> rounds;
  final Map<int, List<RoundScoreModel>> r;
  final Color rankColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bool isPodium = playerRank <= 3;

    // Medal Emoji
    final String medal = playerRank == 2
        ? '🥈 '
        : playerRank == 3
        ? '🥉 '
        : '';

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isPodium ? rankColor : colors.border.withValues(alpha: 0.6),
          width: isPodium ? 1.5 : 0.8,
        ),
        color: colors.surfaceElevated,
        boxShadow: isPodium
            ? [
                BoxShadow(
                  color: rankColor.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 14.h,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                playerNamesById[player.playerId] != null
                    ? '${playerNamesById[player.playerId]}'
                    : 'Deleted player',
                style: GoogleFonts.lato(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.mainText,
                ),
              ),
              Text(
                '${medal}Rank #$playerRank',
                style: GoogleFonts.lato(
                  fontSize: 16.sp,
                  fontWeight: isPodium ? FontWeight.bold : FontWeight.w600,
                  color: isPodium ? rankColor : colors.subText,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: List.generate(rounds.length, (i) {
                      final scoresInRound = r[rounds[i].id] ?? [];
                      final scoreForThisPlayer = scoresInRound.firstWhere(
                        (s) => s.playerId == player.playerId,
                        orElse: () => RoundScoreModel(
                          roundId: rounds[i].id!,
                          playerId: player.playerId,
                          score: 0,
                        ),
                      );
                      return Container(
                        margin: EdgeInsets.only(right: 6.w),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surfaceHighest,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: colors.border.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          spacing: 2.h,
                          children: [
                            Text(
                              'R${i + 1}',
                              style: GoogleFonts.lato(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.subText,
                              ),
                            ),
                            Text(
                              '${scoreForThisPlayer.score}',
                              style: GoogleFonts.lato(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: colors.mainText,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
              Gap(12.w),
              Text(
                '= ${player.totalScore}',
                style: GoogleFonts.lato(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                  color: isPodium ? rankColor : colors.mainText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
