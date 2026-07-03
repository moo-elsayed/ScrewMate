import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skru_mate/core/theming/theme_cubit.dart';
import 'package:skru_mate/features/game/domain/repos/game_repo.dart';
import 'package:skru_mate/features/game/domain/use_cases/insert_game_players_use_case.dart';
import 'package:skru_mate/features/game/domain/use_cases/insert_game_use_case.dart';
import 'package:skru_mate/features/game/domain/use_cases/insert_player_use_case.dart';
import 'package:skru_mate/features/game/domain/use_cases/insert_round_scores_use_case.dart';
import 'package:skru_mate/features/game/domain/use_cases/insert_rounds_use_case.dart';
import 'package:skru_mate/features/games_history/domain/repos/games_history_repo.dart';
import 'package:skru_mate/features/games_history/domain/use_cases/delete_game_use_case.dart';
import 'package:skru_mate/features/games_history/domain/use_cases/get_all_games_use_case.dart';
import 'package:skru_mate/features/games_history/domain/use_cases/get_game_details_use_case.dart';
import 'package:skru_mate/features/players/domain/use_cases/delete_player_use_case.dart';
import 'package:skru_mate/features/players/domain/use_cases/get_all_players_use_case.dart';
import 'package:skru_mate/features/players/domain/use_cases/get_player_by_id_use_case.dart';
import 'package:skru_mate/features/players/domain/use_cases/get_player_game_stats_use_case.dart';
import 'package:skru_mate/features/players/domain/use_cases/update_player_stats_use_case.dart';
import '../../features/game/data/data_sources/game_local_data_source_imp.dart';
import '../../features/game/data/repos/game_repo_imp.dart';
import '../../features/games_history/data/data_sources/games_history_local_data_source_imp.dart';
import '../../features/games_history/data/repos/games_history_repo_imp.dart';
import '../../features/players/data/data_sources/players_local_data_source_imp.dart';
import '../../features/players/data/repos/players_repo_imp.dart';
import '../../features/players/domain/repos/players_repo.dart';
import '../database/app_database.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // Theme
  getIt.registerSingleton<ThemeCubit>(ThemeCubit(prefs));

  // Game Repo
  getIt.registerSingleton<GameRepo>(
    GameRepoImp(
      gameLocalDataSource: GameLocalDataSourceImp(
        appDatabase: AppDatabase().database,
      ),
    ),
  );

  // Players Repo
  getIt.registerSingleton<PlayersRepo>(
    PlayersRepoImp(
      playerLocalDataSource: PlayerLocalDataSourceImp(
        appDatabase: AppDatabase().database,
      ),
    ),
  );

  // Games History Repo
  getIt.registerSingleton<GamesHistoryRepo>(
    GamesHistoryRepoImp(
      gamesLocalDataSource: GamesHistoryLocalDataSourceImpl(
        appDatabase: AppDatabase().database,
      ),
    ),
  );

  // Game Use Cases
  getIt.registerSingleton<InsertGameUseCase>(
    InsertGameUseCase(gameRepo: getIt.get<GameRepo>()),
  );
  getIt.registerSingleton<InsertPlayerUseCase>(
    InsertPlayerUseCase(gameRepo: getIt.get<GameRepo>()),
  );
  getIt.registerSingleton<InsertGamePlayersUseCase>(
    InsertGamePlayersUseCase(gameRepo: getIt.get<GameRepo>()),
  );
  getIt.registerSingleton<InsertRoundsUseCase>(
    InsertRoundsUseCase(gameRepo: getIt.get<GameRepo>()),
  );
  getIt.registerSingleton<InsertRoundScoresUseCase>(
    InsertRoundScoresUseCase(gameRepo: getIt.get<GameRepo>()),
  );

  // Players Use Cases
  getIt.registerSingleton<GetAllPlayersUseCase>(
    GetAllPlayersUseCase(playersRepo: getIt.get<PlayersRepo>()),
  );
  getIt.registerSingleton<GetPlayerByIdUseCase>(
    GetPlayerByIdUseCase(playersRepo: getIt.get<PlayersRepo>()),
  );
  getIt.registerSingleton<UpdatePlayerStatsUseCase>(
    UpdatePlayerStatsUseCase(playersRepo: getIt.get<PlayersRepo>()),
  );
  getIt.registerSingleton<DeletePlayerUseCase>(
    DeletePlayerUseCase(playersRepo: getIt.get<PlayersRepo>()),
  );
  getIt.registerSingleton<GetPlayerGameStatsUseCase>(
    GetPlayerGameStatsUseCase(playersRepo: getIt.get<PlayersRepo>()),
  );

  // Games History Use Cases
  getIt.registerSingleton<GetAllGamesUseCase>(
    GetAllGamesUseCase(gamesHistoryRepo: getIt.get<GamesHistoryRepo>()),
  );
  getIt.registerSingleton<GetGameDetailsUseCase>(
    GetGameDetailsUseCase(gamesHistoryRepo: getIt.get<GamesHistoryRepo>()),
  );
  getIt.registerSingleton<DeleteGameUseCase>(
    DeleteGameUseCase(gamesHistoryRepo: getIt.get<GamesHistoryRepo>()),
  );
}
