import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_dimensions.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';
import 'primary_animated_pressable_widget.dart';
import 'primary_text.dart';

class TertiaryButton extends StatelessWidget {
  const TertiaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.color,
    this.height,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Color? color;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;

    return PrimaryAnimatedPressableWidget(
      onPressed: onPressed,
      child: SizedBox(
        height: height,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.xs.r,
            vertical: AppDimensions.xs.r,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                IconTheme(
                  data: IconThemeData(
                    color: effectiveColor,
                    size: AppDimensions.iconSm,
                  ),
                  child: icon!,
                ),
                AppSpacing.horizontal(AppDimensions.xs),
              ],
              PrimaryText(
                label,
                style: AppTextStyles.bodyLarge,
                color: effectiveColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
