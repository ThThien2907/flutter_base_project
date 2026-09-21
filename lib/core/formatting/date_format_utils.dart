import 'package:intl/intl.dart';

class DateFormatUtils {
  DateFormatUtils._();

  static const String defaultDateFormat = 'dd/MM/yyyy';
  static const String defaultDateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String requestDateFormat = 'yyyy-MM-dd';

  static DateTime? parseDisplayDate(
    String value, {
    String pattern = defaultDateFormat,
  }) {
    try {
      return DateFormat(pattern).parseStrict(value);
    } on FormatException {
      return null;
    }
  }

  static String formatDisplayDate(
    DateTime date, {
    String pattern = defaultDateFormat,
  }) {
    return DateFormat(pattern).format(date);
  }

  static String formatDisplayDateTime(
    DateTime date, {
    String pattern = defaultDateTimeFormat,
  }) {
    return DateFormat(pattern).format(date);
  }

  static String? formatRequestDate(
    DateTime? date, {
    String pattern = requestDateFormat,
  }) {
    if (date == null) return null;
    return DateFormat(pattern).format(date);
  }
}
