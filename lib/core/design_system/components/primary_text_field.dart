import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';
import 'primary_field_icon_slot.dart';
import 'primary_text.dart';

class PrimaryTextField extends StatefulWidget {
  const PrimaryTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.enabled = true,
    this.isRequired = false,
    this.errorText,
    this.maxLength,
    this.minLines,
    this.maxLines = 1,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hintText;
  final String? label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final bool enabled;
  final bool isRequired;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  late bool _obscureText;
  late final FocusNode _focusNode;
  late final FocusNode _visibilityFocusNode;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = FocusNode();
    _visibilityFocusNode = FocusNode(
      canRequestFocus: false,
      skipTraversal: true,
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _visibilityFocusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PrimaryTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText) {
      _obscureText = widget.obscureText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final resolvedErrorText = widget.errorText ?? _errorText;
    final isMultiline = (widget.maxLines ?? 1) > 1;

    return Column(
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
          onTap: widget.enabled ? _requestTextFieldFocus : null,
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
                color: resolvedErrorText == null
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
                    focusNode: _focusNode,
                    controller: widget.controller,
                    keyboardType: widget.keyboardType,
                    textInputAction: widget.textInputAction,
                    textCapitalization: widget.textCapitalization,
                    obscureText: _obscureText,
                    obscuringCharacter: '*',
                    enabled: widget.enabled,
                    style: AppTextStyles.input.copyWith(
                      color: widget.enabled
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
                    validator: _validate,
                    onChanged: _handleChanged,
                    maxLength: widget.maxLength,
                    minLines: widget.minLines,
                    maxLines: widget.maxLines,
                    inputFormatters: widget.inputFormatters,
                    onFieldSubmitted: widget.onSubmitted,
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
                if (widget.obscureText) ...[
                  AppSpacing.horizontal(AppSpacing.sm),
                  IconButton(
                    focusNode: _visibilityFocusNode,
                    tooltip: _obscureText ? 'Show password' : 'Hide password',
                    onPressed: _togglePasswordVisibility,
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    color: colorScheme.onSurface.withValues(alpha: 0.62),
                    iconSize: AppDimensions.iconMd,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 40,
                      height: 40,
                    ),
                  ),
                ] else if (widget.suffixIcon != null) ...[
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
        if (resolvedErrorText != null) ...[
          AppSpacing.vertical(AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: PrimaryText(
              resolvedErrorText,
              style: AppTextStyles.caption,
              color: colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }

  String? _validate(String? value) {
    final result = widget.validator?.call(value);
    if (_errorText != result && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _errorText = result);
        }
      });
    }
    return result;
  }

  void _handleChanged(String value) {
    if (_errorText != null) {
      setState(() => _errorText = null);
    }
    widget.onChanged?.call(value);
  }

  void _requestTextFieldFocus() {
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }
  }

  void _togglePasswordVisibility() {
    setState(() => _obscureText = !_obscureText);
  }
}
