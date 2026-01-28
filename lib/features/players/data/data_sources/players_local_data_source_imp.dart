import 'package:skru_mate/features/players/data/data_sources/players_local_data_source.dart';
import 'package:skru_mate/features/players/data/models/player_games_states_model.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_constants.dart';
import '../../../../core/database/shared_models/player_model.dart';

class PlayerLocalDataSourceImp implements PlayerLocalDataSource {

  PlayerLocalDataSourceImp({required this.appDatabase});
  final Future<Database> appDatabase;

  @override
  Future<void> deletePlayer({required int id}) async {
    final db = await appDatabase;
    await db.delete(
      DatabaseConstants.playersTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<PlayerModel>> getAllPlayers() async {
    final db = await appDatabase;
    final result = await db.query(DatabaseConstants.playersTable);
    return result.map((e) => PlayerModel.fromMap(e)).toList();
  }

  @override
  Future<PlayerModel?> getPlayerById({required int id}) async {
    final db = await appDatabase;
    final result = await db.query(
      DatabaseConstants.playersTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    return PlayerModel.fromMap(result.first);
  }

  @override
  Future<void> updatePlayerStats({required PlayerModel player}) async {
    final db = await appDatabase;
    await db.update(
      DatabaseConstants.playersTable,
      player.toMap(),
      where: 'id = ?',
      whereArgs: [player.id],
    );
  }

  @override
  Future<List<PlayerGameStatsModel>> getPlayerGameStats(int playerId) async {
    final db = await appDatabase;

    final result = await db.rawQuery(
      '''
  SELECT
    g.id AS game_id,
    g.date,
    g.rounds_count,
    gp.total_score,
    (
      SELECT COUNT(*) + 1
      FROM game_players gp2
      WHERE gp2.game_id = gp.game_id 
        AND gp2.total_score < gp.total_score
    ) AS rank
  FROM game_players gp
  JOIN games g ON g.id = gp.game_id
  WHERE gp.player_id = ?
  ORDER BY g.date DESC;
  ''',
      [playerId],
    );

    return result.map((map) => PlayerGameStatsModel.fromMap(map)).toList();
  }
}
