import 'package:easy_localization/easy_localization.dart';

String formatDate(String rawDate) {
  final date = DateTime.tryParse(rawDate);
  if (date == null) return rawDate; // fallback

  return DateFormat('d MMM, yyyy - h:mm a').format(date);
}
