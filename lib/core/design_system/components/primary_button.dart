import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_dimensions.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';
import 'primary_animated_pressable_widget.dart';
import 'primary_text.dart';

enum PrimaryButtonVariant { filled, outlined, iconFilled, iconOutlined }

class PrimaryButton extends StatelessWidget {
  const PrimaryButton.filled({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.expand = true,
    this.height,
  }) : variant = PrimaryButtonVariant.filled;

  const PrimaryButton.outlined({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.expand = true,
    this.height,
  }) : variant = PrimaryButtonVariant.outlined;

  const PrimaryButton.iconFilled({
    super.key,
    required this.icon,
    this.onPressed,
    this.label,
    this.trailingIcon,
    this.isLoading = false,
    this.expand = false,
    this.height,
  }) : variant = PrimaryButtonVariant.iconFilled;

  const PrimaryButton.iconOutlined({
    super.key,
    required this.icon,
    this.onPressed,
    this.label,
    this.trailingIcon,
    this.isLoading = false,
    this.expand = false,
    this.height,
  }) : variant = PrimaryButtonVariant.iconOutlined;

  final String? label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Widget? trailingIcon;
  final bool isLoading;
  final bool expand;
  final double? height;
  final PrimaryButtonVariant variant;

  bool get _isOutlined =>
      variant == PrimaryButtonVariant.outlined ||
      variant == PrimaryButtonVariant.iconOutlined;

  bool get _isIconOnly =>
      variant == PrimaryButtonVariant.iconFilled ||
      variant == PrimaryButtonVariant.iconOutlined;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = onPressed != null && !isLoading;
    final foreground = enabled
        ? (_isOutlined ? colorScheme.primary : colorScheme.onPrimary)
        : colorScheme.onSurfaceVariant;
    final background = enabled
        ? (_isOutlined ? colorScheme.surface : colorScheme.primary)
        : colorScheme.surfaceContainerHighest;
    final buttonHeight = height ?? AppDimensions.buttonHeight.h;
    final iconButtonWidth = height ?? AppDimensions.buttonHeight.w;

    final content = _buildContent(foreground);
    final button = PrimaryAnimatedPressableWidget(
      enabled: enabled,
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: buttonHeight,
        width: expand
            ? double.infinity
            : (_isIconOnly && label == null ? iconButtonWidth : null),
        padding: EdgeInsets.symmetric(
          horizontal: (_isIconOnly ? AppDimensions.md : AppDimensions.sm).r,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          border: Border.all(
            color: enabled
                ? (_isOutlined ? colorScheme.primary : colorScheme.primary)
                : colorScheme.outline,
          ),
          boxShadow: _isOutlined
              ? null
              : [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.15),
                    blurRadius: 5.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
        ),
        child: Center(child: content),
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }

  Widget _buildContent(Color foreground) {
    if (isLoading) {
      return SizedBox(
        width: AppDimensions.iconMd,
        height: AppDimensions.iconMd,
        child: CircularProgressIndicator(
          strokeWidth: 2.4,
          valueColor: AlwaysStoppedAnimation<Color>(foreground),
        ),
      );
    }

    if (_isIconOnly && label == null) {
      return IconTheme(
        data: IconThemeData(color: foreground, size: AppDimensions.iconMd),
        child: icon!,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          IconTheme(
            data: IconThemeData(color: foreground, size: AppDimensions.iconMd),
            child: icon!,
          ),
          AppSpacing.horizontal(AppDimensions.xxs),
        ],
        Flexible(
          child: PrimaryText(
            label ?? '',
            style: AppTextStyles.button,
            color: foreground,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (trailingIcon != null) ...[
          AppSpacing.horizontal(AppDimensions.xxs),
          IconTheme(
            data: IconThemeData(color: foreground, size: AppDimensions.iconMd),
            child: trailingIcon!,
          ),
        ],
      ],
    );
  }
}
