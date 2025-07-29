class PlayerModel {
  final int? id;
  final String name;
  final int totalScore;
  final int maxScore;
  final int minScore;
  final int roundWins;
  final int wins;

  PlayerModel({
    this.id,
    required this.name,
    required this.totalScore,
    required this.maxScore,
    required this.minScore,
    required this.roundWins,
    required this.wins,
  });

  factory PlayerModel.fromMap(Map<String, dynamic> map) {
    return PlayerModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      totalScore: map['total_score'] as int,
      maxScore: map['max_score'] as int,
      minScore: map['min_score'] as int,
      roundWins: map['round_wins'] as int,
      wins: map['wins'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'total_score': totalScore,
      'max_score': maxScore,
      'min_score': minScore,
      'round_wins': roundWins,
      'wins': wins,
    };
  }
}
