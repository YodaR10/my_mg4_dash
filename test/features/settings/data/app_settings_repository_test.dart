import 'package:flutter_test/flutter_test.dart';
import 'package:my_mg4_dash/src/features/settings/data/app_settings_repository.dart';
import 'package:my_mg4_dash/src/features/settings/domain/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppSettingsRepository', () {
    test('load returns defaults when prefs empty', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = AppSettingsRepository(prefs);

      final settings = repo.load();

      expect(settings.themePreference, AppThemePreference.system);
      expect(settings.fontSize, AppFontSize.large);
      expect(settings.hideTopSystemBar, isFalse);
      expect(settings.hideBottomSystemBar, isFalse);
      expect(settings.panelBlur, 1.0);
      expect(settings.panelTintAlpha, 0.08);
    });

    test('load reads and clamps persisted values', () async {
      SharedPreferences.setMockInitialValues({
        AppSettingsRepository.kThemePreference: 'dark',
        AppSettingsRepository.kFontSize: 'small',
        AppSettingsRepository.kHideTopSystemBar: true,
        AppSettingsRepository.kHideBottomSystemBar: true,
        AppSettingsRepository.kPanelBlur: 99.0,
        AppSettingsRepository.kPanelTintAlpha: 0.01,
      });
      final prefs = await SharedPreferences.getInstance();
      final repo = AppSettingsRepository(prefs);

      final settings = repo.load();

      expect(settings.themePreference, AppThemePreference.dark);
      expect(settings.fontSize, AppFontSize.small);
      expect(settings.hideTopSystemBar, isTrue);
      expect(settings.hideBottomSystemBar, isTrue);
      expect(settings.panelBlur, 8.0);
      expect(settings.panelTintAlpha, 0.05);
    });

    test('save persists values', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = AppSettingsRepository(prefs);
      const settings = AppSettings(
        themePreference: AppThemePreference.light,
        fontSize: AppFontSize.medium,
        hideTopSystemBar: true,
        hideBottomSystemBar: false,
        panelBlur: 5.5,
        panelTintAlpha: 0.33,
      );

      await repo.save(settings);
      final reloaded = AppSettingsRepository(prefs).load();

      expect(reloaded, isA<AppSettings>());
      expect(reloaded.themePreference, AppThemePreference.light);
      expect(reloaded.fontSize, AppFontSize.medium);
      expect(reloaded.hideTopSystemBar, isTrue);
      expect(reloaded.hideBottomSystemBar, isFalse);
      expect(reloaded.panelBlur, 5.5);
      expect(reloaded.panelTintAlpha, 0.33);
    });
  });
}
