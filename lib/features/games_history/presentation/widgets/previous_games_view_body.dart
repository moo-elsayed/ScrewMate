import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/routing/routes.dart';
import 'package:skru_mate/core/theming/app_colors.dart';
import 'package:skru_mate/features/games_history/data/models/game_result_view_args.dart';
import 'package:skru_mate/features/games_history/presentation/managers/cubits/games_history_cubit/games_history_states.dart';
import 'package:skru_mate/features/players/presentation/managers/cubits/players_cubit/players_cubit.dart';
import '../../../../core/database/shared_entities/game_entity.dart';
import '../../../../core/database/shared_entities/player_entity.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/theming/colors_manager.dart';
import '../../../../core/widgets/app_toasts.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../managers/cubits/games_history_cubit/games_history_cubit.dart';
import 'custom_previous_games_item.dart';

class PreviousGamesViewBody extends StatefulWidget {
  const PreviousGamesViewBody({super.key});

  @override
  State<PreviousGamesViewBody> createState() => _PreviousGamesViewBodyState();
}

class _PreviousGamesViewBodyState extends State<PreviousGamesViewBody> {
  List<GameEntity> previousGames = [];
  List<PlayerEntity> allPlayersList = [];
  final validStates = [
    GetAllGamesSuccess,
    GetAllPlayersSuccess,
    GetGameDetailsSuccess,
    GetGameDetailsFailure,
    GetGameDetailsLoading,
    ReverseListSuccess,
  ];

  @override
  void initState() {
    super.initState();
    context.read<GamesHistoryCubit>().getAllGames();
    context.read<GamesHistoryCubit>().getAllPlayers();
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<GamesHistoryCubit, GamesHistoryStates>(
        listener: (context, state) {
          if (state is GetAllGamesSuccess) {
            previousGames = state.games;
          } else if (state is GetAllPlayersSuccess) {
            allPlayersList = state.players;
          } else if (state is ReverseListSuccess) {
            previousGames = previousGames.reversed.toList();
          }
        },
        builder: (context, state) {
          final colors = context.colors;
          if (validStates.any((type) => state.runtimeType == type)) {
            return previousGames.isEmpty
                ? Center(
                    child: Text(
                      'No previous games yet',
                      style: AppTextStyles.font16Regular.copyWith(color: colors.mainText),
                    ),
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      top: 8.h,
                      bottom: 75.h,
                      left: 16.w,
                      right: 16.w,
                    ),
                    itemCount: previousGames.length,
                    separatorBuilder: (_, __) =>
                        Divider(color: AppColors.purple, height: 0.h),
                    itemBuilder: (context, index) {
                      final game = previousGames[index];
                      return Slidable(
                        key: ValueKey<GameEntity>(game),
                        startActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          extentRatio: 0.25,
                          children: [
                            SlidableAction(
                              onPressed: (actionContext) {
                                final gamesHistoryCubit = context
                                    .read<GamesHistoryCubit>();
                                final playersCubit = context
                                    .read<PlayersCubit>();
                                final gameId = game.id!;

                                ConfirmationDialog.show(
                                  actionContext,
                                  name: 'Game #${game.id}',
                                  onDelete: () async {
                                    context.pop();

                                    await gamesHistoryCubit.deleteGame(
                                      gameId: gameId,
                                    );
                                    await gamesHistoryCubit.getAllGames();
                                    await playersCubit.getAllPlayers();

                                    if (context.mounted) {
                                      AppToast.show(
                                        context: context,
                                        title: 'Game #$gameId deleted',
                                        type: .success,
                                      );
                                    }
                                  },
                                );
                              },
                              backgroundColor: Theme.of(
                                context,
                              ).scaffoldBackgroundColor,
                              foregroundColor: Colors.red,
                              icon: Icons.delete_outline,
                              label: 'Delete',
                              borderRadius: BorderRadius.circular(12.r),
                              spacing: 3,
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 3.h,
                              ),
                            ),
                          ],
                        ),
                        child: CustomPreviousGamesItem(
                          game: game,
                          isFirst: index == 0,
                          isLast: index == previousGames.length - 1,
                          index: index,
                          onTap: () {
                            context.pushNamed(
                              Routes.gameResultView,
                              arguments: GameResultViewArgs(
                                gameId: game.id!,
                                allPlayersList: allPlayersList,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
          } else {
            return const SizedBox();
          }
        },
      );
}
