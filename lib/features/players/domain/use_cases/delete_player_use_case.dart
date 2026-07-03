import 'package:dartz/dartz.dart';
import 'package:skru_mate/core/errors/failures.dart';
import '../repos/players_repo.dart';

class DeletePlayerUseCase {
  DeletePlayerUseCase({required this.playersRepo});
  final PlayersRepo playersRepo;

  Future<Either<Failure, void>> call({required int id}) =>
      playersRepo.deletePlayer(id: id);
}
