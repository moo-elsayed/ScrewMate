import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';
import '../../../../core/database/shared_entities/player_entity.dart';
import '../../../../core/routing/routes.dart';
import '../../../games_history/data/models/game_result_view_args.dart';
import '../../domain/entities/player_game_stats_entity.dart';

class PreviousGamesForPlayerListView extends StatelessWidget {
  const PreviousGamesForPlayerListView({
    super.key,
    required this.playerGameStatsList,
    required this.players,
    this.showAll = false,
  });

  final List<PlayerGameStatsEntity> playerGameStatsList;
  final List<PlayerEntity> players;
  final bool showAll;

  String _formatDate(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final int itemCount = showAll
        ? playerGameStatsList.length
        : min(playerGameStatsList.length, 5);

    if (itemCount == 0) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Text(
            'No games played yet',
            style: GoogleFonts.lato(
              fontSize: 14.sp,
              color: colors.subText,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: showAll ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemBuilder: (context, index) {
        final playerGameStatsModel = playerGameStatsList[index];
        final rank = playerGameStatsModel.rank;
        final rankColor = rank.getRankColor(context);

        String rankSuffix = 'th';
        if (rank == 1) {
          rankSuffix = 'st';
        } else if (rank == 2) {
          rankSuffix = 'nd';
        } else if (rank == 3) {
          rankSuffix = 'rd';
        }

        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: GestureDetector(
            onTap: () {
              context.pushNamed(
                Routes.gameResultView,
                arguments: GameResultViewArgs(
                  gameId: playerGameStatsModel.gameId,
                  allPlayersList: players,
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: colors.border.withValues(alpha: 0.4),
                  width: 0.8,
                ),
              ),
              child: Row(
                children: [
                  // Left Side: Game Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Game #${playerGameStatsModel.gameId}',
                          style: GoogleFonts.lato(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: colors.mainText,
                          ),
                        ),
                        Gap(6.h),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 12.r,
                              color: colors.subText,
                            ),
                            Gap(4.w),
                            Text(
                              _formatDate(playerGameStatsModel.date),
                              style: GoogleFonts.lato(
                                fontSize: 11.sp,
                                color: colors.subText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Gap(12.w),
                            Icon(
                              Icons.donut_large_rounded,
                              size: 12.r,
                              color: colors.subText,
                            ),
                            Gap(4.w),
                            Text(
                              '${playerGameStatsModel.roundsCount} rounds',
                              style: GoogleFonts.lato(
                                fontSize: 11.sp,
                                color: colors.subText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Right Side: Score & Rank Badge & Chevron
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Score Capsule
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: colors.surfaceHighest,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: colors.border.withValues(alpha: 0.3),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          '${playerGameStatsModel.totalScore} pts',
                          style: GoogleFonts.lato(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: colors.mainText,
                          ),
                        ),
                      ),
                      Gap(8.w),

                      // Rank Badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: rankColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: rankColor,
                            width: 1.r,
                          ),
                        ),
                        child: Text(
                          '$rank$rankSuffix',
                          style: GoogleFonts.lato(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w900,
                            color: rankColor,
                          ),
                        ),
                      ),
                      Gap(4.w),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 20.r,
                        color: colors.subText,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ).animate(delay: Duration(milliseconds: 50 * index))
           .slideY(begin: 0.15, duration: 250.ms)
           .fadeIn(duration: 250.ms),
        );
      },
    );
  }
}
