import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../theming/app_colors.dart';
import '../theming/colors_manager.dart';

extension Navigation on BuildContext {
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushNamed(routeName, arguments: arguments);

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);

  Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, {
    Object? arguments,
    required RoutePredicate predicate,
  }) => Navigator.of(
    this,
  ).pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);

  void pop<T extends Object?>([T? result]) => Navigator.of(this).pop(result);
}

extension AppToastColorExtension on ToastificationType {
  Color getColor(BuildContext context) => switch (this) {
    .success => AppColors.success,
    .info => AppColors.info,
    .warning => AppColors.warning,
    .error => AppColors.error,
  };
}

extension AppToastIconExtension on ToastificationType {
  IconData get stateIcon => switch (this) {
    .success => Icons.check_circle_outline_rounded,
    .error => Icons.error_outline_rounded,
    .warning => Icons.warning_amber_rounded,
    .info => Icons.info_outline_rounded,
  };
}

extension RankColorExtension on int? {
  Color getRankColor(BuildContext context) =>
      getRankColorWithColors(context.colors);

  Color getRankColorWithColors(ColorsManager colors) => switch (this) {
        1 => colors.gold,
        2 => colors.silver,
        3 => colors.bronze,
        _ => colors.unranked,
      };
}
