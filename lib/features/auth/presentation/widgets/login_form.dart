import 'package:flutter_base_project/app/di/injection.dart';
import 'package:flutter_base_project/core/design_system/components/base_import_components.dart';
import 'package:flutter_base_project/core/platform/device/device_info_service.dart';
import 'package:flutter_base_project/core/validation/validators.dart';
import 'package:flutter_base_project/features/auth/presentation/bloc/auth_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthBloc _authBloc = getIt<AuthBloc>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PrimaryTextField(
              controller: _usernameController,
              label: context.tr('login.phone_label'),
              hintText: context.tr('login.phone_hint'),
              textInputAction: TextInputAction.next,
              validator: Validators.validateEmptyField,
              prefixIcon: const Icon(Icons.person_rounded),
            ),
            AppSpacing.vertical(AppSpacing.md),
            PrimaryTextField(
              controller: _passwordController,
              label: context.tr('login.password_label'),
              hintText: context.tr('login.password_hint'),
              obscureText: true,
              textInputAction: TextInputAction.done,
              validator: Validators.validateEmptyField,
              prefixIcon: const Icon(Icons.lock_rounded),
              onSubmitted: (_) => _submit(),
            ),
            AppSpacing.vertical(AppSpacing.lg),
            PrimaryButton.filled(
              label: context.tr('login.sign_in'),
              trailingIcon: const Icon(Icons.arrow_forward_rounded),
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final deviceInfoService = getIt<DeviceInfoService>();
    final deviceId = await deviceInfoService.getDeviceId() ?? 'device_unknown';

    if (!mounted) return;

    _authBloc.logIn(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      deviceId: deviceId,
    );
  }
}
