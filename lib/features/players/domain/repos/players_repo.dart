import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/player_model.dart';

abstract class PlayersRepo {
  Future<Either<Failure, void>> insertPlayer({required PlayerModel player});

  Future<Either<Failure, List<PlayerModel>>> getAllPlayers();

  Future<Either<Failure, void>> updatePlayerStats({required PlayerModel player});

  Future<Either<Failure, PlayerModel?>> getPlayerById({required int id});

  Future<Either<Failure, void>> deletePlayer({required int id});
}
