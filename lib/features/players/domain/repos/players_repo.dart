import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/database/shared_models/player_model.dart';
import '../../data/models/player_games_states_model.dart';

abstract class PlayersRepo {

  Future<Either<Failure, List<PlayerModel>>> getAllPlayers();

  Future<Either<Failure, void>> updatePlayerStats({required PlayerModel player});

  Future<Either<Failure, PlayerModel?>> getPlayerById({required int id});

  Future<Either<Failure, void>> deletePlayer({required int id});

  Future<Either<Failure, List<PlayerGameStatsModel>>> getPlayerGameStats(int playerId);

}
