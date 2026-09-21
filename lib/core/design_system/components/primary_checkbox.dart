import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';
import 'primary_animated_pressable_widget.dart';
import 'primary_text.dart';

enum PrimaryCheckboxVariant { square, pill }

class PrimaryCheckbox extends StatelessWidget {
  const PrimaryCheckbox({
    super.key,
    required this.value,
    this.label,
    this.isCenter = false,
    required this.onChanged,
    this.variant = PrimaryCheckboxVariant.square,
  });

  final bool value;
  final String? label;
  final bool isCenter;
  final ValueChanged<bool> onChanged;
  final PrimaryCheckboxVariant variant;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PrimaryAnimatedPressableWidget(
      onPressed: () => onChanged(!value),
      child: Row(
        mainAxisSize: label != null ? MainAxisSize.max : MainAxisSize.min,
        crossAxisAlignment: isCenter
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: variant == PrimaryCheckboxVariant.pill ? 44 : 22,
            height: 22,
            decoration: BoxDecoration(
              color: value ? colorScheme.primary : colorScheme.surface,
              borderRadius: BorderRadius.circular(
                variant == PrimaryCheckboxVariant.pill
                    ? AppDimensions.radiusLg
                    : AppDimensions.radiusXs,
              ),
              border: Border.all(
                color: value ? colorScheme.primary : colorScheme.outline,
              ),
            ),
            child: value
                ? Icon(
                    Icons.check_rounded,
                    color: colorScheme.onPrimary,
                    size: AppDimensions.iconSm,
                  )
                : null,
          ),
          AppSpacing.horizontal(AppSpacing.sm),
          if (label != null)
            Expanded(
              child: PrimaryText(label!, style: AppTextStyles.bodyMedium),
            ),
        ],
      ),
    );
  }
}
