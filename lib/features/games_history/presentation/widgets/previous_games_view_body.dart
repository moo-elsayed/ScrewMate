import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skru_mate/core/theming/colors.dart';
import 'package:skru_mate/core/theming/styles.dart';
import '../../../../core/database/shared_models/game_model.dart';

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
      padding: EdgeInsets.only(right: 12.w, left: 12.w),
      physics: const BouncingScrollPhysics(),
      itemCount: previousGames.length,
      separatorBuilder: (_, __) =>
          Divider(color: ColorsManager.purple, height: 0.h),
      itemBuilder: (context, index) {
        final game = previousGames[index];
        return GestureDetector(
          onTap: () {
            log(game.date);
          },
          child:
              ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Game #${game.id}'),
                    titleTextStyle: TextStyles.font17WhiteBold,
                    subtitle: Text('Winner: ${game.winnerName}'),
                    subtitleTextStyle: TextStyles.font13White70Regular,
                    trailing: Text(
                      game.date,
                      style: TextStyles.font12White54Regular,
                    ),
                  )
                  .animate(delay: Duration(milliseconds: 50 * index))
                  .slideY(begin: 0.2, duration: 300.ms)
                  .fadeIn(duration: 300.ms),
        );
      },
    );
  }
}
