import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';
import 'primary_text.dart';

class PrimaryPopupMenuItem<T> {
  const PrimaryPopupMenuItem({
    required this.value,
    required this.label,
    required this.icon,
    this.enabled = true,
    this.foregroundColor,
  });

  final T value;
  final String label;
  final IconData icon;
  final bool enabled;
  final Color? foregroundColor;
}

class PrimaryPopupMenuButton<T> extends StatelessWidget {
  const PrimaryPopupMenuButton({
    super.key,
    required this.items,
    required this.onSelected,
    this.icon = const Icon(Icons.more_vert),
    this.tooltip,
    this.enabled = true,
    this.offset = Offset.zero,
    this.position,
    this.elevation = 8,
    this.menuColor,
    this.borderColor,
    this.borderWidth = 1,
  });

  final List<PrimaryPopupMenuItem<T>> items;
  final PopupMenuItemSelected<T> onSelected;
  final Widget icon;
  final String? tooltip;
  final bool enabled;
  final Offset offset;
  final PopupMenuPosition? position;
  final double elevation;
  final Color? menuColor;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<T>(
      icon: icon,
      tooltip: tooltip,
      enabled: enabled,
      offset: offset,
      position: position,
      elevation: elevation,
      color: menuColor ?? colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        side: BorderSide(
          color: borderColor ?? colorScheme.outlineVariant,
          width: borderWidth,
        ),
      ),
      padding: EdgeInsets.zero,
      onSelected: onSelected,
      itemBuilder: (context) => items
          .map(
            (item) => PopupMenuItem<T>(
              value: item.value,
              enabled: item.enabled,
              child: _PrimaryPopupMenuItemContent(item: item),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _PrimaryPopupMenuItemContent<T> extends StatelessWidget {
  const _PrimaryPopupMenuItemContent({required this.item});

  final PrimaryPopupMenuItem<T> item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final foreground = item.enabled
        ? item.foregroundColor ?? colorScheme.onSurface
        : colorScheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(item.icon, size: AppDimensions.iconMd, color: foreground),
        AppSpacing.horizontal(AppDimensions.xs),
        Flexible(
          child: PrimaryText(
            item.label,
            style: AppTextStyles.input,
            color: foreground,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
