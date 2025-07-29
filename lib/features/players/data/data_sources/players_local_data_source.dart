import '../models/player_model.dart';

abstract class PlayerLocalDataSource {
  Future<void> insertPlayer(PlayerModel player);

  Future<List<PlayerModel>> getAllPlayers();

  Future<void> updatePlayerStats(PlayerModel player);

  Future<PlayerModel?> getPlayerById(int id);

  Future<void> deletePlayer(int id);
}
