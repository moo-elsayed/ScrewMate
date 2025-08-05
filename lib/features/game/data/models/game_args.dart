import 'package:flutter/material.dart';
import 'package:skru_mate/core/database/shared_models/player_model.dart';

class GameArgs {
  final List<PlayerModel> players;
  final int roundsCount;
  final GlobalKey<ScaffoldState> scaffoldKey;

  GameArgs({
    required this.players,
    required this.roundsCount,
    required this.scaffoldKey,
  });
}
