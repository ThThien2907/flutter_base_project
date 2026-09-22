import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Values derived from the design frame.
///
/// Generic tokens stay raw so callers can scale them by context. Semantic
/// radius and icon tokens are already scaled with `.r`.
abstract final class AppDimensions {
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

  static double get radiusXs => 8.r;
  static double get radiusSm => 12.r;
  static double get radiusMd => 16.r;
  static double get radiusLg => 24.r;

  static double get iconXXSm => 12.r;
  static double get iconXSm => 16.r;
  static double get iconSm => 18.r;
  static double get iconMd => 20.r;
  static double get iconLg => 24.r;
  static double get iconXLg => 28.r;
  static double get iconXXLg => 32.r;

  static const inputHeight = 58.0;

  static const xSmallButtonHeight = 36.0;
  static const smallButtonHeight = 48.0;
  static const buttonHeight = 56.0;

  static const logoWidth = 250.0;
  static const appMaxWidth = 520.0;
}
