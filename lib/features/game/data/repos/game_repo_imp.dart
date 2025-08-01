import 'package:dartz/dartz.dart';
import 'package:skru_mate/core/database/shared_models/game_model.dart';
import 'package:skru_mate/core/database/shared_models/game_player_model.dart';
import 'package:skru_mate/core/database/shared_models/round_model.dart';
import 'package:skru_mate/core/database/shared_models/round_score_model.dart';
import 'package:skru_mate/core/errors/failures.dart';
import 'package:skru_mate/features/game/data/data_sources/game_local_data_source.dart';
import 'package:skru_mate/features/game/domain/repos/game_repo.dart';

class GameRepoImp implements GameRepo {
  final GameLocalDataSource gameLocalDataSource;

  GameRepoImp({required this.gameLocalDataSource});

  @override
  Future<Either<Failure, int>> insertGame({required GameModel game}) async {
    try {
      final gameId = await gameLocalDataSource.insertGame(game: game);
      return Right(gameId);
    } catch (e) {
      return Left(DatabaseFailure(errorMessage: 'Failed to insert game'));
    }
  }

  @override
  Future<Either<Failure, void>> insertGamePlayers({
    required List<GamePlayerModel> players,
  }) async {
    try {
      await gameLocalDataSource.insertGamePlayers(players: players);
      return const Right(null);
    } catch (e) {
      return Left(
        DatabaseFailure(errorMessage: 'Failed to insert game players'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> insertRounds({
    required List<RoundModel> rounds,
  }) async {
    try {
      await gameLocalDataSource.insertRounds(rounds: rounds);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(errorMessage: 'Failed to insert rounds'));
    }
  }

  @override
  Future<Either<Failure, void>> insertRoundScores({
    required List<RoundScoreModel> scores,
  }) async {
    try {
      await gameLocalDataSource.insertRoundScores(scores: scores);
      return const Right(null);
    } catch (e) {
      return Left(
        DatabaseFailure(errorMessage: 'Failed to insert round scores'),
      );
    }
  }
}
