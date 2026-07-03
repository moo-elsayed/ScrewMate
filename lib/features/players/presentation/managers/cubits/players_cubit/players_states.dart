import '../../../../../../core/database/shared_entities/player_entity.dart';
import '../../../../domain/entities/player_game_stats_entity.dart';

abstract class PlayersStates {}

class StripeInitial extends PlayersStates {}

// getAllPlayers

class GetAllPlayersLoading extends PlayersStates {}

class GetAllPlayersSuccess extends PlayersStates {

  GetAllPlayersSuccess({required this.players});
  final List<PlayerEntity> players;
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
  final PlayerEntity player;
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
  final List<PlayerGameStatsEntity> playerGameStatsList;
}

class GetPlayerGamesStatesFailure extends PlayersStates {

  GetPlayerGamesStatesFailure({required this.errorMessage});
  final String errorMessage;
}

class ReverseListSuccess extends PlayersStates {}
