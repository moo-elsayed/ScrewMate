import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theming/colors.dart';

String formatDate(String rawDate) {
  final date = DateTime.tryParse(rawDate);
  if (date == null) return rawDate; // fallback

  return DateFormat('d MMM, yyyy - h:mm a').format(date);
}

Color getRankColor(int? rank) {
  return rank == 1
      ? ColorsManager.gold
      : rank == 2
      ? ColorsManager.sliver
      : rank == 3
      ? ColorsManager.bronze
      : Colors.brown;
}
