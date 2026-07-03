import 'package:dartz/dartz.dart';
import 'package:skru_mate/core/database/shared_entities/game_entity.dart';
import 'package:skru_mate/core/database/shared_entities/game_player_entity.dart';
import 'package:skru_mate/core/database/shared_entities/player_entity.dart';
import 'package:skru_mate/core/database/shared_entities/round_entity.dart';
import 'package:skru_mate/core/database/shared_entities/round_score_entity.dart';
import 'package:skru_mate/core/database/shared_models/game_model.dart';
import 'package:skru_mate/core/database/shared_models/game_player_model.dart';
import 'package:skru_mate/core/database/shared_models/player_model.dart';
import 'package:skru_mate/core/database/shared_models/round_model.dart';
import 'package:skru_mate/core/database/shared_models/round_score_model.dart';
import 'package:skru_mate/core/errors/failures.dart';
import 'package:skru_mate/features/game/data/data_sources/game_local_data_source.dart';
import 'package:skru_mate/features/game/domain/repos/game_repo.dart';

class GameRepoImp implements GameRepo {
  GameRepoImp({required this.gameLocalDataSource});
  final GameLocalDataSource gameLocalDataSource;

  @override
  Future<Either<Failure, int>> insertGame({required GameEntity game}) async {
    try {
      final gameId = await gameLocalDataSource.insertGame(
        game: GameModel.fromEntity(game),
      );
      return Right(gameId);
    } catch (e) {
      return Left(DatabaseFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> insertPlayer({
    required PlayerEntity player,
  }) async {
    try {
      final playerId = await gameLocalDataSource.insertPlayer(
        player: PlayerModel.fromEntity(player),
      );
      return Right(playerId);
    } catch (e) {
      return Left(DatabaseFailure(errorMessage: 'Failed to add player'));
    }
  }

  @override
  Future<Either<Failure, void>> insertGamePlayers({
    required List<GamePlayerEntity> players,
  }) async {
    try {
      await gameLocalDataSource.insertGamePlayers(
        players: players.map((e) => GamePlayerModel.fromEntity(e)).toList(),
      );
      return const Right(null);
    } catch (e) {
      return Left(
        DatabaseFailure(errorMessage: 'Failed to insert game players'),
      );
    }
  }

  @override
  Future<Either<Failure, List<int>>> insertRounds({
    required List<RoundEntity> rounds,
  }) async {
    try {
      final List<int> roundsIds = await gameLocalDataSource.insertRounds(
        rounds: rounds.map((e) => RoundModel.fromEntity(e)).toList(),
      );
      return Right(roundsIds);
    } catch (e) {
      return Left(DatabaseFailure(errorMessage: 'Failed to insert rounds'));
    }
  }

  @override
  Future<Either<Failure, void>> insertRoundScores({
    required List<RoundScoreEntity> scores,
  }) async {
    try {
      await gameLocalDataSource.insertRoundScores(
        scores: scores.map((e) => RoundScoreModel.fromEntity(e)).toList(),
      );
      return const Right(null);
    } catch (e) {
      return Left(
        DatabaseFailure(errorMessage: 'Failed to insert round scores'),
      );
    }
  }
}
