import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';
import '../../../../core/database/shared_models/player_model.dart';

class CustomPlayerItem extends StatelessWidget {
  const CustomPlayerItem({
    super.key,
    required this.player,
    required this.index,
    required this.selectedSortIndex,
    required this.marginToBottom,
    required this.rank,
    this.onTap,
  });

  final PlayerModel player;
  final int index;
  final int selectedSortIndex;
  final bool marginToBottom;
  final int rank;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    String trailingText = '';
    final bool isWinRate = selectedSortIndex == 3;

    switch (selectedSortIndex) {
      case 0:
        trailingText = '${player.gamesPlayed} games';
      case 1:
        trailingText = '${player.wins} wins';
      case 2:
        trailingText = '${player.roundWins} rounds';
      case 3:
        trailingText = '${(player.winRate).toStringAsFixed(1)}%';
      case 4:
        trailingText = '${player.losses} losses';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
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
            // Rank Number
            SizedBox(
              width: 32.w,
              child: Text(
                '#$rank',
                style: GoogleFonts.lato(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                  color: rank == 1
                      ? colors.gold
                      : rank == 2
                      ? colors.silver
                      : rank == 3
                      ? colors.bronze
                      : colors.subText,
                ),
              ),
            ),
            // Player Name
            Expanded(
              child: Text(
                player.name,
                style: GoogleFonts.lato(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.mainText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 12.w),
            isWinRate
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 38.r,
                        height: 38.r,
                        child: CircularProgressIndicator(
                          value: player.winRate / 100,
                          strokeWidth: 3.5.w,
                          backgroundColor: colors.border.withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colors.primary,
                          ),
                        ),
                      ),
                      Text(
                        trailingText,
                        style: GoogleFonts.lato(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w900,
                          color: colors.mainText,
                        ),
                      ),
                    ],
                  )
                : Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surfaceHighest,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: colors.border.withValues(alpha: 0.4),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      trailingText,
                      style: GoogleFonts.lato(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: colors.mainText,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
