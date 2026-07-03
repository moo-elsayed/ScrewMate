import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';
import 'package:skru_mate/features/players/presentation/widgets/previous_games_for_player_list_view.dart';
import '../../../../core/database/shared_entities/player_entity.dart';
import '../../../../core/widgets/bottom_sheet_handle.dart';
import '../../domain/entities/player_game_stats_entity.dart';

class AllPreviousGamesForPlayerBottomSheet extends StatelessWidget {
  const AllPreviousGamesForPlayerBottomSheet({
    super.key,
    required this.playerGameStatsList,
    required this.players,
  });

  final List<PlayerGameStatsEntity> playerGameStatsList;
  final List<PlayerEntity> players;

  static void show(
    BuildContext context, {
    required List<PlayerGameStatsEntity> playerGameStatsList,
    required List<PlayerEntity> players,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      isScrollControlled: true,
      builder: (_) => AllPreviousGamesForPlayerBottomSheet(
        playerGameStatsList: playerGameStatsList,
        players: players,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 0.h),
      decoration: BoxDecoration(
        color: colors.scaffold,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetHandle(),
          Gap(12.h),
          Text(
            'All Previous Games',
            style: GoogleFonts.lato(
              color: colors.mainText,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(12.h),
          SizedBox(
            height: min(400.h, playerGameStatsList.length * 60.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: PreviousGamesForPlayerListView(
                playerGameStatsList: playerGameStatsList,
                players: players,
                showAll: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
