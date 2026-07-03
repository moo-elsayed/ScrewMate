class RoundScoreEntity {
  const RoundScoreEntity({
    this.id,
    required this.roundId,
    required this.playerId,
    required this.score,
  });

  final int? id;
  final int roundId;
  final int playerId;
  final int score;
}
