import 'package:flutter/material.dart';
import 'package:skru_mate/core/widgets/custom_app_bar.dart';
import 'package:skru_mate/features/players/presentation/widgets/top_players_view_body.dart';

class TopPlayersView extends StatelessWidget {
  const TopPlayersView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: CustomAppBar(text: 'Top Players',), body: TopPlayersViewBody());
  }
}
