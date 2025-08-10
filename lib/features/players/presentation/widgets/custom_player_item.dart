import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skru_mate/core/theming/styles.dart';
import '../../../../core/database/shared_models/player_model.dart';
import '../../../../core/theming/colors.dart';

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
        break;
      case 1:
        trailingText = '${player.wins} wins';
        break;
      case 2:
        trailingText = '${player.roundWins} rounds';
        break;
      case 3:
        trailingText = '${(player.winRate).toStringAsFixed(1)}% win rate';
        break;
      case 4:
        trailingText = '${player.losses} losses';
        break;
      default:
        trailingText = '';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          top: index != 1 ? 12.h : 0.h,
          right: 12.w,
          left: 12.w,
          bottom: marginToBottom ? 12.h : 0.h,
        ),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: ColorsManager.appbarColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text('#$rank  ${player.name}',style: TextStyles.font14WhiteBold)),
            Text(trailingText, style: TextStyles.font12White70Medium),
          ],
        ),
      ),
    );
  }
}
