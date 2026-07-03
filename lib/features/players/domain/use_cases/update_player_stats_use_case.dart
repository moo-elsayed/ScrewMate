import 'package:dartz/dartz.dart';
import 'package:skru_mate/core/database/shared_entities/player_entity.dart';
import 'package:skru_mate/core/errors/failures.dart';
import '../repos/players_repo.dart';

class UpdatePlayerStatsUseCase {
  UpdatePlayerStatsUseCase({required this.playersRepo});
  final PlayersRepo playersRepo;

  Future<Either<Failure, void>> call({required PlayerEntity player}) =>
      playersRepo.updatePlayerStats(player: player);
}
