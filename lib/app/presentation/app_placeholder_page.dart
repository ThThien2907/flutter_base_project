import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/components/base_import_components.dart';
import '../config/app_identity.dart';
import '../di/injection.dart';
import '../theme/app_theme_mode.dart';
import '../theme/theme_bloc.dart';
import '../theme/theme_state.dart';

class AppPlaceholderPage extends StatefulWidget {
  const AppPlaceholderPage({super.key});

  @override
  State<AppPlaceholderPage> createState() => _AppPlaceholderPageState();
}

class _AppPlaceholderPageState extends State<AppPlaceholderPage> {
  final TextEditingController _textController = TextEditingController();
  final ThemeBloc _themeBloc = getIt<ThemeBloc>();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final identity = AppIdentity.current;

    return Scaffold(
      appBar: PrimaryAppBar(
        title: identity.name,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PrimaryCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      'placeholder.title'.tr(),
                      style: AppTextStyles.titleLarge,
                    ),
                    AppSpacing.vertical(AppSpacing.xs),
                    PrimaryText(
                      'Env: ${identity.env} | Flavor: ${identity.flavor}',
                      style: AppTextStyles.bodyMedium,
                      color: AppColors.inkMuted,
                    ),
                  ],
                ),
              ),
              AppSpacing.vertical(AppSpacing.md),
              BlocBuilder<ThemeBloc, ThemeState>(
                bloc: _themeBloc,
                builder: (context, state) {
                  final isDark = state.mode == AppThemeMode.dark;
                  return PrimaryCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PrimaryText(
                          isDark ? 'theme.dark'.tr() : 'theme.light'.tr(),
                          style: AppTextStyles.titleMedium,
                        ),
                        Switch(
                          value: isDark,
                          onChanged: (val) {
                            _themeBloc.changeThemeMode(
                              val ? AppThemeMode.dark : AppThemeMode.light,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              AppSpacing.vertical(AppSpacing.md),
              PrimaryTextField(
                controller: _textController,
                hintText: 'Enter sample text...',
                label: 'Sample Input',
                prefixIcon: const Icon(Icons.edit_note_rounded),
              ),
              AppSpacing.vertical(AppSpacing.md),
              PrimaryButton.filled(
                label: 'Show Loading Demo',
                onPressed: () {
                  PrimaryLoading.during(() async {
                    await Future.delayed(const Duration(seconds: 2));
                  });
                },
              ),
              AppSpacing.vertical(AppSpacing.sm),
              SecondaryButton(
                label: 'Show Alert Dialog',
                onPressed: () {
                  PrimaryDialog.showAlertDialog(
                    context,
                    title: 'Notification',
                    message: 'This is a sample dialog from clean base foundation.',
                  );
                },
              ),
              AppSpacing.vertical(AppSpacing.sm),
              TertiaryButton(
                label: 'Show Success Dialog',
                icon: const Icon(Icons.check_circle_outline),
                onPressed: () {
                  PrimaryDialog.showSuccessDialog(
                    context,
                    title: 'success',
                    message: 'Clean architecture base initialized successfully!',
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
