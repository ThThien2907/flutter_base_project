import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_dimensions.dart';
import 'primary_dialog.dart';

class PrimaryDismissible extends StatelessWidget {
  const PrimaryDismissible({
    super.key,
    required this.dismissibleKey,
    this.onDismissed,
    this.confirmDismiss,
    required this.child,
    required this.confirmMessage,
    this.enable = true,
  });

  final void Function(DismissDirection)? onDismissed;
  final Future<bool?> Function(DismissDirection)? confirmDismiss;
  final Widget child;
  final Key dismissibleKey;
  final String confirmMessage;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    if (!enable) return child;

    return Dismissible(
      key: dismissibleKey,
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        if (confirmDismiss != null) {
          return await confirmDismiss!(direction);
        }
        return await _showDeleteConfirmDialog(context);
      },
      onDismissed: onDismissed,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.sm.r),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Icon(
          Icons.delete_rounded,
          color: Colors.white,
          size: AppDimensions.iconMd,
        ),
      ),
      child: child,
    );
  }

  Future<bool?> _showDeleteConfirmDialog(BuildContext context) async {
    bool? result;

    await PrimaryDialog.showQuestionDialog(
      context,
      message: confirmMessage,
      positiveButtonText: context.tr("delete"),
      onPositiveTapped: () {
        result = true;
      },
      onNegativeTapped: () => result = false,
    );

    return result;
  }
}
