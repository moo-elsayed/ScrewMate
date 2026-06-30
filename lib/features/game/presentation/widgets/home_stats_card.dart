import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skru_mate/core/theming/app_decorations.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';
import 'package:skru_mate/features/game/presentation/widgets/home_stat_item.dart';
import 'package:skru_mate/features/games_history/presentation/managers/cubits/games_history_cubit/games_history_cubit.dart';
import 'package:skru_mate/features/games_history/presentation/managers/cubits/games_history_cubit/games_history_states.dart'
    hide GetAllPlayersLoading, GetAllPlayersSuccess, GetAllPlayersFailure;
import 'package:skru_mate/features/players/presentation/managers/cubits/players_cubit/players_cubit.dart';
import 'package:skru_mate/features/players/presentation/managers/cubits/players_cubit/players_states.dart';

class HomeStatsCard extends StatelessWidget {
  const HomeStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: AppDecorations.glassCard(colors),
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<GamesHistoryCubit, GamesHistoryStates>(
              builder: (context, state) => HomeStatItem(
                icon: Icons.sports_esports_outlined,
                title: 'Games Played',
                value: context.read<GamesHistoryCubit>().allGames.length.toString(),
              ),
            ),
          ),
          Container(
            height: 40.h,
            width: 1,
            color: colors.border.withValues(alpha: 0.2),
          ),
          Expanded(
            child: BlocBuilder<PlayersCubit, PlayersStates>(
              builder: (context, state) => HomeStatItem(
                icon: Icons.people_outline,
                title: 'Total Players',
                value: context.read<PlayersCubit>().allPlayers.length.toString(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
