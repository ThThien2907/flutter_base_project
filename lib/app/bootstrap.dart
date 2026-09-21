import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../core/logging/app_logger.dart';
import 'app.dart';
import 'config/app_env.dart';
import 'di/injection.dart';

late final PackageInfo packageInfo;

Future<void> bootstrap() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await _loadEnvVariable();
    _configureAppLogger();

    await EasyLocalization.ensureInitialized();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    configureDependencies();
    await AppLogger().cleanOldLogs();

    PlatformDispatcher.instance.onError = (error, stack) {
      catchUnhandledExceptions(error, stack);
      return true;
    };

    FlutterError.onError = (FlutterErrorDetails details) {
      catchUnhandledExceptions(details.exception, details.stack);
    };

    try {
      packageInfo = await PackageInfo.fromPlatform();
    } catch (_) {
      // Safe fallback in test environments
    }

    runApp(const BaseApp());
  }, catchUnhandledExceptions);
}

void _configureAppLogger() {
  const enableLoggerInProduction = false;
  final isProduction =
      AppEnv.env == AppEnv.prodEnv || AppEnv.flavor == AppEnv.prodFlavor;

  AppLogger.configure(enabled: !isProduction || enableLoggerInProduction);
}

Future<void> _loadEnvVariable() async {
  try {
    const flavor = appFlavor ??
        String.fromEnvironment('FLAVOR', defaultValue: AppEnv.devFlavor);
    await dotenv.load(fileName: '.env.${flavor.toLowerCase()}');
  } catch (_) {
    // If specific flavor file not found, try .env or ignore for default values
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // Ignore if no .env present
    }
  }
}

void catchUnhandledExceptions(Object error, StackTrace? stack) {
  if (kDebugMode) {
    AppLogger().log('Unhandled exception: $error', level: LogLevel.error);

    if (stack != null) {
      AppLogger().log(stack.toString(), level: LogLevel.error);
    }
  }
}
