import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';
import 'primary_field_icon_slot.dart';
import 'primary_text.dart';

class PrimarySelectItem<T> {
  const PrimarySelectItem({required this.value, required this.label});

  final T value;
  final String label;
}

class PrimarySelect<T> extends StatefulWidget {
  const PrimarySelect({
    super.key,
    required this.items,
    required this.hintText,
    this.value,
    this.label,
    this.prefixIcon,
    this.errorText,
    this.onChanged,
    this.searchable = false,
    this.autoFocusSearch = false,
    this.maxDropdownHeight = 280,
  });

  final List<PrimarySelectItem<T>> items;
  final T? value;
  final String hintText;
  final String? label;
  final Widget? prefixIcon;
  final String? errorText;
  final ValueChanged<T?>? onChanged;
  final bool searchable;
  final bool autoFocusSearch;
  final double maxDropdownHeight;

  @override
  State<PrimarySelect<T>> createState() => _PrimarySelectState<T>();
}

class _PrimarySelectState<T> extends State<PrimarySelect<T>> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _fieldKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  OverlayEntry? _overlayEntry;
  List<PrimarySelectItem<T>> _filteredItems = const [];

  bool get _isEnabled => widget.onChanged != null;

  PrimarySelectItem<T>? get _selectedItem {
    for (final item in widget.items) {
      if (item.value == widget.value) {
        return item;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.addListener(_filterItems);
  }

  @override
  void didUpdateWidget(covariant PrimarySelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _filterItems(rebuildField: false);
    }
    if (!_isEnabled) {
      _removeOverlay();
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _searchController
      ..removeListener(_filterItems)
      ..dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filterItems({bool rebuildField = true}) {
    final keyword = _normalizeSearchText(_searchController.text);
    final filteredItems = keyword.isEmpty
        ? widget.items
        : widget.items
              .where(
                (item) => _normalizeSearchText(item.label).contains(keyword),
              )
              .toList(growable: false);

    if (mounted && rebuildField) {
      setState(() {
        _filteredItems = filteredItems;
      });
    } else {
      _filteredItems = filteredItems;
    }
    _markOverlayNeedsBuild();
  }

  void _markOverlayNeedsBuild() {
    final overlayEntry = _overlayEntry;
    if (overlayEntry == null) {
      return;
    }

    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle) {
      overlayEntry.markNeedsBuild();
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _overlayEntry == overlayEntry) {
        overlayEntry.markNeedsBuild();
      }
    });
  }

  String _normalizeSearchText(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(
          RegExp(
            '[\u00E0\u00E1\u1EA1\u1EA3\u00E3\u00E2\u1EA7\u1EA5'
            '\u1EAD\u1EA9\u1EAB\u0103\u1EB1\u1EAF\u1EB7\u1EB3\u1EB5]',
          ),
          'a',
        )
        .replaceAll(
          RegExp(
            '[\u00E8\u00E9\u1EB9\u1EBB\u1EBD\u00EA\u1EC1\u1EBF'
            '\u1EC7\u1EC3\u1EC5]',
          ),
          'e',
        )
        .replaceAll(RegExp('[\u00EC\u00ED\u1ECB\u1EC9\u0129]'), 'i')
        .replaceAll(
          RegExp(
            '[\u00F2\u00F3\u1ECD\u1ECF\u00F5\u00F4\u1ED3\u1ED1'
            '\u1ED9\u1ED5\u1ED7\u01A1\u1EDD\u1EDB\u1EE3\u1EDF\u1EE1]',
          ),
          'o',
        )
        .replaceAll(
          RegExp(
            '[\u00F9\u00FA\u1EE5\u1EE7\u0169\u01B0\u1EEB\u1EE9'
            '\u1EF1\u1EED\u1EEF]',
          ),
          'u',
        )
        .replaceAll(RegExp('[\u1EF3\u00FD\u1EF5\u1EF7\u1EF9]'), 'y')
        .replaceAll('\u0111', 'd');
  }

  void _toggleDropdown() {
    if (!_isEnabled) {
      return;
    }

    if (widget.searchable) {
      _showSearchSheet();
      return;
    }

    if (_overlayEntry == null) {
      _showOverlay();
      return;
    }

    _removeOverlay();
  }

  void _showOverlay() {
    _searchController.clear();
    _filteredItems = widget.items;
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    if (widget.searchable && widget.autoFocusSearch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _overlayEntry != null) {
          _searchFocusNode.requestFocus();
        }
      });
    }
  }

  Future<void> _showSearchSheet() async {
    _removeOverlay();

    final selectedItem = await showModalBottomSheet<PrimarySelectItem<T>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _SearchableSelectSheet<T>(
          items: widget.items,
          selectedValue: widget.value,
          title: widget.label ?? widget.hintText,
          hintText: widget.hintText,
          autoFocusSearch: widget.autoFocusSearch,
          normalizeSearchText: _normalizeSearchText,
        );
      },
    );

    if (!mounted || selectedItem == null) {
      return;
    }

    widget.onChanged?.call(selectedItem.value);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _searchFocusNode.unfocus();
  }

  OverlayEntry _buildOverlayEntry() {
    final renderBox =
        _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final fieldSize = renderBox?.size ?? Size.zero;

    return OverlayEntry(
      builder: (context) {
        const dropdownGap = AppSpacing.xxs;
        final mediaQuery = MediaQuery.of(context);
        final fieldOffset =
            renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
        final fieldTop = fieldOffset.dy;
        final fieldBottom = fieldTop + fieldSize.height;
        final visibleBottom =
            mediaQuery.size.height -
            mediaQuery.viewInsets.bottom -
            mediaQuery.padding.bottom;
        final visibleTop = mediaQuery.padding.top;
        final availableBelow = math.max(
          0.0,
          visibleBottom - fieldBottom - dropdownGap,
        );
        final availableAbove = math.max(
          0.0,
          fieldTop - visibleTop - dropdownGap,
        );
        final shouldOpenUp =
            availableBelow < widget.maxDropdownHeight &&
            availableAbove > availableBelow;
        final availableHeight = shouldOpenUp ? availableAbove : availableBelow;
        final dropdownMaxHeight = math.min(
          widget.maxDropdownHeight,
          availableHeight,
        );

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _removeOverlay,
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              targetAnchor: shouldOpenUp
                  ? Alignment.topLeft
                  : Alignment.bottomLeft,
              followerAnchor: shouldOpenUp
                  ? Alignment.bottomLeft
                  : Alignment.topLeft,
              offset: Offset(0, shouldOpenUp ? -dropdownGap : dropdownGap),
              child: SizedBox(
                width: fieldSize.width,
                child: _DropdownMenu<T>(
                  items: _filteredItems,
                  hintText: widget.hintText,
                  searchable: widget.searchable,
                  maxHeight: dropdownMaxHeight,
                  searchController: _searchController,
                  searchFocusNode: _searchFocusNode,
                  onSelected: (item) {
                    widget.onChanged?.call(item.value);
                    _removeOverlay();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedItem = _selectedItem;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            PrimaryText(widget.label!, style: AppTextStyles.bodyLarge),
            AppSpacing.vertical(AppSpacing.xs),
          ],
          GestureDetector(
            key: _fieldKey,
            behavior: HitTestBehavior.opaque,
            onTap: _toggleDropdown,
            child: InputDecorator(
              decoration: InputDecoration(
                filled: true,
                fillColor: _isEnabled
                    ? colorScheme.surface
                    : colorScheme.outlineVariant,
                constraints: const BoxConstraints(
                  minHeight: AppDimensions.inputHeight,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: widget.prefixIcon == null
                      ? AppSpacing.md
                      : AppSpacing.xs,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  borderSide: BorderSide(color: colorScheme.primary),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  borderSide: BorderSide(color: colorScheme.error),
                ),
                errorText: widget.errorText,
              ),
              child: Row(
                children: [
                  if (widget.prefixIcon != null) ...[
                    PrimaryFieldIconSlot(child: widget.prefixIcon!),
                    AppSpacing.horizontal(AppSpacing.sm),
                  ],
                  Expanded(
                    child: PrimaryText(
                      selectedItem?.label ?? widget.hintText,
                      style: AppTextStyles.input,
                      color: selectedItem == null
                          ? colorScheme.onSurface.withValues(alpha: 0.62)
                          : colorScheme.onSurface,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: colorScheme.onSurface.withValues(alpha: 0.72),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchableSelectSheet<T> extends StatefulWidget {
  const _SearchableSelectSheet({
    required this.items,
    required this.selectedValue,
    required this.title,
    required this.hintText,
    required this.autoFocusSearch,
    required this.normalizeSearchText,
  });

  final List<PrimarySelectItem<T>> items;
  final T? selectedValue;
  final String title;
  final String hintText;
  final bool autoFocusSearch;
  final String Function(String value) normalizeSearchText;

  @override
  State<_SearchableSelectSheet<T>> createState() =>
      _SearchableSelectSheetState<T>();
}

class _SearchableSelectSheetState<T> extends State<_SearchableSelectSheet<T>> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late List<PrimarySelectItem<T>> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.addListener(_filterItems);
    if (widget.autoFocusSearch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _searchFocusNode.requestFocus();
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant _SearchableSelectSheet<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _filterItems();
    }
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_filterItems)
      ..dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filterItems() {
    final keyword = widget.normalizeSearchText(_searchController.text);
    setState(() {
      _filteredItems = keyword.isEmpty
          ? widget.items
          : widget.items
                .where(
                  (item) =>
                      widget.normalizeSearchText(item.label).contains(keyword),
                )
                .toList(growable: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final viewInsets = MediaQuery.viewInsetsOf(context);

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: FractionallySizedBox(
        heightFactor: 0.86,
        child: Material(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusMd),
          ),
          clipBehavior: Clip.antiAlias,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Column(
              children: [
                AppSpacing.vertical(AppSpacing.xs),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.sm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PrimaryText(
                        widget.title,
                        style: AppTextStyles.titleMedium,
                      ),
                      AppSpacing.vertical(AppSpacing.sm),
                      _SelectSearchField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        hintText: widget.hintText,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _filteredItems.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: PrimaryText(
                              widget.hintText,
                              style: AppTextStyles.bodyMedium,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.62,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView.separated(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          itemCount: _filteredItems.length,
                          separatorBuilder: (_, _) => Divider(
                            height: 1,
                            color: colorScheme.outlineVariant,
                          ),
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            final isSelected =
                                item.value == widget.selectedValue;

                            return InkWell(
                              onTap: () => Navigator.of(context).pop(item),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: PrimaryText(
                                        item.label,
                                        style: AppTextStyles.input,
                                        color: isSelected
                                            ? colorScheme.primary
                                            : colorScheme.onSurface,
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_rounded,
                                        color: colorScheme.primary,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectSearchField extends StatelessWidget {
  const _SelectSearchField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      style: AppTextStyles.input.copyWith(color: colorScheme.onSurface),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: AppTextStyles.input.copyWith(color: AppColors.inkSoft),
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.inkSoft),
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
      ),
    );
  }
}

class _DropdownMenu<T> extends StatelessWidget {
  const _DropdownMenu({
    required this.items,
    required this.hintText,
    required this.searchable,
    required this.maxHeight,
    required this.searchController,
    required this.searchFocusNode,
    required this.onSelected,
  });

  final List<PrimarySelectItem<T>> items;
  final String hintText;
  final bool searchable;
  final double maxHeight;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final ValueChanged<PrimarySelectItem<T>> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      shadowColor: colorScheme.onSurface.withValues(alpha: 0.2),
      elevation: 10,
      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (searchable)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: _SelectSearchField(
                  controller: searchController,
                  focusNode: searchFocusNode,
                  hintText: hintText,
                ),
              ),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: items.length,
                separatorBuilder: (_, _) =>
                    Divider(height: 1, color: colorScheme.outlineVariant),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return InkWell(
                    onTap: () => onSelected(item),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      child: PrimaryText(
                        item.label,
                        style: AppTextStyles.input,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
