import 'package:dartz/dartz.dart';
import 'package:skru_mate/features/games_history/data/models/game_details_model.dart';
import 'package:skru_mate/core/database/shared_models/game_model.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repos/games_history_repo.dart';
import '../data_sources/games_history_local_data_source.dart';

class GamesHistoryRepoImp implements GamesHistoryRepo {
  final GamesHistoryLocalDataSource gamesLocalDataSource;

  GamesHistoryRepoImp({required this.gamesLocalDataSource});

  @override
  Future<Either<Failure, List<GameModel>>> getAllGames() async {
    try {
      final games = await gamesLocalDataSource.getAllGames();
      return Right(games);
    } catch (e) {
      return Left(
        DatabaseFailure(errorMessage: 'Failed to load previous games'),
      );
    }
  }

  @override
  Future<Either<Failure, GameDetailsModel>> getGameDetails({
    required int gameId,
  }) async {
    try {
      final details = await gamesLocalDataSource.getGameDetails(gameId: gameId);
      if (details != null) {
        return Right(details);
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
