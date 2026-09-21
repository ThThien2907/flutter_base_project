import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';
import 'primary_card.dart';
import 'primary_text.dart';

typedef OverlayStateProvider = OverlayState? Function();

class PrimaryLoading {
  PrimaryLoading._();

  /// Pluggable overlay provider configured at app layer (e.g., in App widget)
  /// to decouple core from router/navigation specifics.
  static OverlayStateProvider? overlayStateProvider;

  static OverlayEntry? _overlayEntry;
  static int _loadingCount = 0;

  static final ValueNotifier<String> _titleNotifier = ValueNotifier<String>(
    'handling',
  );

  static bool get isShowing => _overlayEntry?.mounted == true;

  static void show({BuildContext? context, String title = 'handling'}) {
    final overlayState = (context != null ? Overlay.maybeOf(context) : null) ??
        overlayStateProvider?.call();
    if (overlayState == null) return;

    _loadingCount++;
    _titleNotifier.value = title;

    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (_) {
        return _PrimaryLoadingView(titleNotifier: _titleNotifier);
      },
    );

    overlayState.insert(_overlayEntry!);
  }

  static void hide({bool force = false}) {
    if (_overlayEntry == null) {
      _loadingCount = 0;
      return;
    }

    if (!force) {
      _loadingCount--;

      if (_loadingCount > 0) return;
    }

    _remove();
  }

  static void _remove() {
    _loadingCount = 0;

    final entry = _overlayEntry;
    _overlayEntry = null;

    entry?.remove();
  }

  static Future<T> during<T>(
    Future<T> Function() action, {
    BuildContext? context,
    String title = 'handling',
  }) async {
    show(context: context, title: title);

    try {
      return await action();
    } finally {
      hide();
    }
  }
}

class _PrimaryLoadingView extends StatelessWidget {
  const _PrimaryLoadingView({required this.titleNotifier});

  final ValueNotifier<String> titleNotifier;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: ModalBarrier(dismissible: false, color: Colors.black54),
        ),
        Positioned.fill(
          child: PopScope(
            canPop: false,
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: PrimaryCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: LoadingAnimationWidget.staggeredDotsWave(
                            color: Theme.of(context).colorScheme.primary,
                            size: 50,
                          ),
                        ),
                        AppSpacing.vertical(AppSpacing.md),
                        ValueListenableBuilder<String>(
                          valueListenable: titleNotifier,
                          builder: (_, title, _) {
                            return PrimaryText(
                              title.tr(),
                              style: AppTextStyles.bodyLarge,
                              textAlign: TextAlign.center,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
