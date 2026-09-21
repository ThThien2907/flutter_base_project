import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';
import 'primary_field_icon_slot.dart';
import 'primary_text.dart';

class PrimaryAutoCompleteTextField<T> extends StatefulWidget {
  final String? Function(String value)? validator;
  final void Function(T value)? onSelected;
  final Future<List<T>> Function(String keyword) onSearch;
  final String? label;
  final String? hintText;
  final String? instruction;
  final String Function(T item)? displayStringForOption;
  final TextEditingController? controller;
  final FocusNode? node;
  final FocusNode? nextNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextAlign? textAlign;
  final bool enabled;
  final bool isRequired;
  final bool autofocus;
  final int? maxLength;
  final int? maxLine;
  final AutovalidateMode? validateMode;
  final EdgeInsets? paddingInput;
  final Color? fillColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? prefix;
  final Widget? helper;
  final String? suffixText;
  final Duration debounce;

  const PrimaryAutoCompleteTextField({
    super.key,
    required this.onSearch,
    this.displayStringForOption,
    this.validator,
    this.onSelected,
    this.hintText,
    this.enabled = true,
    this.controller,
    this.label,
    this.paddingInput,
    this.fillColor,
    this.maxLine = 1,
    this.isRequired = false,
    this.suffixIcon,
    this.prefixIcon,
    this.prefix,
    this.validateMode,
    this.instruction,
    this.helper,
    this.node,
    this.nextNode,
    this.textInputAction,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign,
    this.keyboardType,
    this.maxLength,
    this.suffixText,
    this.debounce = const Duration(milliseconds: 500),
  });

  @override
  State<PrimaryAutoCompleteTextField<T>> createState() =>
      _PrimaryAutoCompleteTextFieldState<T>();
}

class _PrimaryAutoCompleteTextFieldState<T>
    extends State<PrimaryAutoCompleteTextField<T>> {
  late final TextEditingController _internalController;
  String? errorText;
  VoidCallback? _controllerListener;
  TextEditingController? _listenedController;
  bool _isSheetOpen = false;

  TextEditingController get _controller =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController();
    _controllerListener = () {
      if (mounted && errorText != null) {
        setState(() {
          errorText = null;
        });
      }
    };
    _listenedController = _controller;
    _listenedController?.addListener(_controllerListener!);
  }

  @override
  void didUpdateWidget(covariant PrimaryAutoCompleteTextField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_listenedController != _controller) {
      _listenedController?.removeListener(_controllerListener!);
      _listenedController = _controller;
      _listenedController?.addListener(_controllerListener!);
    }
    if (!widget.enabled && errorText != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => errorText = null);
        }
      });
    }
  }

  @override
  void dispose() {
    if (_controllerListener != null) {
      _listenedController?.removeListener(_controllerListener!);
    }
    _internalController.dispose();
    super.dispose();
  }

  Future<void> _openSearchSheet() async {
    if (!widget.enabled || _isSheetOpen) {
      return;
    }

    _isSheetOpen = true;
    final selectedItem = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _AutocompleteSearchSheet<T>(
          initialText: _controller.text,
          title: widget.label ?? widget.hintText ?? '',
          hintText: widget.hintText ?? '',
          debounce: widget.debounce,
          textCapitalization: widget.textCapitalization,
          keyboardType: widget.keyboardType,
          displayStringForOption: widget.displayStringForOption,
          onSearch: widget.onSearch,
          onSelected: widget.onSelected,
        );
      },
    );
    _isSheetOpen = false;

    if (!mounted || selectedItem == null) {
      return;
    }

    _controller.text =
        widget.displayStringForOption?.call(selectedItem) ??
        selectedItem.toString();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMultiline = (widget.maxLine ?? 1) > 1;

    return Padding(
      padding: widget.paddingInput ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            Row(
              children: [
                PrimaryText(widget.label!, style: AppTextStyles.bodyLarge),
                if (widget.isRequired)
                  const PrimaryText(
                    ' *',
                    style: AppTextStyles.bodyLarge,
                    color: AppColors.error,
                  ),
              ],
            ),
            AppSpacing.vertical(AppSpacing.xs),
          ],
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _openSearchSheet,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              height: isMultiline ? null : AppDimensions.inputHeight,
              constraints: const BoxConstraints(
                minHeight: AppDimensions.inputHeight,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: isMultiline ? AppSpacing.sm : 0,
              ),
              decoration: BoxDecoration(
                color: widget.enabled
                    ? colorScheme.surface
                    : colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                border: Border.all(
                  color: errorText == null
                      ? colorScheme.outline
                      : colorScheme.error,
                ),
              ),
              child: Row(
                children: [
                  if (widget.prefixIcon != null) ...[
                    PrimaryFieldIconSlot(child: widget.prefixIcon!),
                    AppSpacing.horizontal(AppSpacing.sm),
                  ],
                  Expanded(
                    child: TextFormField(
                      textAlign: widget.textAlign ?? TextAlign.left,
                      controller: _controller,
                      focusNode: widget.node,
                      enabled: widget.enabled,
                      autofocus: widget.autofocus,
                      maxLength: widget.maxLength ?? 100,
                      maxLines: widget.maxLine,
                      keyboardType: widget.keyboardType,
                      cursorColor: colorScheme.primary,
                      textInputAction: widget.textInputAction,
                      textCapitalization: widget.textCapitalization,
                      style: AppTextStyles.input.copyWith(
                        color: widget.enabled
                            ? colorScheme.onSurface
                            : colorScheme.onSurfaceVariant,
                      ),
                      validator: (value) {
                        if (widget.validator == null) return null;
                        final result = widget.validator!(value ?? '');
                        if (errorText != result && mounted) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() => errorText = result);
                            }
                          });
                        }
                        return result;
                      },
                      autovalidateMode:
                          widget.validateMode ?? AutovalidateMode.disabled,
                      readOnly: true,
                      onTap: _openSearchSheet,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: AppTextStyles.input.copyWith(
                          color: AppColors.inkSoft,
                          fontWeight: FontWeight.w500,
                        ),
                        enabled: widget.enabled,
                        fillColor: AppColors.transparent,
                        counterText: "",
                        isCollapsed: true,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorStyle: const TextStyle(height: 0, fontSize: 0),
                      ),
                    ),
                  ),
                  if (widget.suffixIcon != null) ...[
                    AppSpacing.horizontal(AppSpacing.sm),
                    IconTheme(
                      data: IconThemeData(
                        color: colorScheme.onSurface.withValues(alpha: 0.62),
                        size: AppDimensions.iconMd,
                      ),
                      child: widget.suffixIcon!,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (errorText != null) ...[
            AppSpacing.vertical(AppSpacing.xs),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: PrimaryText(
                errorText!,
                style: AppTextStyles.caption,
                color: colorScheme.error,
              ),
            ),
          ],
          if (widget.instruction != null) ...[
            AppSpacing.vertical(AppSpacing.xs),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: PrimaryText(
                widget.instruction!,
                color: AppColors.inkSoft,
                style: AppTextStyles.bodySmall,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AutocompleteSearchSheet<T> extends StatefulWidget {
  const _AutocompleteSearchSheet({
    required this.initialText,
    required this.title,
    required this.hintText,
    required this.debounce,
    required this.textCapitalization,
    required this.keyboardType,
    required this.displayStringForOption,
    required this.onSearch,
    required this.onSelected,
  });

  final String initialText;
  final String title;
  final String hintText;
  final Duration debounce;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final String Function(T item)? displayStringForOption;
  final Future<List<T>> Function(String keyword) onSearch;
  final void Function(T value)? onSelected;

  @override
  State<_AutocompleteSearchSheet<T>> createState() =>
      _AutocompleteSearchSheetState<T>();
}

class _AutocompleteSearchSheetState<T>
    extends State<_AutocompleteSearchSheet<T>> {
  late final TextEditingController _searchController;
  final FocusNode _searchFocusNode = FocusNode();
  final List<T> _options = [];

  Timer? _debounceTimer;
  bool _isLoading = false;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialText);
    _searchController.addListener(_onChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _searchFocusNode.requestFocus();
        if (_searchController.text.trim().isNotEmpty) {
          _search(_searchController.text);
        }
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController
      ..removeListener(_onChanged)
      ..dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onChanged() {
    _debounceTimer?.cancel();
    final value = _searchController.text;
    if (value.trim().isEmpty) {
      _requestId++;
      setState(() {
        _options.clear();
        _isLoading = false;
      });
      return;
    }

    setState(() {
      if (value.trim().length < 8) {
        _options.clear();
        _isLoading = false;
      }
    });
    _debounceTimer = Timer(widget.debounce, () => _search(value));
  }

  void _clearSearch() {
    _requestId++;
    _debounceTimer?.cancel();
    _searchController.clear();
    setState(() {
      _options.clear();
      _isLoading = false;
    });
    _searchFocusNode.requestFocus();
  }

  Future<void> _search(String value) async {
    final keyword = value.trim();
    if (keyword.isEmpty || keyword.length < 8) {
      return;
    }

    final requestId = ++_requestId;
    setState(() => _isLoading = true);

    List<T> results = const [];
    try {
      results = await widget.onSearch(keyword);
    } catch (_) {
      results = const [];
    }

    if (!mounted || requestId != _requestId) {
      return;
    }

    setState(() {
      _options
        ..clear()
        ..addAll(results);
      _isLoading = false;
    });
  }

  String _displayString(T item) {
    return widget.displayStringForOption?.call(item) ?? item.toString();
  }

  void _selectOption(T item) {
    widget.onSelected?.call(item);
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
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryText(
                            widget.title,
                            style: AppTextStyles.titleMedium,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    AppSpacing.vertical(AppSpacing.sm),
                    TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      keyboardType: widget.keyboardType,
                      textCapitalization: widget.textCapitalization,
                      textInputAction: TextInputAction.search,
                      style: AppTextStyles.input.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: widget.hintText,
                        hintStyle: AppTextStyles.input.copyWith(
                          color: AppColors.inkSoft,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.inkSoft,
                        ),
                        suffixIcon: _searchController.text.isEmpty
                            ? null
                            : IconButton(
                                onPressed: _clearSearch,
                                icon: const Icon(Icons.close_rounded),
                                color: AppColors.inkSoft,
                              ),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerLow,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusXs,
                          ),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusXs,
                          ),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusXs,
                          ),
                          borderSide: BorderSide(color: colorScheme.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.primary,
                        ),
                      )
                    : _options.isEmpty
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
                        itemCount: _options.length,
                        separatorBuilder: (_, _) => Divider(
                          height: 1,
                          color: colorScheme.outlineVariant,
                        ),
                        itemBuilder: (context, index) {
                          final item = _options[index];

                          return InkWell(
                            onTap: () => _selectOption(item),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              child: PrimaryText(
                                _displayString(item),
                                style: AppTextStyles.input,
                                color: colorScheme.onSurface,
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
    );
  }
}
