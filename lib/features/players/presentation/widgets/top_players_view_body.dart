import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/routing/routes.dart';
import 'package:skru_mate/features/players/data/models/player_details_args.dart';
import '../../../../core/database/shared_models/player_model.dart';
import 'custom_player_item.dart';
import 'custom_sort_item.dart';

class TopPlayersViewBody extends StatefulWidget {
  const TopPlayersViewBody({super.key});

  @override
  State<TopPlayersViewBody> createState() => _TopPlayersViewBodyState();
}

class _TopPlayersViewBodyState extends State<TopPlayersViewBody> {
  final List<PlayerModel> topPlayersList = [
    PlayerModel(
      id: 1,
      name: 'Omar',
      gamesPlayed: 20,
      wins: 12,
      roundWins: 45,
      winRate: 60.0,
      losses: 2,
    ),
    PlayerModel(
      id: 2,
      name: 'Sara',
      gamesPlayed: 18,
      wins: 10,
      roundWins: 39,
      winRate: 55.6,
      losses: 1,
    ),
    PlayerModel(
      id: 3,
      name: 'Mostafa',
      gamesPlayed: 22,
      wins: 8,
      roundWins: 31,
      winRate: 36.3,
      losses: 6,
    ),
    PlayerModel(
      id: 4,
      name: 'Laila',
      gamesPlayed: 15,
      wins: 9,
      roundWins: 28,
      winRate: 60.0,
      losses: 0,
    ),
    PlayerModel(
      id: 5,
      name: 'Ahmed',
      gamesPlayed: 25,
      wins: 14,
      roundWins: 50,
      winRate: 56.0,
      losses: 4,
    ),
    PlayerModel(
      id: 6,
      name: 'Nour',
      gamesPlayed: 10,
      wins: 4,
      roundWins: 17,
      winRate: 40.0,
      losses: 3,
    ),
    PlayerModel(
      id: 7,
      name: 'Youssef',
      gamesPlayed: 30,
      wins: 16,
      roundWins: 52,
      winRate: 53.3,
      losses: 5,
    ),
    PlayerModel(
      id: 8,
      name: 'Mariam',
      gamesPlayed: 12,
      wins: 5,
      roundWins: 20,
      winRate: 41.6,
      losses: 2,
    ),
    PlayerModel(
      id: 9,
      name: 'Ziad',
      gamesPlayed: 17,
      wins: 6,
      roundWins: 25,
      winRate: 35.2,
      losses: 7,
    ),
    PlayerModel(
      id: 10,
      name: 'Farah',
      gamesPlayed: 14,
      wins: 7,
      roundWins: 29,
      winRate: 50.0,
      losses: 1,
    ),
  ];

  final List<String> sortOptions = [
    'Games Played',
    'Wins',
    'Round Wins',
    'Win Rate',
    'Losses',
  ];

  int selectedSortIndex = 0;
  int lastSelectedSortIndex = -1;

  late List<PlayerModel> sortedPlayers; // Copy of the original
  late Map<String, Map<dynamic, int>> ranksMap;

  void sortPlayers() {
    if (lastSelectedSortIndex != selectedSortIndex) {
      switch (selectedSortIndex) {
        case 0:
          sortedPlayers.sort((a, b) => b.gamesPlayed.compareTo(a.gamesPlayed));
          break;
        case 1:
          sortedPlayers.sort((a, b) => b.wins.compareTo(a.wins));
          break;
        case 2:
          sortedPlayers.sort((a, b) => b.roundWins.compareTo(a.roundWins));
          break;
        case 3:
          sortedPlayers.sort((a, b) => b.winRate.compareTo(a.winRate));
          break;
        case 4:
          sortedPlayers.sort((a, b) => a.losses.compareTo(b.losses));
          break;
      }
      lastSelectedSortIndex = selectedSortIndex;
      setState(() {});
    }
  }

  dynamic getValueBySortIndex(PlayerModel player, int index) {
    switch (index) {
      case 0:
        return player.gamesPlayed;
      case 1:
        return player.wins;
      case 2:
        return player.roundWins;
      case 3:
        return player.winRate;
      case 4:
        return player.losses;
      default:
        return player.wins;
    }
  }

  void calculateRanks() {
    ranksMap = {};

    for (int i = 0; i < sortOptions.length; i++) {
      final statName = sortOptions[i];
      final Map<dynamic, int> statRanks = {};

      // Create a list of all values for this stat
      final values = topPlayersList
          .map((player) => getValueBySortIndex(player, i))
          .toList();

      // Remove duplicates and sort
      final unique = values.toSet().toList();
      if (i != 4) {
        unique.sort((a, b) => b.compareTo(a)); // Higher is better
      } else {
        unique.sort((a, b) => a.compareTo(b)); // Losses: lower is better
      }

      for (int j = 0; j < unique.length; j++) {
        statRanks[unique[j]] = j + 1; // Rank starts at 1
      }

      ranksMap[statName] = statRanks;
    }
  }

  @override
  void initState() {
    super.initState();
    sortedPlayers = List<PlayerModel>.from(topPlayersList);
    sortedPlayers.sort((a, b) => b.gamesPlayed.compareTo(a.gamesPlayed));
    calculateRanks();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(sortOptions.length, (index) {
              final String sortOption = sortOptions[index];
              final bool isSelected = selectedSortIndex == index;
              return CustomSortItem(
                onTap: () {
                  selectedSortIndex = index;
                  sortPlayers();
                },
                isSelected: isSelected,
                sortOption: sortOption,
                marginToRight: index == sortOptions.length - 1,
              );
            }),
          ),
        ),
        Gap(8.h),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: List.generate(sortedPlayers.length, (index) {
                final PlayerModel player = sortedPlayers[index];
                final playerStatValue = getValueBySortIndex(
                  player,
                  selectedSortIndex,
                );
                final rank =
                    ranksMap[sortOptions[selectedSortIndex]]?[playerStatValue] ??
                    0;

                return CustomPlayerItem(
                      player: player,
                      index: index + 1,
                      rank: rank,
                      selectedSortIndex: selectedSortIndex,
                      marginToBottom: index == sortedPlayers.length - 1,
                      onTap: () {
                        final statRanks = getStatRanks(player);
                        context.pushNamed(
                          Routes.playerView,
                          arguments: PlayerDetailsArgs(
                            player: player,
                            statRanks: statRanks,
                          ),
                        );
                      },
                    )
                    .animate(delay: Duration(milliseconds: 50 * index))
                    .slideY(begin: 0.2, duration: 300.ms)
                    .fadeIn(duration: 300.ms);
              }),
            ),
          ),
        ),
      ],
    );
  }

  Map<String, int> getStatRanks(PlayerModel player) {
    return {
      for (int i = 0; i < sortOptions.length; i++)
        sortOptions[i]:
            ranksMap[sortOptions[i]]?[getValueBySortIndex(player, i)] ?? 0,
    };
  }
}
