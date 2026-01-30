import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skru_mate/features/players/presentation/widgets/previous_games_for_player_list_view.dart';
import '../../../../core/database/shared_models/player_model.dart';
import '../../../../core/widgets/bottom_sheet_handle.dart';
import '../../data/models/player_games_states_model.dart';

class AllPreviousGamesForPlayerBottomSheet extends StatelessWidget {
  const AllPreviousGamesForPlayerBottomSheet({
    super.key,
    required this.playerGameStatsList,
    required this.players,
  });

  final List<PlayerGameStatsModel> playerGameStatsList;
  final List<PlayerModel> players;

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.only(top: 12.h,left: 8.w,right: 8.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetHandle(),
          Text(
            'All Previous Games',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(12.h),
          SizedBox(
            height: min(400.h, playerGameStatsList.length * 60.h),
            child: Scrollbar(
              thumbVisibility: false,
              radius: const Radius.circular(8),
              thickness: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: PreviousGamesForPlayerListView(
                  playerGameStatsList: playerGameStatsList,
                  players: players,
                  showAll: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
}
