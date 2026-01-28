import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../players/domain/repos/players_repo.dart';
import '../../../../domain/repos/games_history_repo.dart';
import 'games_history_states.dart';

class GamesHistoryCubit extends Cubit<GamesHistoryStates> {
  GamesHistoryCubit({required this.gamesHistoryRepo, required this.playersRepo})
    : super(GamesHistoryInitial());

  final GamesHistoryRepo gamesHistoryRepo;
  final PlayersRepo playersRepo;

  Future<void> getAllGames() async {
    emit(GetAllGamesLoading());
    final result = await gamesHistoryRepo.getAllGames();
    result.fold(
      (failure) => emit(GetAllGamesFailure(errorMessage: failure.errorMessage)),
      (games) => emit(GetAllGamesSuccess(games: games)),
    );
  }

  Future<void> getGameDetails({required int gameId}) async {
    emit(GetGameDetailsLoading());
    final result = await gamesHistoryRepo.getGameDetails(gameId: gameId);
    result.fold(
      (failure) =>
          emit(GetGameDetailsFailure(errorMessage: failure.errorMessage)),
      (details) => emit(GetGameDetailsSuccess(gameDetails: details)),
    );
  }

  Future<void> deleteGame({required int gameId}) async =>
      await gamesHistoryRepo.deleteGame(gameId: gameId);

  reverseList() {
    emit(ReverseListSuccess());
  }

  /// from players feature
  Future getAllPlayers() async {
    emit(GetAllPlayersLoading());
    final result = await playersRepo.getAllPlayers();
    result.fold(
      (failure) =>
          emit(GetAllPlayersFailure(errorMessage: failure.errorMessage)),
      (players) => emit(GetAllPlayersSuccess(players: players)),
    );
  }
}
