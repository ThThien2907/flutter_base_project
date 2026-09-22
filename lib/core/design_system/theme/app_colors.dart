import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'app_dimensions.dart';

abstract final class AppColors {
  // Primary color scale (Default Blue)
  static const primary50 = Color(0xFFEAF6FC);
  static const primary100 = Color(0xFFD5EDF8);
  static const primary200 = Color(0xFFABDDF1);
  static const primary300 = Color(0xFF78C7E7);
  static const primary400 = Color(0xFF3AA5D5);
  static const primary500 = Color(0xFF0078BF);
  static const primary600 = Color(0xFF00649F);
  static const primary700 = Color(0xFF005286);
  static const primary800 = Color(0xFF004472);
  static const primary900 = Color(0xFF003A6F);
  static const primary950 = Color(0xFF002443);

  // Secondary color scale (Default Orange)
  static const secondary50 = Color(0xFFFFF4EC);
  static const secondary100 = Color(0xFFFFE7D6);
  static const secondary200 = Color(0xFFFFC7A8);
  static const secondary300 = Color(0xFFFFA16F);
  static const secondary400 = Color(0xFFFF793B);
  static const secondary500 = Color(0xFFFF5700);
  static const secondary600 = Color(0xFFDC4700);
  static const secondary700 = Color(0xFFB93800);
  static const secondary800 = Color(0xFF942D00);
  static const secondary900 = Color(0xFF762700);
  static const secondary950 = Color(0xFF401100);

  // Brand roles
  static const primary = primary500;
  static const primaryDark = primary900;
  static const primaryLight = primary50;
  static const secondary = secondary500;
  static const secondaryLight = secondary50;
  static const tertiary = Color(0xFFFF9800);
  static const tertiaryLight = Color(0xFFFFF3D6);
  static const onTertiary = Color(0xFF321D00);
  static const onTertiaryContainer = Color(0xFF3E2600);
  static const tertiaryFixedDim = Color(0xFFFFD08A);
  static const onTertiaryFixed = Color(0xFF2A1800);
  static const onTertiaryFixedVariant = Color(0xFF694300);

  // Semantic status colors
  static const success = Color(0xFF16834A);
  static const successLight = Color(0xFFE8F7EE);
  static const warning = Color(0xFFAD5700);
  static const warningLight = Color(0xFFFFF3DF);
  static const error = Color(0xFFD92D20);
  static const errorLight = Color(0xFFFFE9E7);
  static const onErrorContainer = Color(0xFF6E100B);
  static const info = primary500;
  static const infoLight = primary50;

  // Light neutral roles
  static const ink = Color(0xFF102A43);
  static const inkMuted = Color(0xFF52667A);
  static const inkSoft = Color(0xFF7B8B9A);
  static const line = Color(0xFFD5DEE7);
  static const lineSoft = Color(0xFFE8EEF3);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceSoft = Color(0xFFF4F8FB);
  static const background = Color(0xFFF8FAFC);
  static const disabled = Color(0xFFBBC6D1);
  static const onDisabled = Color(0xFF607286);
  static const surfaceDim = Color(0xFFDCE3E9);
  static const surfaceContainer = Color(0xFFEEF3F7);
  static const surfaceContainerHigh = Color(0xFFE8EEF3);
  static const surfaceContainerHighest = Color(0xFFE0E7ED);
  static const scrim = Color(0xFF001B2E);
  static const transparent = Colors.transparent;

  // Dark theme roles
  static const darkPrimary = Color(0xFF5BC0EB);
  static const darkPrimaryDark = Color(0xFF8DD5F2);
  static const darkPrimaryLight = Color(0xFF063B55);
  static const darkOnPrimary = Color(0xFF00344D);
  static const darkOnPrimaryContainer = Color(0xFFBCE8FA);
  static const darkSecondary = Color(0xFFFF9863);
  static const darkSecondaryLight = Color(0xFF522100);
  static const darkOnSecondaryContainer = Color(0xFFFFDBCA);

  static const darkTertiary = Color(0xFFFFC268);
  static const darkTertiaryLight = Color(0xFF4B2D00);
  static const darkOnTertiary = Color(0xFF432B00);
  static const darkOnTertiaryContainer = Color(0xFFFFDDA7);
  static const darkError = Color(0xFFFFB4AB);
  static const darkOnError = Color(0xFF690005);
  static const darkErrorContainer = Color(0xFF93000A);
  static const darkOnErrorContainer = Color(0xFFFFDAD6);
  static const darkInk = Color(0xFFF3F7FA);
  static const darkInkMuted = Color(0xFFC1CCD6);
  static const darkInkSoft = Color(0xFF8FA1B2);
  static const darkLine = Color(0xFF3A4B5C);
  static const darkLineSoft = Color(0xFF263746);
  static const darkSurface = Color(0xFF101D29);
  static const darkSurfaceSoft = Color(0xFF172735);
  static const darkBackground = Color(0xFF08141F);
  static const darkSurfaceBright = Color(0xFF344552);
  static const darkSurfaceLowest = Color(0xFF061019);
  static const darkSurfaceHigh = Color(0xFF20313F);
  static const darkSurfaceHighest = Color(0xFF2B3C49);
  static const darkDisabled = Color(0xFF41515F);
  static const darkOnDisabled = Color(0xFF91A0AE);
  static const darkShadow = Color(0xFF000000);

  // Shadows
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: primary900.withValues(alpha: 0.12),
      blurRadius: AppDimensions.md.r,
      offset: Offset(0, AppDimensions.xs.h),
    ),
  ];

  static List<BoxShadow> get strongShadow => [
    BoxShadow(
      color: primary900.withValues(alpha: 0.18),
      blurRadius: AppDimensions.lg.r,
      offset: Offset(0, -AppDimensions.xs.h),
    ),
  ];
}

@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
  });

  static const light = AppSemanticColors(
    success: AppColors.success,
    onSuccess: AppColors.surface,
    successContainer: AppColors.successLight,
    onSuccessContainer: Color(0xFF073D20),
    warning: AppColors.warning,
    onWarning: AppColors.surface,
    warningContainer: AppColors.warningLight,
    onWarningContainer: Color(0xFF4A2800),
    info: AppColors.info,
    onInfo: AppColors.surface,
    infoContainer: AppColors.infoLight,
    onInfoContainer: AppColors.primary900,
  );

  static const dark = AppSemanticColors(
    success: Color(0xFF55D98B),
    onSuccess: Color(0xFF00391B),
    successContainer: Color(0xFF07552A),
    onSuccessContainer: Color(0xFFB7F4CC),
    warning: Color(0xFFFFC46B),
    onWarning: Color(0xFF462B00),
    warningContainer: Color(0xFF633F00),
    onWarningContainer: Color(0xFFFFDDB0),
    info: AppColors.darkPrimary,
    onInfo: Color(0xFF00344D),
    infoContainer: AppColors.darkPrimaryLight,
    onInfoContainer: Color(0xFFBCE8FA),
  );

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color onInfoContainer;

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
    );
  }

  @override
  AppSemanticColors lerp(covariant AppSemanticColors? other, double t) {
    if (other == null) {
      return this;
    }

    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      )!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
    );
  }
}
