import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skru_mate/core/helpers/di.dart';
import 'package:skru_mate/features/games_history/domain/use_cases/delete_game_use_case.dart';
import 'package:skru_mate/features/games_history/domain/use_cases/get_all_games_use_case.dart';
import 'package:skru_mate/features/games_history/domain/use_cases/get_game_details_use_case.dart';
import 'package:skru_mate/features/games_history/presentation/managers/cubits/games_history_cubit/games_history_cubit.dart';
import 'package:skru_mate/features/games_history/presentation/widgets/game_result_view_body.dart';
import 'package:skru_mate/features/players/domain/use_cases/get_all_players_use_case.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../data/models/game_result_view_args.dart';

class GameResultView extends StatelessWidget {
  const GameResultView({super.key, required this.gameResultViewArgs});

  final GameResultViewArgs gameResultViewArgs;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => GamesHistoryCubit(
          getAllGamesUseCase: getIt.get<GetAllGamesUseCase>(),
          getGameDetailsUseCase: getIt.get<GetGameDetailsUseCase>(),
          deleteGameUseCase: getIt.get<DeleteGameUseCase>(),
          getAllPlayersUseCase: getIt.get<GetAllPlayersUseCase>(),
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
