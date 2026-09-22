import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_base_project/app/di/injection.dart';
import 'package:flutter_base_project/app/router/app_routes.dart';
import 'package:flutter_base_project/app/session/session_coordinator.dart';
import 'package:flutter_base_project/app/theme/app_theme_mode.dart';
import 'package:flutter_base_project/app/theme/theme_bloc.dart';
import 'package:flutter_base_project/app/theme/theme_state.dart';
import 'package:flutter_base_project/core/design_system/components/base_import_components.dart';
import 'package:flutter_base_project/core/foundation/resource.dart';
import 'package:flutter_base_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_base_project/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_base_project/features/auth/presentation/widgets/language_switch_button.dart';

class SettingsTabView extends StatelessWidget {
  const SettingsTabView({super.key});

  void _handleLogoutResource(BuildContext context, AuthState state) {
    final resource = state.logoutResource;
    switch (resource.state) {
      case Result.initial:
        PrimaryLoading.hide(force: true);
        break;
      case Result.loading:
        PrimaryLoading.show();
        break;
      case Result.success:
      case Result.error:
        PrimaryLoading.hide(force: true);
        getIt<SessionCoordinator>().logout();
        if (context.mounted) {
          context.go(AppRoutes.login);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeBloc = getIt<ThemeBloc>();
    final authBloc = getIt<AuthBloc>();

    return BlocListener<AuthBloc, AuthState>(
      bloc: authBloc,
      listenWhen: (previous, current) =>
          previous.logoutResource != current.logoutResource,
      listener: _handleLogoutResource,
      child: Scaffold(
        appBar: PrimaryAppBar(title: context.tr('shell.settings_tab')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppDimensions.lg.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Theme setting card
                BlocBuilder<ThemeBloc, ThemeState>(
                  bloc: themeBloc,
                  builder: (context, state) {
                    final isDark = state.mode == AppThemeMode.dark;
                    return PrimaryCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isDark
                                    ? Icons.dark_mode_rounded
                                    : Icons.light_mode_rounded,
                                color: AppColors.primary,
                              ),
                              AppSpacing.horizontal(AppDimensions.sm),
                              PrimaryText(
                                isDark
                                    ? context.tr('theme.dark')
                                    : context.tr('theme.light'),
                                style: AppTextStyles.titleMedium,
                              ),
                            ],
                          ),
                          Switch(
                            value: isDark,
                            onChanged: (val) {
                              themeBloc.changeThemeMode(
                                val ? AppThemeMode.dark : AppThemeMode.light,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                AppSpacing.vertical(AppDimensions.md),

                // Language setting card
                PrimaryCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.language_rounded,
                            color: AppColors.primary,
                          ),
                          AppSpacing.horizontal(AppDimensions.sm),
                          PrimaryText(
                            context.tr('common.switch_language'),
                            style: AppTextStyles.titleMedium,
                          ),
                        ],
                      ),
                      const LanguageSwitchButton(),
                    ],
                  ),
                ),
                AppSpacing.vertical(AppDimensions.xl),

                // Logout Button
                PrimaryButton.outlined(
                  label: context.tr('shell.logout'),
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.error,
                  ),
                  onPressed: () {
                    PrimaryDialog.showQuestionDialog<void>(
                      context,
                      title: 'shell.logout_confirm_title',
                      message: 'shell.logout_confirm_message',
                      positiveButtonText: 'shell.logout',
                      negativeButtonText: 'cancel',
                      onPositiveTapped: () {
                        authBloc.logout();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
