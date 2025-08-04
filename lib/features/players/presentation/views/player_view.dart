import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/theming/styles.dart';
import 'package:skru_mate/core/widgets/custom_app_bar.dart';
import 'package:skru_mate/core/widgets/custom_toast.dart';
import 'package:skru_mate/features/players/presentation/managers/cubits/players_cubit/players_cubit.dart';
import 'package:skru_mate/features/players/presentation/managers/cubits/players_cubit/players_states.dart';
import 'package:skru_mate/features/players/presentation/widgets/player_view_body.dart';
import '../../data/models/player_details_args.dart';
import '../../../../core/widgets/delete_confirmation_dialog.dart';

class PlayerView extends StatelessWidget {
  const PlayerView({super.key, required this.playerDetailsArgs});

  final PlayerDetailsArgs playerDetailsArgs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: playerDetailsArgs.player.name,
        centerTitle: false,
        actions: [
          BlocListener<PlayersCubit, PlayersStates>(
            listener: (context, state) {
              if (state is DeletePlayerSuccess) {
                context.read<PlayersCubit>().getAllPlayers();
                showCustomToast(
                  context: context,
                  message: '${playerDetailsArgs.player.name} deleted',
                  contentType: ContentType.success,
                );
                context.pop();
              }
            },
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: (value) {
                if (value == 'edit') {
                  log('// go to edit');
                } else if (value == 'delete') {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => DeleteConfirmationDialog(
                      name: playerDetailsArgs.player.name,
                      onDelete: () {
                        context.read<PlayersCubit>().deletePlayer(id: playerDetailsArgs.player.id!);
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
                  child: Text('Edit', style: TextStyles.font14WhiteRegular),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text(
                    'Delete',
                    style: TextStyles.font14WhiteRegular.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: PlayerViewBody(playerDetailsArgs: playerDetailsArgs),
    );
  }
}
