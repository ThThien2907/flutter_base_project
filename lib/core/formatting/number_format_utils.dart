import 'package:intl/intl.dart';

class NumberFormatUtils {
  NumberFormatUtils._();

  static const String defaultCurrencySymbol = 'đ';
  static const String defaultWeightUnit = 'kg';

  static String formatCurrencyWithUnit(
    num? value, {
    String locale = 'vi_VN',
    String symbol = defaultCurrencySymbol,
  }) {
    if (value == null) return '--';
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
    );
    return formatter.format(value);
  }

  static String formatShortCurrency(
    num? value, {
    String locale = 'vi_VN',
  }) {
    if (value == null) return '--';

    final absValue = value.abs();
    final formatter = NumberFormat.decimalPattern(locale)
      ..maximumFractionDigits = 2
      ..minimumFractionDigits = 0;

    if (absValue >= 1e6) {
      return '${formatter.format(value / 1e6)} tr';
    }

    if (absValue >= 1e3) {
      return '${formatter.format(value / 1e3)} k';
    }

    return formatter.format(value);
  }

  static String formatCurrencyInput(
    num? value, {
    String locale = 'vi_VN',
  }) {
    if (value == null) return '';
    return NumberFormat.decimalPattern(locale).format(value);
  }

  static int parseCurrencyInput(String value) {
    return int.tryParse(value.replaceAll(RegExp(r'\D'), '')) ?? 0;
  }

  static String formatWeightWithUnit(
    num? value, {
    String unit = defaultWeightUnit,
    String locale = 'vi_VN',
  }) {
    if (value == null) return '--';
    final formatter = NumberFormat.decimalPattern(locale);
    return '${formatter.format(value)} $unit';
  }

  static double? mToKm(double? value) {
    if (value == null) return null;
    return value / 1000;
  }

  static String formatDistance(num? distanceInMeters) {
    if (distanceInMeters == null) return '--';

    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m';
    }

    final distanceInKilometers = distanceInMeters / 1000;
    return '${distanceInKilometers.toStringAsFixed(1)} km';
  }
}
