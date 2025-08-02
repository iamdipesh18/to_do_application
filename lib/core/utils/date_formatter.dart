import 'package:intl/intl.dart';

class DateFormatter {
  static String format(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  static String formatReadable(DateTime dateTime) {
    final DateFormat formatter = DateFormat.yMMMMd().add_jm();
    return formatter.format(dateTime);
  }
}
