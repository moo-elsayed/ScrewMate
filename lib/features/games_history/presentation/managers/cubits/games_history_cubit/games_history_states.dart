import 'package:skru_mate/core/database/shared_models/game_model.dart';
import 'package:skru_mate/features/games_history/data/models/game_details_model.dart';

abstract class GamesHistoryStates {}

class GamesHistoryInitial extends GamesHistoryStates {}

// getAllGames

class GetAllGamesLoading extends GamesHistoryStates {}

class GetAllGamesSuccess extends GamesHistoryStates {
  final List<GameModel> games;

  GetAllGamesSuccess({required this.games});
}

class GetAllGamesFailure extends GamesHistoryStates {
  final String errorMessage;

  GetAllGamesFailure({required this.errorMessage});
}

// getGameDetails

class GetGameDetailsLoading extends GamesHistoryStates {}

class GetGameDetailsSuccess extends GamesHistoryStates {
  final GameDetailsModel gameDetails;

  GetGameDetailsSuccess({required this.gameDetails});
}

class GetGameDetailsFailure extends GamesHistoryStates {
  final String errorMessage;

  GetGameDetailsFailure({required this.errorMessage});
}
