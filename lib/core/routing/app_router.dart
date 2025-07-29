import 'package:flutter/material.dart';
import 'package:skru_mate/core/routing/routes.dart';
import 'package:skru_mate/features/home/presentation/views/home_view.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.homeView:
        return MaterialPageRoute(builder: (context) => const HomeView());
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
