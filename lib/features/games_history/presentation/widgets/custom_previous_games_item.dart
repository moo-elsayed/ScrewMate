import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/database/shared_models/game_model.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/theming/app_text_styles.dart';

class CustomPreviousGamesItem extends StatelessWidget {
  const CustomPreviousGamesItem({
    super.key,
    required this.game,
    this.onTap,
    required this.index,
  });

  final GameModel game;
  final void Function()? onTap;
  final int index;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child:
          ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Game #${game.id}'),
                titleTextStyle: AppTextStyles.font17WhiteBold,
                subtitle: game.winnerName != null
                    ? game.winnerName!.contains(', ')
                          ? Text('Winners: ${game.winnerName}')
                          : Text('Winner: ${game.winnerName}')
                    : const Text('Winner: Deleted player'),
                subtitleTextStyle: AppTextStyles.font13White70Regular,
                trailing: Text(
                  formatDate(game.date),
                  style: AppTextStyles.font12White54Regular,
                ),
              )
              .animate(delay: Duration(milliseconds: 50 * index))
              .slideY(begin: 0.2, duration: 300.ms)
              .fadeIn(duration: 300.ms),
    );
}
