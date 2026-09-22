import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_style.dart';
import 'primary_text.dart';

class PrimaryAppBar extends StatefulWidget implements PreferredSizeWidget {
  const PrimaryAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.onBack,
    this.showBackButton = false,
    this.centerTitle = true,
    this.backgroundColor = AppColors.surface,
    this.foregroundColor = AppColors.ink,
    this.elevation = 0,
    this.bottom,
    this.height = kToolbarHeight,
  });

  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final FutureOr<void> Function()? onBack;
  final bool showBackButton;
  final bool centerTitle;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final PreferredSizeWidget? bottom;
  final double height;

  @override
  Size get preferredSize =>
      Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));

  @override
  State<PrimaryAppBar> createState() => _PrimaryAppBarState();
}

class _PrimaryAppBarState extends State<PrimaryAppBar> {
  bool _allowBackHandlerPop = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.onBack == null
          ? widget.showBackButton
          : _allowBackHandlerPop,
      onPopInvokedWithResult: _handlePopInvoked,
      child: AppBar(
        elevation: widget.elevation,
        scrolledUnderElevation: widget.elevation,
        toolbarHeight: widget.height,
        centerTitle: widget.centerTitle,
        automaticallyImplyLeading: false,
        leading: widget.leading ?? _buildLeading(context),
        leadingWidth: AppDimensions.buttonHeight.w + AppDimensions.sm.w,
        title: PrimaryText(
          widget.title,
          style: AppTextStyles.titleXLarge,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: widget.actions,
        bottom: widget.bottom,
      ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (!widget.showBackButton) {
      return null;
    }

    return IconButton(
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () => _handleBack(context),
      icon: const Icon(Icons.arrow_back_rounded),
      iconSize: AppDimensions.iconLg,
    );
  }

  Future<void> _handleBack(BuildContext context) async {
    final onBack = widget.onBack;
    if (onBack == null) {
      Navigator.maybePop(context);
      return;
    }

    setState(() => _allowBackHandlerPop = true);
    await onBack();
    if (mounted) {
      setState(() => _allowBackHandlerPop = false);
    }
  }

  void _handlePopInvoked(bool didPop, Object? result) {
    if (didPop || widget.onBack == null) {
      return;
    }

    _handleBack(context);
  }
}
