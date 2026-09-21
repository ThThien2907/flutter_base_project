import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_base_project/app/di/injection.dart';
import 'package:flutter_base_project/app/router/app_routes.dart';
import 'package:flutter_base_project/core/design_system/components/base_import_components.dart';
import 'package:flutter_base_project/core/foundation/resource.dart';
import 'package:flutter_base_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_base_project/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_base_project/features/auth/presentation/widgets/language_switch_button.dart';
import 'package:flutter_base_project/features/auth/presentation/widgets/login_form.dart';
import 'package:flutter_base_project/features/auth/presentation/widgets/login_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthBloc _bloc = getIt<AuthBloc>();

  Future<void> _handleLoginResource(
    BuildContext context,
    AuthState state,
  ) async {
    switch (state.loginResource.state) {
      case Result.initial:
        PrimaryLoading.hide(force: true);
        break;

      case Result.loading:
        PrimaryLoading.show();
        break;

      case Result.success:
        PrimaryLoading.hide(force: true);
        _bloc.fetchUserData();
        break;

      case Result.error:
        PrimaryLoading.hide(force: true);
        if (!context.mounted) return;
        await PrimaryDialog.showErrorDialog(
          context,
          message: state.loginResource.message?.tr() ?? 'error.generic'.tr(),
        );
        break;
    }
  }

  Future<void> _handleUserResource(
    BuildContext context,
    AuthState state,
  ) async {
    switch (state.userResource.state) {
      case Result.initial:
        break;

      case Result.loading:
        PrimaryLoading.show();
        break;

      case Result.success:
        PrimaryLoading.hide(force: true);
        if (!context.mounted) return;
        context.go(AppRoutes.shell);
        break;

      case Result.error:
        PrimaryLoading.hide(force: true);
        if (!context.mounted) return;
        await PrimaryDialog.showErrorDialog(
          context,
          message: state.userResource.message?.tr() ?? 'error.generic'.tr(),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          bloc: _bloc,
          listenWhen: (previous, current) =>
              previous.loginResource != current.loginResource,
          listener: (context, state) => _handleLoginResource(context, state),
        ),
        BlocListener<AuthBloc, AuthState>(
          bloc: _bloc,
          listenWhen: (previous, current) =>
              previous.userResource != current.userResource,
          listener: (context, state) => _handleUserResource(context, state),
        ),
      ],
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xl,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppDimensions.appMaxWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.centerRight,
                        child: LanguageSwitchButton(),
                      ),
                      AppSpacing.vertical(AppSpacing.lg),
                      const LoginHeader(),
                      AppSpacing.vertical(AppSpacing.xl),
                      const LoginForm(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
