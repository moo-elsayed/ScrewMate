import 'package:dartz/dartz.dart';
import 'package:skru_mate/core/database/shared_entities/round_entity.dart';
import 'package:skru_mate/core/errors/failures.dart';
import '../repos/game_repo.dart';

class InsertRoundsUseCase {
  InsertRoundsUseCase({required this.gameRepo});
  final GameRepo gameRepo;

  Future<Either<Failure, List<int>>> call({required List<RoundEntity> rounds}) =>
      gameRepo.insertRounds(rounds: rounds);
}
