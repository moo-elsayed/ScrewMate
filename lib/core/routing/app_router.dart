import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skru_mate/core/routing/routes.dart';
import 'package:skru_mate/features/game/data/models/game_args.dart';
import 'package:skru_mate/features/game/presentation/views/game_view.dart';
import 'package:skru_mate/features/games_history/presentation/views/game_result_view.dart';
import 'package:skru_mate/features/games_history/presentation/views/previous_games_view.dart';
import 'package:skru_mate/features/players/presentation/views/player_view.dart';
import 'package:skru_mate/features/players/presentation/views/top_players_view.dart';
import '../../features/game/data/models/add_players_args.dart';
import '../../features/game/presentation/views/add_players_view.dart';
import '../../features/game/presentation/views/home_view.dart';
import '../../features/games_history/data/models/game_result_view_args.dart';
import '../../features/players/data/models/player_details_args.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.homeView:
        return _navigate(const HomeView());
      case Routes.addPlayersView:
        final args = arguments as AddPlayersArgs;
        return _navigate(
          AddPlayersView(
            roundsCount: args.roundsCount,
            playersCount: args.playersCount,
          ),
        );
      case Routes.topPlayersView:
        return _navigate(const TopPlayersView());
      case Routes.playerView:
        final args = arguments as PlayerDetailsArgs;
        return _navigate(PlayerView(playerDetailsArgs: args));
      case Routes.previousGamesView:
        return _navigate(const PreviousGamesView());
      case Routes.gameView:
        final args = arguments as GameArgs;
        return _navigate(GameView(gameArgs: args));
      case Routes.gameResultView:
        final args = arguments as GameResultViewArgs;
        return _navigate(GameResultView(gameResultViewArgs: args));
      default:
        return null;
    }
  }

  PageRouteBuilder<dynamic> _navigate(Widget view) => PageRouteBuilder(
    pageBuilder: (_, __, ___) => view,
    transitionsBuilder: (_, animation, __, child) => FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      child: child,
    ),
  );
}
