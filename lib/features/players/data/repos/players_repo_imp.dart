import 'package:dartz/dartz.dart';
import 'package:skru_mate/core/errors/failures.dart';
import 'package:skru_mate/features/players/data/data_sources/players_local_data_source.dart';
import 'package:skru_mate/features/players/data/models/player_model.dart';
import '../../domain/repos/players_repo.dart';

class PlayersRepoImp implements PlayersRepo {
  final PlayerLocalDataSource playerLocalDataSource;

  PlayersRepoImp({required this.playerLocalDataSource});

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
  Future<Either<Failure, List<PlayerModel>>> getAllPlayers() async {
    try {
      final result = await playerLocalDataSource.getAllPlayers();
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(errorMessage: 'Failed to load players'));
    }
  }

  @override
  Future<Either<Failure, PlayerModel?>> getPlayerById({required int id}) async {
    try {
      final result = await playerLocalDataSource.getPlayerById(id: id);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(errorMessage: 'Failed to load the player'));
    }
  }

  @override
  Future<Either<Failure, void>> insertPlayer({
    required PlayerModel player,
  }) async {
    try {
      await playerLocalDataSource.insertPlayer(player: player);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(errorMessage: 'Failed to add player'));
    }
  }

  @override
  Future<Either<Failure, void>> updatePlayerStats({
    required PlayerModel player,
  }) async {
    try {
      await playerLocalDataSource.updatePlayerStats(player: player);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(errorMessage: 'Failed to update player'));
    }
  }
}
