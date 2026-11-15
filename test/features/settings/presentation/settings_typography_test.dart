import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_mg4_dash/src/features/settings/domain/app_settings.dart';
import 'package:my_mg4_dash/src/features/settings/presentation/settings_typography.dart';

void main() {
  group('SettingsTypography', () {
    test('forFontSize maps presets', () {
      expect(SettingsTypography.forFontSize(AppFontSize.large).scale, 1.0);
      expect(SettingsTypography.forFontSize(AppFontSize.medium).scale, 0.9);
      expect(SettingsTypography.forFontSize(AppFontSize.small).scale, 0.8);
    });

    testWidgets('computed sizes scale with font size', (tester) async {
      late SettingsTypography large;
      late SettingsTypography small;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(960, 360),
          builder: (context, child) {
            large = SettingsTypography.forFontSize(AppFontSize.large);
            small = SettingsTypography.forFontSize(AppFontSize.small);
            return const SizedBox();
          },
        ),
      );

      expect(large.sectionTitle, greaterThan(small.sectionTitle));
      expect(large.navItem, greaterThan(small.navItem));
      expect(large.tileIcon, greaterThan(small.tileIcon));
      expect(large.switchWidth, greaterThan(small.switchWidth));
      expect(small.note, greaterThan(0));
    });
  });
}
