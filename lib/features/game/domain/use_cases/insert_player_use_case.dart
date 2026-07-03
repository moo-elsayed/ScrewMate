import 'package:dartz/dartz.dart';
import 'package:skru_mate/core/database/shared_entities/player_entity.dart';
import 'package:skru_mate/core/errors/failures.dart';
import '../repos/game_repo.dart';

class InsertPlayerUseCase {
  InsertPlayerUseCase({required this.gameRepo});
  final GameRepo gameRepo;

  Future<Either<Failure, int>> call({required PlayerEntity player}) =>
      gameRepo.insertPlayer(player: player);
}
