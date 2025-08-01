import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/widgets/custom_button.dart';
import 'package:skru_mate/core/widgets/custom_text_form_field.dart';
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
            Gap(24.h),
            Row(
              children: [
                Text('Add players:', style: TextStyles.font18WhiteBold),
              ],
            ),
            Gap(24.h),
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
}
