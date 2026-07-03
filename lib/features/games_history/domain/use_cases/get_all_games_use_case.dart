import 'package:dartz/dartz.dart';
import 'package:skru_mate/core/database/shared_entities/game_entity.dart';
import 'package:skru_mate/core/errors/failures.dart';
import '../repos/games_history_repo.dart';

class GetAllGamesUseCase {
  GetAllGamesUseCase({required this.gamesHistoryRepo});
  final GamesHistoryRepo gamesHistoryRepo;

  Future<Either<Failure, List<GameEntity>>> call() =>
      gamesHistoryRepo.getAllGames();
}
