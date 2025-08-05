import '../../../../../../core/database/shared_models/player_model.dart';

abstract class GameStates {}

class GameInitial extends GameStates {}

// Insert Game
class InsertGameLoading extends GameStates {}

class InsertGameSuccess extends GameStates {
  final int gameId;

  InsertGameSuccess({required this.gameId});
}

class InsertGameFailure extends GameStates {
  final String errorMessage;

  InsertGameFailure({required this.errorMessage});
}

// insertPlayer

class InsertPlayerLoading extends GameStates {}

class InsertPlayerSuccess extends GameStates {
  final int playerId;

  InsertPlayerSuccess({required this.playerId});
}

class InsertPlayerFailure extends GameStates {
  final String errorMessage;

  InsertPlayerFailure({required this.errorMessage});
}

// getAllPlayers

class GetAllPlayersLoading extends GameStates {}

class GetAllPlayersSuccess extends GameStates {
  final List<PlayerModel> players;

  GetAllPlayersSuccess({required this.players});
}

class GetAllPlayersFailure extends GameStates {
  final String errorMessage;

  GetAllPlayersFailure({required this.errorMessage});
}

// Insert Game Players
class InsertGamePlayersLoading extends GameStates {}

class InsertGamePlayersSuccess extends GameStates {}

class InsertGamePlayersFailure extends GameStates {
  final String errorMessage;

  InsertGamePlayersFailure({required this.errorMessage});
}

// updatePlayerStats

class UpdatePlayerStatsLoading extends GameStates {}

class UpdatePlayerStatsSuccess extends GameStates {}

class UpdatePlayerStatsFailure extends GameStates {
  final String errorMessage;

  UpdatePlayerStatsFailure({required this.errorMessage});
}

// Insert Rounds
class InsertRoundsLoading extends GameStates {}

class InsertRoundsSuccess extends GameStates {
  final List<int> roundsIds;

  InsertRoundsSuccess({required this.roundsIds});
}

class InsertRoundsFailure extends GameStates {
  final String errorMessage;

  InsertRoundsFailure({required this.errorMessage});
}

// Insert Round Scores
class InsertRoundScoresLoading extends GameStates {}

class InsertRoundScoresSuccess extends GameStates {}

class InsertRoundScoresFailure extends GameStates {
  final String errorMessage;

  InsertRoundScoresFailure({required this.errorMessage});
}
