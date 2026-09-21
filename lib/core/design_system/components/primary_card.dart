import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';
import 'primary_animated_pressable_widget.dart';
import 'primary_frame.dart';

class PrimaryCard extends StatelessWidget {
  const PrimaryCard({
    super.key,
    required this.child,
    this.onPressed,
    this.padding,
    this.margin,
    this.borderColor,
    this.color,
    this.borderRadius,
    this.isCircle = false,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final Color? color;
  final BorderRadius? borderRadius;
  final bool isCircle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final card = PrimaryFrame(
      padding: padding,
      margin: margin,
      color: color,
      borderColor: borderColor ?? colorScheme.outlineVariant,
      borderRadius:
          borderRadius ?? BorderRadius.circular(AppDimensions.radiusMd),
      boxShadow: Theme.of(context).brightness == Brightness.dark
          ? null
          : const [
              BoxShadow(
                color: Color(0x0A101828),
                blurRadius: 22,
                offset: Offset(0, 12),
              ),
            ],
      isCircle: isCircle,
      child: child,
    );

    if (onPressed == null) {
      return card;
    }

    return PrimaryAnimatedPressableWidget(
      onPressed: onPressed,
      borderRadius: borderRadius,
      child: card,
    );
  }
}
