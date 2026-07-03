import 'package:dartz/dartz.dart';
import 'package:skru_mate/core/errors/failures.dart';
import '../repos/games_history_repo.dart';

class DeleteGameUseCase {
  DeleteGameUseCase({required this.gamesHistoryRepo});
  final GamesHistoryRepo gamesHistoryRepo;

  Future<Either<Failure, void>> call({required int gameId}) =>
      gamesHistoryRepo.deleteGame(gameId: gameId);
}
