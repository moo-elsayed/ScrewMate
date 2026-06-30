import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/database/shared_models/player_model.dart';
import 'package:skru_mate/core/helpers/extentions.dart';
import 'package:skru_mate/core/theming/colors_manager.dart';
import 'package:skru_mate/generated/assets.dart';
import 'custom_score_button.dart';
import 'custom_score_dialog.dart';

class CustomPlayerCard extends StatefulWidget {
  const CustomPlayerCard({
    super.key,
    required this.areWeAddScoreToAllPlayers,
    required this.isRank1,
    required this.player,
    required this.playerRank,
    required this.areWeAddScoreToThisPlayer,
    required this.round,
    required this.roundScore,
    required this.dialogOnSave,
    required this.isDoubleRound,
    required this.playerScore,
    required this.areWeAddScoreToAnyPlayer,
  });

  final VoidCallback dialogOnSave;
  final List<int> roundScore;
  final PlayerModel player;
  final bool areWeAddScoreToAllPlayers;
  final bool isRank1;
  final bool areWeAddScoreToThisPlayer;
  final bool areWeAddScoreToAnyPlayer;
  final bool isDoubleRound;
  final int playerRank;
  final int round;
  final int playerScore;

  @override
  State<CustomPlayerCard> createState() => _CustomPlayerCardState();
}

class _CustomPlayerCardState extends State<CustomPlayerCard> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final isHighlighted = !widget.areWeAddScoreToAllPlayers ||
        (widget.areWeAddScoreToAllPlayers && widget.isRank1);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: isHighlighted
                ? LinearGradient(
                    colors: [
                      colors.primary,
                      colors.primaryLight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isHighlighted ? null : colors.surfaceElevated,
            border: isHighlighted
                ? null
                : Border.all(
                    color: colors.border.withValues(alpha: 0.15),
                    width: 1.5,
                  ),
            boxShadow: isHighlighted
                ? [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.player.name,
                    style: GoogleFonts.lato(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: isHighlighted ? Colors.white : colors.mainText,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: isHighlighted
                          ? Colors.white.withValues(alpha: 0.15)
                          : colors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      'Rank #${widget.playerRank}',
                      style: GoogleFonts.lato(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: isHighlighted ? Colors.white : colors.primaryLight,
                      ),
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              Row(
                children: [
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 45.h),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: List.generate(
                            widget.areWeAddScoreToThisPlayer
                                ? widget.round
                                : widget.round - 1,
                            (i) => Container(
                              margin: EdgeInsets.only(right: 6.w),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: isHighlighted
                                    ? Colors.white.withValues(alpha: 0.15)
                                    : colors.surfaceHighest,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: isHighlighted
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : colors.border.withValues(alpha: 0.1),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'R${i + 1}',
                                    style: GoogleFonts.lato(
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isHighlighted
                                          ? Colors.white.withValues(alpha: 0.7)
                                          : colors.subText,
                                    ),
                                  ),
                                  Gap(1.h),
                                  Text(
                                    '${widget.roundScore[i]}',
                                    style: GoogleFonts.lato(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: isHighlighted
                                          ? Colors.white
                                          : colors.mainText,
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
                  CustomScoreButton(
                    icon: widget.areWeAddScoreToThisPlayer ? Icons.edit : null,
                    onTap: () => _showDialog(context),
                  ),
                  Gap(12.w),
                  Container(
                    constraints: BoxConstraints(minWidth: 50.w),
                    child: Text(
                      '= ${widget.playerScore}',
                      style: GoogleFonts.lato(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900,
                        color: isHighlighted ? Colors.white : colors.mainText,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (widget.isRank1 &&
            (widget.areWeAddScoreToAllPlayers ||
                (!widget.areWeAddScoreToAnyPlayer && widget.round > 1)))
          Positioned(
            top: -10.h,
            left: -8.w,
            child: SizedBox(
              height: 32.h,
              width: 32.w,
              child: Transform.rotate(
                angle: 325 * (pi / 180),
                child: SvgPicture.asset(
                  Assets.svgsCrown,
                  colorFilter: const ColorFilter.mode(
                    Colors.amber,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => context.pop(),
        child: CustomScoreDialog(
          onSave: (int score) {
            widget.roundScore[widget.round - 1] = score;
            widget.dialogOnSave();
          },
          player: widget.player,
          round: widget.round,
          isDoubleRound: widget.isDoubleRound,
          scoreOfPlayer: widget.areWeAddScoreToThisPlayer
              ? widget.roundScore[widget.round - 1]
              : null,
        ),
      ),
    );
  }
}
