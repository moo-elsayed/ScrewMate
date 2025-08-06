import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/database/shared_models/game_model.dart';
import '../../../../core/theming/styles.dart';
import 'package:intl/intl.dart';

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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:
          ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Game #${game.id}'),
                titleTextStyle: TextStyles.font17WhiteBold,
                subtitle: game.winnerName != null
                    ? Text('Winner: ${game.winnerName}')
                    : const Text('Winner: deleted player'),
                subtitleTextStyle: TextStyles.font13White70Regular,
                trailing: Text(
                  _formatDate(game.date),
                  style: TextStyles.font12White54Regular,
                ),
              )
              .animate(delay: Duration(milliseconds: 50 * index))
              .slideY(begin: 0.2, duration: 300.ms)
              .fadeIn(duration: 300.ms),
    );
  }

  String _formatDate(String rawDate) {
    final date = DateTime.tryParse(rawDate);
    if (date == null) return rawDate; // fallback

    return DateFormat('d MMM, yyyy - h:mm a').format(date);
  }
}
