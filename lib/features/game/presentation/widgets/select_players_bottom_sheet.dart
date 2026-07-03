import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';
import 'package:skru_mate/core/widgets/bottom_sheet_handle.dart';
import 'package:toastification/toastification.dart';
import '../../../../core/database/shared_entities/player_entity.dart';
import '../../../../core/widgets/app_toasts.dart';

class SelectPlayersBottomSheet extends StatefulWidget {
  const SelectPlayersBottomSheet({
    super.key,
    required this.players,
    required this.controllers,
    required this.selectedPlayers,
  });

  final List<PlayerEntity> players;
  final List<TextEditingController> controllers;
  final List<PlayerEntity> selectedPlayers;

  static void show(
    BuildContext context, {
    required List<PlayerEntity> players,
    required List<PlayerEntity> selectedPlayers,
    required List<TextEditingController> controllers,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      isScrollControlled: true,
      builder: (_) => SelectPlayersBottomSheet(
        players: players,
        selectedPlayers: selectedPlayers,
        controllers: controllers,
      ),
    );
  }

  @override
  State<SelectPlayersBottomSheet> createState() =>
      _SelectPlayersBottomSheetState();
}

class _SelectPlayersBottomSheetState extends State<SelectPlayersBottomSheet> {
  late final ValueNotifier<Set<int>> selectedPlayerIdsNotifier;

  @override
  void initState() {
    super.initState();
    selectedPlayerIdsNotifier = ValueNotifier<Set<int>>(
      widget.selectedPlayers.map((p) => p.id!).toSet(),
    );
  }

  @override
  void dispose() {
    selectedPlayerIdsNotifier.dispose();
    super.dispose();
  }

  void _toggleSelection(PlayerEntity player) {
    final currentSet = Set<int>.from(selectedPlayerIdsNotifier.value);
    final isSelected = currentSet.contains(player.id);
    if (!isSelected) {
      bool isFull = true;

      for (var controller in widget.controllers) {
        if (controller.text.isEmpty) {
          isFull = false;
          break;
        }
      }

      if (isFull) {
        AppToast.show(
          context: context,
          title: 'Maximum players selected.',
          type: ToastificationType.warning,
        );
        return;
      } else {
        currentSet.add(player.id!);
        for (var controller in widget.controllers) {
          if (controller.text == '') {
            controller.text = player.name;
            break;
          }
        }
      }
    } else {
      currentSet.remove(player.id!);
      for (var controller in widget.controllers) {
        if (controller.text == player.name) {
          controller.text = '';
          break;
        }
      }
    }
    selectedPlayerIdsNotifier.value = currentSet;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      padding: EdgeInsets.fromLTRB(16.h, 10.h, 16.h, 0.h),
      decoration: BoxDecoration(
        color: colors.scaffold,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetHandle(),
          Gap(12.h),
          widget.players.isEmpty
              ? SizedBox(
                  height: 200.h,
                  child: Center(
                    child: Text(
                      'There are no players yet',
                      style: GoogleFonts.lato(
                        fontSize: 16.sp,
                        color: colors.subText,
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    Text(
                      'Select Players',
                      style: GoogleFonts.lato(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: colors.mainText,
                      ),
                    ),
                    Gap(16.h),
                    ValueListenableBuilder<Set<int>>(
                      valueListenable: selectedPlayerIdsNotifier,
                      builder: (context, selectedPlayerIds, child) => SizedBox(
                          height: min(350.h, widget.players.length * 62.h),
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: widget.players.length,
                            itemBuilder: (context, index) {
                              final player = widget.players[index];
                              final isSelected = selectedPlayerIds.contains(
                                player.id,
                              );

                              return GestureDetector(
                                onTap: () => _toggleSelection(player),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: EdgeInsets.symmetric(vertical: 4.h),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? colors.primary.withValues(alpha: 0.08)
                                        : colors.surfaceElevated,
                                    borderRadius: BorderRadius.circular(16.r),
                                    border: Border.all(
                                      color: isSelected
                                          ? colors.primary.withValues(alpha: 0.5)
                                          : colors.border.withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          player.name,
                                          style: GoogleFonts.lato(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                            color: colors.mainText,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 22.r,
                                        height: 22.r,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected
                                              ? colors.primary
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: isSelected
                                                ? colors.primary
                                                : colors.subText.withValues(
                                                    alpha: 0.6,
                                                  ),
                                            width: 2,
                                          ),
                                        ),
                                        child: isSelected
                                            ? Icon(
                                                Icons.check,
                                                size: 14.r,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
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
}
