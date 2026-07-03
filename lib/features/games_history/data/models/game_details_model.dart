import 'package:skru_mate/core/database/shared_models/round_model.dart';
import 'package:skru_mate/core/database/shared_models/round_score_model.dart';
import '../../../../core/database/shared_models/game_model.dart';
import '../../../../core/database/shared_models/game_player_model.dart';
import '../../domain/entities/game_details_entity.dart';

class GameDetailsModel {
  GameDetailsModel({
    required this.game,
    required this.players,
    required this.rounds,
    required this.roundScoresByRoundId,
  });

  factory GameDetailsModel.fromEntity(GameDetailsEntity entity) =>
      GameDetailsModel(
        game: GameModel.fromEntity(entity.game),
        players: entity.players
            .map((e) => GamePlayerModel.fromEntity(e))
            .toList(),
        rounds: entity.rounds
            .map((e) => RoundModel.fromEntity(e))
            .toList(),
        roundScoresByRoundId: entity.roundScoresByRoundId.map(
          (k, v) => MapEntry(k, v.map((e) => RoundScoreModel.fromEntity(e)).toList()),
        ),
      );

  GameDetailsEntity toEntity() => GameDetailsEntity(
        game: game.toEntity(),
        players: players.map((e) => e.toEntity()).toList(),
        rounds: rounds.map((e) => e.toEntity()).toList(),
        roundScoresByRoundId: roundScoresByRoundId.map(
          (k, v) => MapEntry(k, v.map((e) => e.toEntity()).toList()),
        ),
      );

  final GameModel game;
  final List<GamePlayerModel> players;
  final List<RoundModel> rounds;
  final Map<int, List<RoundScoreModel>> roundScoresByRoundId;
}
