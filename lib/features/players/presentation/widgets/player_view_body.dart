import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skru_mate/features/players/presentation/widgets/player_stats_grid_view.dart';
import '../../data/models/player_details_args.dart';

class PlayerViewBody extends StatelessWidget {
  const PlayerViewBody({super.key, required this.playerDetailsArgs});

  final PlayerDetailsArgs playerDetailsArgs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, right: 12.w, left: 12.w),
      child: Column(
        children: [PlayerStatsGridView(playerDetailsArgs: playerDetailsArgs)],
      ),
    );
  }
}
