import '../../../../../../core/database/shared_models/player_model.dart';
import '../../../../data/models/player_games_states_model.dart';

abstract class PlayersStates {}

class StripeInitial extends PlayersStates {}

// getAllPlayers

class GetAllPlayersLoading extends PlayersStates {}

class GetAllPlayersSuccess extends PlayersStates {

  GetAllPlayersSuccess({required this.players});
  final List<PlayerModel> players;
}

class GetAllPlayersFailure extends PlayersStates {

  GetAllPlayersFailure({required this.errorMessage});
  final String errorMessage;
}

// updatePlayerStats

class UpdatePlayerStatsLoading extends PlayersStates {}

class UpdatePlayerStatsSuccess extends PlayersStates {}

class UpdatePlayerStatsFailure extends PlayersStates {

  UpdatePlayerStatsFailure({required this.errorMessage});
  final String errorMessage;
}

// getPlayerById

class GetPlayerByIdLoading extends PlayersStates {}

class GetPlayerByIdSuccess extends PlayersStates {

  GetPlayerByIdSuccess({required this.player});
  final PlayerModel player;
}

class GetPlayerByIdFailure extends PlayersStates {

  GetPlayerByIdFailure({required this.errorMessage});
  final String errorMessage;
}

// deletePlayer

class DeletePlayerLoading extends PlayersStates {}

class DeletePlayerSuccess extends PlayersStates {}

class DeletePlayerFailure extends PlayersStates {

  DeletePlayerFailure({required this.errorMessage});
  final String errorMessage;
}

// getPlayerGamesStates

class GetPlayerGamesStatesLoading extends PlayersStates {}

class GetPlayerGamesStatesSuccess extends PlayersStates {

  GetPlayerGamesStatesSuccess({required this.playerGameStatsList});
  final List<PlayerGameStatsModel> playerGameStatsList;
}

class GetPlayerGamesStatesFailure extends PlayersStates {

  GetPlayerGamesStatesFailure({required this.errorMessage});
  final String errorMessage;
}

class ReverseListSuccess extends PlayersStates {}
