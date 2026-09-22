import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_project/app/config/app_identity.dart';
import 'package:flutter_base_project/app/di/injection.dart';
import 'package:flutter_base_project/core/design_system/components/base_import_components.dart';
import 'package:flutter_base_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_base_project/features/auth/presentation/bloc/auth_state.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final identity = AppIdentity.current;
    final authBloc = getIt<AuthBloc>();

    return Scaffold(
      appBar: PrimaryAppBar(title: identity.name),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppDimensions.lg.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BlocBuilder<AuthBloc, AuthState>(
                bloc: authBloc,
                builder: (context, state) {
                  final user = state.userEntity;
                  final displayName =
                      user?.displayName ??
                      user?.userLogin ??
                      context.tr('shell.welcome_back');

                  return PrimaryCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.primary,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            AppSpacing.horizontal(AppDimensions.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    displayName,
                                    style: AppTextStyles.titleMedium,
                                  ),
                                  if (user?.userEmail != null) ...[
                                    AppSpacing.vertical(AppDimensions.xxs),
                                    PrimaryText(
                                      user!.userEmail!,
                                      style: AppTextStyles.bodySmall,
                                      color: AppColors.inkMuted,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              AppSpacing.vertical(AppDimensions.lg),
              PrimaryCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      context.tr('placeholder.description'),
                      style: AppTextStyles.bodyLarge,
                    ),
                    AppSpacing.vertical(AppDimensions.md),
                    PrimaryText(
                      'Environment: ${identity.env}',
                      style: AppTextStyles.bodyMedium,
                      color: AppColors.inkMuted,
                    ),
                    AppSpacing.vertical(AppDimensions.xs),
                    PrimaryText(
                      'Flavor: ${identity.flavor}',
                      style: AppTextStyles.bodyMedium,
                      color: AppColors.inkMuted,
                    ),
                  ],
                ),
              ),
              PrimaryButton.outlined(
                label: context.tr('shell.logout'),
                icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                onPressed: () {
                  PrimaryDialog.showQuestionDialog<void>(
                    context,
                    title: 'shell.logout_confirm_title',
                    message: 'shell.logout_confirm_message',
                    positiveButtonText: 'shell.logout',
                    negativeButtonText: 'cancel',
                    onPositiveTapped: () {
                      authBloc.fetchUserData();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
