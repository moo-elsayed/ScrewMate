import 'package:skru_mate/core/database/database_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();

  factory AppDatabase() => _instance;

  AppDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('scorekeeper.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
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
      winner_id INTEGER,
      FOREIGN KEY (winner_id) REFERENCES ${DatabaseConstants.playersTable}(id)
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
