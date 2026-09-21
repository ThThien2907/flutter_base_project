import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/shell/presentation/bloc/shell_bloc.dart';
import '../router/app_router.dart';
import '../session/session_coordinator.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() {
  if (getIt.isRegistered<AppRouter>()) {
    return;
  }

  getIt.init();

  // Register cleanables with SessionCoordinator
  if (getIt.isRegistered<SessionCoordinator>()) {
    final coordinator = getIt<SessionCoordinator>();
    if (getIt.isRegistered<AuthBloc>()) {
      coordinator.registerCleanable(getIt<AuthBloc>());
    }
    if (getIt.isRegistered<ShellBloc>()) {
      coordinator.registerCleanable(getIt<ShellBloc>());
    }
  }
}
