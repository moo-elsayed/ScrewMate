import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_constants.dart';
import '../../../../core/database/shared_models/game_model.dart';
import '../../../../core/database/shared_models/game_player_model.dart';
import '../../../../core/database/shared_models/round_model.dart';
import '../../../../core/database/shared_models/round_score_model.dart';
import '../models/game_details_model.dart';
import 'games_history_local_data_source.dart';

class GamesHistoryLocalDataSourceImpl implements GamesHistoryLocalDataSource {
  GamesHistoryLocalDataSourceImpl({required this.appDatabase});

  final Future<Database> appDatabase;

  @override
  Future<List<GameModel>> getAllGames() async {
    final db = await appDatabase;

    final result = await db.rawQuery('''
  SELECT 
    g.id,
    g.date,
    g.rounds_count,
    GROUP_CONCAT(p.name, ', ') AS winner_name
  FROM ${DatabaseConstants.gamesTable} g
  LEFT JOIN ${DatabaseConstants.playersTable} p
    ON ',' || g.winners_ids || ',' LIKE '%,' || p.id || ',%'
  GROUP BY g.id
  ORDER BY g.date ASC
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
    final Map<int, List<RoundScoreModel>> roundScoresByRoundId = {};

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

  @override
  Future<void> deleteGame({required int gameId}) async {
    final db = await appDatabase;

    // ==========================================================
    // خطوة 1: لازم نجيب بيانات الجيم واللاعبين قبل الحذف عشان نعدل الإحصائيات
    // ==========================================================

    // 1. هات بيانات الجيم عشان نعرف مين اللي كسبوا (winners_ids)
    final gameResult = await db.query(
      DatabaseConstants.gamesTable,
      where: 'id = ?',
      whereArgs: [gameId],
    );

    if (gameResult.isEmpty) return; // لو الجيم مش موجود أصلاً
    final gameData = gameResult.first;

    // نفك السترينج بتاع الايديهات لليست عشان نقارن بيها
    final String winnersIdsString = gameData['winners_ids'] as String;
    final List<String> winnersIds = winnersIdsString.split(',');

    // 2. هات بيانات اللاعبين اللي شاركوا في الجيم ده (عشان نعرف rounds_won لكل واحد)
    final gamePlayersResult = await db.query(
      DatabaseConstants.gamePlayersTable,
      where: 'game_id = ?',
      whereArgs: [gameId],
    );

    // ==========================================================
    // خطوة 2: تعديل جدول الـ Players (خصم الإحصائيات)
    // ==========================================================

    for (final gp in gamePlayersResult) {
      final int playerId = gp['player_id'] as int;
      final int roundsWonInThisGame = gp['rounds_won'] as int;
      final bool isWinner = winnersIds.contains(playerId.toString());

      // هات بيانات اللاعب الأصلية الحالية
      final playerResult = await db.query(
        DatabaseConstants.playersTable,
        where: 'id = ?',
        whereArgs: [playerId],
      );

      if (playerResult.isNotEmpty) {
        final player = playerResult.first;

        // حساب القيم الجديدة (بالنقصان)
        final int currentGamesPlayed = player['games_played'] as int;
        final int currentWins = player['wins'] as int;
        final int currentLosses = player['losses'] as int;
        final int currentRoundWins = player['round_wins'] as int;

        // نقص 1 من عدد الألعاب
        final int newGamesPlayed = currentGamesPlayed > 0
            ? currentGamesPlayed - 1
            : 0;

        // نقص 1 من الفوز لو كان كسبان
        final int newWins = (isWinner && currentWins > 0)
            ? currentWins - 1
            : currentWins;

        // نقص 1 من الخسارة لو كان خسران
        final int newLosses = (!isWinner && currentLosses > 0)
            ? currentLosses - 1
            : currentLosses;

        // نقص عدد الجولات اللي كسبها في الجيم ده
        final int newRoundWins = currentRoundWins >= roundsWonInThisGame
            ? currentRoundWins - roundsWonInThisGame
            : 0;

        // إعادة حساب الـ Win Rate
        double newWinRate = 0.0;
        if (newGamesPlayed > 0) {
          newWinRate = (newWins / newGamesPlayed) * 100;
        }

        // تحديث بيانات اللاعب في الداتا بيز
        await db.update(
          DatabaseConstants.playersTable,
          {
            'games_played': newGamesPlayed,
            'wins': newWins,
            'losses': newLosses,
            'round_wins': newRoundWins,
            'win_rate': newWinRate,
          },
          where: 'id = ?',
          whereArgs: [playerId],
        );
      }
    }

    // ==========================================================
    // خطوة 3: الحذف
    // ==========================================================

    // 1. Get round IDs
    final roundResults = await db.query(
      DatabaseConstants.roundsTable,
      columns: ['id'],
      where: 'game_id = ?',
      whereArgs: [gameId],
    );

    final roundIds = roundResults.map((e) => e['id'] as int).toList();

    // 2. Delete round scores
    for (final roundId in roundIds) {
      await db.delete(
        DatabaseConstants.roundScoresTable,
        where: 'round_id = ?',
        whereArgs: [roundId],
      );
    }

    // 3. Delete rounds
    await db.delete(
      DatabaseConstants.roundsTable,
      where: 'game_id = ?',
      whereArgs: [gameId],
    );

    // 4. Delete game players
    await db.delete(
      DatabaseConstants.gamePlayersTable,
      where: 'game_id = ?',
      whereArgs: [gameId],
    );

    // 5. Delete the game itself
    await db.delete(
      DatabaseConstants.gamesTable,
      where: 'id = ?',
      whereArgs: [gameId],
    );
  }
}
