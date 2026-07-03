class GamePlayerEntity {
  const GamePlayerEntity({
    this.id,
    required this.gameId,
    required this.playerId,
    required this.totalScore,
    required this.roundsWon,
  });

  final int? id;
  final int gameId;
  final int playerId;
  final int totalScore;
  final int roundsWon;
}
