import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:skru_mate/core/database/shared_models/player_model.dart';
import 'package:skru_mate/core/theming/styles.dart';
import 'package:skru_mate/core/widgets/custom_app_bar.dart';
import 'package:skru_mate/features/players/presentation/widgets/player_view_body.dart';

class PlayerView extends StatelessWidget {
  const PlayerView({super.key, required this.playerModel});

  final PlayerModel playerModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: playerModel.name,
        centerTitle: false,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'edit') {
                log('// go to edit');
              } else if (value == 'delete') {
                log('// confirm delete');
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
                  style: TextStyles.font14WhiteRegular.copyWith(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
      body: PlayerViewBody(playerModel: playerModel),
    );
  }
}
