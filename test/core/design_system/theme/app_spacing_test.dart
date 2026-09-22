import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_base_project/app/config/app_screen_config.dart';
import 'package:flutter_base_project/core/design_system/theme/app_dimensions.dart';
import 'package:flutter_base_project/core/design_system/theme/app_spacing.dart';
import 'package:flutter_base_project/core/design_system/theme/app_text_style.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

void main() {
  testWidgets('scales dimensions by their layout semantics', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = AppScreenConfig.designSize;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    late double padding;
    late double horizontalSpacing;
    late double verticalSpacing;
    late double fontSize;
    late double radius;
    late double iconSize;

    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: AppScreenConfig.designSize,
        minTextAdapt: true,
        splitScreenMode: true,
        autoRebuild: true,
        builder: (_, _) => MaterialApp(
          home: Builder(
            builder: (_) {
              padding = AppDimensions.md.r;
              horizontalSpacing = AppSpacing.horizontal(
                AppDimensions.md,
              ).width!;
              verticalSpacing = AppSpacing.vertical(AppDimensions.md).height!;
              fontSize = AppTextStyles.bodyMedium.fontSize!;
              radius = AppDimensions.radiusMd;
              iconSize = AppDimensions.iconMd;
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(padding, 16);
    expect(horizontalSpacing, 16);
    expect(verticalSpacing, 16);
    expect(fontSize, 16);
    expect(radius, 16);
    expect(iconSize, 20);

    tester.view.physicalSize = const Size(750, 812);
    await tester.pumpAndSettle();

    expect(padding, 16);
    expect(horizontalSpacing, 32);
    expect(verticalSpacing, 16);
    expect(fontSize, 32);
    expect(radius, 16);
    expect(iconSize, 20);
  });
}
