import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/routing/routes.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';
import 'package:skru_mate/core/widgets/custom_button.dart';
import 'package:skru_mate/features/game/data/models/add_players_args.dart';
import 'package:skru_mate/features/game/presentation/widgets/animated_number_selector.dart';
import 'package:skru_mate/features/game/presentation/widgets/home_stats_card.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  late final ValueNotifier<int> _selectedPlayers;
  late final ValueNotifier<int> _selectedRounds;

  @override
  void initState() {
    super.initState();
    _selectedPlayers = ValueNotifier<int>(4);
    _selectedRounds = ValueNotifier<int>(5);
  }

  @override
  void dispose() {
    _selectedPlayers.dispose();
    _selectedRounds.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ready for a match?',
              style: GoogleFonts.lato(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: colors.mainText,
              ),
            ),
            Gap(4.h),
            Text(
              'Set up your game rules and start playing.',
              style: GoogleFonts.lato(
                fontSize: 13.sp,
                color: colors.bodyText,
              ),
            ),
            Gap(20.h),
            const HomeStatsCard(),
            Gap(24.h),
            Text(
              'Game Setup',
              style: GoogleFonts.lato(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: colors.mainText,
              ),
            ),
            Gap(12.h),
            ValueListenableBuilder<int>(
              valueListenable: _selectedPlayers,
              builder: (context, playersCount, _) => AnimatedNumberSelector(
                title: 'Players Count',
                value: playersCount,
                minValue: 2,
                maxValue: 12,
                icon: CupertinoIcons.person_3_fill,
                onChanged: (val) => _selectedPlayers.value = val,
              ),
            ),
            Gap(16.h),
            ValueListenableBuilder<int>(
              valueListenable: _selectedRounds,
              builder: (context, roundsCount, _) => AnimatedNumberSelector(
                title: 'Rounds Count',
                value: roundsCount,
                minValue: 1,
                maxValue: 10,
                icon: CupertinoIcons.arrow_2_circlepath,
                onChanged: (val) => _selectedRounds.value = val,
              ),
            ),
            Gap(32.h),
            CustomButton(
              onTap: () {
                context.pushNamed(
                  Routes.addPlayersView,
                  arguments: AddPlayersArgs(
                    playersCount: _selectedPlayers.value,
                    roundsCount: _selectedRounds.value,
                  ),
                );
              },
              label: 'Start New Match',
              icon: CupertinoIcons.play_fill,
            ),
            Gap(16.h),
          ],
        ),
      ),
    );
  }
}
