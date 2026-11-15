import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_demo/src/app/providers/app_settings_provider.dart';
import 'package:liquid_glass_demo/src/app/providers/navigation_provider.dart';
import 'package:liquid_glass_demo/src/features/settings/domain/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('appSettingsProvider', () {
    test('loads initial settings from repository', () async {
      SharedPreferences.setMockInitialValues({
        'settings.themePreference': 'dark',
        'settings.fontSize': 'small',
      });
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      final settings = container.read(appSettingsProvider);

      expect(settings.themePreference, AppThemePreference.dark);
      expect(settings.fontSize, AppFontSize.small);
    });

    test('update changes state and persists', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      const next = AppSettings(
        themePreference: AppThemePreference.light,
        fontSize: AppFontSize.medium,
        panelBlur: 4.0,
      );
      await container.read(appSettingsProvider.notifier).update(next);

      expect(container.read(appSettingsProvider).themePreference,
          AppThemePreference.light);
      expect(prefs.getString('settings.themePreference'), 'light');
      expect(prefs.getString('settings.fontSize'), 'medium');
      expect(prefs.getDouble('settings.panelBlur'), 4.0);
    });
  });

  group('navigation provider', () {
    test('selectedTabIndexProvider defaults and updates', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(selectedTabIndexProvider), 0);
      container.read(selectedTabIndexProvider.notifier).setIndex(3);
      expect(container.read(selectedTabIndexProvider), 3);
    });
  });
}
