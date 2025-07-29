import 'package:skru_mate/features/players/data/data_sources/players_local_data_source.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_constants.dart';
import '../models/player_model.dart';

class PlayerLocalDataSourceImp implements PlayerLocalDataSource {
  final Future<Database> appDatabase;

  PlayerLocalDataSourceImp({required this.appDatabase});

  @override
  Future<void> deletePlayer(int id) async {
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
  Future<PlayerModel?> getPlayerById(int id) async {
    final db = await appDatabase;
    final result = await db.query(
      DatabaseConstants.playersTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    return PlayerModel.fromMap(result.first);
  }

  @override
  Future<void> insertPlayer(PlayerModel player) async {
    final db = await appDatabase;
    await db.insert(
      DatabaseConstants.playersTable,
      player.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  @override
  Future<void> updatePlayerStats(PlayerModel player) async {
    final db = await appDatabase;
    await db.update(
      DatabaseConstants.playersTable,
      player.toMap(),
      where: 'id = ?',
      whereArgs: [player.id],
    );
  }
}
