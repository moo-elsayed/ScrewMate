import 'package:skru_mate/core/database/shared_entities/player_entity.dart';

class GameResultViewArgs {
  GameResultViewArgs({
    required this.gameId,
    required this.allPlayersList,
    this.fromHistory = true,
  });

  final int gameId;
  final bool fromHistory;
  final List<PlayerEntity> allPlayersList;
}
