import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtils {
  NetworkUtils._();

  static Future<bool> isNetworkAvailable() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return _hasNetworkInterface(connectivityResult);
  }

  static Future<bool> hasInternetAccess({String lookupHost = 'google.com'}) async {
    try {
      final result = await InternetAddress.lookup(lookupHost);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }

  static void listen({
    void Function()? onConnected,
    void Function()? onLostConnection,
  }) {
    Connectivity().onConnectivityChanged.listen((result) {
      if (_hasNetworkInterface(result)) {
        onConnected?.call();
        return;
      }

      onLostConnection?.call();
    });
  }

  static bool _hasNetworkInterface(List<ConnectivityResult> result) {
    return result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet) ||
        result.contains(ConnectivityResult.vpn);
  }
}
