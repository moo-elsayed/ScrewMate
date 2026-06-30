import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skru_mate/core/helpers/di.dart';
import 'package:skru_mate/features/games_history/presentation/managers/cubits/games_history_cubit/games_history_cubit.dart';
import 'package:skru_mate/features/games_history/presentation/widgets/game_result_view_body.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../players/domain/repos/players_repo.dart';
import '../../data/models/game_result_view_args.dart';
import '../../data/repos/games_history_repo_imp.dart';

class GameResultView extends StatelessWidget {
  const GameResultView({super.key, required this.gameResultViewArgs});

  final GameResultViewArgs gameResultViewArgs;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => GamesHistoryCubit(
          playersRepo: getIt.get<PlayersRepo>(),
          gamesHistoryRepo: getIt.get<GamesHistoryRepoImp>(),
        ),
        child: Scaffold(
          appBar: CustomAppBar(
            text: gameResultViewArgs.fromHistory
                ? 'Game #${gameResultViewArgs.gameId}'
                : 'Game Results',
          ),
          body: GameResultViewBody(gameResultViewArgs: gameResultViewArgs),
        ),
      );
}
