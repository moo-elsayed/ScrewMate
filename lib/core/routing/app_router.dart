import 'package:flutter/material.dart';
import 'package:skru_mate/core/database/shared_models/player_model.dart';
import 'package:skru_mate/core/routing/routes.dart';
import 'package:skru_mate/features/players/presentation/views/player_view.dart';
import 'package:skru_mate/features/players/presentation/views/top_players_view.dart';

import '../../features/game/data/models/add_players_args.dart';
import '../../features/game/presentation/views/add_players_view.dart';
import '../../features/game/presentation/views/home_view.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.homeView:
        return MaterialPageRoute(builder: (context) => const HomeView());
      case Routes.addPlayersView:
        final args = arguments as AddPlayersArgs;
        return MaterialPageRoute(
          builder: (context) => AddPlayersView(
            roundsCount: args.roundsCount,
            playersCount: args.playersCount,
          ),
        );
      case Routes.topPlayersView:
        return MaterialPageRoute(builder: (context) => const TopPlayersView());
      case Routes.playerView:
        final args = arguments as PlayerModel;
        return MaterialPageRoute(
          builder: (context) => PlayerView(playerModel: args),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('No route defined for this ${settings.name}'),
            ),
          ),
        );
    }
  }
}
