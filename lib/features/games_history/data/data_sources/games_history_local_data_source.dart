import '../models/game_details_model.dart';
import '../models/game_model.dart';

abstract class GamesHistoryLocalDataSource {
  Future<List<GameModel>> getAllGames();

  Future<GameDetailsModel?> getGameDetails(int gameId);
}
