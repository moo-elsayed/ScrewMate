import 'package:skru_mate/core/database/shared_models/player_model.dart';

class GameArgs {
  GameArgs({required this.players, required this.roundsCount});

  final List<PlayerModel> players;
  final int roundsCount;
}
