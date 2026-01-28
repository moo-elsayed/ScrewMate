import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skru_mate/features/players/domain/repos/players_repo.dart';
import 'package:skru_mate/features/players/presentation/managers/cubits/players_cubit/players_states.dart';
import '../../../../../../core/database/shared_models/player_model.dart';

class PlayersCubit extends Cubit<PlayersStates> {
  PlayersCubit({required this.playersRepo}) : super(StripeInitial());
  final PlayersRepo playersRepo;

  Future getAllPlayers() async {
    emit(GetAllPlayersLoading());
    final result = await playersRepo.getAllPlayers();
    result.fold(
      (failure) =>
          emit(GetAllPlayersFailure(errorMessage: failure.errorMessage)),
      (players) => emit(GetAllPlayersSuccess(players: players)),
    );
  }

  Future updatePlayerStats({required PlayerModel player}) async {
    emit(UpdatePlayerStatsLoading());
    final result = await playersRepo.updatePlayerStats(player: player);
    result.fold(
      (failure) =>
          emit(UpdatePlayerStatsFailure(errorMessage: failure.errorMessage)),
      (_) => emit(UpdatePlayerStatsSuccess()),
    );
  }

  Future getPlayerById({required int id}) async {
    emit(GetPlayerByIdLoading());
    final result = await playersRepo.getPlayerById(id: id);
    result.fold(
      (failure) =>
          emit(GetPlayerByIdFailure(errorMessage: failure.errorMessage)),
      (player) => emit(GetPlayerByIdSuccess(player: player!)),
    );
  }

  Future deletePlayer({required int id}) async {
    final result = await playersRepo.deletePlayer(id: id);
    result.fold(
      (failure) =>
          emit(DeletePlayerFailure(errorMessage: failure.errorMessage)),
      (_) => emit(DeletePlayerSuccess()),
    );
  }

  Future getPlayerGameStats(int playerId) async {
    emit(GetPlayerGamesStatesLoading());
    final result = await playersRepo.getPlayerGameStats(playerId);
    result.fold(
      (failure) =>
          emit(GetPlayerGamesStatesFailure(errorMessage: failure.errorMessage)),
      (playerGameStatsList) => emit(
        GetPlayerGamesStatesSuccess(playerGameStatsList: playerGameStatsList),
      ),
    );
  }

  reverseList() {
    emit(ReverseListSuccess());
  }
}
