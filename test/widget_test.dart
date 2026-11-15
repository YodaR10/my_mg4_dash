import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_demo/src/app/app.dart';
import 'package:liquid_glass_demo/src/app/providers/app_settings_provider.dart';
import 'package:liquid_glass_demo/src/features/settings/domain/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('renders app shell and home dashboard', (tester) async {
    tester.view.physicalSize = const Size(960, 360);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const MyApp(),
      ),
    );
    await tester.pump();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Energy'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Navigazione'), findsOneWidget);
    expect(find.text('Radio'), findsOneWidget);
    expect(find.text('Clima'), findsOneWidget);
  });

  test('AppSettings copyWith and themeMode', () {
    const settings = AppSettings();
    expect(settings.themeMode, ThemeMode.system);
    final dark = settings.copyWith(themePreference: AppThemePreference.dark);
    expect(dark.themeMode, ThemeMode.dark);
    expect(dark.panelBlur, settings.panelBlur);
  });
}
