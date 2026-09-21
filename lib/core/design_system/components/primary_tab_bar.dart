import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';

class PrimaryTabBar extends StatelessWidget {
  const PrimaryTabBar({
    super.key,
    this.onTap,
    required this.items,
    required this.controller,
    this.isScrollable,
    this.borderRadius,
    this.height,
  });

  final List<String> items;
  final void Function(int)? onTap;
  final TabController controller;
  final bool? isScrollable;
  final BorderRadius? borderRadius;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        borderRadius:
            borderRadius ?? BorderRadius.circular(AppDimensions.radiusMd),
        color: scaffoldBackgroundColor,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: TabBar(
        controller: controller,
        padding: EdgeInsets.zero,
        labelColor: colorScheme.primary,
        labelStyle: AppTextStyles.labelMedium,
        unselectedLabelColor: colorScheme.onSurface,
        unselectedLabelStyle: AppTextStyles.bodyMedium,
        labelPadding: EdgeInsets.zero,
        indicator: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        indicatorPadding: EdgeInsets.zero,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicatorAnimation: TabIndicatorAnimation.elastic,
        splashBorderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        isScrollable: isScrollable ?? false,
        tabAlignment:
            isScrollable == true ? TabAlignment.start : TabAlignment.fill,
        tabs: items
            .map(((item) => Tab(text: item, height: AppSpacing.xxl)))
            .toList(),
        onTap: onTap,
      ),
    );
  }
}
