import 'package:skru_mate/core/database/shared_models/game_model.dart';
import 'package:skru_mate/features/games_history/data/models/game_details_model.dart';

import '../../../../../../core/database/shared_models/player_model.dart';

abstract class GamesHistoryStates {}

class GamesHistoryInitial extends GamesHistoryStates {}

// getAllGames

class GetAllGamesLoading extends GamesHistoryStates {}

class GetAllGamesSuccess extends GamesHistoryStates {

  GetAllGamesSuccess({required this.games});
  final List<GameModel> games;
}

class GetAllGamesFailure extends GamesHistoryStates {

  GetAllGamesFailure({required this.errorMessage});
  final String errorMessage;
}

// getGameDetails

class GetGameDetailsLoading extends GamesHistoryStates {}

class GetGameDetailsSuccess extends GamesHistoryStates {

  GetGameDetailsSuccess({required this.gameDetails});
  final GameDetailsModel gameDetails;
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
  final List<PlayerModel> players;
}

class GetAllPlayersFailure extends GamesHistoryStates {

  GetAllPlayersFailure({required this.errorMessage});
  final String errorMessage;
}