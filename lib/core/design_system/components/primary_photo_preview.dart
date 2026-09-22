import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import 'primary_animated_pressable_widget.dart';
import 'primary_frame.dart';

enum PrimaryPhotoPreviewSource { file, network }

class PrimaryPhotoPreview {
  const PrimaryPhotoPreview._();

  static Future<void> showFile(BuildContext context, {required String path}) {
    return showDialog<void>(
      context: context,
      useSafeArea: false,
      builder: (context) => PrimaryPhotoPreviewDialog.file(path: path),
    );
  }

  static Future<void> showNetwork(BuildContext context, {required String url}) {
    return showDialog<void>(
      context: context,
      useSafeArea: false,
      builder: (context) => PrimaryPhotoPreviewDialog.network(url: url),
    );
  }
}

class PrimaryPhotoPreviewDialog extends StatelessWidget {
  const PrimaryPhotoPreviewDialog.file({super.key, required String path})
    : source = PrimaryPhotoPreviewSource.file,
      value = path;

  const PrimaryPhotoPreviewDialog.network({super.key, required String url})
    : source = PrimaryPhotoPreviewSource.network,
      value = url;

  final PrimaryPhotoPreviewSource source;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog.fullscreen(
      backgroundColor: colorScheme.scrim,
      child: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Center(child: _buildImage(context)),
            ),
          ),
          Positioned(
            top: AppDimensions.lg.h,
            right: AppDimensions.md.w,
            child: SafeArea(
              child: Tooltip(
                message: context.tr('close'),
                child: PrimaryAnimatedPressableWidget(
                  onPressed: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  child: PrimaryFrame(
                    width: AppDimensions.xl.w,
                    height: AppDimensions.xl.h,
                    color: AppColors.error,
                    boxShadow: AppColors.strongShadow,
                    isCircle: true,
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: AppDimensions.iconXSm,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return switch (source) {
      PrimaryPhotoPreviewSource.file => Image.file(
        File(value),
        fit: BoxFit.contain,
        errorBuilder: _buildError,
      ),
      PrimaryPhotoPreviewSource.network => Image.network(
        value,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          );
        },
        errorBuilder: _buildError,
      ),
    };
  }

  Widget _buildError(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return Icon(
      Icons.broken_image_rounded,
      color: Theme.of(context).colorScheme.onInverseSurface,
      size: AppDimensions.iconXLg,
    );
  }
}
