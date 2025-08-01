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

// Insert Game Players
class InsertGamePlayersLoading extends GameStates {}

class InsertGamePlayersSuccess extends GameStates {}

class InsertGamePlayersFailure extends GameStates {
  final String errorMessage;

  InsertGamePlayersFailure({required this.errorMessage});
}

// Insert Rounds
class InsertRoundsLoading extends GameStates {}

class InsertRoundsSuccess extends GameStates {}

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
