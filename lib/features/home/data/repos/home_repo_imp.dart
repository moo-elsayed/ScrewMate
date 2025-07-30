import 'package:dartz/dartz.dart';
import 'package:skru_mate/core/database/shared_models/game_model.dart';
import 'package:skru_mate/core/database/shared_models/game_player_model.dart';
import 'package:skru_mate/core/database/shared_models/round_model.dart';
import 'package:skru_mate/core/database/shared_models/round_score_model.dart';
import 'package:skru_mate/core/errors/failures.dart';
import 'package:skru_mate/features/home/data/data_sources/home_local_data_source.dart';
import 'package:skru_mate/features/home/domain/repos/home_repo.dart';

class HomeRepoImp implements HomeRepo {
  final HomeLocalDataSource homeLocalDataSource;

  HomeRepoImp({required this.homeLocalDataSource});

  @override
  Future<Either<Failure, int>> insertGame({required GameModel game}) async {
    try {
      final gameId = await homeLocalDataSource.insertGame(game: game);
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
      await homeLocalDataSource.insertGamePlayers(players: players);
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
      await homeLocalDataSource.insertRounds(rounds: rounds);
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
      await homeLocalDataSource.insertRoundScores(scores: scores);
      return const Right(null);
    } catch (e) {
      return Left(
        DatabaseFailure(errorMessage: 'Failed to insert round scores'),
      );
    }
  }
}
