import 'package:dartz/dartz.dart';
import 'package:skru_mate/core/database/shared_entities/player_entity.dart';
import 'package:skru_mate/core/errors/failures.dart';
import '../repos/players_repo.dart';

class GetAllPlayersUseCase {
  GetAllPlayersUseCase({required this.playersRepo});
  final PlayersRepo playersRepo;

  Future<Either<Failure, List<PlayerEntity>>> call() =>
      playersRepo.getAllPlayers();
}
