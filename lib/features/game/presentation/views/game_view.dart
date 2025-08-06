import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/widgets/confirmation_dialog.dart';
import 'package:skru_mate/core/widgets/custom_app_bar.dart';
import 'package:skru_mate/features/game/data/models/game_args.dart';
import 'package:skru_mate/features/game/presentation/widgets/game_view_body.dart';

class GameView extends StatelessWidget {
  const GameView({super.key, required this.gameArgs});

  final GameArgs gameArgs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: GestureDetector(
          onTap: () {
            showCupertinoDialog(
              context: context,
              builder: (context) => ConfirmationDialog(
                delete: false,
                fullText: 'Are you want to leave the game?',
                textOkButton: 'Yes',
                onDelete: () {
                  context.pop();
                  context.pop();
                },
              ),
            );
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        text: 'Current Game',
      ),
      body: GameViewBody(gameArgs: gameArgs),
    );
  }
}
