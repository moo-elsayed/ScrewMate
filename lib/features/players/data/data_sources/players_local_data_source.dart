import '../../../../core/database/shared_models/player_model.dart';
import '../models/player_games_states_model.dart';

abstract class PlayerLocalDataSource {
  Future<void> insertPlayer({required PlayerModel player});

  Future<List<PlayerModel>> getAllPlayers();

  Future<void> updatePlayerStats({required PlayerModel player});

  Future<PlayerModel?> getPlayerById({required int id});

  Future<void> deletePlayer({required int id});

  Future<List<PlayerGameStatsModel>> getPlayerGameStats(int playerId);
}
