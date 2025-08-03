import '../../../../core/database/shared_models/player_model.dart';

class PlayerDetailsArgs {
  final PlayerModel player;
  final Map<String, int> statRanks;

  PlayerDetailsArgs({required this.player, required this.statRanks});
}
