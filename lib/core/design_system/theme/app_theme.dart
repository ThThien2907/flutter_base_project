import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_text_style.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme => _buildTheme(
        colorScheme: _lightColorScheme,
        semanticColors: AppSemanticColors.light,
        scaffoldColor: AppColors.background,
        disabledColor: AppColors.disabled,
      );

  static ThemeData get darkTheme => _buildTheme(
        colorScheme: _darkColorScheme,
        semanticColors: AppSemanticColors.dark,
        scaffoldColor: AppColors.darkBackground,
        disabledColor: AppColors.darkDisabled,
      );

  static ThemeData get light => lightTheme;
  static ThemeData get dark => darkTheme;

  static const _lightColorScheme = ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.surface,
    primaryContainer: AppColors.primary100,
    onPrimaryContainer: AppColors.primary900,
    primaryFixed: AppColors.primary100,
    primaryFixedDim: AppColors.primary200,
    onPrimaryFixed: AppColors.primary950,
    onPrimaryFixedVariant: AppColors.primary800,
    secondary: AppColors.secondary,
    onSecondary: AppColors.secondary950,
    secondaryContainer: AppColors.secondary100,
    onSecondaryContainer: AppColors.secondary950,
    secondaryFixed: AppColors.secondary100,
    secondaryFixedDim: AppColors.secondary200,
    onSecondaryFixed: AppColors.secondary950,
    onSecondaryFixedVariant: AppColors.secondary800,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    tertiaryContainer: AppColors.tertiaryLight,
    onTertiaryContainer: AppColors.onTertiaryContainer,
    tertiaryFixed: AppColors.tertiaryLight,
    tertiaryFixedDim: AppColors.tertiaryFixedDim,
    onTertiaryFixed: AppColors.onTertiaryFixed,
    onTertiaryFixedVariant: AppColors.onTertiaryFixedVariant,
    error: AppColors.error,
    onError: AppColors.surface,
    errorContainer: AppColors.errorLight,
    onErrorContainer: AppColors.onErrorContainer,
    surface: AppColors.surface,
    onSurface: AppColors.ink,
    surfaceDim: AppColors.surfaceDim,
    surfaceBright: AppColors.surface,
    surfaceContainerLowest: AppColors.surface,
    surfaceContainerLow: AppColors.surfaceSoft,
    surfaceContainer: AppColors.surfaceContainer,
    surfaceContainerHigh: AppColors.surfaceContainerHigh,
    surfaceContainerHighest: AppColors.surfaceContainerHighest,
    onSurfaceVariant: AppColors.inkMuted,
    outline: AppColors.line,
    outlineVariant: AppColors.lineSoft,
    shadow: AppColors.primary900,
    scrim: AppColors.scrim,
    inverseSurface: AppColors.ink,
    onInverseSurface: AppColors.surfaceSoft,
    inversePrimary: AppColors.darkPrimary,
    surfaceTint: AppColors.primary,
  );

  static const _darkColorScheme = ColorScheme.dark(
    primary: AppColors.darkPrimary,
    onPrimary: AppColors.darkOnPrimary,
    primaryContainer: AppColors.darkPrimaryLight,
    onPrimaryContainer: AppColors.darkOnPrimaryContainer,
    primaryFixed: AppColors.primary100,
    primaryFixedDim: AppColors.darkPrimary,
    onPrimaryFixed: AppColors.primary950,
    onPrimaryFixedVariant: AppColors.primary800,
    secondary: AppColors.darkSecondary,
    onSecondary: AppColors.secondary950,
    secondaryContainer: AppColors.darkSecondaryLight,
    onSecondaryContainer: AppColors.darkOnSecondaryContainer,
    secondaryFixed: AppColors.secondary100,
    secondaryFixedDim: AppColors.darkSecondary,
    onSecondaryFixed: AppColors.secondary950,
    onSecondaryFixedVariant: AppColors.secondary800,
    tertiary: AppColors.darkTertiary,
    onTertiary: AppColors.darkOnTertiary,
    tertiaryContainer: AppColors.darkTertiaryLight,
    onTertiaryContainer: AppColors.darkOnTertiaryContainer,
    tertiaryFixed: AppColors.tertiaryLight,
    tertiaryFixedDim: AppColors.darkTertiary,
    onTertiaryFixed: AppColors.onTertiaryFixed,
    onTertiaryFixedVariant: AppColors.onTertiaryFixedVariant,
    error: AppColors.darkError,
    onError: AppColors.darkOnError,
    errorContainer: AppColors.darkErrorContainer,
    onErrorContainer: AppColors.darkOnErrorContainer,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkInk,
    surfaceDim: AppColors.darkBackground,
    surfaceBright: AppColors.darkSurfaceBright,
    surfaceContainerLowest: AppColors.darkSurfaceLowest,
    surfaceContainerLow: AppColors.darkSurface,
    surfaceContainer: AppColors.darkSurfaceSoft,
    surfaceContainerHigh: AppColors.darkSurfaceHigh,
    surfaceContainerHighest: AppColors.darkSurfaceHighest,
    onSurfaceVariant: AppColors.darkInkMuted,
    outline: AppColors.darkLine,
    outlineVariant: AppColors.darkLineSoft,
    shadow: AppColors.darkShadow,
    scrim: AppColors.darkShadow,
    inverseSurface: AppColors.darkInk,
    onInverseSurface: AppColors.darkSurface,
    inversePrimary: AppColors.primary,
    surfaceTint: AppColors.darkPrimary,
  );

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required AppSemanticColors semanticColors,
    required Color scaffoldColor,
    required Color disabledColor,
  }) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final textTheme = _textTheme(colorScheme);
    final defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      borderSide: BorderSide(color: colorScheme.outline),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      extensions: <ThemeExtension<dynamic>>[semanticColors],
      fontFamily: AppTextStyles.fontFamily,
      scaffoldBackgroundColor: scaffoldColor,
      canvasColor: scaffoldColor,
      cardColor: colorScheme.surface,
      dividerColor: colorScheme.outlineVariant,
      disabledColor: disabledColor,
      focusColor: colorScheme.primary.withValues(alpha: 0.16),
      hoverColor: colorScheme.primary.withValues(alpha: 0.08),
      highlightColor: colorScheme.primary.withValues(alpha: 0.08),
      splashColor: colorScheme.primary.withValues(alpha: 0.12),
      shadowColor: colorScheme.shadow.withValues(alpha: isDark ? 0.48 : 0.16),
      textTheme: textTheme,
      primaryTextTheme: textTheme.apply(
        bodyColor: colorScheme.onPrimary,
        displayColor: colorScheme.onPrimary,
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
      primaryIconTheme: IconThemeData(color: colorScheme.onPrimary),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: AppColors.transparent,
        surfaceTintColor: AppColors.transparent,
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        actionsIconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: AppTextStyles.titleMedium.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      bottomAppBarTheme: BottomAppBarThemeData(
        color: colorScheme.surface,
        surfaceTintColor: AppColors.transparent,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.12),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedIconTheme: IconThemeData(color: colorScheme.primary),
        unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
        selectedLabelStyle: AppTextStyles.labelXSmall.copyWith(
          color: colorScheme.primary,
        ),
        unselectedLabelStyle: AppTextStyles.labelXSmall.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: AppColors.transparent,
        indicatorColor: colorScheme.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return IconThemeData(
            color: states.contains(WidgetState.selected)
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurfaceVariant,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return AppTextStyles.labelXSmall.copyWith(
            color: states.contains(WidgetState.selected)
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          );
        }),
        elevation: 0,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: AppColors.transparent,
        scrimColor: colorScheme.scrim.withValues(alpha: 0.44),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        surfaceTintColor: AppColors.transparent,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        textColor: colorScheme.onSurface,
        iconColor: colorScheme.onSurfaceVariant,
        selectedColor: colorScheme.primary,
        selectedTileColor: colorScheme.primaryContainer,
        tileColor: colorScheme.surface,
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: colorScheme.surface,
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        floatingLabelStyle: AppTextStyles.bodyMedium.copyWith(
          color: colorScheme.primary,
        ),
        hintStyle: AppTextStyles.input.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
        errorStyle: AppTextStyles.caption.copyWith(color: colorScheme.error),
        prefixIconColor: colorScheme.onSurfaceVariant,
        suffixIconColor: colorScheme.onSurfaceVariant,
        border: defaultBorder,
        enabledBorder: defaultBorder,
        focusedBorder: defaultBorder.copyWith(
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: defaultBorder.copyWith(
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: defaultBorder.copyWith(
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        disabledBorder: defaultBorder.copyWith(
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: _filledButtonStyle(colorScheme),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _filledButtonStyle(colorScheme),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _outlinedButtonStyle(colorScheme),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.disabled)
                ? disabledColor
                : colorScheme.primary;
          }),
          overlayColor: _overlayColor(colorScheme.primary),
          textStyle: const WidgetStatePropertyAll(AppTextStyles.button),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.disabled)
                ? disabledColor
                : colorScheme.onSurfaceVariant;
          }),
          backgroundColor: const WidgetStatePropertyAll(AppColors.transparent),
          overlayColor: _overlayColor(colorScheme.primary),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        focusColor: colorScheme.primaryContainer,
        hoverColor: colorScheme.primaryContainer,
        splashColor: colorScheme.onPrimary.withValues(alpha: 0.18),
        elevation: 2,
        focusElevation: 3,
        hoverElevation: 3,
        highlightElevation: 4,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return disabledColor;
          }
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return AppColors.transparent;
        }),
        checkColor: WidgetStatePropertyAll(colorScheme.onPrimary),
        overlayColor: _overlayColor(colorScheme.primary),
        side: BorderSide(color: colorScheme.outline, width: 1.5),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return disabledColor;
          }
          return states.contains(WidgetState.selected)
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant;
        }),
        overlayColor: _overlayColor(colorScheme.primary),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.surfaceContainerHighest;
          }
          return states.contains(WidgetState.selected)
              ? colorScheme.onPrimary
              : colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return disabledColor.withValues(alpha: 0.45);
          }
          return states.contains(WidgetState.selected)
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? colorScheme.primary
              : colorScheme.outline;
        }),
        overlayColor: _overlayColor(colorScheme.primary),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.primaryContainer,
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withValues(alpha: 0.12),
        valueIndicatorColor: colorScheme.inverseSurface,
        valueIndicatorTextStyle: AppTextStyles.labelSmall.copyWith(
          color: colorScheme.onInverseSurface,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.primaryContainer,
        circularTrackColor: colorScheme.primaryContainer,
        refreshBackgroundColor: colorScheme.surface,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        selectedColor: colorScheme.primaryContainer,
        disabledColor: disabledColor.withValues(alpha: 0.36),
        checkmarkColor: colorScheme.onPrimaryContainer,
        deleteIconColor: colorScheme.onSurfaceVariant,
        labelStyle: AppTextStyles.labelSmall.copyWith(
          color: colorScheme.onSurface,
        ),
        secondaryLabelStyle: AppTextStyles.labelSmall.copyWith(
          color: colorScheme.onPrimaryContainer,
        ),
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: AppColors.transparent,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.24),
        titleTextStyle: AppTextStyles.titleLarge.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        modalBackgroundColor: colorScheme.surface,
        surfaceTintColor: AppColors.transparent,
        modalBarrierColor: colorScheme.scrim.withValues(alpha: 0.44),
        dragHandleColor: colorScheme.outline,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.18),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusLg),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        actionTextColor: colorScheme.inversePrimary,
        disabledActionTextColor: colorScheme.onInverseSurface.withValues(
          alpha: 0.38,
        ),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        closeIconColor: colorScheme.onInverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colorScheme.surfaceContainer,
        surfaceTintColor: AppColors.transparent,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.18),
        textStyle: AppTextStyles.bodyMedium.copyWith(
          color: colorScheme.onSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.inverseSurface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
        ),
        textStyle: AppTextStyles.caption.copyWith(
          color: colorScheme.onInverseSurface,
        ),
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: colorScheme.error,
        textColor: colorScheme.onError,
        textStyle: AppTextStyles.labelXSmall.copyWith(
          color: colorScheme.onError,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicatorColor: colorScheme.primary,
        dividerColor: colorScheme.outlineVariant,
        overlayColor: _overlayColor(colorScheme.primary),
        labelStyle: AppTextStyles.labelMedium,
        unselectedLabelStyle: AppTextStyles.labelMedium,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.primary,
        selectionColor: colorScheme.primary.withValues(alpha: 0.28),
        selectionHandleColor: colorScheme.primary,
      ),
    );
  }

  static TextTheme _textTheme(ColorScheme colorScheme) {
    return const TextTheme(
      displayLarge: AppTextStyles.display,
      displayMedium: AppTextStyles.titleXXXLarge,
      displaySmall: AppTextStyles.titleXXLarge,
      headlineLarge: AppTextStyles.titleXLarge,
      headlineMedium: AppTextStyles.titleLarge,
      headlineSmall: AppTextStyles.titleMedium,
      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium,
      titleSmall: AppTextStyles.titleSmall,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
    ).apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
      decorationColor: colorScheme.onSurface,
    );
  }

  static ButtonStyle _filledButtonStyle(ColorScheme colorScheme) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.disabled)
            ? colorScheme.surfaceContainerHighest
            : colorScheme.primary;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.disabled)
            ? colorScheme.onSurfaceVariant
            : colorScheme.onPrimary;
      }),
      overlayColor: _overlayColor(colorScheme.onPrimary),
      iconColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.disabled)
            ? colorScheme.onSurfaceVariant
            : colorScheme.onPrimary;
      }),
      textStyle: const WidgetStatePropertyAll(AppTextStyles.button),
      elevation: const WidgetStatePropertyAll(0),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
    );
  }

  static ButtonStyle _outlinedButtonStyle(ColorScheme colorScheme) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.disabled)
            ? colorScheme.surfaceContainerLow
            : colorScheme.surface;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.disabled)
            ? colorScheme.onSurfaceVariant
            : colorScheme.primary;
      }),
      overlayColor: _overlayColor(colorScheme.primary),
      iconColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.disabled)
            ? colorScheme.onSurfaceVariant
            : colorScheme.primary;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        return BorderSide(
          color: states.contains(WidgetState.disabled)
              ? colorScheme.outlineVariant
              : colorScheme.primary,
        );
      }),
      textStyle: const WidgetStatePropertyAll(AppTextStyles.button),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
    );
  }

  static WidgetStateProperty<Color?> _overlayColor(Color color) {
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return color.withValues(alpha: 0.12);
      }
      if (states.contains(WidgetState.focused)) {
        return color.withValues(alpha: 0.12);
      }
      if (states.contains(WidgetState.hovered)) {
        return color.withValues(alpha: 0.08);
      }
      return null;
    });
  }
}
