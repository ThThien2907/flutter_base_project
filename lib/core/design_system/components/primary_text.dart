import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';

class PrimaryText extends StatelessWidget {
  const PrimaryText(
    this.data, {
    super.key,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String data;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? _resolveThemeColor(context, style?.color);
    final effectiveStyle = (style ?? AppTextStyles.bodyMedium).copyWith(
      color: textColor,
    );

    return Text(
      data,
      style: effectiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  Color _resolveThemeColor(BuildContext context, Color? styleColor) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fallbackColor = styleColor ?? colorScheme.onSurface;

    if (!isDark) {
      return fallbackColor;
    }

    return switch (fallbackColor) {
      AppColors.ink => colorScheme.onSurface,
      AppColors.inkMuted => AppColors.darkInkMuted,
      AppColors.inkSoft => AppColors.darkInkSoft,
      AppColors.surface => colorScheme.onPrimary,
      _ => fallbackColor,
    };
  }
}
