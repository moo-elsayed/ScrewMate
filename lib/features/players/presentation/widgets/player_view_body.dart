import 'package:flutter/material.dart';
import '../../../../core/database/shared_models/player_model.dart';

class PlayerViewBody extends StatelessWidget {
  const PlayerViewBody({super.key, required this.playerModel});

  final PlayerModel playerModel;

  @override
  Widget build(BuildContext context) {
    return const Column(children: []);
  }
}
