import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_constants.dart';
import '../../../../core/database/shared_models/game_model.dart';
import '../../../../core/database/shared_models/game_player_model.dart';
import '../../../../core/database/shared_models/round_model.dart';
import '../../../../core/database/shared_models/round_score_model.dart';
import '../models/game_details_model.dart';
import 'games_history_local_data_source.dart';

class GamesHistoryLocalDataSourceImpl implements GamesHistoryLocalDataSource {
  final Future<Database> appDatabase;

  GamesHistoryLocalDataSourceImpl({required this.appDatabase});

  @override
  Future<List<GameModel>> getAllGames() async {
    final db = await appDatabase;
    final result = await db.rawQuery('''
    SELECT 
      games.id, 
      games.date, 
      games.rounds_count, 
      games.winner_id, 
      players.name AS winner_name
    FROM ${DatabaseConstants.gamesTable} AS games
    LEFT JOIN ${DatabaseConstants.playersTable} AS players
      ON games.winner_id = players.id
    ORDER BY games.date ASC
  ''');

    return result.map((e) => GameModel.fromMap(e)).toList();
  }

  @override
  Future<GameDetailsModel?> getGameDetails({required int gameId}) async {
    final db = await appDatabase;

    // 1. Get game
    final gameResult = await db.query(
      DatabaseConstants.gamesTable,
      where: 'id = ?',
      whereArgs: [gameId],
    );
    if (gameResult.isEmpty) return null;
    final game = GameModel.fromMap(gameResult.first);

    // 2. Get players of that game
    final playerResults = await db.query(
      DatabaseConstants.gamePlayersTable,
      where: 'game_id = ?',
      whereArgs: [gameId],
    );
    final players = playerResults
        .map((e) => GamePlayerModel.fromMap(e))
        .toList();

    // 3. Get rounds
    final roundResults = await db.query(
      DatabaseConstants.roundsTable,
      where: 'game_id = ?',
      whereArgs: [gameId],
      orderBy: 'round_number ASC',
    );
    final rounds = roundResults.map((e) => RoundModel.fromMap(e)).toList();

    // 4. Get scores for each round
    Map<int, List<RoundScoreModel>> roundScoresByRoundId = {};

    for (final round in rounds) {
      final scores = await db.query(
        DatabaseConstants.roundScoresTable,
        where: 'round_id = ?',
        whereArgs: [round.id],
      );
      roundScoresByRoundId[round.id!] = scores
          .map((e) => RoundScoreModel.fromMap(e))
          .toList();
    }

    return GameDetailsModel(
      game: game,
      players: players,
      rounds: rounds,
      roundScoresByRoundId: roundScoresByRoundId,
    );
  }
}
