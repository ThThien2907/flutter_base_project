import 'package:flutter_base_project/app/config/app_identity.dart';
import 'package:flutter_base_project/core/design_system/components/base_import_components.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final identity = AppIdentity.current;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryText(
          identity.name,
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        AppSpacing.vertical(AppSpacing.xs),
        PrimaryText(
          'login.title'.tr(),
          style: AppTextStyles.displaySmall.copyWith(height: 1.2),
        ),
        AppSpacing.vertical(AppSpacing.xs),
        PrimaryText(
          'login.subtitle'.tr(),
          style: AppTextStyles.bodyMedium,
          color: AppColors.inkMuted,
        ),
      ],
    );
  }
}
