import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/database/shared_models/player_model.dart';
import '../../../../core/theming/styles.dart';

class SelectPlayersBottomSheet extends StatefulWidget {
  const SelectPlayersBottomSheet({
    super.key,
    required this.players,
    required this.controllers,
  });

  final List<PlayerModel> players;
  final List<TextEditingController> controllers;

  @override
  State<SelectPlayersBottomSheet> createState() =>
      _SelectPlayersBottomSheetState();
}

class _SelectPlayersBottomSheetState extends State<SelectPlayersBottomSheet> {
  final selectedPlayerIds = <int>{};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, left: 12.w, right: 12.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          Text('Select Players', style: TextStyles.font18WhiteBold),
          Gap(16.h),
          SizedBox(
            height: 400.h, // adjust as needed
            child: ListView.builder(
              itemCount: widget.players.length,
              itemBuilder: (context, index) {
                final player = widget.players[index];
                final isSelected = selectedPlayerIds.contains(player.id);

                return CheckboxListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                  title: Text(
                    player.name,
                    style: TextStyles.font16WhiteRegular,
                  ),
                  value: isSelected,
                  activeColor: Colors.purple,
                  checkColor: Colors.white,
                  checkboxShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  onChanged: (value) {
                    if (value == true) {
                      selectedPlayerIds.add(player.id!);
                      for (var controller in widget.controllers) {
                        if (controller.text == '') {
                          controller.text = player.name;
                          break;
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
        ],
      ),
    );
  }
}
