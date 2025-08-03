import 'package:flutter/material.dart';
import 'package:skru_mate/core/widgets/custom_app_bar.dart';
import 'package:skru_mate/features/games_history/presentation/widgets/previous_games_view_body.dart';

class PreviousGamesView extends StatelessWidget {
  const PreviousGamesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(text: 'Previous Games'),
      body: PreviousGamesViewBody(),
    );
  }
}
