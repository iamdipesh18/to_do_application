// This imports the 'intl' package, which is used to format dates, times, numbers, etc.
// It helps convert DateTime objects into readable strings in different formats.
import 'package:intl/intl.dart';

// This class helps format DateTime objects in different ways
// so they can be displayed nicely in the app.
class DateFormatter {
  // This method takes a DateTime and formats it as 'yyyy-MM-dd'
  // For example, August 2, 2025 becomes '2025-08-02'
  static String format(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  // This method returns a more human-friendly version of the date and time.
  // It includes the full date and time in readable form, like:
  // "August 2, 2025 5:30 PM"
  static String formatReadable(DateTime dateTime) {
    final DateFormat formatter = DateFormat.yMMMMd().add_jm();
    return formatter.format(dateTime);
  }
}
