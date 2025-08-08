import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/theming/styles.dart';
import 'package:skru_mate/core/widgets/custom_app_bar.dart';
import 'package:skru_mate/core/widgets/custom_toast.dart';
import 'package:skru_mate/features/players/presentation/managers/cubits/players_cubit/players_cubit.dart';
import 'package:skru_mate/features/players/presentation/managers/cubits/players_cubit/players_states.dart';
import 'package:skru_mate/features/players/presentation/widgets/edit_player_name_dialog.dart';
import 'package:skru_mate/features/players/presentation/widgets/player_view_body.dart';
import '../../data/models/player_details_args.dart';
import '../../../../core/widgets/confirmation_dialog.dart';

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
  Widget build(BuildContext context) {
    return BlocConsumer<PlayersCubit, PlayersStates>(
      listener: (context, state) {
        if (state is DeletePlayerSuccess) {
          context.read<PlayersCubit>().getAllPlayers();
          showCustomToast(
            context: context,
            message: '${widget.playerDetailsArgs.player.name} deleted',
            contentType: ContentType.success,
          );
          context.pop();
        } else if (state is UpdatePlayerStatsSuccess) {
          context.read<PlayersCubit>().getAllPlayers();
          Future.delayed(
            const Duration(milliseconds: 500),
            () => showCustomToast(
              context: context,
              message: 'name changed to $playerName',
              contentType: ContentType.success,
            ),
          );
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
          ],
        ),
        body: PlayerViewBody(playerDetailsArgs: widget.playerDetailsArgs),
      ),
    );
  }
}
