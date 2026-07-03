import 'package:dartz/dartz.dart';
import 'package:skru_mate/core/database/shared_entities/game_player_entity.dart';
import 'package:skru_mate/core/errors/failures.dart';
import '../repos/game_repo.dart';

class InsertGamePlayersUseCase {
  InsertGamePlayersUseCase({required this.gameRepo});
  final GameRepo gameRepo;

  Future<Either<Failure, void>> call({
    required List<GamePlayerEntity> players,
  }) => gameRepo.insertGamePlayers(players: players);
}
