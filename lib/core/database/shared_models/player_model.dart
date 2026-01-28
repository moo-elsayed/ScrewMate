class PlayerModel {

  PlayerModel({
    this.id,
    required this.name,
    required this.gamesPlayed,
    required this.wins,
    required this.roundWins,
    required this.winRate,
    required this.losses,
  });

  factory PlayerModel.fromMap(Map<String, dynamic> map) => PlayerModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      gamesPlayed: map['games_played'] as int,
      wins: map['wins'] as int,
      roundWins: map['round_wins'] as int,
      winRate: (map['win_rate'] as num).toDouble(),
      losses: map['losses'] as int,
    );
  final int? id;
  final String name;
  final int gamesPlayed;
  final int wins;
  final int roundWins;
  final double winRate;
  final int losses;

  PlayerModel copyWith({
    int? id,
    String? name,
    int? gamesPlayed,
    int? wins,
    int? roundWins,
    double? winRate,
    int? losses,
  }) => PlayerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      wins: wins ?? this.wins,
      roundWins: roundWins ?? this.roundWins,
      winRate: winRate ?? this.winRate,
      losses: losses ?? this.losses,
    );

  Map<String, dynamic> toMap() => {
      'id': id,
      'name': name,
      'games_played': gamesPlayed,
      'wins': wins,
      'round_wins': roundWins,
      'win_rate': winRate,
      'losses': losses,
    };
}
