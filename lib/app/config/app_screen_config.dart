import 'package:flutter/widgets.dart';

/// Responsive layout configuration shared by the whole application.
///
/// Keep [designSize] aligned with the base frame used by the UI design team.
abstract final class AppScreenConfig {
  static const designSize = Size(375, 812);
}
