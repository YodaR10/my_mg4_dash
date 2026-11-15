import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_mg4_dash/src/features/settings/domain/app_settings.dart';
import 'package:my_mg4_dash/src/features/settings/presentation/settings_typography.dart';

void main() {
  testWidgets('all typography getters are readable', (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(960, 360),
        builder: (context, child) => const SizedBox(),
      ),
    );
    for (final size in AppFontSize.values) {
      final t = SettingsTypography.forFontSize(size);
      expect(t.sectionTitle, greaterThan(0));
      expect(t.sectionSubtitle, greaterThan(0));
      expect(t.navHeader, greaterThan(0));
      expect(t.navItem, greaterThan(0));
      expect(t.tileTitle, greaterThan(0));
      expect(t.tileSubtitle, greaterThan(0));
      expect(t.detailLabel, greaterThan(0));
      expect(t.detailTitle, greaterThan(0));
      expect(t.detailBody, greaterThan(0));
      expect(t.note, greaterThan(0));
      expect(t.tileIcon, greaterThan(0));
      expect(t.radioIcon, greaterThan(0));
      expect(t.chevronIcon, greaterThan(0));
      expect(t.navIcon, greaterThan(0));
      expect(t.noteIcon, greaterThan(0));
      expect(t.detailHeroIcon, greaterThan(0));
      expect(t.switchWidth, greaterThan(0));
      expect(t.switchHeight, greaterThan(0));
      expect(t.switchPadding, greaterThan(0));
      expect(t.switchThumb, greaterThan(0));
    }
  });
}
