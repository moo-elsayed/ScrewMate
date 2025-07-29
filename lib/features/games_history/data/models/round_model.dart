class RoundModel {
  final int? id;
  final int gameId;
  final int roundNumber;

  RoundModel({
    this.id,
    required this.gameId,
    required this.roundNumber,
  });

  factory RoundModel.fromMap(Map<String, dynamic> map) {
    return RoundModel(
      id: map['id'],
      gameId: map['game_id'],
      roundNumber: map['round_number'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'game_id': gameId,
      'round_number': roundNumber,
    };
  }
}
