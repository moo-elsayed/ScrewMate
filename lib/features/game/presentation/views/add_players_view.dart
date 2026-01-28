import 'package:flutter/material.dart';
import '../widgets/add_players_view_body.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class AddPlayersView extends StatelessWidget {
  const AddPlayersView({
    super.key,
    required this.playersCount,
    required this.roundsCount,
  });

  final int playersCount;
  final int roundsCount;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: const CustomAppBar(),
      body: AddPlayersViewBody(
        playersCount: playersCount,
        roundsCount: roundsCount,
      ),
    );
}
