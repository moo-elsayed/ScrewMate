class GamePlayerModel {
  final int? id;
  final int gameId;
  final int playerId;
  final int totalScore;
  final int roundsWon;

  GamePlayerModel({
    this.id,
    required this.gameId,
    required this.playerId,
    required this.totalScore,
    required this.roundsWon,
  });

  factory GamePlayerModel.fromMap(Map<String, dynamic> map) {
    return GamePlayerModel(
      id: map['id'],
      gameId: map['game_id'],
      playerId: map['player_id'],
      totalScore: map['total_score'],
      roundsWon: map['rounds_won'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'game_id': gameId,
      'player_id': playerId,
      'total_score': totalScore,
      'rounds_won': roundsWon,
    };
  }
}
