import 'package:skru_mate/core/database/shared_models/round_model.dart';
import 'package:skru_mate/core/database/shared_models/round_score_model.dart';
import '../../../../core/database/shared_models/game_model.dart';
import '../../../../core/database/shared_models/game_player_model.dart';

class GameDetailsModel {

  GameDetailsModel({
    required this.game,
    required this.players,
    required this.rounds,
    required this.roundScoresByRoundId,
  });
  final GameModel game;
  final List<GamePlayerModel> players;
  final List<RoundModel> rounds;
  final Map<int, List<RoundScoreModel>> roundScoresByRoundId;
}
