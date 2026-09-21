import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';
import 'primary_button.dart';
import 'primary_card.dart';
import 'primary_text.dart';

class PrimaryDialog {
  static const _headerIconSize = 64.0;

  static Future<dynamic> showAlertDialog(
    BuildContext context, {
    String title = "notification.title",
    String? message,
    Map<String, String>? messageNamedArgs,
    String closeText = 'close',
    Function()? onClosed,
    String? secondaryButtonText,
    void Function()? onSecondaryTapped,
  }) async {
    return await showGeneralDialog(
      barrierLabel: "CustomDialog",
      barrierDismissible: true,
      context: context,
      pageBuilder: (dialogContext, animation, child) {
        return _CustomDialogView(
          headerIcon: Container(
            width: _headerIconSize,
            height: _headerIconSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.info,
            ),
            child: const Icon(
              Icons.notifications,
              size: AppSpacing.lg,
              color: AppColors.infoLight,
            ),
          ),
          body: Column(
            children: [
              AppSpacing.vertical(AppSpacing.md),
              PrimaryText(
                title.tr(),
                style: AppTextStyles.titleLarge,
                textAlign: TextAlign.center,
              ),
              if (message != null) ...[
                AppSpacing.vertical(AppSpacing.md),
                PrimaryText(
                  message.tr(namedArgs: messageNamedArgs),
                  style: AppTextStyles.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
              AppSpacing.vertical(AppSpacing.md),
            ],
          ),
          bottomActions: secondaryButtonText == null
              ? PrimaryButton.filled(
                  label: closeText.tr(),
                  height: AppDimensions.smallButtonHeight,
                  onPressed: () {
                    Navigator.pop(dialogContext, true);
                    onClosed?.call();
                  },
                )
              : Row(
                  children: [
                    Expanded(
                      child: PrimaryButton.outlined(
                        label: secondaryButtonText.tr(),
                        height: AppDimensions.smallButtonHeight,
                        onPressed: () {
                          Navigator.pop(dialogContext, false);
                          onSecondaryTapped?.call();
                        },
                      ),
                    ),
                    AppSpacing.horizontal(AppSpacing.sm),
                    Expanded(
                      child: PrimaryButton.filled(
                        label: closeText.tr(),
                        height: AppDimensions.smallButtonHeight,
                        onPressed: () {
                          Navigator.pop(dialogContext, true);
                          onClosed?.call();
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutBack,
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  static Future<dynamic> showDefaultDialog(
    BuildContext context, {
    Widget child = const SizedBox.shrink(),
  }) async {
    return await showGeneralDialog(
      barrierLabel: "CustomDialog",
      barrierDismissible: true,
      context: context,
      pageBuilder: (BuildContext context, animation, _) => child,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutBack,
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  static Future<dynamic> showSuccessDialog(
    BuildContext context, {
    String title = "success",
    String? message,
    String? closeText,
    void Function()? onClosed,
    String? positiveButtonText,
    void Function()? onPositiveTapped,
    String? negativeButtonText,
    void Function()? onNegativeTapped,
  }) {
    return showGeneralDialog<dynamic>(
      context: context,
      pageBuilder: (dialogContext, n, m) => _CustomDialogView(
        headerIcon: Container(
          width: _headerIconSize,
          height: _headerIconSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.success,
          ),
          child: const Icon(
            Icons.check_rounded,
            size: AppSpacing.lg,
            color: AppColors.successLight,
          ),
        ),
        body: Column(
          children: [
            AppSpacing.vertical(AppSpacing.md),
            PrimaryText(
              title.tr(),
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              AppSpacing.vertical(AppSpacing.md),
              PrimaryText(
                message.tr(),
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
            AppSpacing.vertical(AppSpacing.md),
          ],
        ),
        bottomActions: negativeButtonText == null
            ? PrimaryButton.filled(
                label:
                    positiveButtonText?.tr() ?? closeText?.tr() ?? "close".tr(),
                height: AppDimensions.smallButtonHeight,
                onPressed: () {
                  Navigator.pop(dialogContext, true);
                  if (onPositiveTapped != null) {
                    onPositiveTapped();
                  } else {
                    onClosed?.call();
                  }
                },
              )
            : Row(
                children: [
                  Expanded(
                    child: PrimaryButton.outlined(
                      label: negativeButtonText.tr(),
                      height: AppDimensions.smallButtonHeight,
                      onPressed: () {
                        Navigator.pop(dialogContext, false);
                        onNegativeTapped?.call();
                      },
                    ),
                  ),
                  AppSpacing.horizontal(AppSpacing.sm),
                  Expanded(
                    child: PrimaryButton.filled(
                      label:
                          positiveButtonText?.tr() ??
                          closeText?.tr() ??
                          "close".tr(),
                      height: AppDimensions.smallButtonHeight,
                      onPressed: () {
                        Navigator.pop(dialogContext, true);
                        if (onPositiveTapped != null) {
                          onPositiveTapped();
                        } else {
                          onClosed?.call();
                        }
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  static Future<dynamic> showErrorDialog(
    BuildContext context, {
    String title = "error.error",
    String? message = "error.generic",
    void Function()? onClosed,
    String? buttonText,
  }) {
    return showGeneralDialog<dynamic>(
      context: context,
      pageBuilder: (dialogContext, n, m) => _CustomDialogView(
        headerIcon: Container(
          width: _headerIconSize,
          height: _headerIconSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.error,
          ),
          child: const Icon(
            Icons.close_rounded,
            size: AppSpacing.lg,
            color: AppColors.errorLight,
          ),
        ),
        body: Column(
          children: [
            AppSpacing.vertical(AppSpacing.md),
            PrimaryText(
              title.tr(),
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.center,
            ),
            AppSpacing.vertical(AppSpacing.md),
            PrimaryText(
              (message ?? "error.generic").tr(),
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
            AppSpacing.vertical(AppSpacing.md),
          ],
        ),
        bottomActions: PrimaryButton.filled(
          label: buttonText ?? "close".tr(),
          height: AppDimensions.smallButtonHeight,
          onPressed: () {
            Navigator.pop(dialogContext, true);
            onClosed?.call();
          },
        ),
      ),
    );
  }

  static Future<T?> showWarningDialog<T>(
    BuildContext context, {
    String title = "warning",
    String? message,
    void Function()? onPositiveTapped,
    void Function()? onNegativeTapped,
    String positiveButtonText = "agree",
    String negativeButtonText = "cancel",
  }) {
    return showGeneralDialog<T?>(
      context: context,
      pageBuilder: (dialogContext, n, m) => _CustomDialogView(
        headerIcon: Container(
          width: _headerIconSize,
          height: _headerIconSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.warning,
          ),
          child: const Icon(
            Icons.warning_amber_rounded,
            size: AppSpacing.lg,
            color: AppColors.warningLight,
          ),
        ),
        body: Column(
          children: [
            AppSpacing.vertical(AppSpacing.md),
            PrimaryText(
              title.tr(),
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              AppSpacing.vertical(AppSpacing.md),
              PrimaryText(
                message.tr(),
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
            AppSpacing.vertical(AppSpacing.md),
          ],
        ),
        bottomActions: Row(
          children: [
            Expanded(
              child: PrimaryButton.outlined(
                label: negativeButtonText.tr(),
                height: AppDimensions.smallButtonHeight,
                onPressed: () {
                  Navigator.pop(dialogContext, false);
                  onNegativeTapped?.call();
                },
              ),
            ),
            AppSpacing.horizontal(AppSpacing.sm),
            Expanded(
              child: PrimaryButton.filled(
                label: positiveButtonText.tr(),
                height: AppDimensions.smallButtonHeight,
                onPressed: () {
                  Navigator.pop(dialogContext, true);
                  onPositiveTapped?.call();
                },
              ),
            ),
          ],
        ),
      ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutBack,
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  static Future<T?> showQuestionDialog<T>(
    BuildContext context, {
    String title = "confirm",
    String? message,
    void Function()? onPositiveTapped,
    void Function()? onNegativeTapped,
    String positiveButtonText = "agree",
    String negativeButtonText = "cancel",
  }) {
    return showGeneralDialog<T?>(
      context: context,
      pageBuilder: (dialogContext, n, m) => _CustomDialogView(
        headerIcon: Container(
          width: _headerIconSize,
          height: _headerIconSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.info,
          ),
          child: const Icon(
            Icons.question_mark_rounded,
            size: AppSpacing.lg,
            color: AppColors.infoLight,
          ),
        ),
        body: Column(
          children: [
            AppSpacing.vertical(AppSpacing.md),
            PrimaryText(
              title.tr(),
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              AppSpacing.vertical(AppSpacing.sm),
              PrimaryText(
                message.tr(),
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
            AppSpacing.vertical(AppSpacing.sm),
          ],
        ),
        bottomActions: Row(
          children: [
            Expanded(
              child: PrimaryButton.outlined(
                label: negativeButtonText.tr(),
                height: AppDimensions.smallButtonHeight,
                onPressed: () {
                  Navigator.pop(dialogContext, false);
                  onNegativeTapped?.call();
                },
              ),
            ),
            AppSpacing.horizontal(AppSpacing.sm),
            Expanded(
              child: PrimaryButton.filled(
                label: positiveButtonText.tr(),
                height: AppDimensions.smallButtonHeight,
                onPressed: () {
                  Navigator.pop(dialogContext, true);
                  onPositiveTapped?.call();
                },
              ),
            ),
          ],
        ),
      ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutBack,
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  static Future<T?> showCustomDialog<T>(
    BuildContext context, {
    Widget? header,
    required Widget child,
    Widget? actionButtons,
    EdgeInsetsGeometry? padding,
    bool barrierDismissible = false,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'CustomDialog',
      pageBuilder: (_, n, m) => StatefulBuilder(
        builder: (context, _) {
          final viewInsets = MediaQuery.of(context).viewInsets;
          return AnimatedPadding(
            duration: const Duration(milliseconds: 250),
            padding: EdgeInsets.only(bottom: viewInsets.bottom),
            curve: Curves.easeOut,
            child: _CustomDialogView(
              headerIcon: header,
              body: child,
              bottomActions: actionButtons,
              padding: padding,
              canPop: barrierDismissible,
            ),
          );
        },
      ),
    );
  }
}

class _CustomDialogView extends StatelessWidget {
  const _CustomDialogView({
    this.headerIcon,
    this.body,
    this.bottomActions,
    this.padding,
    this.canPop = false,
  });

  final Widget? headerIcon;
  final Widget? body;
  final Widget? bottomActions;
  final EdgeInsetsGeometry? padding;
  final bool canPop;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Material(
            color: Colors.transparent,
            child: PrimaryCard(
              padding: padding ?? const EdgeInsets.all(AppSpacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ?headerIcon,
                  ?body,
                  ?bottomActions,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
