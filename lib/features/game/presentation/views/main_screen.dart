import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skru_mate/features/game/data/models/custom_bottom_navigation_item_data.dart';
import 'package:skru_mate/features/game/presentation/views/home_view.dart';
import 'package:skru_mate/features/game/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:skru_mate/features/games_history/presentation/managers/cubits/games_history_cubit/games_history_cubit.dart';
import 'package:skru_mate/features/games_history/presentation/views/previous_games_view.dart';
import 'package:skru_mate/features/players/presentation/managers/cubits/players_cubit/players_cubit.dart';
import 'package:skru_mate/features/players/presentation/views/top_players_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeView(),
    TopPlayersView(),
    PreviousGamesView(),
  ];

  final List<CustomBottomNavigationItemData> _navItems = const [
    CustomBottomNavigationItemData(
      icon: CupertinoIcons.gamecontroller_fill,
      label: 'Play',
    ),
    CustomBottomNavigationItemData(
      icon: CupertinoIcons.chart_bar_square_fill,
      label: 'Leaderboard',
    ),
    CustomBottomNavigationItemData(
      icon: CupertinoIcons.clock_fill,
      label: 'History',
    ),
  ];

  @override
  void initState() {
    super.initState();
    context.read<GamesHistoryCubit>().getAllGames();
    context.read<PlayersCubit>().getAllPlayers();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    extendBody: true,
    body: IndexedStack(index: _currentIndex, children: _screens),
    bottomNavigationBar: CustomBottomNavigationBar(
      currentIndex: _currentIndex,
      items: _navItems,
      onTabSelected: (index) => setState(() => _currentIndex = index),
    ),
  );
}
