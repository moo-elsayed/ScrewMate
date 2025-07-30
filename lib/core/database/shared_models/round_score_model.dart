class RoundScoreModel {
  final int? id;
  final int roundId;
  final int playerId;
  final int score;

  RoundScoreModel({
    this.id,
    required this.roundId,
    required this.playerId,
    required this.score,
  });

  factory RoundScoreModel.fromMap(Map<String, dynamic> map) {
    return RoundScoreModel(
      id: map['id'],
      roundId: map['round_id'],
      playerId: map['player_id'],
      score: map['score'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'round_id': roundId,
      'player_id': playerId,
      'score': score,
    };
  }
}
