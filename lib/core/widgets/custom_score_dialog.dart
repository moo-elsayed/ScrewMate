import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/theming/colors.dart';
import 'package:skru_mate/core/widgets/custom_button.dart';
import 'package:skru_mate/core/widgets/custom_text_form_field.dart';
import '../database/shared_models/player_model.dart';

class CustomScoreDialog extends StatefulWidget {
  const CustomScoreDialog({
    super.key,
    required this.player,
    required this.round,
    required this.onSave,
    required this.isDoubleRound,
    this.scoreOfPlayer,
  });

  final PlayerModel player;
  final int round;
  final Function(int) onSave;
  final bool isDoubleRound;
  final int? scoreOfPlayer;

  @override
  State<CustomScoreDialog> createState() => _CustomScoreDialogState();
}

class _CustomScoreDialogState extends State<CustomScoreDialog> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  late int score;
  bool tapOnScrew = false;
  bool tapOnScore2 = false;
  bool tapOnScore4 = false;
  bool isTextEmpty = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.scoreOfPlayer?.toString());
    isTextEmpty = _controller.text.trim().isEmpty;

    _controller.addListener(() {
      final isNowEmpty = _controller.text.trim().isEmpty;
      if (isNowEmpty != isTextEmpty) {
        setState(() {
          isTextEmpty = isNowEmpty;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size sizeOfScreen = MediaQuery.sizeOf(context);
    return Material(
      color: Colors.black38,
      child: Theme(
        data: ThemeData.light(),
        child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: sizeOfScreen.width * 0.75),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusGeometry.circular(16.r),
                  color: Colors.white,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Score for ${widget.player.name} in round ${widget.round}',
                        style: GoogleFonts.lato(color: Colors.black),
                      ),
                      Gap(12.h),
                      CustomTextFormField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsetsGeometry.symmetric(
                          vertical: 14.h,
                          horizontal: 16.h,
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
                      Gap(20.h),
                      CustomButton(
                        onTap: () {
                          if (!tapOnScrew) {
                            _controller.text = '0';
                            setBooleansToTrue();
                          }
                        },
                        notActiveColor: tapOnScrew
                            ? ColorsManager.appbarColor
                            : null,
                        label: 'Screw (0)',
                      ),
                      Gap(12.h),
                      Row(
                        spacing: 8.w,
                        children: [
                          Expanded(
                            child: CustomButton(
                              onTap: () {
                                if (!tapOnScore2) {
                                  if (_controller.text.isEmpty) return;
                                  _multiplyScoreBy(2);
                                  setBooleansToTrue();
                                }
                              },
                              label: 'Score × 2',
                              notActiveColor: tapOnScore2
                                  ? ColorsManager.appbarColor
                                  : null,
                            ),
                          ),
                          if (widget.isDoubleRound)
                            Expanded(
                              child: CustomButton(
                                onTap: () {
                                  if (!tapOnScore4) {
                                    if (_controller.text.isEmpty) return;
                                    _multiplyScoreBy(4);
                                    setBooleansToTrue();
                                  }
                                },
                                label: 'Score × 4',
                                notActiveColor: tapOnScore4
                                    ? ColorsManager.appbarColor
                                    : null,
                              ),
                            ),
                        ],
                      ),
                      Gap(12.h),
                      CustomButton(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            score = int.parse(_controller.text);
                            widget.onSave(score);
                            context.pop();
                          }
                        },
                        label: 'Save Score',
                        notActiveColor: isTextEmpty
                            ? ColorsManager.appbarColor
                            : null,
                      ),
                      Gap(8.h),
                      GestureDetector(
                        onTap: _resetScore,
                        child: Text(
                          'Reset',
                          style: GoogleFonts.lato(
                            decoration: TextDecoration.underline,
                            fontSize: 14.sp,
                            color: Colors.black,
                            decorationColor: Colors.black,
                            height: 2,
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

  void _resetScore() {
    _controller.clear();
    setBooleansToFalse();
  }

  void _multiplyScoreBy(int multiplier) {
    int current = int.parse(_controller.text);
    current *= multiplier;
    _controller.text = '$current';
  }

  void setBooleansToTrue() {
    tapOnScrew = true;
    tapOnScore2 = true;
    tapOnScore4 = true;
    setState(() {});
  }

  void setBooleansToFalse() {
    tapOnScrew = false;
    tapOnScore2 = false;
    tapOnScore4 = false;
    setState(() {});
  }
}
