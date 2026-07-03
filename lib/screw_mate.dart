import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skru_mate/core/theming/app_theme.dart';
import 'package:skru_mate/core/theming/theme_cubit.dart';
import 'package:skru_mate/features/game/domain/use_cases/insert_game_players_use_case.dart';
import 'package:skru_mate/features/game/domain/use_cases/insert_game_use_case.dart';
import 'package:skru_mate/features/game/domain/use_cases/insert_player_use_case.dart';
import 'package:skru_mate/features/game/domain/use_cases/insert_round_scores_use_case.dart';
import 'package:skru_mate/features/game/domain/use_cases/insert_rounds_use_case.dart';
import 'package:skru_mate/features/games_history/domain/use_cases/delete_game_use_case.dart';
import 'package:skru_mate/features/games_history/domain/use_cases/get_all_games_use_case.dart';
import 'package:skru_mate/features/games_history/domain/use_cases/get_game_details_use_case.dart';
import 'package:skru_mate/features/games_history/presentation/managers/cubits/games_history_cubit/games_history_cubit.dart';
import 'package:skru_mate/features/players/domain/use_cases/delete_player_use_case.dart';
import 'package:skru_mate/features/players/domain/use_cases/get_all_players_use_case.dart';
import 'package:skru_mate/features/players/domain/use_cases/get_player_by_id_use_case.dart';
import 'package:skru_mate/features/players/domain/use_cases/get_player_game_stats_use_case.dart';
import 'package:skru_mate/features/players/domain/use_cases/update_player_stats_use_case.dart';
import 'core/helpers/di.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'features/game/presentation/managers/cubits/game_cubit/game_cubit.dart';
import 'features/players/presentation/managers/cubits/players_cubit/players_cubit.dart';

class ScrewMate extends StatelessWidget {
  const ScrewMate({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => PlayersCubit(
              getAllPlayersUseCase: getIt.get<GetAllPlayersUseCase>(),
              updatePlayerStatsUseCase: getIt.get<UpdatePlayerStatsUseCase>(),
              getPlayerByIdUseCase: getIt.get<GetPlayerByIdUseCase>(),
              deletePlayerUseCase: getIt.get<DeletePlayerUseCase>(),
              getPlayerGameStatsUseCase: getIt.get<GetPlayerGameStatsUseCase>(),
            ),
          ),
          BlocProvider(
            create: (context) => GameCubit(
              insertGameUseCase: getIt.get<InsertGameUseCase>(),
              insertGamePlayersUseCase: getIt.get<InsertGamePlayersUseCase>(),
              insertRoundsUseCase: getIt.get<InsertRoundsUseCase>(),
              insertRoundScoresUseCase: getIt.get<InsertRoundScoresUseCase>(),
              insertPlayerUseCase: getIt.get<InsertPlayerUseCase>(),
              getAllPlayersUseCase: getIt.get<GetAllPlayersUseCase>(),
              updatePlayerStatsUseCase: getIt.get<UpdatePlayerStatsUseCase>(),
            ),
          ),
          BlocProvider(
            create: (context) => GamesHistoryCubit(
              getAllGamesUseCase: getIt.get<GetAllGamesUseCase>(),
              getGameDetailsUseCase: getIt.get<GetGameDetailsUseCase>(),
              deleteGameUseCase: getIt.get<DeleteGameUseCase>(),
              getAllPlayersUseCase: getIt.get<GetAllPlayersUseCase>(),
            ),
          ),
          BlocProvider(
            create: (context) => getIt.get<ThemeCubit>(),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) => MaterialApp(
            title: 'ScrewMate',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            initialRoute: Routes.mainScreen,
            onGenerateRoute: appRouter.generateRoute,
          ),
        ),
      ),
    );
}
