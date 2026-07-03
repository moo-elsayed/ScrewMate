class GameEntity {
  const GameEntity({
    this.id,
    required this.date,
    required this.roundsCount,
    this.winnersId,
    this.winnerName,
  });

  final int? id;
  final String date;
  final int roundsCount;
  final String? winnersId;
  final String? winnerName;
}
