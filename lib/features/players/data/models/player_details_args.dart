import '../../../../core/database/shared_entities/player_entity.dart';

class PlayerDetailsArgs {
  PlayerDetailsArgs({
    required this.player,
    required this.statRanks,
    required this.playersList,
  });
  final PlayerEntity player;
  final Map<String, int> statRanks;
  final List<PlayerEntity> playersList;
}
