import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skru_mate/core/theming/app_theme.dart';
import 'package:skru_mate/core/theming/theme_cubit.dart';
import 'package:skru_mate/features/games_history/data/repos/games_history_repo_imp.dart';
import 'package:skru_mate/features/games_history/presentation/managers/cubits/games_history_cubit/games_history_cubit.dart';
import 'core/helpers/di.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'features/game/domain/repos/game_repo.dart';
import 'features/game/presentation/managers/cubits/game_cubit/game_cubit.dart';
import 'features/players/domain/repos/players_repo.dart';
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
            create: (context) =>
                PlayersCubit(playersRepo: getIt.get<PlayersRepo>()),
          ),
          BlocProvider(
            create: (context) => GameCubit(
              gameRepo: getIt.get<GameRepo>(),
              playersRepo: getIt.get<PlayersRepo>(),
            ),
          ),
          BlocProvider(
            create: (context) => GamesHistoryCubit(
              playersRepo: getIt.get<PlayersRepo>(),
              gamesHistoryRepo: getIt.get<GamesHistoryRepoImp>(),
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
