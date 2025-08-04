import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/database/shared_models/player_model.dart';

class GameViewBody extends StatelessWidget {
  const GameViewBody({super.key, required this.players});

  final List<PlayerModel> players;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => Text(players[index].name),
      separatorBuilder: (__, _) => Gap(12.h),
      itemCount: players.length,
    );
  }
}
