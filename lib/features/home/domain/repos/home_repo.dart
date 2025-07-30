import 'package:dartz/dartz.dart';
import 'package:skru_mate/core/errors/failures.dart';

import '../../../../core/database/shared_models/game_model.dart';
import '../../../../core/database/shared_models/game_player_model.dart';
import '../../../../core/database/shared_models/round_model.dart';
import '../../../../core/database/shared_models/round_score_model.dart';

abstract class HomeRepo {
  Future<Either<Failure, int>> insertGame({required GameModel game});

  Future<Either<Failure, void>> insertGamePlayers({
    required List<GamePlayerModel> players,
  });

  Future<Either<Failure, void>> insertRounds({
    required List<RoundModel> rounds,
  });

  Future<Either<Failure, void>> insertRoundScores({
    required List<RoundScoreModel> scores,
  });
}
