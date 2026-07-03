import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';
import 'package:skru_mate/core/widgets/custom_button.dart';
import 'package:skru_mate/core/widgets/custom_text_form_field.dart';
import '../../../../core/database/shared_entities/player_entity.dart';

class CustomScoreDialog extends StatefulWidget {
  const CustomScoreDialog({
    super.key,
    required this.player,
    required this.round,
    required this.onSave,
    required this.isDoubleRound,
    this.scoreOfPlayer,
  });

  final PlayerEntity player;
  final int round;
  final Function(int) onSave;
  final bool isDoubleRound;
  final int? scoreOfPlayer;

  static Future<T?> show<T>(
    BuildContext context, {
    required PlayerEntity player,
    required int round,
    required Function(int) onSave,
    required bool isDoubleRound,
    int? scoreOfPlayer,
  }) =>
      showCupertinoDialog<T>(
        context: context,
        builder: (context) => GestureDetector(
          onTap: () => context.pop(),
          child: CustomScoreDialog(
            player: player,
            round: round,
            onSave: onSave,
            isDoubleRound: isDoubleRound,
            scoreOfPlayer: scoreOfPlayer,
          ),
        ),
      );

  @override
  State<CustomScoreDialog> createState() => _CustomScoreDialogState();
}

class _CustomScoreDialogState extends State<CustomScoreDialog> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();
  late int score;

  final _isTextEmpty = ValueNotifier<bool>(true);
  final _operationsDisabled = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.scoreOfPlayer?.toString());
    _isTextEmpty.value = _controller.text.trim().isEmpty;

    _controller.addListener(() {
      final isNowEmpty = _controller.text.trim().isEmpty;
      if (isNowEmpty != _isTextEmpty.value) {
        _isTextEmpty.value = isNowEmpty;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _isTextEmpty.dispose();
    _operationsDisabled.dispose();
    super.dispose();
  }

  void _resetScore() {
    _controller.clear();
    _operationsDisabled.value = false;
  }

  void _multiplyScoreBy(int multiplier) {
    int current = int.parse(_controller.text);
    current *= multiplier;
    _controller.text = '$current';
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final colors = context.colors;
    return Material(
      color: Colors.black54,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: mediaQueryData.viewInsets.bottom,
        ),
        child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: mediaQueryData.size.width * 0.78,
            ),
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  color: colors.surfaceElevated,
                  border: Border.all(
                    color: colors.border.withValues(alpha: 0.15),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          'ROUND ${widget.round}',
                          style: GoogleFonts.lato(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w900,
                            color: colors.primary,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      Gap(8.h),
                      Text(
                        'Score for ${widget.player.name}',
                        style: GoogleFonts.lato(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: colors.mainText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Gap(10.h),
                      CustomTextFormField(
                        controller: _controller,
                        focusNode: _focusNode,
                        keyboardType: TextInputType.number,
                        fillColor: colors.surfaceHighest,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: colors.mainText,
                        ),
                        cursorColor: colors.primary,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 12.w,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a score';
                          }
                          return null;
                        },
                      ),
                      Gap(14.h),
                      ValueListenableBuilder<bool>(
                        valueListenable: _operationsDisabled,
                        builder: (context, disabled, child) => Column(
                          children: [
                            CustomButton(
                              onTap: () {
                                if (!disabled) {
                                  _controller.text = '0';
                                  _operationsDisabled.value = true;
                                }
                              },
                              notActiveColor:
                                  disabled ? colors.surfaceHighest : null,
                              label: 'Screw (0)',
                              icon: Icons.bolt_outlined,
                            ),
                            Gap(8.h),
                            Row(
                              spacing: 8.w,
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    onTap: () {
                                      if (!disabled) {
                                        if (_controller.text.isEmpty) return;
                                        _multiplyScoreBy(2);
                                        _operationsDisabled.value = true;
                                      }
                                    },
                                    label: 'Score × 2',
                                    notActiveColor: disabled
                                        ? colors.surfaceHighest
                                        : null,
                                  ),
                                ),
                                if (widget.isDoubleRound)
                                  Expanded(
                                    child: CustomButton(
                                      onTap: () {
                                        if (!disabled) {
                                          if (_controller.text.isEmpty) {
                                            return;
                                          }
                                          _multiplyScoreBy(4);
                                          _operationsDisabled.value = true;
                                        }
                                      },
                                      label: 'Score × 4',
                                      notActiveColor: disabled
                                          ? colors.surfaceHighest
                                          : null,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Gap(8.h),
                      ValueListenableBuilder<bool>(
                        valueListenable: _isTextEmpty,
                        builder: (context, isEmpty, child) => CustomButton(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              score = int.parse(_controller.text);
                              widget.onSave(score);
                              context.pop();
                            }
                          },
                          label: 'Save Score',
                          notActiveColor:
                              isEmpty ? colors.surfaceHighest : null,
                          icon: Icons.save_outlined,
                        ),
                      ),
                      Gap(8.h),
                      GestureDetector(
                        onTap: _resetScore,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          child: Text(
                            'Reset',
                            style: GoogleFonts.lato(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: colors.primary,
                              decoration: TextDecoration.underline,
                              decorationColor: colors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
