import 'package:flutter/material.dart';
import '../widgets/add_players_view_body.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class AddPlayersView extends StatelessWidget {
  const AddPlayersView({
    super.key,
    required this.playersCount,
    required this.roundsCount,
    required this.scaffoldKey,
  });

  final int playersCount;
  final int roundsCount;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: AddPlayersViewBody(
        playersCount: playersCount,
        roundsCount: roundsCount,
        scaffoldKey: scaffoldKey,
      ),
    );
  }
}
