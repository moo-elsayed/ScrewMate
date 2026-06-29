import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors_manager.dart';

/// Premium shared decorations for consistent visual language.
/// Access via `context.decorations` or use static methods with a [ColorsManager].
class AppDecorations {
  AppDecorations._();

  /// Glassmorphism card effect — semi-transparent with blur.
  static BoxDecoration glassCard(ColorsManager colors) => BoxDecoration(
    color: colors.surface.withValues(alpha: 0.6),
    borderRadius: BorderRadius.circular(16.r),
    border: Border.all(
      color: colors.border.withValues(alpha: 0.3),
      width: 0.5,
    ),
  );

  /// Standard elevated card.
  static BoxDecoration elevatedCard(ColorsManager colors) => BoxDecoration(
    color: colors.surfaceElevated,
    borderRadius: BorderRadius.circular(16.r),
    border: Border.all(
      color: colors.border.withValues(alpha: 0.3),
      width: 0.5,
    ),
  );

  /// Primary gradient (for buttons, highlights).
  static LinearGradient get primaryGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF8B5CF6),
      Color(0xFF7C3AED),
      Color(0xFF6D28D9),
    ],
  );

  /// Gold gradient for winners/rank 1.
  static LinearGradient get goldGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.amber.shade400,
      Colors.amber.shade700,
    ],
  );

  /// Subtle glow shadow for primary elements.
  static List<BoxShadow> primaryGlow({double opacity = 0.3}) => [
    BoxShadow(
      color: const Color(0xFF7C3AED).withValues(alpha: opacity),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  /// Gold glow for winner elements.
  static List<BoxShadow> goldGlow({double opacity = 0.3}) => [
    BoxShadow(
      color: const Color(0xFFF59E0B).withValues(alpha: opacity),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  /// Card with a neon glow border.
  static BoxDecoration glowCard(ColorsManager colors, {Color? glowColor}) =>
      BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: (glowColor ?? colors.primary).withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (glowColor ?? colors.primary).withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      );

  /// Rank-colored border decoration for player cards.
  static BoxDecoration rankCard(ColorsManager colors, int rank) {
    final Color rankColor = _getRankColor(colors, rank);
    return BoxDecoration(
      color: colors.surfaceElevated,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(
        color: rankColor.withValues(alpha: rank <= 3 ? 0.6 : 0.2),
        width: rank == 1 ? 1.5 : 0.5,
      ),
      boxShadow: rank == 1
          ? [
              BoxShadow(
                color: rankColor.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
    );
  }

  static Color _getRankColor(ColorsManager colors, int rank) => switch (rank) {
    1 => colors.gold,
    2 => colors.silver,
    3 => colors.bronze,
    _ => colors.unranked,
  };
}

/// Extension for quick access to decorations via BuildContext.
extension DecorationContextExtension on BuildContext {
  AppDecorations get decorations => AppDecorations._();
}
