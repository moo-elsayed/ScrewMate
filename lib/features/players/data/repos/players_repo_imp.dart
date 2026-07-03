import 'package:dartz/dartz.dart';
import 'package:skru_mate/core/database/shared_entities/player_entity.dart';
import 'package:skru_mate/core/database/shared_models/player_model.dart';
import 'package:skru_mate/core/errors/failures.dart';
import 'package:skru_mate/features/players/data/data_sources/players_local_data_source.dart';
import 'package:skru_mate/features/players/domain/entities/player_game_stats_entity.dart';

import '../../domain/repos/players_repo.dart';

class PlayersRepoImp implements PlayersRepo {
  PlayersRepoImp({required this.playerLocalDataSource});
  final PlayerLocalDataSource playerLocalDataSource;

  @override
  Future<Either<Failure, void>> deletePlayer({required int id}) async {
    try {
      await playerLocalDataSource.deletePlayer(id: id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(errorMessage: 'Failed to delete player'));
    }
  }

  @override
  Future<Either<Failure, List<PlayerEntity>>> getAllPlayers() async {
    try {
      final result = await playerLocalDataSource.getAllPlayers();
      return Right(result.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(errorMessage: 'Failed to load players'));
    }
  }

  @override
  Future<Either<Failure, PlayerEntity?>> getPlayerById({required int id}) async {
    try {
      final result = await playerLocalDataSource.getPlayerById(id: id);
      return Right(result?.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(errorMessage: 'Failed to load the player'));
    }
  }

  @override
  Future<Either<Failure, void>> updatePlayerStats({
    required PlayerEntity player,
  }) async {
    try {
      await playerLocalDataSource.updatePlayerStats(
        player: PlayerModel.fromEntity(player),
      );
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(errorMessage: 'Failed to update player'));
    }
  }

  @override
  Future<Either<Failure, List<PlayerGameStatsEntity>>> getPlayerGameStats(
    int playerId,
  ) async {
    try {
      final result = await playerLocalDataSource.getPlayerGameStats(playerId);
      return Right(result.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(
        DatabaseFailure(errorMessage: 'Failed to get player games states'),
      );
    }
  }
}
