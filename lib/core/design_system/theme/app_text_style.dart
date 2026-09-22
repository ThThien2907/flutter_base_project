import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static const String fontFamily = 'Afacad Flux';

  static TextStyle get display => TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 32.sp,
    fontWeight: FontWeight.w900,
    height: 1.18,
  );

  static TextStyle get displayLarge => TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 30.sp,
    fontWeight: FontWeight.w900,
    height: 1.18,
  );

  static TextStyle get displayMedium => TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 28.sp,
    fontWeight: FontWeight.w900,
    height: 1.18,
  );

  static TextStyle get displaySmall => TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 26.sp,
    fontWeight: FontWeight.w900,
    height: 1.18,
  );

  static TextStyle get titleXXXLarge => TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static TextStyle get titleXXLarge => TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static TextStyle get titleXLarge => TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static TextStyle get titleLarge => TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static TextStyle get titleMedium => TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get titleSmall => TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get titleXSmall => TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get labelXLarge => TextStyle(
    fontFamily: fontFamily,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static TextStyle get labelLarge => TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static TextStyle get labelMedium => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static TextStyle get labelSmall => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static TextStyle get labelXSmall => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static TextStyle get bodyLarge => TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontFamily: fontFamily,
    color: AppColors.inkMuted,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get bodySmall => TextStyle(
    fontFamily: fontFamily,
    color: AppColors.inkMuted,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get bodyXSmall => TextStyle(
    fontFamily: fontFamily,
    color: AppColors.inkMuted,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get caption => TextStyle(
    fontFamily: fontFamily,
    color: AppColors.inkSoft,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get button => TextStyle(
    fontFamily: fontFamily,
    color: AppColors.surface,
    fontSize: 17.sp,
    fontWeight: FontWeight.w800,
    height: 1.2,
  );

  static TextStyle get input => TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );
}
