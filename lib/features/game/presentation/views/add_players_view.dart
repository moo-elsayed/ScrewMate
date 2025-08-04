import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skru_mate/core/helpers/dependency_injection.dart';
import 'package:skru_mate/features/game/presentation/managers/cubits/game_cubit/game_cubit.dart';
import 'package:skru_mate/features/players/domain/repos/players_repo.dart';
import '../../domain/repos/game_repo.dart';
import '../widgets/add_players_view_body.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class AddPlayersView extends StatelessWidget {
  const AddPlayersView({
    super.key,
    required this.playersCount,
    required this.roundsCount,
  });

  final int playersCount;
  final int roundsCount;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameCubit(
        gameRepo: getIt.get<GameRepo>(),
        playersRepo: getIt.get<PlayersRepo>(),
      ),
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: AddPlayersViewBody(
          playersCount: playersCount,
          roundsCount: roundsCount,
        ),
      ),
    );
  }
}
