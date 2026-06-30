import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/database/shared_models/game_player_model.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';
import '../../../../core/database/shared_models/round_model.dart';
import '../../../../core/database/shared_models/round_score_model.dart';

class WinnerCard extends StatelessWidget {
  const WinnerCard({
    super.key,
    required this.player,
    required this.playerName,
    required this.rounds,
    required this.r,
  });

  final GamePlayerModel player;
  final String playerName;
  final List<RoundModel> rounds;
  final Map<int, List<RoundScoreModel>> r;

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
          border: Border.all(color: const Color(0xFFFEE382), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF39C12).withValues(alpha: 0.35),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.emoji_events_rounded, color: Colors.white, size: 40.sp),
            Gap(8.h),
            Text(
              playerName,
              style: GoogleFonts.lato(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  const Shadow(
                    blurRadius: 4,
                    color: Colors.black38,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Gap(6.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '${player.totalScore} pts',
                style: GoogleFonts.lato(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );

  void _showPlayerDetailsDialog(BuildContext context, GamePlayerModel player) {
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
                      orElse: () => RoundScoreModel(
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
