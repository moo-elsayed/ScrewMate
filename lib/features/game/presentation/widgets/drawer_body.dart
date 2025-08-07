import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skru_mate/core/database/shared_models/player_model.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/routing/routes.dart';
import 'package:skru_mate/core/theming/styles.dart';
import 'package:skru_mate/features/game/presentation/managers/cubits/game_cubit/game_cubit.dart';
import 'package:skru_mate/features/game/presentation/managers/cubits/game_cubit/game_states.dart';
import 'drawer_item.dart';

class DrawerBody extends StatefulWidget {
  const DrawerBody({super.key});

  @override
  State<DrawerBody> createState() => _DrawerBodyState();
}

class _DrawerBodyState extends State<DrawerBody> {
  late List<PlayerModel> players;

  @override
  void initState() {
    super.initState();
    context.read<GameCubit>().getAllPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameCubit, GameStates>(
      listener: (context, state) {
        if (state is GetAllPlayersSuccess) {
          players = state.players;
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('ScrewMate', style: TextStyles.font24WhiteSemibold),
            ),
            Divider(height: 64.h, indent: 10.w, endIndent: 10.w),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DrawerItem(
                title: 'Previous Games',
                onTap: () {
                  context.pushNamed(
                    Routes.previousGamesView,
                    arguments: players,
                  );
                },
              ),
            ),
            Gap(24.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DrawerItem(
                title: 'Top Players',
                onTap: () {
                  context.pushNamed(Routes.topPlayersView, arguments: players);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
