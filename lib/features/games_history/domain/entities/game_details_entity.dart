import 'package:skru_mate/core/database/shared_entities/game_entity.dart';
import 'package:skru_mate/core/database/shared_entities/game_player_entity.dart';
import 'package:skru_mate/core/database/shared_entities/round_entity.dart';
import 'package:skru_mate/core/database/shared_entities/round_score_entity.dart';

class GameDetailsEntity {
  const GameDetailsEntity({
    required this.game,
    required this.players,
    required this.rounds,
    required this.roundScoresByRoundId,
  });

  final GameEntity game;
  final List<GamePlayerEntity> players;
  final List<RoundEntity> rounds;
  final Map<int, List<RoundScoreEntity>> roundScoresByRoundId;
}
