import 'package:dartz/dartz.dart';
import 'package:skru_mate/core/errors/failures.dart';
import '../../../../core/database/shared_entities/game_entity.dart';
import '../../../../core/database/shared_entities/game_player_entity.dart';
import '../../../../core/database/shared_entities/player_entity.dart';
import '../../../../core/database/shared_entities/round_entity.dart';
import '../../../../core/database/shared_entities/round_score_entity.dart';

abstract class GameRepo {
  Future<Either<Failure, int>> insertGame({required GameEntity game});

  Future<Either<Failure, int>> insertPlayer({required PlayerEntity player});

  Future<Either<Failure, void>> insertGamePlayers({
    required List<GamePlayerEntity> players,
  });

  Future<Either<Failure, List<int>>> insertRounds({
    required List<RoundEntity> rounds,
  });

  Future<Either<Failure, void>> insertRoundScores({
    required List<RoundScoreEntity> scores,
  });
}
