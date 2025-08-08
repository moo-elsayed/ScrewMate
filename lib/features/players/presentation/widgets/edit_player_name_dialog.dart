import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/theming/colors.dart';
import 'package:skru_mate/core/widgets/custom_button.dart';
import 'package:skru_mate/core/widgets/custom_text_form_field.dart';
import '../../../../core/database/shared_models/player_model.dart';
import '../managers/cubits/players_cubit/players_cubit.dart';

class EditPlayerNameDialog extends StatefulWidget {
  const EditPlayerNameDialog({
    super.key,
    required this.player,
    required this.onNameChanged,
  });

  final PlayerModel player;
  final Function(String) onNameChanged;

  @override
  State<EditPlayerNameDialog> createState() => _EditPlayerNameDialogState();
}

class _EditPlayerNameDialogState extends State<EditPlayerNameDialog> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  bool isTextEmpty = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.player.name);
    isTextEmpty = _controller.text.trim().isEmpty;

    _controller.addListener(() {
      final isNowEmpty = _controller.text.trim().isEmpty;
      if (isNowEmpty != isTextEmpty) {
        isTextEmpty = isNowEmpty;
        setState(() {});
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
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Material(
      color: Colors.black38,
      child: Padding(
        padding: EdgeInsetsGeometry.only(
          bottom: mediaQueryData.viewInsets.bottom,
        ),
        child: Theme(
          data: ThemeData.light(),
          child: Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: mediaQueryData.size.width * 0.75,
              ),
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
                          'Edit Player Name',
                          style: GoogleFonts.lato(color: Colors.black),
                        ),
                        Gap(12.h),
                        CustomTextFormField(
                          controller: _controller,
                          keyboardType: TextInputType.name,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsetsGeometry.symmetric(
                            vertical: 14.h,
                            horizontal: 16.h,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Player name is required';
                            }
                            return null;
                          },
                        ),
                        Gap(20.h),
                        CustomButton(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              final name = _controller.text.trim();
                              widget.onNameChanged(name);
                              context.read<PlayersCubit>().updatePlayerStats(
                                player: widget.player.copyWith(name: name),
                              );
                              context.pop();
                            }
                          },
                          label: 'Save Name',
                          notActiveColor: isTextEmpty
                              ? ColorsManager.appbarColor
                              : null,
                        ),
                      ],
                    ),
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
