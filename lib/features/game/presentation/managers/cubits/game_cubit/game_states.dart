import '../../../../../../core/database/shared_models/player_model.dart';

abstract class GameStates {}

class GameInitial extends GameStates {}

// Insert Game
class InsertGameLoading extends GameStates {}

class InsertGameSuccess extends GameStates {

  InsertGameSuccess({required this.gameId});
  final int gameId;
}

class InsertGameFailure extends GameStates {

  InsertGameFailure({required this.errorMessage});
  final String errorMessage;
}

// insertPlayer

class InsertPlayerLoading extends GameStates {}

class InsertPlayerSuccess extends GameStates {

  InsertPlayerSuccess({required this.playerId});
  final int playerId;
}

class InsertPlayerFailure extends GameStates {

  InsertPlayerFailure({required this.errorMessage});
  final String errorMessage;
}

// getAllPlayers

class GetAllPlayersLoading extends GameStates {}

class GetAllPlayersSuccess extends GameStates {

  GetAllPlayersSuccess({required this.players});
  final List<PlayerModel> players;
}

class GetAllPlayersFailure extends GameStates {

  GetAllPlayersFailure({required this.errorMessage});
  final String errorMessage;
}

// Insert Game Players
class InsertGamePlayersLoading extends GameStates {}

class InsertGamePlayersSuccess extends GameStates {}

class InsertGamePlayersFailure extends GameStates {

  InsertGamePlayersFailure({required this.errorMessage});
  final String errorMessage;
}

// updatePlayerStats

class UpdatePlayerStatsLoading extends GameStates {}

class UpdatePlayerStatsSuccess extends GameStates {}

class UpdatePlayerStatsFailure extends GameStates {

  UpdatePlayerStatsFailure({required this.errorMessage});
  final String errorMessage;
}

// Insert Rounds
class InsertRoundsLoading extends GameStates {}

class InsertRoundsSuccess extends GameStates {

  InsertRoundsSuccess({required this.roundsIds});
  final List<int> roundsIds;
}

class InsertRoundsFailure extends GameStates {

  InsertRoundsFailure({required this.errorMessage});
  final String errorMessage;
}

// Insert Round Scores
class InsertRoundScoresLoading extends GameStates {}

class InsertRoundScoresSuccess extends GameStates {}

class InsertRoundScoresFailure extends GameStates {

  InsertRoundScoresFailure({required this.errorMessage});
  final String errorMessage;
}
