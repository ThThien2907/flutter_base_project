import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  static const xxxs = 2.0;
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 40.0;
  static const xxxl = 48.0;
  static const xxxxl = 56.0;

  static SizedBox vertical(double value) => SizedBox(height: value);
  static SizedBox horizontal(double value) => SizedBox(width: value);
}
