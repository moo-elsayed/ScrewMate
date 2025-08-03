import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skru_mate/core/widgets/custom_button.dart';
import 'package:skru_mate/core/widgets/custom_text_form_field.dart';
import 'package:skru_mate/features/game/presentation/widgets/select_players_bottom_sheet.dart';
import '../../../../core/database/shared_models/player_model.dart';
import '../../../../core/theming/styles.dart';

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

  final List<PlayerModel> topPlayersList = [
    PlayerModel(
      id: 1,
      name: 'Omar',
      gamesPlayed: 20,
      wins: 12,
      roundWins: 45,
      winRate: 60.0,
      losses: 2,
    ),
    PlayerModel(
      id: 2,
      name: 'Sara',
      gamesPlayed: 18,
      wins: 10,
      roundWins: 39,
      winRate: 55.6,
      losses: 1,
    ),
    PlayerModel(
      id: 3,
      name: 'Mostafa',
      gamesPlayed: 22,
      wins: 8,
      roundWins: 31,
      winRate: 36.3,
      losses: 6,
    ),
    PlayerModel(
      id: 4,
      name: 'Laila',
      gamesPlayed: 15,
      wins: 9,
      roundWins: 28,
      winRate: 60.0,
      losses: 0,
    ),
    PlayerModel(
      id: 5,
      name: 'Ahmed',
      gamesPlayed: 25,
      wins: 14,
      roundWins: 50,
      winRate: 56.0,
      losses: 4,
    ),
    PlayerModel(
      id: 6,
      name: 'Nour',
      gamesPlayed: 10,
      wins: 4,
      roundWins: 17,
      winRate: 40.0,
      losses: 3,
    ),
    PlayerModel(
      id: 7,
      name: 'Youssef',
      gamesPlayed: 30,
      wins: 16,
      roundWins: 52,
      winRate: 53.3,
      losses: 5,
    ),
    PlayerModel(
      id: 8,
      name: 'Mariam',
      gamesPlayed: 12,
      wins: 5,
      roundWins: 20,
      winRate: 41.6,
      losses: 2,
    ),
    PlayerModel(
      id: 9,
      name: 'Ziad',
      gamesPlayed: 17,
      wins: 6,
      roundWins: 25,
      winRate: 35.2,
      losses: 7,
    ),
    PlayerModel(
      id: 10,
      name: 'Farah',
      gamesPlayed: 14,
      wins: 7,
      roundWins: 29,
      winRate: 50.0,
      losses: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.playersCount,
      (index) => TextEditingController(),
    );
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
    return GestureDetector(
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
                Text('Add players:', style: TextStyles.font18WhiteBold),
                GestureDetector(
                  onTap: () {
                    _showPlayerSelectionSheet(
                      context: context,
                      players: getSelectPlayersList(),
                    );
                  },
                  child: Row(
                    spacing: 3.w,
                    children: [
                      Text(
                        'Select players',
                        style: TextStyles.font14WhiteMedium,
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
            Form(
              key: _formKey,
              child: Expanded(
                child: ListView.separated(
                  itemCount: widget.playersCount,
                  separatorBuilder: (_, __) => Gap(12.h),
                  itemBuilder: (context, index) {
                    return CustomTextFormField(
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
                        }
                        return null;
                      },
                      // suffixIcon: _controllers[index].text.isNotEmpty
                      //     ? GestureDetector(
                      //         onTap: () {
                      //           _controllers[index].text = '';
                      //           setState(() {});
                      //         },
                      //         child: const Icon(Icons.cancel_outlined),
                      //       )
                      //     : null,
                    );
                  },
                ),
              ),
            ),
            Gap(16.h),
            CustomButton(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                } else {}
              },
              label: 'Start Game',
            ),
            Gap(16.h),
          ],
        ),
      ),
    );
  }

  void _showPlayerSelectionSheet({
    required BuildContext context,
    required List<PlayerModel> players,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      isScrollControlled: true,
      builder: (_) {
        return SelectPlayersBottomSheet(
          players: players,
          controllers: _controllers,
        );
      },
    );
  }

  List<PlayerModel> getSelectPlayersList() {
    List<PlayerModel> list = [];
    bool isFound = false;
    for (PlayerModel player in topPlayersList) {
      for (var controller in _controllers) {
        if (player.name == controller.text) {
          isFound = true;
          break;
        }
      }
      if (!isFound) {
        list.add(player);
      }
      isFound = false;
    }
    return list;
  }
}
