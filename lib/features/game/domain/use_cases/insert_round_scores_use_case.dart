import 'package:dartz/dartz.dart';
import 'package:skru_mate/core/database/shared_entities/round_score_entity.dart';
import 'package:skru_mate/core/errors/failures.dart';
import '../repos/game_repo.dart';

class InsertRoundScoresUseCase {
  InsertRoundScoresUseCase({required this.gameRepo});
  final GameRepo gameRepo;

  Future<Either<Failure, void>> call({required List<RoundScoreEntity> scores}) =>
      gameRepo.insertRoundScores(scores: scores);
}
