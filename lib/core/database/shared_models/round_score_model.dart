class RoundScoreModel {

  RoundScoreModel({
    this.id,
    required this.roundId,
    required this.playerId,
    required this.score,
  });

  factory RoundScoreModel.fromMap(Map<String, dynamic> map) => RoundScoreModel(
      id: map['id'],
      roundId: map['round_id'],
      playerId: map['player_id'],
      score: map['score'],
    );
  final int? id;
  final int roundId;
  final int playerId;
  final int score;

  Map<String, dynamic> toMap() => {
      'id': id,
      'round_id': roundId,
      'player_id': playerId,
      'score': score,
    };
}
