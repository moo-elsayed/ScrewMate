import '../models/game_details_model.dart';
import '../../../../core/database/shared_models/game_model.dart';

abstract class GamesHistoryLocalDataSource {
  Future<List<GameModel>> getAllGames();

  Future<GameDetailsModel?> getGameDetails({required int gameId});

  Future<void> deleteGame({required int gameId});
}
