import 'dart:async';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/design_system/components/primary_dialog.dart';
import '../core/design_system/components/primary_loading.dart';
import '../core/design_system/theme/app_theme.dart';
import '../core/network/api_interceptor.dart';
import 'config/app_identity.dart';
import 'di/injection.dart';
import 'router/app_router.dart';
import 'router/app_routes.dart';
import 'router/route_observer_page.dart';
import 'session/session_cleanup.dart';
import 'session/session_coordinator.dart';
import 'theme/theme_bloc.dart';
import 'theme/theme_state.dart';

class BaseApp extends StatelessWidget {
  const BaseApp({
    super.key,
    this.assetLoader,
  });

  final AssetLoader? assetLoader;

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [Locale('vi'), Locale('en')],
      path: 'assets/langs',
      startLocale: const Locale('vi'),
      fallbackLocale: const Locale('vi'),
      assetLoader: assetLoader ?? const RootBundleAssetLoader(),
      child: const _MaterialApp(),
    );
  }
}

class _MaterialApp extends StatefulWidget {
  const _MaterialApp();

  @override
  State<_MaterialApp> createState() => _MaterialAppState();
}

class _MaterialAppState extends State<_MaterialApp> {
  final ThemeBloc _themeBloc = getIt.get<ThemeBloc>()..loadThemeMode();
  StreamSubscription<SessionEndReason>? _sessionEndedSubscription;

  @override
  void initState() {
    super.initState();
    _configureOverlayProvider();
    _configureUnauthorizedHandler();
    _subscribeToSessionEnded();
  }

  @override
  void dispose() {
    _sessionEndedSubscription?.cancel();
    _clearUnauthorizedHandler();
    super.dispose();
  }

  void _configureOverlayProvider() {
    PrimaryLoading.overlayStateProvider =
        () => rootNavigatorKey.currentState?.overlay;
  }

  void _configureUnauthorizedHandler() {
    for (final interceptor
        in getIt<Dio>().interceptors.whereType<ApiInterceptor>()) {
      interceptor.onUnauthorized = () => getIt<SessionCoordinator>().handleSessionExpired();
    }
  }

  void _clearUnauthorizedHandler() {
    for (final interceptor
        in getIt<Dio>().interceptors.whereType<ApiInterceptor>()) {
      interceptor.onUnauthorized = null;
    }
  }

  void _subscribeToSessionEnded() {
    _sessionEndedSubscription =
        getIt<SessionCoordinator>().sessionEndedStream.listen((reason) {
      _handleSessionEnded(reason);
    });
  }

  Future<void> _handleSessionEnded(SessionEndReason reason) async {
    final router = getIt<AppRouter>().router;
    final currentRoute =
        RouteObserverPage.currentRoute ??
        router.routerDelegate.currentConfiguration.uri.path;

    PrimaryLoading.hide(force: true);

    if (currentRoute != AppRoutes.login) {
      router.go(AppRoutes.login);
      await WidgetsBinding.instance.endOfFrame;
    }

    if (reason == SessionEndReason.tokenExpired) {
      if (!mounted) return;
      final context = rootNavigatorKey.currentContext;
      if (context == null || !context.mounted) return;

      await PrimaryDialog.showErrorDialog(
        context,
        message: 'error_code.auth.token_expired',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      bloc: _themeBloc,
      builder: (context, state) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: AppIdentity.current.name,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.mode.materialThemeMode,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          routerConfig: getIt<AppRouter>().router,
        );
      },
    );
  }
}
