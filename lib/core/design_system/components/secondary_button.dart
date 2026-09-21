import 'package:flutter/material.dart';

import 'primary_button.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.expand = true,
    this.height,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Widget? trailingIcon;
  final bool isLoading;
  final bool expand;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton.outlined(
      label: label,
      onPressed: onPressed,
      icon: icon,
      trailingIcon: trailingIcon,
      isLoading: isLoading,
      expand: expand,
      height: height,
    );
  }
}
