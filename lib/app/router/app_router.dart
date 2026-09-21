import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/shell/presentation/pages/shell_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../presentation/app_placeholder_page.dart';
import 'app_routes.dart';
import 'route_observer_page.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

@lazySingleton
class AppRouter {
  late final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    observers: [RouteObserverPage.instance],
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.shell,
        name: AppRoutes.shell,
        builder: (context, state) => const ShellPage(),
      ),
      GoRoute(
        path: AppRoutes.demo,
        name: AppRoutes.demo,
        builder: (context, state) => const AppPlaceholderPage(),
      ),
    ],
  );
}
