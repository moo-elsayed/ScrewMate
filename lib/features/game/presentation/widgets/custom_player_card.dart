import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skru_mate/core/database/shared_models/player_model.dart';
import 'package:skru_mate/generated/assets.dart';
import '../../../../core/helpers/extentions.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
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
  Widget build(BuildContext context) => Stack(
    clipBehavior: .none,
    children: [
      Container(
        padding: EdgeInsets.all(16.r),
        decoration: _buildBoxDecoration(context),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 16.h,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.player.name, style: AppTextStyles.font18WhiteBold),
                Text(
                  'Rank #${widget.playerRank}',
                  style: AppTextStyles.font18WhiteRegular,
                ),
              ],
            ),
            Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 180.w),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        widget.areWeAddScoreToThisPlayer
                            ? widget.round
                            : widget.round - 1,
                        (i) => Padding(
                          padding: EdgeInsets.only(right: 4.w),
                          child: Column(
                            children: [
                              Text('R${i + 1}'),
                              Text('${widget.roundScore[i]}'),
                            ],
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
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 60.w),
                    child: Text(
                      '= ${widget.playerScore}',
                      style: AppTextStyles.font20WhiteBold,
                      textAlign: TextAlign.end,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
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
          top: -12.h,
          left: -10.w,
          child: SizedBox(
            height: 30.h,
            width: 30.w,
            child: Transform.rotate(
              angle: 325 * (pi / 180),
              child: SvgPicture.asset(Assets.svgsCrown),
            ),
          ),
        ),
    ],
  );

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

  BoxDecoration _buildBoxDecoration(BuildContext context) => BoxDecoration(
    borderRadius: BorderRadius.circular(16.r),
    border: !widget.areWeAddScoreToAllPlayers
        ? null
        : widget.areWeAddScoreToAllPlayers && widget.isRank1
        ? null
        : Border.all(color: Colors.white54, width: 0.5),
    color: !widget.areWeAddScoreToAllPlayers
        ? AppColors.purple.withValues(alpha: 0.9)
        : widget.areWeAddScoreToAllPlayers && widget.isRank1
        ? AppColors.purple.withValues(alpha: 0.9)
        : Theme.of(context).scaffoldBackgroundColor,
  );
}
