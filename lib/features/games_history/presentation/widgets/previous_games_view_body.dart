import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/theming/colors.dart';
import '../../../../core/database/shared_models/game_model.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../core/widgets/delete_confirmation_dialog.dart';
import 'custom_previous_games_item.dart';

class PreviousGamesViewBody extends StatefulWidget {
  const PreviousGamesViewBody({super.key});

  @override
  State<PreviousGamesViewBody> createState() => _PreviousGamesViewBodyState();
}

class _PreviousGamesViewBodyState extends State<PreviousGamesViewBody> {
  final List<GameModel> previousGames = [
    GameModel(
      id: 1,
      date: '2025-07-28',
      roundsCount: 5,
      winnerId: 3,
      winnerName: 'Sara',
    ),
    GameModel(
      id: 2,
      date: '2025-07-26',
      roundsCount: 4,
      winnerId: 1,
      winnerName: 'Omar',
    ),
    GameModel(
      id: 3,
      date: '2025-07-24',
      roundsCount: 6,
      winnerId: 5,
      winnerName: 'Ahmed',
    ),
    GameModel(
      id: 4,
      date: '2025-07-22',
      roundsCount: 3,
      winnerId: 4,
      winnerName: 'Laila',
    ),
    GameModel(
      id: 5,
      date: '2025-07-20',
      roundsCount: 5,
      winnerId: 2,
      winnerName: 'Mostafa',
    ),
    GameModel(
      id: 6,
      date: '2025-07-18',
      roundsCount: 4,
      winnerId: 6,
      winnerName: 'Nour',
    ),
    GameModel(
      id: 7,
      date: '2025-07-16',
      roundsCount: 7,
      winnerId: 7,
      winnerName: 'Youssef',
    ),
    GameModel(
      id: 8,
      date: '2025-07-14',
      roundsCount: 6,
      winnerId: 8,
      winnerName: 'Mariam',
    ),
    GameModel(
      id: 9,
      date: '2025-07-12',
      roundsCount: 5,
      winnerId: 9,
      winnerName: 'Ziad',
    ),
    GameModel(
      id: 10,
      date: '2025-07-10',
      roundsCount: 3,
      winnerId: 10,
      winnerName: 'Farah',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                    builder: (context) => DeleteConfirmationDialog(
                      name: 'Game #${game.id}',
                      onDelete: () {
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
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                foregroundColor: Colors.red,
                icon: Icons.delete_outline,
                label: 'Delete',
                borderRadius: BorderRadius.circular(12.r),
                spacing: 6,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
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
  }
}
