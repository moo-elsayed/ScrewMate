import 'package:skru_mate/core/database/shared_entities/player_entity.dart';

class GameArgs {
  GameArgs({required this.players, required this.roundsCount});

  final List<PlayerEntity> players;
  final int roundsCount;
}
