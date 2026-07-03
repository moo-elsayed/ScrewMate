import 'package:dartz/dartz.dart';
import 'package:skru_mate/core/database/shared_entities/game_entity.dart';
import 'package:skru_mate/core/errors/failures.dart';
import '../repos/game_repo.dart';

class InsertGameUseCase {
  InsertGameUseCase({required this.gameRepo});
  final GameRepo gameRepo;

  Future<Either<Failure, int>> call({required GameEntity game}) =>
      gameRepo.insertGame(game: game);
}
