import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skru_mate/core/database/shared_models/game_model.dart';
import 'package:skru_mate/core/database/shared_models/game_player_model.dart';
import 'package:skru_mate/core/database/shared_models/round_model.dart';
import 'package:skru_mate/core/database/shared_models/round_score_model.dart';
import 'package:skru_mate/features/players/domain/repos/players_repo.dart';
import '../../../../../../core/database/shared_models/player_model.dart';
import '../../../../domain/repos/game_repo.dart';
import 'game_states.dart';

class GameCubit extends Cubit<GameStates> {
  GameCubit({required this.playersRepo, required this.gameRepo})
    : super(GameInitial());

  final GameRepo gameRepo;
  final PlayersRepo playersRepo;

  Future insertGame({required GameModel game}) async {
    emit(InsertGameLoading());
    final result = await gameRepo.insertGame(game: game);
    result.fold(
      (failure) => emit(InsertGameFailure(errorMessage: failure.errorMessage)),
      (gameId) => emit(InsertGameSuccess(gameId: gameId)),
    );
  }

  Future insertGamePlayers({required List<GamePlayerModel> players}) async {
    emit(InsertGamePlayersLoading());
    final result = await gameRepo.insertGamePlayers(players: players);
    result.fold(
      (failure) =>
          emit(InsertGamePlayersFailure(errorMessage: failure.errorMessage)),
      (_) => emit(InsertGamePlayersSuccess()),
    );
  }

  Future insertRounds({required List<RoundModel> rounds}) async {
    emit(InsertRoundsLoading());
    final result = await gameRepo.insertRounds(rounds: rounds);
    result.fold(
      (failure) =>
          emit(InsertRoundsFailure(errorMessage: failure.errorMessage)),
      (roundsIds) => emit(InsertRoundsSuccess(roundsIds: roundsIds)),
    );
  }

  Future insertRoundScores({required List<RoundScoreModel> scores}) async {
    emit(InsertRoundScoresLoading());
    final result = await gameRepo.insertRoundScores(scores: scores);
    result.fold(
      (failure) =>
          emit(InsertRoundScoresFailure(errorMessage: failure.errorMessage)),
      (_) => emit(InsertRoundScoresSuccess()),
    );
  }

  Future insertPlayer({required PlayerModel player}) async {
    //emit(InsertPlayerLoading());
    final result = await gameRepo.insertPlayer(player: player);
    return result;
    // result.fold(
    //   (failure) =>
    //       emit(InsertPlayerFailure(errorMessage: failure.errorMessage)),
    //   (playerId) => emit(InsertPlayerSuccess(playerId: playerId)),
    // );
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

  Future updatePlayerStats({required PlayerModel player}) async {
    // emit(UpdatePlayerStatsLoading());
    //  var result =
    await playersRepo.updatePlayerStats(player: player);
    // result.fold(
    //   (failure) =>
    //       emit(UpdatePlayerStatsFailure(errorMessage: failure.errorMessage)),
    //   (_) => emit(UpdatePlayerStatsSuccess()),
    // );
  }
}
