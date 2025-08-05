import 'package:flutter/material.dart';
import 'package:skru_mate/core/widgets/custom_app_bar.dart';
import 'package:skru_mate/features/game/data/models/game_args.dart';
import 'package:skru_mate/features/game/presentation/widgets/game_view_body.dart';

class GameView extends StatelessWidget {
  const GameView({super.key, required this.gameArgs});

  final GameArgs gameArgs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: GameViewBody(gameArgs: gameArgs),
    );
  }
}
