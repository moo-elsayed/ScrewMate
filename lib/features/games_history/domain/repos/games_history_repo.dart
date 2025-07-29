import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/game_details_model.dart';
import '../../data/models/game_model.dart';

abstract class GamesHistoryRepo {
  Future<Either<Failure, List<GameModel>>> getAllGames();

  Future<Either<Failure, GameDetailsModel>> getGameDetails(int gameId);
}
