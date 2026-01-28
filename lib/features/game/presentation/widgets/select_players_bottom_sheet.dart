import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skru_mate/core/widgets/bottom_sheet_handle.dart';
import '../../../../core/database/shared_models/player_model.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/widgets/custom_toast.dart';

class SelectPlayersBottomSheet extends StatefulWidget {
  const SelectPlayersBottomSheet({
    super.key,
    required this.players,
    required this.controllers,
    required this.selectedPlayers,
  });

  final List<PlayerModel> players;
  final List<TextEditingController> controllers;
  final List<PlayerModel> selectedPlayers;

  @override
  State<SelectPlayersBottomSheet> createState() =>
      _SelectPlayersBottomSheetState();
}

class _SelectPlayersBottomSheetState extends State<SelectPlayersBottomSheet> {
  final selectedPlayerIds = <int>{};

  @override
  void initState() {
    super.initState();
    selectedPlayerIds.addAll(widget.selectedPlayers.map((p) => p.id!).toList());
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.only(top: 12.h, left: 8.w, right: 8.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetHandle(),
          widget.players.isEmpty
              ? SizedBox(
                  height: 400.h,
                  child: Center(
                    child: Text(
                      'There are no players yet',
                      style: AppTextStyles.font16WhiteRegular,
                    ),
                  ),
                )
              : Column(
                  children: [
                    Text('Select Players', style: AppTextStyles.font18WhiteBold),
                    Gap(16.h),
                    SizedBox(
                      height: min(400.h, widget.players.length * 60.h),
                      child: Scrollbar(
                        thumbVisibility: false,
                        radius: const Radius.circular(8),
                        thickness: 2,
                        child: ListView.builder(
                          itemCount: widget.players.length,
                          itemBuilder: (context, index) {
                            final player = widget.players[index];
                            final isSelected = selectedPlayerIds.contains(
                              player.id,
                            );

                            return CheckboxListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                              ),
                              title: Text(
                                player.name,
                                style: AppTextStyles.font16WhiteRegular,
                              ),
                              value: isSelected,
                              activeColor: Colors.purple,
                              checkColor: Colors.white,
                              checkboxShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              onChanged: (value) {
                                if (value == true) {
                                  bool isFull = true;

                                  for (var controller in widget.controllers) {
                                    if (controller.text.isEmpty) {
                                      isFull = false;
                                      break;
                                    }
                                  }

                                  if (isFull) {
                                    showCustomToast(
                                      context: context,
                                      message: 'Maximum players selected.',
                                      contentType: ContentType.warning,
                                    );
                                    return;
                                  } else {
                                    selectedPlayerIds.add(player.id!);
                                    for (var controller in widget.controllers) {
                                      if (controller.text == '') {
                                        controller.text = player.name;
                                        break;
                                      }
                                    }
                                  }
                                } else {
                                  selectedPlayerIds.remove(player.id!);
                                  for (var controller in widget.controllers) {
                                    if (controller.text == player.name) {
                                      controller.text = '';
                                      break;
                                    }
                                  }
                                }
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
}
