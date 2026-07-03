import 'package:dartz/dartz.dart';
import 'package:skru_mate/core/errors/failures.dart';
import '../entities/game_details_entity.dart';
import '../repos/games_history_repo.dart';

class GetGameDetailsUseCase {
  GetGameDetailsUseCase({required this.gamesHistoryRepo});
  final GamesHistoryRepo gamesHistoryRepo;

  Future<Either<Failure, GameDetailsEntity>> call({required int gameId}) =>
      gamesHistoryRepo.getGameDetails(gameId: gameId);
}
