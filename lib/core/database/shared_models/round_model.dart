import '../shared_entities/round_entity.dart';

class RoundModel {
  RoundModel({
    this.id,
    required this.gameId,
    required this.roundNumber,
  });

  factory RoundModel.fromMap(Map<String, dynamic> map) => RoundModel(
      id: map['id'],
      gameId: map['game_id'],
      roundNumber: map['round_number'],
    );

  factory RoundModel.fromEntity(RoundEntity entity) => RoundModel(
        id: entity.id,
        gameId: entity.gameId,
        roundNumber: entity.roundNumber,
      );

  RoundEntity toEntity() => RoundEntity(
        id: id,
        gameId: gameId,
        roundNumber: roundNumber,
      );
  final int? id;
  final int gameId;
  final int roundNumber;

  Map<String, dynamic> toMap() => {
      'id': id,
      'game_id': gameId,
      'round_number': roundNumber,
    };
}
