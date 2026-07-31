import 'package:intl/intl.dart';

class Helpers {

  static String formatTime(DateTime time) {
    return DateFormat("hh:mm a").format(time);
  }

}
