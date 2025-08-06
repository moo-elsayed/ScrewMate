import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/theming/colors.dart';
import 'package:skru_mate/features/games_history/presentation/managers/cubits/games_history_cubit/games_history_states.dart';
import '../../../../core/database/shared_models/game_model.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../managers/cubits/games_history_cubit/games_history_cubit.dart';
import 'custom_previous_games_item.dart';

class PreviousGamesViewBody extends StatefulWidget {
  const PreviousGamesViewBody({super.key});

  @override
  State<PreviousGamesViewBody> createState() => _PreviousGamesViewBodyState();
}

class _PreviousGamesViewBodyState extends State<PreviousGamesViewBody> {
  late List<GameModel> previousGames;

  @override
  void initState() {
    super.initState();
    context.read<GamesHistoryCubit>().getAllGames();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GamesHistoryCubit, GamesHistoryStates>(
      listener: (context, state) {
        if (state is GetAllGamesSuccess) {
          previousGames = state.games;
        } else if (state is ReverseListSuccess) {
          previousGames = previousGames.reversed.toList();
        }
      },
      builder: (context, state) {
        if (state is GetAllGamesSuccess || state is ReverseListSuccess) {
          return ListView.separated(
            // padding: EdgeInsets.only(right: 12.w, left: 12.w),
            physics: const BouncingScrollPhysics(),
            itemCount: previousGames.length,
            separatorBuilder: (_, __) => Divider(
              color: ColorsManager.purple,
              height: 0.h,
              endIndent: 12.w,
              indent: 12.w,
            ),
            itemBuilder: (context, index) {
              final game = previousGames[index];
              return Slidable(
                key: ValueKey<GameModel>(game),
                startActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) => ConfirmationDialog(
                            name: 'Game #${game.id}',
                            onDelete: () {
                              context.read<GamesHistoryCubit>().deleteGame(
                                gameId: previousGames[index].id!,
                              );
                              previousGames.remove(game);
                              context.pop();
                              showCustomToast(
                                context: context,
                                message: 'Game #${game.id} deleted',
                                contentType: ContentType.success,
                              );
                              setState(() {});
                            },
                          ),
                        );
                      },
                      backgroundColor: Theme.of(
                        context,
                      ).scaffoldBackgroundColor,
                      foregroundColor: Colors.red,
                      icon: Icons.delete_outline,
                      label: 'Delete',
                      borderRadius: BorderRadius.circular(12.r),
                      spacing: 6,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(right: 12.w, left: 12.w),
                  child: CustomPreviousGamesItem(
                    game: game,
                    index: index,
                    onTap: () {
                      log(game.date);
                    },
                  ),
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
}
