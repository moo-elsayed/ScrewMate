import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/database/shared_models/player_model.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';

class PlayerViewHeader extends StatelessWidget {
  const PlayerViewHeader({
    super.key,
    required this.player,
    required this.playerName,
  });

  final PlayerModel player;
  final String playerName;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final String initials = playerName.trim().isNotEmpty
        ? playerName.trim().split(' ').map((s) => s[0]).take(2).join().toUpperCase()
        : '?';

    String status = 'Active Player';
    Color statusColor = colors.subText;
    if (player.winRate >= 60.0 && player.gamesPlayed >= 5) {
      status = 'Elite Competitor';
      statusColor = colors.gold;
    } else if (player.winRate >= 45.0 && player.gamesPlayed >= 3) {
      status = 'Pro Player';
      statusColor = colors.primaryLight;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80.r,
            height: 80.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  colors.primary,
                  colors.primaryLight,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.25),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: GoogleFonts.lato(
                fontSize: 26.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ).animate().scale(duration: 350.ms, curve: Curves.easeOutBack),
          Gap(10.h),
          
          // Player Name
          Text(
            playerName,
            style: GoogleFonts.lato(
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: colors.mainText,
            ),
            textAlign: TextAlign.center,
          ).animate().fade(duration: 350.ms).slideY(begin: 0.15),
          Gap(6.h),
          
          // Status Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 0.8),
            ),
            child: Text(
              status,
              style: GoogleFonts.lato(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: statusColor,
              ),
            ),
          ).animate().fade(duration: 350.ms, delay: 100.ms),
        ],
      ),
    );
  }
}
