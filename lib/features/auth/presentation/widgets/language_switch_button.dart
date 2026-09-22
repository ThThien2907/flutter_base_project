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
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.sm.r,
            vertical: AppDimensions.xs.r,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.language_rounded, size: AppDimensions.iconSm),
              AppSpacing.horizontal(AppDimensions.xs),
              PrimaryText(languageCode, style: AppTextStyles.labelSmall),
            ],
          ),
        ),
      ),
    );
  }
}
