import 'package:flutter/material.dart';

class RouteObserverPage extends RouteObserver<PageRoute<dynamic>> {
  RouteObserverPage._();

  static final RouteObserverPage instance = RouteObserverPage._();

  static String? currentRoute;

  String? _getRouteName(Route<dynamic>? route) {
    return route?.settings.name;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    if (route is PageRoute) {
      currentRoute = _getRouteName(route);
      debugPrint('didPush currentRoute: $currentRoute');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    if (previousRoute is PageRoute) {
      currentRoute = _getRouteName(previousRoute);
      debugPrint('didPop currentRoute: $currentRoute');
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    if (newRoute is PageRoute) {
      currentRoute = _getRouteName(newRoute);
      debugPrint('didReplace currentRoute: $currentRoute');
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);

    if (previousRoute is PageRoute) {
      currentRoute = _getRouteName(previousRoute);
      debugPrint('didRemove currentRoute: $currentRoute');
    }
  }
}
