import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/helpers/dependency_injection.dart';
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
  Widget build(BuildContext context) {
    return ScreenUtilInit(
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
        ],

        child: MaterialApp(
          title: 'ScrewMate',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(),
          initialRoute: Routes.homeView,
          onGenerateRoute: appRouter.generateRoute,
        ),
      ),
    );
  }
}
