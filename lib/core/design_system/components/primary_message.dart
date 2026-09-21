import 'package:flutter/material.dart';

import '../theme/app_text_style.dart';
import 'primary_text.dart';

class PrimaryMessage {
  const PrimaryMessage._();

  static void show(
    BuildContext context, {
    required String message,
    bool hideCurrent = true,
    Duration? duration,
  }) {
    if (message.trim().isEmpty) return;

    final colorScheme = Theme.of(context).colorScheme;
    final snackBarTheme = Theme.of(context).snackBarTheme;
    final contentStyle =
        snackBarTheme.contentTextStyle ??
        AppTextStyles.bodyMedium.copyWith(color: colorScheme.onInverseSurface);
    final messenger = ScaffoldMessenger.of(context);

    if (hideCurrent) {
      messenger.hideCurrentSnackBar();
    }

    messenger.showSnackBar(
      SnackBar(
        duration: duration ?? const Duration(seconds: 2),
        content: PrimaryText(
          message.trim(),
          style: contentStyle,
          color: contentStyle.color ?? colorScheme.onInverseSurface,
        ),
      ),
    );
  }
}
