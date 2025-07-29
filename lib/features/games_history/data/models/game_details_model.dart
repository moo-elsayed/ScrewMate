import 'package:skru_mate/features/games_history/data/models/round_model.dart';
import 'package:skru_mate/features/games_history/data/models/round_score_model.dart';
import 'game_model.dart';
import 'game_player_model.dart';

class GameDetailsModel {
  final GameModel game;
  final List<GamePlayerModel> players;
  final List<RoundModel> rounds;
  final Map<int, List<RoundScoreModel>> roundScoresByRoundId;

  GameDetailsModel({
    required this.game,
    required this.players,
    required this.rounds,
    required this.roundScoresByRoundId,
  });
}
