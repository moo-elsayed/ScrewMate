import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/database/shared_models/player_model.dart';
import 'package:skru_mate/features/players/data/models/player_games_states_model.dart';
import 'package:skru_mate/features/players/presentation/managers/cubits/players_cubit/players_cubit.dart';
import 'package:skru_mate/features/players/presentation/managers/cubits/players_cubit/players_states.dart';
import 'package:skru_mate/features/players/presentation/widgets/all_previous_games_for_player_bottom_sheet.dart';
import 'package:skru_mate/features/players/presentation/widgets/player_stats_grid_view.dart';
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
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.only(top: 16.h, right: 12.w, left: 12.w),
      child: Column(
        children: [
          PlayerStatsGridView(playerDetailsArgs: widget.playerDetailsArgs),
          BlocConsumer<PlayersCubit, PlayersStates>(
            listener: (context, state) {
              if (state is GetPlayerGamesStatesSuccess) {
                playerGameStatsList = state.playerGameStatsList;
              } else if (state is GetAllPlayersSuccess) {
                players = state.players;
              }
            },
            builder: (context, state) {
              if (validStates.any((type) => state.runtimeType == type) &&
                  playerGameStatsList.isNotEmpty) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(48.w),
                        GestureDetector(
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
                                'Previous Games for ${widget.playerName}',
                                style: GoogleFonts.lato(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (playerGameStatsList.length > 5)
                                Padding(
                                  padding: EdgeInsets.only(bottom: 1.h),
                                  child: Icon(
                                    CupertinoIcons.chevron_right,
                                    size: 18.r,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: PreviousGamesForPlayerListView(
                            playerGameStatsList: playerGameStatsList,
                            players: players,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );

  void _showAllGames(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      isScrollControlled: true,
      builder: (_) => AllPreviousGamesForPlayerBottomSheet(
          playerGameStatsList: playerGameStatsList,
          players: players,
        ),
    );
  }
}
