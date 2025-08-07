import 'package:flutter/material.dart';
import 'package:skru_mate/features/games_history/presentation/widgets/game_result_view_body.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../data/models/game_result_view_args.dart';

class GameResultView extends StatelessWidget {
  const GameResultView({super.key, required this.gameResultViewArgs});

  final GameResultViewArgs gameResultViewArgs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: 'Game #${gameResultViewArgs.gameId}'),
      body: GameResultViewBody(gameResultViewArgs: gameResultViewArgs),
    );
  }
}
