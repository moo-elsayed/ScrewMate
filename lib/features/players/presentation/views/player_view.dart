import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/theming/app_text_styles.dart';
import 'package:skru_mate/core/widgets/custom_app_bar.dart';
import 'package:skru_mate/features/players/presentation/managers/cubits/players_cubit/players_cubit.dart';
import 'package:skru_mate/features/players/presentation/managers/cubits/players_cubit/players_states.dart';
import 'package:skru_mate/features/players/presentation/widgets/edit_player_name_dialog.dart';
import 'package:skru_mate/features/players/presentation/widgets/player_view_body.dart';

import '../../../../core/widgets/app_toasts.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../data/models/player_details_args.dart';

class PlayerView extends StatefulWidget {
  const PlayerView({super.key, required this.playerDetailsArgs});

  final PlayerDetailsArgs playerDetailsArgs;

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  late String playerName;

  @override
  void initState() {
    super.initState();
    playerName = widget.playerDetailsArgs.player.name;
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<PlayersCubit, PlayersStates>(
        listener: (context, state) {
          if (state is DeletePlayerSuccess) {
            context.read<PlayersCubit>().getAllPlayers();
            AppToast.show(
              context: context,
              title: '${widget.playerDetailsArgs.player.name} deleted',
              type: .success,
            );
            context.pop();
          } else if (state is UpdatePlayerStatsSuccess) {
            context.read<PlayersCubit>().getAllPlayers();
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                AppToast.show(
                  context: context,
                  title: 'name changed to $playerName',
                  type: .success,
                );
              }
            });
          }
        },
        builder: (context, state) => Scaffold(
          appBar: CustomAppBar(
            text: playerName,
            centerTitle: false,
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'edit') {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => GestureDetector(
                        onTap: () => context.pop(),
                        child: EditPlayerNameDialog(
                          onNameChanged: (String name) {
                            playerName = name;
                          },
                          player: widget.playerDetailsArgs.player.copyWith(
                            name: playerName,
                          ),
                        ),
                      ),
                    );
                  } else if (value == 'delete') {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => ConfirmationDialog(
                        name: widget.playerDetailsArgs.player.name,
                        onDelete: () {
                          context.read<PlayersCubit>().deletePlayer(
                            id: widget.playerDetailsArgs.player.id!,
                          );
                          context.pop();
                        },
                      ),
                    );
                  }
                },
                position: PopupMenuPosition.under,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text(
                      'Edit',
                      style: AppTextStyles.font14WhiteRegular,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      'Delete',
                      style: AppTextStyles.font14WhiteRegular.copyWith(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: PlayerViewBody(
            playerDetailsArgs: widget.playerDetailsArgs,
            playerName: playerName,
          ),
        ),
      );
}
