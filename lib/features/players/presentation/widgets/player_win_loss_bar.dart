import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/database/shared_models/player_model.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';

class PlayerWinLossBar extends StatelessWidget {
  const PlayerWinLossBar({
    super.key,
    required this.player,
  });

  final PlayerModel player;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final int totalWins = player.wins;
    final int totalLosses = player.losses;
    final int totalGames = totalWins + totalLosses;

    if (totalGames == 0) return const SizedBox();

    final double winRatio = totalWins / totalGames;
    final double lossRatio = totalLosses / totalGames;

    return Container(
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.4),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Ratio',
            style: GoogleFonts.lato(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: colors.mainText,
            ),
          ),
          Gap(10.h),
          // Segmented Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: SizedBox(
              height: 10.h,
              child: Row(
                children: [
                  if (totalWins > 0)
                    Expanded(
                      flex: (winRatio * 100).round(),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colors.success,
                              colors.success.withValues(alpha: 0.8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (totalLosses > 0)
                    Expanded(
                      flex: (lossRatio * 100).round(),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colors.error,
                              colors.error.withValues(alpha: 0.8),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Gap(12.h),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8.r,
                    height: 8.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.success,
                    ),
                  ),
                  Gap(6.w),
                  Text(
                    'Wins: $totalWins (${(winRatio * 100).toStringAsFixed(0)}%)',
                    style: GoogleFonts.lato(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: colors.subText,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 8.r,
                    height: 8.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.error,
                    ),
                  ),
                  Gap(6.w),
                  Text(
                    'Losses: $totalLosses (${(lossRatio * 100).toStringAsFixed(0)}%)',
                    style: GoogleFonts.lato(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: colors.subText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate().fade(duration: 400.ms, delay: 150.ms).slideY(begin: 0.1);
  }
}
