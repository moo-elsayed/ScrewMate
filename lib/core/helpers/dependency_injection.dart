import 'package:get_it/get_it.dart';
import 'package:skru_mate/features/game/domain/repos/game_repo.dart';
import '../../features/game/data/data_sources/game_local_data_source_imp.dart';
import '../../features/game/data/repos/game_repo_imp.dart';
import '../../features/games_history/data/data_sources/games_history_local_data_source_imp.dart';
import '../../features/games_history/data/repos/games_history_repo_imp.dart';
import '../../features/players/data/data_sources/players_local_data_source_imp.dart';
import '../../features/players/data/repos/players_repo_imp.dart';
import '../../features/players/domain/repos/players_repo.dart';
import '../database/app_database.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<GameRepo>(
    GameRepoImp(
      gameLocalDataSource: GameLocalDataSourceImp(
        appDatabase: AppDatabase().database,
      ),
    ),
  );
  getIt.registerSingleton<PlayersRepo>(
    PlayersRepoImp(
      playerLocalDataSource: PlayerLocalDataSourceImp(
        appDatabase: AppDatabase().database,
      ),
    ),
  );
  getIt.registerSingleton<GamesHistoryRepoImp>(
    GamesHistoryRepoImp(
      gamesLocalDataSource: GamesHistoryLocalDataSourceImpl(
        appDatabase: AppDatabase().database,
      ),
    ),
  );
}
