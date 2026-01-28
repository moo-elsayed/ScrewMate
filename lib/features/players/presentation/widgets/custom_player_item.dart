import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skru_mate/core/theming/app_text_styles.dart';
import '../../../../core/database/shared_models/player_model.dart';
import '../../../../core/theming/app_colors.dart';

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
    String trailingText;

    switch (selectedSortIndex) {
      case 0:
        trailingText = '${player.gamesPlayed} games';
      case 1:
        trailingText = '${player.wins} wins';
      case 2:
        trailingText = '${player.roundWins} rounds';
      case 3:
        trailingText = '${(player.winRate).toStringAsFixed(1)}% win rate';
      case 4:
        trailingText = '${player.losses} losses';
      default:
        trailingText = '';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.appbarColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text('#$rank  ${player.name}',style: AppTextStyles.font14WhiteBold)),
            Text(trailingText, style: AppTextStyles.font12White70Medium),
          ],
        ),
      ),
    );
  }
}
