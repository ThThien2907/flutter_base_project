import 'package:flutter_base_project/core/design_system/components/base_import_components.dart';

class LanguageSwitchButton extends StatelessWidget {
  const LanguageSwitchButton({super.key});

  static const _viLocale = Locale('vi');
  static const _enLocale = Locale('en');

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    final languageCode = currentLocale.languageCode.toUpperCase();
    final nextLocale = currentLocale.languageCode == _viLocale.languageCode
        ? _enLocale
        : _viLocale;

    return Tooltip(
      message: context.tr('common.switch_language'),
      child: PrimaryCard(
        onPressed: () => context.setLocale(nextLocale),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language_rounded, size: AppDimensions.iconSm),
              AppSpacing.horizontal(AppSpacing.xs),
              PrimaryText(languageCode, style: AppTextStyles.labelSmall),
            ],
          ),
        ),
      ),
    );
  }
}
