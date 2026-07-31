import 'package:intl/intl.dart';

class Helpers {
  static String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static bool isEmpty(String value) {
    return value.trim().isEmpty;
  }
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
