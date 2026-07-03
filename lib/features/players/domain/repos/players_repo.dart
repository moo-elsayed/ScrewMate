import 'package:dartz/dartz.dart';
import '../../../../core/database/shared_entities/player_entity.dart';
import '../../../../core/errors/failures.dart';
import '../entities/player_game_stats_entity.dart';

abstract class PlayersRepo {
  Future<Either<Failure, List<PlayerEntity>>> getAllPlayers();

  Future<Either<Failure, void>> updatePlayerStats({required PlayerEntity player});

  Future<Either<Failure, PlayerEntity?>> getPlayerById({required int id});

  Future<Either<Failure, void>> deletePlayer({required int id});

  Future<Either<Failure, List<PlayerGameStatsEntity>>> getPlayerGameStats(int playerId);
}
