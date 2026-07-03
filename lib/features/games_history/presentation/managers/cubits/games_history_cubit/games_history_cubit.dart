import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skru_mate/core/database/shared_entities/game_entity.dart';
import 'package:skru_mate/features/games_history/domain/use_cases/delete_game_use_case.dart';
import 'package:skru_mate/features/games_history/domain/use_cases/get_all_games_use_case.dart';
import 'package:skru_mate/features/games_history/domain/use_cases/get_game_details_use_case.dart';
import 'package:skru_mate/features/players/domain/use_cases/get_all_players_use_case.dart';
import 'games_history_states.dart';

class GamesHistoryCubit extends Cubit<GamesHistoryStates> {
  GamesHistoryCubit({
    required this.getAllGamesUseCase,
    required this.getGameDetailsUseCase,
    required this.deleteGameUseCase,
    required this.getAllPlayersUseCase,
  }) : super(GamesHistoryInitial());

  final GetAllGamesUseCase getAllGamesUseCase;
  final GetGameDetailsUseCase getGameDetailsUseCase;
  final DeleteGameUseCase deleteGameUseCase;
  final GetAllPlayersUseCase getAllPlayersUseCase;

  List<GameEntity> allGames = [];

  Future<void> getAllGames() async {
    emit(GetAllGamesLoading());
    final result = await getAllGamesUseCase();
    result.fold(
      (failure) => emit(GetAllGamesFailure(errorMessage: failure.errorMessage)),
      (games) {
        allGames = games;
        emit(GetAllGamesSuccess(games: games));
      },
    );
  }

  Future<void> getGameDetails({required int gameId}) async {
    emit(GetGameDetailsLoading());
    final result = await getGameDetailsUseCase(gameId: gameId);
    result.fold(
      (failure) =>
          emit(GetGameDetailsFailure(errorMessage: failure.errorMessage)),
      (details) => emit(GetGameDetailsSuccess(gameDetails: details)),
    );
  }

  Future<void> deleteGame({required int gameId}) async =>
      await deleteGameUseCase(gameId: gameId);

  void reverseList() {
    emit(ReverseListSuccess());
  }

  /// from players feature
  Future getAllPlayers() async {
    emit(GetAllPlayersLoading());
    final result = await getAllPlayersUseCase();
    result.fold(
      (failure) =>
          emit(GetAllPlayersFailure(errorMessage: failure.errorMessage)),
      (players) => emit(GetAllPlayersSuccess(players: players)),
    );
  }
}
