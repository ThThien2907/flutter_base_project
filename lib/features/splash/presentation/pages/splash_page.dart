import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_base_project/app/config/app_identity.dart';
import 'package:flutter_base_project/app/di/injection.dart';
import 'package:flutter_base_project/app/router/app_routes.dart';
import 'package:flutter_base_project/app/session/session_coordinator.dart';
import 'package:flutter_base_project/core/design_system/components/base_import_components.dart';
import 'package:flutter_base_project/core/foundation/resource.dart';
import 'package:flutter_base_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_base_project/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_base_project/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:flutter_base_project/features/splash/presentation/bloc/splash_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final SplashBloc _splashBloc;
  late final AuthBloc _authBloc;
  bool _hasRequestedUserData = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _splashBloc = getIt<SplashBloc>();
    _authBloc = getIt<AuthBloc>();
    _splashBloc.checkSession();
  }

  void _handleCheckSessionResource(BuildContext context, SplashState state) {
    if (_hasNavigated) return;
    switch (state.checkSessionResource.state) {
      case Result.initial:
      case Result.loading:
        break;
      case Result.success:
        final hasSession = state.checkSessionResource.data ?? false;
        if (hasSession) {
          if (!_hasRequestedUserData) {
            _hasRequestedUserData = true;
            _authBloc.fetchUserData();
          }
        } else {
          _hasNavigated = true;
          if (context.mounted) {
            context.go(AppRoutes.login);
          }
        }
        break;
      case Result.error:
        break;
    }
  }

  void _handleUserResource(BuildContext context, AuthState state) {
    if (_hasNavigated) return;
    switch (state.userResource.state) {
      case Result.initial:
      case Result.loading:
        break;
      case Result.success:
        _hasNavigated = true;
        if (context.mounted) {
          context.go(AppRoutes.shell);
        }
        break;
      case Result.error:
        final statusCode = state.userResource.statusCode;
        if (statusCode == 401) {
          _hasNavigated = true;
          getIt<SessionCoordinator>().logout();
          if (context.mounted) {
            context.go(AppRoutes.login);
          }
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final identity = AppIdentity.current;

    return MultiBlocListener(
      listeners: [
        BlocListener<SplashBloc, SplashState>(
          bloc: _splashBloc,
          listenWhen: (previous, current) =>
              previous.checkSessionResource != current.checkSessionResource,
          listener: _handleCheckSessionResource,
        ),
        BlocListener<AuthBloc, AuthState>(
          bloc: _authBloc,
          listenWhen: (previous, current) =>
              previous.userResource != current.userResource,
          listener: _handleUserResource,
        ),
      ],
      child: BlocBuilder<SplashBloc, SplashState>(
        bloc: _splashBloc,
        builder: (context, splashState) {
          return BlocBuilder<AuthBloc, AuthState>(
            bloc: _authBloc,
            builder: (context, authState) {
              final isSplashError = splashState.checkSessionResource.isError;
              final isUserError =
                  authState.userResource.isError &&
                  authState.userResource.statusCode != 401;
              final showError = isSplashError || isUserError;

              final errorMessage = isSplashError
                  ? splashState.checkSessionResource.message
                  : authState.userResource.message;

              return Scaffold(
                backgroundColor: AppColors.primary,
                body: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusLg,
                              ),
                            ),
                            child: const Icon(
                              Icons.local_shipping_rounded,
                              size: 64,
                              color: AppColors.primary,
                            ),
                          ),
                          AppSpacing.vertical(AppSpacing.md),
                          PrimaryText(
                            identity.name,
                            style: AppTextStyles.titleLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AppSpacing.vertical(AppSpacing.sm),
                          PrimaryText(
                            'splash.loading'.tr(),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (showError)
                      Positioned.fill(
                        child: ColoredBox(
                          color: Colors.black54,
                          child: Center(
                            child: PrimaryCard(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.wifi_off_rounded,
                                    size: 48,
                                    color: AppColors.error,
                                  ),
                                  AppSpacing.vertical(AppSpacing.sm),
                                  PrimaryText(
                                    errorMessage?.tr() ??
                                        'splash.retry_session'.tr(),
                                    style: AppTextStyles.bodyMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  AppSpacing.vertical(AppSpacing.md),
                                  PrimaryButton.filled(
                                    label: 'retry'.tr(),
                                    onPressed: () {
                                      if (isSplashError) {
                                        _splashBloc.retry();
                                      } else {
                                        _authBloc.fetchUserData();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
