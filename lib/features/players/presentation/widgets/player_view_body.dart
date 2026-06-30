import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/database/shared_models/player_model.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';
import 'package:skru_mate/features/players/data/models/player_games_states_model.dart';
import 'package:skru_mate/features/players/presentation/managers/cubits/players_cubit/players_cubit.dart';
import 'package:skru_mate/features/players/presentation/managers/cubits/players_cubit/players_states.dart';
import 'package:skru_mate/features/players/presentation/widgets/all_previous_games_for_player_bottom_sheet.dart';
import 'package:skru_mate/features/players/presentation/widgets/player_stats_grid_view.dart';
import 'package:skru_mate/features/players/presentation/widgets/player_view_header.dart';
import 'package:skru_mate/features/players/presentation/widgets/player_win_loss_bar.dart';
import 'package:skru_mate/features/players/presentation/widgets/previous_games_for_player_list_view.dart';
import '../../data/models/player_details_args.dart';

class PlayerViewBody extends StatefulWidget {
  const PlayerViewBody({
    super.key,
    required this.playerDetailsArgs,
    required this.playerName,
  });

  final PlayerDetailsArgs playerDetailsArgs;
  final String playerName;

  @override
  State<PlayerViewBody> createState() => _PlayerViewBodyState();
}

class _PlayerViewBodyState extends State<PlayerViewBody> {
  late List<PlayerGameStatsModel> playerGameStatsList;
  late List<PlayerModel> players;

  final validStates = [
    GetPlayerGamesStatesSuccess,
    GetAllPlayersSuccess,
    UpdatePlayerStatsSuccess,
    UpdatePlayerStatsLoading,
  ];

  @override
  void initState() {
    super.initState();
    final PlayerDetailsArgs playerDetailsArgs = widget.playerDetailsArgs;
    players = playerDetailsArgs.playersList;
    context.read<PlayersCubit>().getPlayerGameStats(
      playerDetailsArgs.player.id!,
    );
    playerGameStatsList = [];
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final PlayerModel player = widget.playerDetailsArgs.player;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: BlocConsumer<PlayersCubit, PlayersStates>(
        listener: (context, state) {
          if (state is GetPlayerGamesStatesSuccess) {
            playerGameStatsList = state.playerGameStatsList;
          } else if (state is GetAllPlayersSuccess) {
            players = state.players;
          }
        },
        builder: (context, state) {
          final hasGames = playerGameStatsList.isNotEmpty;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. Player Header
              SliverToBoxAdapter(
                child: PlayerViewHeader(
                  player: player,
                  playerName: widget.playerName,
                ),
              ),

              // 2. Win/Loss Split Bar
              SliverToBoxAdapter(
                child: PlayerWinLossBar(player: player),
              ),

              SliverToBoxAdapter(child: Gap(8.h)),

              // 3. Stats Grid
              SliverToBoxAdapter(
                child: PlayerStatsGridView(playerDetailsArgs: widget.playerDetailsArgs),
              ),

              // 4. Previous Games Section Header
              if (hasGames)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 24.h, bottom: 8.h, left: 4.w, right: 4.w),
                    child: GestureDetector(
                      onTap: () {
                        if (playerGameStatsList.length > 5) {
                          _showAllGames(context);
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Previous Games',
                            style: GoogleFonts.lato(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w900,
                              color: colors.mainText,
                            ),
                          ),
                          if (playerGameStatsList.length > 5)
                            Row(
                              children: [
                                Text(
                                  'See All (${playerGameStatsList.length})',
                                  style: GoogleFonts.lato(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: colors.primary,
                                  ),
                                ),
                                Gap(4.w),
                                Icon(
                                  CupertinoIcons.chevron_right,
                                  size: 14.r,
                                  color: colors.primary,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

              // 5. Previous Games List
              if (hasGames)
                SliverToBoxAdapter(
                  child: PreviousGamesForPlayerListView(
                    playerGameStatsList: playerGameStatsList,
                    players: players,
                  ),
                ),

              SliverToBoxAdapter(child: Gap(30.h)),
            ],
          );
        },
      ),
    );
  }

  void _showAllGames(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      isScrollControlled: true,
      builder: (_) => AllPreviousGamesForPlayerBottomSheet(
        playerGameStatsList: playerGameStatsList,
        players: players,
      ),
    );
  }
}
