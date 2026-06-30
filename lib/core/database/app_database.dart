import 'package:path/path.dart';
import 'package:skru_mate/core/database/database_constants.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  factory AppDatabase() => _instance;

  AppDatabase._internal();

  static final AppDatabase _instance = AppDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('scorekeeper.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 5,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 4) {
          try {
            await db.execute(
              'ALTER TABLE ${DatabaseConstants.playersTable} ADD COLUMN losses INTEGER DEFAULT 0',
            );
          } catch (e) {
            // Column might already exist
          }
        }
        if (oldVersion < 5) {
          await _recalculateAllPlayersLosses(db);
        }
      },
    );
  }

  Future<void> _recalculateAllPlayersLosses(Database db) async {
    try {
      final List<Map<String, dynamic>> players = await db.query(DatabaseConstants.playersTable);
      final Map<int, int> playerLosses = {};
      for (var player in players) {
        final id = player['id'] as int?;
        if (id != null) {
          playerLosses[id] = 0;
        }
      }

      final List<Map<String, dynamic>> games = await db.query(DatabaseConstants.gamesTable);

      for (var game in games) {
        final gameId = game['id'] as int;
        final List<Map<String, dynamic>> gamePlayers = await db.query(
          DatabaseConstants.gamePlayersTable,
          where: 'game_id = ?',
          whereArgs: [gameId],
        );

        if (gamePlayers.isNotEmpty) {
          int maxScore = -999999;
          for (var gp in gamePlayers) {
            final score = gp['total_score'] as int;
            if (score > maxScore) {
              maxScore = score;
            }
          }

          for (var gp in gamePlayers) {
            final score = gp['total_score'] as int;
            final playerId = gp['player_id'] as int;
            if (score == maxScore) {
              playerLosses[playerId] = (playerLosses[playerId] ?? 0) + 1;
            }
          }
        }
      }

      for (var entry in playerLosses.entries) {
        await db.update(
          DatabaseConstants.playersTable,
          {'losses': entry.value},
          where: 'id = ?',
          whereArgs: [entry.key],
        );
      }
    } catch (e) {
      // Handle silently
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
  CREATE TABLE ${DatabaseConstants.playersTable} (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    games_played INTEGER DEFAULT 0,
    wins INTEGER DEFAULT 0,
    round_wins INTEGER DEFAULT 0,
    win_rate REAL DEFAULT 0.0,
    losses INTEGER DEFAULT 0
  );
''');

    await db.execute('''
   CREATE TABLE ${DatabaseConstants.gamesTable} (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date TEXT NOT NULL,
    rounds_count INTEGER NOT NULL,
    winners_ids TEXT NOT NULL,
    winner_name TEXT NOT NULL
   );
  ''');

    await db.execute('''
    CREATE TABLE ${DatabaseConstants.gamePlayersTable} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      game_id INTEGER NOT NULL,
      player_id INTEGER NOT NULL,
      total_score INTEGER DEFAULT 0,
      rounds_won INTEGER DEFAULT 0,
      FOREIGN KEY (game_id) REFERENCES ${DatabaseConstants.gamesTable}(id),
      FOREIGN KEY (player_id) REFERENCES ${DatabaseConstants.playersTable}(id)
    );
  ''');

    await db.execute('''
    CREATE TABLE ${DatabaseConstants.roundsTable} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      game_id INTEGER NOT NULL,
      round_number INTEGER NOT NULL,
      FOREIGN KEY (game_id) REFERENCES ${DatabaseConstants.gamesTable}(id)
    );
  ''');

    await db.execute('''
    CREATE TABLE ${DatabaseConstants.roundScoresTable} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      round_id INTEGER NOT NULL,
      player_id INTEGER NOT NULL,
      score INTEGER NOT NULL,
      FOREIGN KEY (round_id) REFERENCES ${DatabaseConstants.roundsTable}(id),
      FOREIGN KEY (player_id) REFERENCES ${DatabaseConstants.playersTable}(id)
    );
  ''');
  }
}
