import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_demo/src/app/app.dart';
import 'package:liquid_glass_demo/src/app/providers/app_settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('tab navigation switches pages', (tester) async {
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
    await tester.pump(const Duration(milliseconds: 100));

    Future<void> tapTab(String label) async {
      final finder = find.text(label);
      await tester.tap(finder.last, warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 120));
    }

    await tapTab('Energy');
    expect(find.text('40% - Charging'), findsOneWidget);

    await tapTab('Map');
    expect(find.text('Page 3'), findsOneWidget);

    await tapTab('Climate');
    expect(find.text('Page 4'), findsOneWidget);

    await tapTab('Apps');
    expect(find.text('Page 5'), findsOneWidget);

    await tapTab('Settings');
    expect(find.text('Impostazioni'), findsWidgets);

    await tapTab('Home');
    expect(find.text('Navigazione'), findsOneWidget);
  });
}
