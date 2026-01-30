import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theming/app_colors.dart';

String formatDate(String rawDate) {
  final date = DateTime.tryParse(rawDate);
  if (date == null) return rawDate; // fallback

  return DateFormat('d MMM, yyyy - h:mm a').format(date);
}

Color getRankColor(int? rank) => rank == 1
    ? AppColors.gold
    : rank == 2
    ? AppColors.sliver
    : rank == 3
    ? AppColors.bronze
    : AppColors.unranked;
