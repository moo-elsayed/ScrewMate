import 'package:dartz/dartz.dart';
import 'package:skru_mate/core/database/shared_entities/player_entity.dart';
import 'package:skru_mate/core/errors/failures.dart';
import '../repos/players_repo.dart';

class GetPlayerByIdUseCase {
  GetPlayerByIdUseCase({required this.playersRepo});
  final PlayersRepo playersRepo;

  Future<Either<Failure, PlayerEntity?>> call({required int id}) =>
      playersRepo.getPlayerById(id: id);
}
