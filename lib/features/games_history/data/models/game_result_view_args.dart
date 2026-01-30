import 'package:skru_mate/core/database/shared_models/player_model.dart';

class GameResultViewArgs {
  GameResultViewArgs({
    required this.gameId,
    required this.allPlayersList,
    this.fromHistory = true,
  });

  final int gameId;
  final bool fromHistory;
  final List<PlayerModel> allPlayersList;
}
