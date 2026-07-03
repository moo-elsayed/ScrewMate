import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/routing/routes.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';
import 'package:skru_mate/features/players/data/models/player_details_args.dart';
import 'package:skru_mate/features/players/presentation/managers/cubits/players_cubit/players_cubit.dart';
import 'package:skru_mate/features/players/presentation/managers/cubits/players_cubit/players_states.dart';
import '../../../../core/database/shared_entities/player_entity.dart';
import 'custom_player_item.dart';
import 'custom_sort_item.dart';

class TopPlayersViewBody extends StatefulWidget {
  const TopPlayersViewBody({super.key});

  @override
  State<TopPlayersViewBody> createState() => _TopPlayersViewBodyState();
}

class _TopPlayersViewBodyState extends State<TopPlayersViewBody> {
  late List<PlayerEntity> topPlayersList;

  final List<String> sortOptions = [
    'Games Played',
    'Wins',
    'Round Wins',
    'Win Rate',
    'Losses',
  ];

  final validStates = [
    GetAllPlayersSuccess,
    ReverseListSuccess,
    GetPlayerGamesStatesSuccess,
    GetPlayerGamesStatesFailure,
    GetPlayerGamesStatesLoading,
  ];

  int selectedSortIndex = 0;
  int lastSelectedSortIndex = -1;

  late List<PlayerEntity> sortedPlayers;
  late Map<String, Map<dynamic, int>> ranksMap;

  @override
  void initState() {
    super.initState();
    context.read<PlayersCubit>().getAllPlayers();
  }

  void sortPlayers() {
    if (lastSelectedSortIndex != selectedSortIndex) {
      switch (selectedSortIndex) {
        case 0:
          sortedPlayers.sort((a, b) => b.gamesPlayed.compareTo(a.gamesPlayed));
        case 1:
          sortedPlayers.sort((a, b) => b.wins.compareTo(a.wins));
        case 2:
          sortedPlayers.sort((a, b) => b.roundWins.compareTo(a.roundWins));
        case 3:
          sortedPlayers.sort((a, b) => b.winRate.compareTo(a.winRate));
        case 4:
          sortedPlayers.sort((a, b) => a.losses.compareTo(b.losses));
      }
      lastSelectedSortIndex = selectedSortIndex;
      setState(() {});
    }
  }

  dynamic getValueBySortIndex(PlayerEntity player, int index) {
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

  String getValueString(PlayerEntity player) {
    switch (selectedSortIndex) {
      case 0:
        return '${player.gamesPlayed} games';
      case 1:
        return '${player.wins} wins';
      case 2:
        return '${player.roundWins} rounds';
      case 3:
        return '${(player.winRate).toStringAsFixed(1)}%';
      case 4:
        return '${player.losses} losses';
      default:
        return '';
    }
  }

  void calculateRanks() {
    ranksMap = {};

    for (int i = 0; i < sortOptions.length; i++) {
      final statName = sortOptions[i];
      final Map<dynamic, int> statRanks = {};

      final values = topPlayersList
          .map((player) => getValueBySortIndex(player, i))
          .toList();

      final unique = values.toSet().toList();
      if (i != 4) {
        unique.sort((a, b) => b.compareTo(a));
      } else {
        unique.sort((a, b) => a.compareTo(b));
      }

      for (int j = 0; j < unique.length; j++) {
        statRanks[unique[j]] = j + 1;
      }

      ranksMap[statName] = statRanks;
    }
  }

  Map<String, int> getStatRanks(PlayerEntity player) => {
    for (int i = 0; i < sortOptions.length; i++)
      sortOptions[i]:
          ranksMap[sortOptions[i]]?[getValueBySortIndex(player, i)] ?? 0,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocConsumer<PlayersCubit, PlayersStates>(
      listener: (context, state) {
        if (state is ReverseListSuccess) {
          sortedPlayers = sortedPlayers.reversed.toList();
        } else if (state is GetAllPlayersSuccess) {
          topPlayersList = state.players;
          sortedPlayers = List<PlayerEntity>.from(topPlayersList);
          sortedPlayers.sort((a, b) => b.gamesPlayed.compareTo(a.gamesPlayed));
          calculateRanks();
        }
      },
      builder: (context, state) {
        if (validStates.any((type) => state.runtimeType == type)) {
          return Column(
            children: [
              Gap(8.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
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
                child: sortedPlayers.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'There are no players yet',
                            style: GoogleFonts.lato(
                              fontSize: 16.sp,
                              color: colors.subText,
                            ),
                          ),
                        ],
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          bottom: 75.h,
                        ),
                        itemCount: sortedPlayers.length,
                        separatorBuilder: (context, index) => Gap(8.h),
                        itemBuilder: (context, index) {
                          final PlayerEntity player = sortedPlayers[index];
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
                                marginToBottom:
                                    index == sortedPlayers.length - 1,
                                onTap: () {
                                  final statRanks = getStatRanks(player);
                                  context.pushNamed(
                                    Routes.playerView,
                                    arguments: PlayerDetailsArgs(
                                      player: player,
                                      statRanks: statRanks,
                                      playersList: topPlayersList,
                                    ),
                                  );
                                },
                              )
                              .animate(
                                delay: Duration(milliseconds: 30 * index),
                              )
                              .slideY(begin: 0.15, duration: 250.ms)
                              .fadeIn(duration: 250.ms);
                        },
                      ),
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
