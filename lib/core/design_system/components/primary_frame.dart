import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';

class PrimaryFrame extends StatelessWidget {
  const PrimaryFrame({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.borderColor,
    this.borderRadius,
    this.boxShadow,
    this.gradient,
    this.isCircle = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? color;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final bool isCircle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? color ?? colorScheme.surface : null,
        gradient: gradient,
        borderRadius: !isCircle
            ? borderRadius ?? BorderRadius.circular(AppDimensions.radiusMd)
            : null,
        border: borderColor == null ? null : Border.all(color: borderColor!),
        boxShadow: boxShadow,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      ),
      child: child,
    );
  }
}
