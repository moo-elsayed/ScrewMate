import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/routing/routes.dart';
import 'package:skru_mate/core/widgets/custom_button.dart';
import 'package:skru_mate/core/widgets/custom_text_form_field.dart';
import 'package:skru_mate/core/widgets/custom_toast.dart';
import 'package:skru_mate/features/game/data/models/game_args.dart';
import 'package:skru_mate/features/game/presentation/managers/cubits/game_cubit/game_cubit.dart';
import 'package:skru_mate/features/game/presentation/managers/cubits/game_cubit/game_states.dart';
import 'package:skru_mate/features/game/presentation/widgets/select_players_bottom_sheet.dart';
import '../../../../core/database/shared_models/player_model.dart';
import '../../../../core/theming/app_text_styles.dart';

class AddPlayersViewBody extends StatefulWidget {
  const AddPlayersViewBody({
    super.key,
    required this.playersCount,
    required this.roundsCount,
  });

  final int playersCount;
  final int roundsCount;

  @override
  State<AddPlayersViewBody> createState() => _AddPlayersViewBodyState();
}

class _AddPlayersViewBodyState extends State<AddPlayersViewBody> {
  late List<TextEditingController> _controllers;
  final _formKey = GlobalKey<FormState>();
  late final List<PlayerModel> playersList;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.playersCount,
      (index) => TextEditingController(),
    );
    context.read<GameCubit>().getAllPlayers();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<GameCubit, GameStates>(
    listener: (context, state) {
      if (state is GetAllPlayersSuccess) {
        playersList = state.players;
      }
    },
    child: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Add players:', style: AppTextStyles.font18WhiteBold),
                GestureDetector(
                  onTap: () {
                    _showPlayerSelectionSheet(
                      context: context,
                      selectedPlayers: getSelectedPlayersList(),
                      players: playersList,
                    );
                  },
                  child: Row(
                    spacing: 3.w,
                    children: [
                      Text(
                        'Select players',
                        style: AppTextStyles.font14WhiteMedium,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Icon(
                          CupertinoIcons.chevron_right,
                          size: 16.r,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(16.h),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView.separated(
                  itemCount: widget.playersCount,
                  separatorBuilder: (_, __) => Gap(12.h),
                  itemBuilder: (context, index) => CustomTextFormField(
                    controller: _controllers[index],
                    hintText: 'Add player ${index + 1}',
                    keyboardType: TextInputType.name,
                    contentPadding: EdgeInsetsGeometry.symmetric(
                      vertical: 14.h,
                      horizontal: 20.w,
                    ),
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Field is empty';
                      } else {
                        for (int i = 0; i < _controllers.length; i++) {
                          if (i != index &&
                              _controllers[index].text.toLowerCase() ==
                                  _controllers[i].text.toLowerCase()) {
                            return 'Duplicate player name';
                          }
                        }
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            Gap(16.h),
            CustomButton(
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  final names = _controllers
                      .map((controller) => controller.text.trim())
                      .where((name) => name.isNotEmpty)
                      .toList();

                  final existingNames = playersList
                      .map((p) => p.name.toLowerCase())
                      .toSet();
                  final newNames = names
                      .where(
                        (name) => !existingNames.contains(name.toLowerCase()),
                      )
                      .toList();

                  for (final name in newNames) {
                    PlayerModel newPlayer = PlayerModel(
                      name: name,
                      gamesPlayed: 0,
                      wins: 0,
                      roundWins: 0,
                      winRate: 0,
                      losses: 0,
                    );

                    await context
                        .read<GameCubit>()
                        .insertPlayer(player: newPlayer)
                        .then((result) {
                          result.fold(
                            (failure) {
                              showCustomToast(
                                context: context,
                                message: 'Failed to add ${newPlayer.name}',
                                contentType: ContentType.failure,
                              );
                            },
                            (newId) {
                              newPlayer = newPlayer.copyWith(id: newId);
                              playersList.add(newPlayer);
                            },
                          );
                        });
                  }

                  final selectedPlayers = names
                      .map(
                        (name) => playersList.firstWhere(
                          (p) => p.name.toLowerCase() == name.toLowerCase(),
                          orElse: () =>
                              throw Exception('Player $name not found'),
                        ),
                      )
                      .toList();

                  if (context.mounted) {
                    context.pushNamed(
                      Routes.gameView,
                      arguments: GameArgs(
                        players: selectedPlayers,
                        roundsCount: widget.roundsCount,
                      ),
                    );
                  }
                }
              },
              label: 'Start Game',
            ),

            Gap(16.h),
          ],
        ),
      ),
    ),
  );

  void _showPlayerSelectionSheet({
    required BuildContext context,
    required List<PlayerModel> players,
    required List<PlayerModel> selectedPlayers,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      isScrollControlled: true,
      builder: (_) => SelectPlayersBottomSheet(
        players: players,
        selectedPlayers: selectedPlayers,
        controllers: _controllers,
      ),
    );
  }

  List<PlayerModel> getSelectedPlayersList() {
    final List<PlayerModel> list = [];
    bool isFound = false;
    for (PlayerModel player in playersList) {
      for (var controller in _controllers) {
        if (player.name.toLowerCase() == controller.text.toLowerCase()) {
          isFound = true;
          break;
        }
      }
      if (isFound) {
        list.add(player);
      }
      isFound = false;
    }
    return list;
  }
}
