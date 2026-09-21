import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static const String fontFamily = 'Afacad Flux';

  static const display = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 32,
    fontWeight: FontWeight.w900,
    height: 1.18,
  );

  static const displayLarge = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 30,
    fontWeight: FontWeight.w900,
    height: 1.18,
  );

  static const displayMedium = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 28,
    fontWeight: FontWeight.w900,
    height: 1.18,
  );

  static const displaySmall = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 26,
    fontWeight: FontWeight.w900,
    height: 1.18,
  );

  static const titleXXXLarge = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static const titleXXLarge = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static const titleXLarge = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static const titleLarge = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static const titleMedium = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const titleSmall = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static const titleXSmall = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle labelXLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static const TextStyle labelXSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static const bodyLarge = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  static const bodyMedium = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.inkMuted,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const bodySmall = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.inkMuted,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const bodyXSmall = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.inkMuted,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const caption = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.inkSoft,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const button = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.surface,
    fontSize: 17,
    fontWeight: FontWeight.w800,
    height: 1.2,
  );

  static const input = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );
}
