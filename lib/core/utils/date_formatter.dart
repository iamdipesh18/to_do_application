import 'package:intl/intl.dart';

/// Utility functions for formatting dates

class DateFormatter {
  /// Formats a [DateTime] to a short readable string like "Aug 1, 2025"
  static String formatShortDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  /// Formats a [DateTime] to a date and time string like "Aug 1, 2025 14:30"
  static String formatDateTime(DateTime date) {
    return DateFormat('yMMMd HH:mm').format(date);
  }

  /// Formats a [DateTime] to just the time, like "14:30"
  static String formatTime(DateTime date) {
    return DateFormat.Hm().format(date);
  }
}
