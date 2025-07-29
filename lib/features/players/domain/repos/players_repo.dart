import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/player_model.dart';

abstract class PlayersRepo {
  Future<Either<Failure, void>> insertPlayer(PlayerModel player);

  Future<Either<Failure, List<PlayerModel>>> getAllPlayers();

  Future<Either<Failure, void>> updatePlayerStats(PlayerModel player);

  Future<Either<Failure, PlayerModel?>> getPlayerById(int id);

  Future<Either<Failure, void>> deletePlayer(int id);
}
