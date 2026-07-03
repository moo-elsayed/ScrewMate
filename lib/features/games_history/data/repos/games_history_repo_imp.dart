import 'package:dartz/dartz.dart';
import 'package:skru_mate/core/database/shared_entities/game_entity.dart';
import 'package:skru_mate/features/games_history/domain/entities/game_details_entity.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/repos/games_history_repo.dart';
import '../data_sources/games_history_local_data_source.dart';

class GamesHistoryRepoImp implements GamesHistoryRepo {
  GamesHistoryRepoImp({required this.gamesLocalDataSource});
  final GamesHistoryLocalDataSource gamesLocalDataSource;

  @override
  Future<Either<Failure, List<GameEntity>>> getAllGames() async {
    try {
      final games = await gamesLocalDataSource.getAllGames();
      return Right(games.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(
        DatabaseFailure(errorMessage: 'Failed to load previous games'),
      );
    }
  }

  @override
  Future<Either<Failure, GameDetailsEntity>> getGameDetails({
    required int gameId,
  }) async {
    try {
      final details = await gamesLocalDataSource.getGameDetails(gameId: gameId);
      if (details != null) {
        return Right(details.toEntity());
      } else {
        return Left(DatabaseFailure(errorMessage: 'Game not found'));
      }
    } catch (e) {
      return Left(
        DatabaseFailure(errorMessage: 'Failed to return game details'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteGame({required int gameId}) async {
    try {
      await gamesLocalDataSource.deleteGame(gameId: gameId);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(errorMessage: 'Failed to delete game'));
    }
  }
}
