import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';
import 'package:skru_mate/core/widgets/theme_selection_bottom_sheet.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppBar(
          text: 'ScrewMate',
          leading: const SizedBox.shrink(),
          actions: [
            IconButton(
              icon: Icon(
                CupertinoIcons.brightness,
                color: context.colors.primaryLight,
              ),
              onPressed: () => ThemeSelectionBottomSheet.show(context),
            ),
          ],
        ),
        body: const SafeArea(
          child: HomeViewBody(),
        ),
      );
}
