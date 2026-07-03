import 'package:skru_mate/core/database/shared_entities/game_entity.dart';
import 'package:skru_mate/core/database/shared_entities/player_entity.dart';
import 'package:skru_mate/features/games_history/domain/entities/game_details_entity.dart';

abstract class GamesHistoryStates {}

class GamesHistoryInitial extends GamesHistoryStates {}

// getAllGames

class GetAllGamesLoading extends GamesHistoryStates {}

class GetAllGamesSuccess extends GamesHistoryStates {

  GetAllGamesSuccess({required this.games});
  final List<GameEntity> games;
}

class GetAllGamesFailure extends GamesHistoryStates {

  GetAllGamesFailure({required this.errorMessage});
  final String errorMessage;
}

// getGameDetails

class GetGameDetailsLoading extends GamesHistoryStates {}

class GetGameDetailsSuccess extends GamesHistoryStates {

  GetGameDetailsSuccess({required this.gameDetails});
  final GameDetailsEntity gameDetails;
}

class GetGameDetailsFailure extends GamesHistoryStates {

  GetGameDetailsFailure({required this.errorMessage});
  final String errorMessage;
}

// delete game

class DeleteGameLoading extends GamesHistoryStates {}

class DeleteGameSuccess extends GamesHistoryStates {}

class DeleteGameFailure extends GamesHistoryStates {

  DeleteGameFailure({required this.errorMessage});
  final String errorMessage;
}

class ReverseListSuccess extends GamesHistoryStates {}


// getAllPlayers

class GetAllPlayersLoading extends GamesHistoryStates {}

class GetAllPlayersSuccess extends GamesHistoryStates {

  GetAllPlayersSuccess({required this.players});
  final List<PlayerEntity> players;
}

class GetAllPlayersFailure extends GamesHistoryStates {

  GetAllPlayersFailure({required this.errorMessage});
  final String errorMessage;
}