class RoundEntity {
  const RoundEntity({
    this.id,
    required this.gameId,
    required this.roundNumber,
  });

  final int? id;
  final int gameId;
  final int roundNumber;
}
