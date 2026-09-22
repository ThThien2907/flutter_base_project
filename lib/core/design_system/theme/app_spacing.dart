import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

abstract final class AppSpacing {
  /// A vertical gap scaled against the design height.
  static SizedBox vertical(double value) => SizedBox(height: value.h);

  /// A horizontal gap scaled against the design width.
  static SizedBox horizontal(double value) => SizedBox(width: value.w);
}
