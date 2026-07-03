import 'package:dartz/dartz.dart';
import 'package:skru_mate/core/errors/failures.dart';
import '../entities/player_game_stats_entity.dart';
import '../repos/players_repo.dart';

class GetPlayerGameStatsUseCase {
  GetPlayerGameStatsUseCase({required this.playersRepo});
  final PlayersRepo playersRepo;

  Future<Either<Failure, List<PlayerGameStatsEntity>>> call({
    required int playerId,
  }) => playersRepo.getPlayerGameStats(playerId);
}
