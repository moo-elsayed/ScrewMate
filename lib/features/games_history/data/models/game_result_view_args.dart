import 'package:skru_mate/core/database/shared_models/player_model.dart';

class GameResultViewArgs {

  GameResultViewArgs({required this.gameId, required this.allPlayersList});
  final int gameId;
  final List<PlayerModel> allPlayersList;
}
