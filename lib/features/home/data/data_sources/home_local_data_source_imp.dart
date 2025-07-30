import 'package:skru_mate/core/database/shared_models/game_model.dart';
import 'package:skru_mate/core/database/shared_models/game_player_model.dart';
import 'package:skru_mate/core/database/shared_models/round_model.dart';
import 'package:skru_mate/core/database/shared_models/round_score_model.dart';
import 'package:skru_mate/features/home/data/data_sources/home_local_data_source.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_constants.dart';

class HomeLocalDataSourceImp implements HomeLocalDataSource {
  final Future<Database> appDatabase;

  HomeLocalDataSourceImp({required this.appDatabase});

  @override
  Future<int> insertGame({required GameModel game}) async {
    final db = await appDatabase;
    return await db.insert(
      DatabaseConstants.gamesTable,
      game.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> insertGamePlayers({
    required List<GamePlayerModel> players,
  }) async {
    final db = await appDatabase;
    final batch = db.batch();

    for (var player in players) {
      batch.insert(
        DatabaseConstants.gamePlayersTable,
        player.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  @override
  Future<void> insertRounds({required List<RoundModel> rounds}) async {
    final db = await appDatabase;
    final batch = db.batch();

    for (var round in rounds) {
      batch.insert(
        DatabaseConstants.roundsTable,
        round.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  @override
  Future<void> insertRoundScores({
    required List<RoundScoreModel> scores,
  }) async {
    final db = await appDatabase;
    final batch = db.batch();

    for (var score in scores) {
      batch.insert(
        DatabaseConstants.roundScoresTable,
        score.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }
}
