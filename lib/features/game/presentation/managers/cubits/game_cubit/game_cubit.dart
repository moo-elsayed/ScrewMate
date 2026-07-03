import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skru_mate/core/database/shared_entities/game_entity.dart';
import 'package:skru_mate/core/database/shared_entities/game_player_entity.dart';
import 'package:skru_mate/core/database/shared_entities/player_entity.dart';
import 'package:skru_mate/core/database/shared_entities/round_entity.dart';
import 'package:skru_mate/core/database/shared_entities/round_score_entity.dart';
import 'package:skru_mate/features/game/domain/use_cases/insert_game_players_use_case.dart';
import 'package:skru_mate/features/game/domain/use_cases/insert_game_use_case.dart';
import 'package:skru_mate/features/game/domain/use_cases/insert_player_use_case.dart';
import 'package:skru_mate/features/game/domain/use_cases/insert_round_scores_use_case.dart';
import 'package:skru_mate/features/game/domain/use_cases/insert_rounds_use_case.dart';
import 'package:skru_mate/features/players/domain/use_cases/get_all_players_use_case.dart';
import 'package:skru_mate/features/players/domain/use_cases/update_player_stats_use_case.dart';
import 'game_states.dart';

class GameCubit extends Cubit<GameStates> {
  GameCubit({
    required this.insertGameUseCase,
    required this.insertGamePlayersUseCase,
    required this.insertRoundsUseCase,
    required this.insertRoundScoresUseCase,
    required this.insertPlayerUseCase,
    required this.getAllPlayersUseCase,
    required this.updatePlayerStatsUseCase,
  }) : super(GameInitial());

  final InsertGameUseCase insertGameUseCase;
  final InsertGamePlayersUseCase insertGamePlayersUseCase;
  final InsertRoundsUseCase insertRoundsUseCase;
  final InsertRoundScoresUseCase insertRoundScoresUseCase;
  final InsertPlayerUseCase insertPlayerUseCase;
  final GetAllPlayersUseCase getAllPlayersUseCase;
  final UpdatePlayerStatsUseCase updatePlayerStatsUseCase;

  Future insertGame({required GameEntity game}) async {
    emit(InsertGameLoading());
    final result = await insertGameUseCase(game: game);
    result.fold(
      (failure) => emit(InsertGameFailure(errorMessage: failure.errorMessage)),
      (gameId) => emit(InsertGameSuccess(gameId: gameId)),
    );
  }

  Future insertGamePlayers({required List<GamePlayerEntity> players}) async {
    emit(InsertGamePlayersLoading());
    final result = await insertGamePlayersUseCase(players: players);
    result.fold(
      (failure) =>
          emit(InsertGamePlayersFailure(errorMessage: failure.errorMessage)),
      (_) => emit(InsertGamePlayersSuccess()),
    );
  }

  Future insertRounds({required List<RoundEntity> rounds}) async {
    emit(InsertRoundsLoading());
    final result = await insertRoundsUseCase(rounds: rounds);
    result.fold(
      (failure) =>
          emit(InsertRoundsFailure(errorMessage: failure.errorMessage)),
      (roundsIds) => emit(InsertRoundsSuccess(roundsIds: roundsIds)),
    );
  }

  Future insertRoundScores({required List<RoundScoreEntity> scores}) async {
    emit(InsertRoundScoresLoading());
    final result = await insertRoundScoresUseCase(scores: scores);
    result.fold(
      (failure) =>
          emit(InsertRoundScoresFailure(errorMessage: failure.errorMessage)),
      (_) => emit(InsertRoundScoresSuccess()),
    );
  }

  Future insertPlayer({required PlayerEntity player}) async {
    final result = await insertPlayerUseCase(player: player);
    return result;
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

  Future updatePlayerStats({required PlayerEntity player}) async {
    await updatePlayerStatsUseCase(player: player);
  }
}
