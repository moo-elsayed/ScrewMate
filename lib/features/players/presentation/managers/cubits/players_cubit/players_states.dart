import '../../../../../../core/database/shared_models/player_model.dart';
import '../../../../data/models/player_games_states_model.dart';

abstract class PlayersStates {}

class StripeInitial extends PlayersStates {}

// insertPlayer

class InsertPlayerLoading extends PlayersStates {}

class InsertPlayerSuccess extends PlayersStates {}

class InsertPlayerFailure extends PlayersStates {
  final String errorMessage;

  InsertPlayerFailure({required this.errorMessage});
}

// getAllPlayers

class GetAllPlayersLoading extends PlayersStates {}

class GetAllPlayersSuccess extends PlayersStates {
  final List<PlayerModel> players;

  GetAllPlayersSuccess({required this.players});
}

class GetAllPlayersFailure extends PlayersStates {
  final String errorMessage;

  GetAllPlayersFailure({required this.errorMessage});
}

// updatePlayerStats

class UpdatePlayerStatsLoading extends PlayersStates {}

class UpdatePlayerStatsSuccess extends PlayersStates {}

class UpdatePlayerStatsFailure extends PlayersStates {
  final String errorMessage;

  UpdatePlayerStatsFailure({required this.errorMessage});
}

// getPlayerById

class GetPlayerByIdLoading extends PlayersStates {}

class GetPlayerByIdSuccess extends PlayersStates {
  final PlayerModel player;

  GetPlayerByIdSuccess({required this.player});
}

class GetPlayerByIdFailure extends PlayersStates {
  final String errorMessage;

  GetPlayerByIdFailure({required this.errorMessage});
}

// deletePlayer

class DeletePlayerLoading extends PlayersStates {}

class DeletePlayerSuccess extends PlayersStates {}

class DeletePlayerFailure extends PlayersStates {
  final String errorMessage;

  DeletePlayerFailure({required this.errorMessage});
}

// getPlayerGamesStates

class GetPlayerGamesStatesLoading extends PlayersStates {}

class GetPlayerGamesStatesSuccess extends PlayersStates {
  final List<PlayerGameStatsModel> playerGameStatsList;

  GetPlayerGamesStatesSuccess({required this.playerGameStatsList});
}

class GetPlayerGamesStatesFailure extends PlayersStates {
  final String errorMessage;

  GetPlayerGamesStatesFailure({required this.errorMessage});
}
