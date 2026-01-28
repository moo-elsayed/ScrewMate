class PlayerGameStatsModel {

  PlayerGameStatsModel({
    required this.gameId,
    required this.date,
    required this.roundsCount,
    required this.totalScore,
    required this.rank,
  });

  factory PlayerGameStatsModel.fromMap(Map<String, dynamic> map) => PlayerGameStatsModel(
      gameId: map['game_id'],
      date: map['date'],
      roundsCount: map['rounds_count'],
      totalScore: map['total_score'],
      rank: map['rank'],
    );
  final int gameId;
  final String date;
  final int roundsCount;
  final int totalScore;
  final int rank;
}
