import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';
import 'primary_text.dart';

typedef ImageUrlResolver = String? Function(String? path);

class PrimaryAvatar extends StatelessWidget {
  const PrimaryAvatar({
    super.key,
    this.imagePath,
    this.semanticLabel,
    this.fallbackText,
    this.size = AppSpacing.xxxl,
    this.imageUrlResolver,
  });

  /// Optional global resolver for relative image paths
  static ImageUrlResolver? globalImageResolver;

  final String? imagePath;
  final String? semanticLabel;
  final String? fallbackText;
  final double size;
  final ImageUrlResolver? imageUrlResolver;

  String? _resolveUrl(String? path) {
    if (path == null || path.trim().isEmpty) return null;
    if (imageUrlResolver != null) return imageUrlResolver!(path);
    if (globalImageResolver != null) return globalImageResolver!(path);

    final uri = Uri.tryParse(path.trim());
    if (uri != null && uri.hasScheme) {
      return uri.toString();
    }
    return path.trim();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final imageUrl = _resolveUrl(imagePath);

    return Semantics(
      image: true,
      label: semanticLabel,
      child: SizedBox.square(
        dimension: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.primaryContainer,
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: ClipOval(
            child: imageUrl == null
                ? _AvatarFallback(size: size, text: fallbackText)
                : Image.network(
                    imageUrl,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        _AvatarFallback(size: size, text: fallbackText),
                  ),
          ),
        ),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback({required this.size, this.text});

  final String? text;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: colorScheme.primaryContainer,
      child: text?.isNotEmpty == true
          ? Center(
              child: PrimaryText(
                text!,
                style: AppTextStyles.titleLarge,
                color: colorScheme.onPrimaryContainer,
              ),
            )
          : Icon(
              Icons.person_rounded,
              color: colorScheme.onPrimaryContainer,
              size: size >= AppSpacing.xxxl
                  ? AppDimensions.iconXLg
                  : AppDimensions.iconLg,
            ),
    );
  }
}
