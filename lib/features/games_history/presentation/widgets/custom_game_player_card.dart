import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';
import '../../../../core/database/shared_entities/game_player_entity.dart';
import '../../../../core/database/shared_entities/round_entity.dart';
import '../../../../core/database/shared_entities/round_score_entity.dart';

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
  final GamePlayerEntity player;
  final List<RoundEntity> rounds;
  final Map<int, List<RoundScoreEntity>> r;
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
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isPodium
            ? rankColor.withValues(alpha: 0.05)
            : colors.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isPodium
              ? rankColor.withValues(alpha: 0.3)
              : colors.border.withValues(alpha: 0.3),
          width: isPodium ? 1.2 : 0.8,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Rank badge / number
              Container(
                width: 28.r,
                height: 28.r,
                decoration: BoxDecoration(
                  color: isPodium
                      ? rankColor.withValues(alpha: 0.15)
                      : colors.surfaceHighest,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$playerRank',
                  style: GoogleFonts.lato(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                    color: isPodium ? rankColor : colors.subText,
                  ),
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Text(
                  '$medal${playerNamesById[player.playerId] ?? 'Unknown'}',
                  style: GoogleFonts.lato(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.mainText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Gap(12.w),
              if (player.roundsWon > 0)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: colors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '🏆 ${player.roundsWon} rounds',
                    style: GoogleFonts.lato(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: colors.success,
                    ),
                  ),
                ),
            ],
          ),
          Gap(10.h),
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
                        orElse: () => RoundScoreEntity(
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
