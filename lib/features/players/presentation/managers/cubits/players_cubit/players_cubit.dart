import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skru_mate/core/database/shared_entities/player_entity.dart';
import 'package:skru_mate/features/players/domain/use_cases/delete_player_use_case.dart';
import 'package:skru_mate/features/players/domain/use_cases/get_all_players_use_case.dart';
import 'package:skru_mate/features/players/domain/use_cases/get_player_by_id_use_case.dart';
import 'package:skru_mate/features/players/domain/use_cases/get_player_game_stats_use_case.dart';
import 'package:skru_mate/features/players/domain/use_cases/update_player_stats_use_case.dart';
import 'package:skru_mate/features/players/presentation/managers/cubits/players_cubit/players_states.dart';

class PlayersCubit extends Cubit<PlayersStates> {
  PlayersCubit({
    required this.getAllPlayersUseCase,
    required this.updatePlayerStatsUseCase,
    required this.getPlayerByIdUseCase,
    required this.deletePlayerUseCase,
    required this.getPlayerGameStatsUseCase,
  }) : super(StripeInitial());

  final GetAllPlayersUseCase getAllPlayersUseCase;
  final UpdatePlayerStatsUseCase updatePlayerStatsUseCase;
  final GetPlayerByIdUseCase getPlayerByIdUseCase;
  final DeletePlayerUseCase deletePlayerUseCase;
  final GetPlayerGameStatsUseCase getPlayerGameStatsUseCase;

  List<PlayerEntity> allPlayers = [];

  Future getAllPlayers() async {
    emit(GetAllPlayersLoading());
    final result = await getAllPlayersUseCase();
    result.fold(
      (failure) =>
          emit(GetAllPlayersFailure(errorMessage: failure.errorMessage)),
      (players) {
        allPlayers = players;
        emit(GetAllPlayersSuccess(players: players));
      },
    );
  }

  Future updatePlayerStats({required PlayerEntity player}) async {
    emit(UpdatePlayerStatsLoading());
    final result = await updatePlayerStatsUseCase(player: player);
    result.fold(
      (failure) =>
          emit(UpdatePlayerStatsFailure(errorMessage: failure.errorMessage)),
      (_) => emit(UpdatePlayerStatsSuccess()),
    );
  }

  Future getPlayerById({required int id}) async {
    emit(GetPlayerByIdLoading());
    final result = await getPlayerByIdUseCase(id: id);
    result.fold(
      (failure) =>
          emit(GetPlayerByIdFailure(errorMessage: failure.errorMessage)),
      (player) => emit(GetPlayerByIdSuccess(player: player!)),
    );
  }

  Future deletePlayer({required int id}) async {
    final result = await deletePlayerUseCase(id: id);
    result.fold(
      (failure) =>
          emit(DeletePlayerFailure(errorMessage: failure.errorMessage)),
      (_) => emit(DeletePlayerSuccess()),
    );
  }

  Future getPlayerGameStats(int playerId) async {
    emit(GetPlayerGamesStatesLoading());
    final result = await getPlayerGameStatsUseCase(playerId: playerId);
    result.fold(
      (failure) =>
          emit(GetPlayerGamesStatesFailure(errorMessage: failure.errorMessage)),
      (playerGameStatsList) => emit(
        GetPlayerGamesStatesSuccess(playerGameStatsList: playerGameStatsList),
      ),
    );
  }

  void reverseList() {
    emit(ReverseListSuccess());
  }
}
