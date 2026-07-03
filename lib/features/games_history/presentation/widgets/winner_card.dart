import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/database/shared_entities/game_player_entity.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';
import '../../../../core/database/shared_entities/round_entity.dart';
import '../../../../core/database/shared_entities/round_score_entity.dart';

class WinnerCard extends StatelessWidget {
  const WinnerCard({
    super.key,
    required this.player,
    required this.playerName,
    required this.rounds,
    required this.r,
  });

  final GamePlayerEntity player;
  final String playerName;
  final List<RoundEntity> rounds;
  final Map<int, List<RoundScoreEntity>> r;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => _showPlayerDetailsDialog(context, player),
        child: Container(
        width: 140.w,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF1C40F), // Rich Gold
              Color(0xFFF39C12), // Dark Gold
            ],
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF39C12).withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 60.r,
                  height: 60.r,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                ),
                Icon(
                  Icons.emoji_events_rounded,
                  size: 36.r,
                  color: Colors.white,
                ),
              ],
            ),
            Gap(12.h),
            Text(
              playerName != 'Unknown' ? playerName : 'Winner',
              style: GoogleFonts.lato(
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Gap(4.h),
            Text(
              '${player.totalScore} pts',
              style: GoogleFonts.lato(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Gap(6.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '1st Place',
                style: GoogleFonts.lato(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );

  void _showPlayerDetailsDialog(BuildContext context, GamePlayerEntity player) {
    final colors = context.colors;
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: colors.surfaceElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                playerName != 'Unknown' ? playerName : 'Player Details',
                style: GoogleFonts.lato(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
              Gap(16.h),
              SingleChildScrollView(
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
                      margin: EdgeInsets.only(right: 8.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surfaceHighest,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
                      ),
                      child: Column(
                        spacing: 4.h,
                        children: [
                          Text(
                            'R${i + 1}',
                            style: GoogleFonts.lato(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.subText,
                            ),
                          ),
                          Text(
                            '${scoreForThisPlayer.score}',
                            style: GoogleFonts.lato(
                              fontSize: 14.sp,
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
              Gap(20.h),
              Divider(color: colors.border.withValues(alpha: 0.5)),
              Gap(10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Score: ',
                    style: GoogleFonts.lato(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.subText,
                    ),
                  ),
                  Text(
                    '${player.totalScore}',
                    style: GoogleFonts.lato(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w900,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
