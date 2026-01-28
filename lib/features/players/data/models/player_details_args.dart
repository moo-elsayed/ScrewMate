import '../../../../core/database/shared_models/player_model.dart';

class PlayerDetailsArgs {

  PlayerDetailsArgs({
    required this.player,
    required this.statRanks,
    required this.playersList,
  });
  final PlayerModel player;
  final Map<String, int> statRanks;
  final List<PlayerModel> playersList;
}
