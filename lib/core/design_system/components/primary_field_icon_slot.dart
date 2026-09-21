import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';

class PrimaryFieldIconSlot extends StatelessWidget {
  const PrimaryFieldIconSlot({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
      ),
      child: SizedBox(
        width: 42,
        height: 42,
        child: Center(
          child: IconTheme(
            data: IconThemeData(
              color: Theme.of(context).colorScheme.primary,
              size: AppDimensions.iconMd,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
