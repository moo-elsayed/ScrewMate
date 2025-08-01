class PlayerModel {
  final int? id;
  final String name;
  final int gamesPlayed;
  final int wins;
  final int roundWins;
  final double winRate;

  PlayerModel({
    this.id,
    required this.name,
    required this.gamesPlayed,
    required this.wins,
    required this.roundWins,
    required this.winRate,
  });

  factory PlayerModel.fromMap(Map<String, dynamic> map) {
    return PlayerModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      gamesPlayed: map['games_played'] as int,
      wins: map['wins'] as int,
      roundWins: map['round_wins'] as int,
      winRate: (map['win_rate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'games_played': gamesPlayed,
      'wins': wins,
      'round_wins': roundWins,
      'win_rate': winRate,
    };
  }
}
