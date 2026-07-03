import 'package:dartz/dartz.dart';
import '../../../../core/database/shared_entities/game_entity.dart';
import '../../../../core/errors/failures.dart';
import '../entities/game_details_entity.dart';

abstract class GamesHistoryRepo {
  Future<Either<Failure, List<GameEntity>>> getAllGames();

  Future<Either<Failure, GameDetailsEntity>> getGameDetails({
    required int gameId,
  });

  Future<Either<Failure, void>> deleteGame({required int gameId});
}
