class GameModel {
  final int? id;
  final String date;
  final int roundsCount;
  final int? winnerId;
  final String? winnerName;

  GameModel({
    this.id,
    required this.date,
    required this.roundsCount,
    this.winnerId,
    this.winnerName,
  });

  factory GameModel.fromMap(Map<String, dynamic> map) {
    return GameModel(
      id: map['id'] as int?,
      date: map['date'] as String,
      roundsCount: map['rounds_count'] as int,
      winnerId: map['winner_id'] as int?,
      winnerName: map['winner_name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'rounds_count': roundsCount,
      'winner_id': winnerId,
      'winner_name': winnerName,
    };
  }
}
