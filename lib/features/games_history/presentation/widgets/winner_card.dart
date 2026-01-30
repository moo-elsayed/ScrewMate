import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skru_mate/core/database/shared_models/game_player_model.dart';
import '../../../../core/database/shared_models/round_model.dart';
import '../../../../core/database/shared_models/round_score_model.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';

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
      padding: .all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.gold.withValues(alpha: 0.9),
            AppColors.gold.withValues(alpha: 0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.amberAccent, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.3),
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
            style: AppTextStyles.font18WhiteBold.copyWith(
              color: Colors.white,
              shadows: [const Shadow(blurRadius: 2, color: Colors.black45)],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Gap(4.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              '${player.totalScore} pts',
              style: AppTextStyles.font14WhiteBold,
            ),
          ),
        ],
      ),
    ),
  );

  void _showPlayerDetailsDialog(BuildContext context, GamePlayerModel player) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: AppColors.roundDetailsForPlayerColor,
        shape: RoundedRectangleBorder(borderRadius: .circular(16.r)),
        child: Padding(
          padding: .all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                playerName != 'Unknown' ? playerName : 'Player Details',
                style: AppTextStyles.font18WhiteBold.copyWith(
                  color: AppColors.purple,
                ),
              ),
              Gap(16.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        spacing: 4.h,
                        children: [
                          Text(
                            'R${i + 1}',
                            style: AppTextStyles.font12WhiteMedium.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${scoreForThisPlayer.score}',
                            style: AppTextStyles.font14WhiteBold,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              Gap(20.h),
              const Divider(color: Colors.white24),
              Gap(10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Score: ',
                    style: AppTextStyles.font14WhiteRegular,
                  ),
                  Text(
                    '${player.totalScore}',
                    style: AppTextStyles.font20WhiteBold.copyWith(
                      color: AppColors.purple,
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
