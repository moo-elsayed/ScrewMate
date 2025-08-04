import '../../../../core/database/shared_models/game_model.dart';
import '../../../../core/database/shared_models/game_player_model.dart';
import '../../../../core/database/shared_models/player_model.dart';
import '../../../../core/database/shared_models/round_model.dart';
import '../../../../core/database/shared_models/round_score_model.dart';

abstract class GameLocalDataSource {
  Future<int> insertGame({required GameModel game});

  Future<int> insertPlayer({required PlayerModel player});

  Future<void> insertGamePlayers({required List<GamePlayerModel> players});

  Future<void> insertRounds({required List<RoundModel> rounds});

  Future<void> insertRoundScores({required List<RoundScoreModel> scores});
}
