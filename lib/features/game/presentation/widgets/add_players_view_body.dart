import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/routing/routes.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';
import 'package:skru_mate/core/widgets/app_toasts.dart';
import 'package:skru_mate/core/widgets/custom_button.dart';
import 'package:skru_mate/core/widgets/custom_text_form_field.dart';
import 'package:skru_mate/features/game/data/models/game_args.dart';
import 'package:skru_mate/features/game/presentation/managers/cubits/game_cubit/game_cubit.dart';
import 'package:skru_mate/features/game/presentation/managers/cubits/game_cubit/game_states.dart';
import 'package:skru_mate/features/game/presentation/widgets/select_players_bottom_sheet.dart';
import 'package:skru_mate/features/players/presentation/managers/cubits/players_cubit/players_cubit.dart';
import '../../../../core/database/shared_entities/player_entity.dart';

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
  late final List<PlayerEntity> playersList;

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
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocListener<GameCubit, GameStates>(
      listener: (context, state) {
        if (state is GetAllPlayersSuccess) {
          playersList = state.players;
        }
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
                  Text(
                    'Add players:',
                    style: GoogleFonts.lato(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: colors.mainText,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      SelectPlayersBottomSheet.show(
                        context,
                        selectedPlayers: getSelectedPlayersList(),
                        players: playersList,
                        controllers: _controllers,
                      );
                    },
                    child: Row(
                      spacing: 3.w,
                      children: [
                        Text(
                          'Select players',
                          style: GoogleFonts.lato(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.primary,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: Icon(
                            CupertinoIcons.chevron_right,
                            size: 16.r,
                            color: colors.primary,
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
            Gap(6.h),
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
                    PlayerEntity newPlayer = PlayerEntity(
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
                              AppToast.show(
                                context: context,
                                title: 'Failed to add ${newPlayer.name}',
                                type: .error,
                              );
                            },
                            (newId) {
                              newPlayer = newPlayer.copyWith(id: newId);
                              playersList.add(newPlayer);
                            },
                          );
                        });
                  }

                  if (newNames.isNotEmpty) {
                    if (context.mounted) {
                      await context.read<PlayersCubit>().getAllPlayers();
                    }
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
                    await context.pushNamed(
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
            Gap(6.h),
          ],
        ),
      ),
    ),
  );
}



  List<PlayerEntity> getSelectedPlayersList() {
    final List<PlayerEntity> list = [];
    bool isFound = false;
    for (PlayerEntity player in playersList) {
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
