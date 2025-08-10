class GameModel {
  final int? id;
  final String date;
  final int roundsCount;
  final String? winnersId;
  final String? winnerName;

  GameModel({
    this.id,
    required this.date,
    required this.roundsCount,
    this.winnersId,
    this.winnerName,
  });

  factory GameModel.fromMap(Map<String, dynamic> map) {
    return GameModel(
      id: map['id'] as int?,
      date: map['date'] as String,
      roundsCount: map['rounds_count'] as int,
      winnersId: map['winners_ids'] as String?,
      winnerName: map['winner_name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'rounds_count': roundsCount,
      'winners_ids': winnersId,
      'winner_name': winnerName,
    };
  }
}
