import 'package:skru_mate/core/database/shared_models/player_model.dart';

class GameResultViewArgs {
  final int gameId;
  final List<PlayerModel> allPlayersList;

  GameResultViewArgs({required this.gameId, required this.allPlayersList});
}
