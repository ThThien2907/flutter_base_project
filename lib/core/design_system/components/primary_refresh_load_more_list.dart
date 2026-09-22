import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_dimensions.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';
import '../widgets/app_empty_state.dart';
import 'primary_button.dart';
import 'primary_text.dart';

class PrimaryRefreshLoadMoreList<T> extends StatelessWidget {
  const PrimaryRefreshLoadMoreList({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onRefresh,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onLoadMore,
    this.emptyWidget,
    this.padding,
    this.separatorBuilder,
    this.loadMoreErrorMessage,
    this.onRetryLoadMore,
    this.retryLabel,
    this.loadMoreThreshold = 240,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Future<void> Function() onRefresh;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;
  final Widget? emptyWidget;
  final EdgeInsetsGeometry? padding;
  final IndexedWidgetBuilder? separatorBuilder;
  final String? loadMoreErrorMessage;
  final VoidCallback? onRetryLoadMore;
  final String? retryLabel;
  final double loadMoreThreshold;

  bool get _hasLoadMoreError => loadMoreErrorMessage?.isNotEmpty == true;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: padding ?? EdgeInsets.all(AppDimensions.lg.r),
          children: [
            AppSpacing.vertical(AppDimensions.xxl),
            emptyWidget ?? const AppEmptyState(message: ''),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (hasMore &&
              !isLoadingMore &&
              !_hasLoadMoreError &&
              notification.metrics.extentAfter <= loadMoreThreshold) {
            onLoadMore();
          }

          return false;
        },
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding:
              padding ??
              EdgeInsets.fromLTRB(
                AppDimensions.md.r,
                AppDimensions.sm.r,
                AppDimensions.md.r,
                AppDimensions.lg.r,
              ),
          itemCount:
              items.length + (isLoadingMore || _hasLoadMoreError ? 1 : 0),
          separatorBuilder:
              separatorBuilder ?? (_, _) => AppSpacing.vertical(AppDimensions.sm),
          itemBuilder: (context, index) {
            if (index >= items.length) {
              return _PrimaryRefreshLoadMoreFooter(
                isLoading: isLoadingMore,
                errorMessage: loadMoreErrorMessage,
                onRetry: onRetryLoadMore,
                retryLabel: retryLabel,
              );
            }

            return itemBuilder(context, items[index], index);
          },
        ),
      ),
    );
  }
}

class _PrimaryRefreshLoadMoreFooter extends StatelessWidget {
  const _PrimaryRefreshLoadMoreFooter({
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
    required this.retryLabel,
  });

  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppDimensions.md.r),
          child: SizedBox(
            width: AppDimensions.iconLg,
            height: AppDimensions.iconLg,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    final message = errorMessage;
    if (message?.isNotEmpty != true) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.sm.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryText(
            message!,
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          AppSpacing.vertical(AppDimensions.sm),
          PrimaryButton.outlined(
            label: retryLabel ?? '',
            onPressed: onRetry,
            expand: false,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
    );
  }
}
