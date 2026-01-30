import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/database/shared_models/game_player_model.dart';
import '../../../../core/database/shared_models/round_model.dart';
import '../../../../core/database/shared_models/round_score_model.dart';
import '../../../../core/theming/app_text_styles.dart';

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
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16.r),
    decoration: BoxDecoration(
      borderRadius: .circular(16.r),
      border: Border.all(color: rankColor, width: 0.5),
      color: rankColor.withValues(alpha: playerRank <= 3 ? 0.25 : 0.13),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.h,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              playerNamesById[player.playerId] != null
                  ? '${playerNamesById[player.playerId]}'
                  : 'Deleted player',
              style: AppTextStyles.font18WhiteBold,
            ),
            Text('Rank #$playerRank', style: AppTextStyles.font18WhiteRegular),
          ],
        ),
        Row(
          children: [
            SingleChildScrollView(
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
                  return Padding(
                    padding: EdgeInsets.only(right: 4.w),
                    child: Column(
                      spacing: 4.h,
                      children: [
                        Text('R${i + 1}'),
                        Text('${scoreForThisPlayer.score}'),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const Spacer(),
            Text(
              '= ${player.totalScore}',
              style: AppTextStyles.font20WhiteBold,
            ),
          ],
        ),
      ],
    ),
  );
}
