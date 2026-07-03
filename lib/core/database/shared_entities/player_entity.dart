class PlayerEntity {
  const PlayerEntity({
    this.id,
    required this.name,
    required this.gamesPlayed,
    required this.wins,
    required this.roundWins,
    required this.winRate,
    required this.losses,
  });

  final int? id;
  final String name;
  final int gamesPlayed;
  final int wins;
  final int roundWins;
  final double winRate;
  final int losses;

  PlayerEntity copyWith({
    int? id,
    String? name,
    int? gamesPlayed,
    int? wins,
    int? roundWins,
    double? winRate,
    int? losses,
  }) => PlayerEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    gamesPlayed: gamesPlayed ?? this.gamesPlayed,
    wins: wins ?? this.wins,
    roundWins: roundWins ?? this.roundWins,
    winRate: winRate ?? this.winRate,
    losses: losses ?? this.losses,
  );
}
