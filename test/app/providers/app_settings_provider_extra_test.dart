import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_demo/src/app/providers/app_settings_provider.dart';
import 'package:liquid_glass_demo/src/features/settings/domain/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('update is no-op when value unchanged', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);

    final current = container.read(appSettingsProvider);
    await container.read(appSettingsProvider.notifier).update(current);
    expect(container.read(appSettingsProvider), current);
  });

  test('applySystemUi handles different overlay combinations', () async {
    await applySystemUi(const AppSettings());
    await applySystemUi(const AppSettings(
      hideTopSystemBar: true,
      hideBottomSystemBar: false,
    ));
    await applySystemUi(const AppSettings(
      hideTopSystemBar: false,
      hideBottomSystemBar: true,
    ));
    await applySystemUi(const AppSettings(
      hideTopSystemBar: true,
      hideBottomSystemBar: true,
    ));
  });
}
