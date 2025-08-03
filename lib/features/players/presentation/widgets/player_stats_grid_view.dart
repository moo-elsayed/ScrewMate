import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/player_details_args.dart';
import 'custom_player_stat_item.dart';

class PlayerStatsGridView extends StatelessWidget {
  const PlayerStatsGridView({super.key, required this.playerDetailsArgs});

  final PlayerDetailsArgs playerDetailsArgs;

  @override
  Widget build(BuildContext context) {
    final player = playerDetailsArgs.player;
    final statRanks = playerDetailsArgs.statRanks;

    final List<Map<String, dynamic>> stats = [
      {'title': 'Games Played', 'value': player.gamesPlayed},
      {'title': 'Wins', 'value': player.wins},
      {'title': 'Round Wins', 'value': player.roundWins},
      {'title': 'Win Rate', 'value': '${player.winRate.toStringAsFixed(1)}%'},
      {'title': 'Losses', 'value': player.losses},
    ];
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.8,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        final title = stat['title'];
        final value = stat['value'].toString();
        final rank = statRanks[title];
        return CustomPlayerStatItem(rank: rank!, title: title, value: value)
            .animate(delay: Duration(milliseconds: 50 * index))
            .slideY(begin: 0.2, duration: 300.ms)
            .fadeIn(duration: 300.ms);
      },
    );
  }
}
