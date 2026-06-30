import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';
import '../../../../core/helpers/functions.dart';

class CustomPlayerStatItem extends StatelessWidget {
  const CustomPlayerStatItem({
    super.key,
    required this.title,
    required this.value,
    required this.rank,
  });

  final String title;
  final String value;
  final int rank;

  IconData _getStatIcon() {
    switch (title) {
      case 'Games Played':
        return Icons.sports_esports_rounded;
      case 'Wins':
        return Icons.emoji_events_rounded;
      case 'Round Wins':
        return Icons.stars_rounded;
      case 'Win Rate':
        return Icons.percent_rounded;
      case 'Losses':
        return Icons.trending_down_rounded;
      default:
        return Icons.bar_chart_rounded;
    }
  }

  Color _getStatColor(ColorsManager colors) {
    switch (title) {
      case 'Wins':
        return colors.gold;
      case 'Losses':
        return colors.error;
      case 'Round Wins':
        return colors.primaryLight;
      default:
        return colors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final statColor = _getStatColor(colors);
    final icon = _getStatIcon();

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.4),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: statColor, size: 18.r),
              Gap(6.w),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.lato(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.subText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Value & Rank
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                decoration: BoxDecoration(
                  color: colors.surfaceHighest,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: colors.border.withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  'Rank #$rank',
                  style: GoogleFonts.lato(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: getRankColor(rank),
                  ),
                ),
              ),
              Text(
                value,
                style: GoogleFonts.lato(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: colors.mainText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
