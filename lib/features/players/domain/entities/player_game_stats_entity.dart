class PlayerGameStatsEntity {
  const PlayerGameStatsEntity({
    required this.gameId,
    required this.date,
    required this.roundsCount,
    required this.totalScore,
    required this.rank,
  });

  final int gameId;
  final String date;
  final int roundsCount;
  final int totalScore;
  final int rank;
}
