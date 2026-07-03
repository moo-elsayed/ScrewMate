import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/shared_entities/game_entity.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/theming/colors_manager.dart';

class CustomPreviousGamesItem extends StatelessWidget {
  const CustomPreviousGamesItem({
    super.key,
    required this.game,
    required this.isFirst,
    required this.isLast,
    this.onTap,
    required this.index,
  });

  final bool isFirst;
  final bool isLast;
  final GameEntity game;
  final void Function()? onTap;
  final int index;

  String _formatDate(String rawDate) {
    final date = DateTime.tryParse(rawDate);
    if (date == null) return rawDate;
    return DateFormat('d MMM, yyyy - h:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(
          bottom: isLast ? 0 : 8.h,
          top: isFirst ? 0 : 8.h,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Game #${game.id}',
                    style: AppTextStyles.font17Bold.copyWith(color: colors.mainText),
                  ),
                  const Gap(4),
                  Text(
                    game.winnerName != null
                        ? game.winnerName!.contains(', ')
                            ? 'Winners: ${game.winnerName}'
                            : 'Winner: ${game.winnerName}'
                        : 'Winner: Deleted player',
                    style: AppTextStyles.font13Regular.copyWith(color: colors.bodyText),
                  ),
                ],
              ),
            ),
            Text(
              _formatDate(game.date),
              style: AppTextStyles.font12Regular.copyWith(color: colors.subText),
            ),
          ],
        ),
      )
          .animate(delay: Duration(milliseconds: 50 * index))
          .slideY(begin: 0.2, duration: 300.ms)
          .fadeIn(duration: 300.ms),
    );
  }
}
