import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_demo/src/app/providers/app_settings_provider.dart';
import 'package:liquid_glass_demo/src/features/settings/domain/app_settings.dart';
import 'package:liquid_glass_demo/src/features/settings/presentation/settings_view.dart';
import 'package:liquid_glass_demo/src/features/settings/presentation/widgets/settings_detail_panel.dart';
import 'package:liquid_glass_demo/src/features/settings/presentation/widgets/settings_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Widget> _wrap(Widget child) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  return ProviderScope(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    child: ScreenUtilInit(
      designSize: const Size(960, 360),
      builder: (context, _) => MaterialApp(home: Scaffold(body: child)),
    ),
  );
}

Future<void> _tapText(WidgetTester tester, String text) async {
  final finder = find.text(text).first;
  await tester.ensureVisible(finder);
  await tester.pump(const Duration(milliseconds: 50));
  await tester.tap(finder, warnIfMissed: false);
  await tester.pump(const Duration(milliseconds: 120));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    final view = TestWidgetsFlutterBinding.instance.platformDispatcher.views.single;
    view.physicalSize = const Size(960, 360);
    view.devicePixelRatio = 1;
  });
  tearDown(() {
    final view = TestWidgetsFlutterBinding.instance.platformDispatcher.views.single;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  testWidgets('SettingsView renders and switches sections', (tester) async {
    await tester.pumpWidget(await _wrap(const SettingsView()));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Impostazioni'), findsOneWidget);
    expect(find.text('Aspetto'), findsWidgets);
    expect(find.textContaining('Tema:'), findsWidgets);

    await _tapText(tester, 'Schermo e barre');
    expect(find.text('Modalità fullscreen'), findsWidgets);

    await _tapText(tester, 'Sistema');
    expect(find.text('Verifica aggiornamenti'), findsOneWidget);

    await _tapText(tester, 'Audio');
    expect(find.text('Volume multimediale'), findsOneWidget);

    await _tapText(tester, 'Connettività');
    expect(find.text('Wi‑Fi'), findsOneWidget);

    await _tapText(tester, 'Privacy e sicurezza');
    expect(find.text('Permessi app'), findsOneWidget);
  });

  testWidgets('SettingsView appearance controls update details', (tester) async {
    await tester.pumpWidget(await _wrap(const SettingsView()));
    await tester.pump(const Duration(milliseconds: 100));

    await _tapText(tester, 'Chiaro');
    expect(find.text('Tema: Chiaro'), findsWidgets);

    await _tapText(tester, 'Scuro');
    expect(find.text('Tema: Scuro'), findsWidgets);

    await _tapText(tester, 'Medio');
    expect(find.text('Caratteri: Medio'), findsWidgets);

    await _tapText(tester, 'Piccolo');
    expect(find.text('Caratteri: Piccolo'), findsWidgets);

    await _tapText(tester, 'Grande');
    expect(find.text('Caratteri: Grande'), findsWidgets);
  });

  testWidgets('SettingsNav calls onSelect', (tester) async {
    SettingsSection? selected;
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(960, 360),
        builder: (context, _) => MaterialApp(
          home: Scaffold(
            body: SettingsNav(
              selected: SettingsSection.appearance,
              onSelect: (s) => selected = s,
              fontSize: AppFontSize.large,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Sistema'));
    await tester.pump();
    expect(selected, SettingsSection.system);
  });

  testWidgets('SettingsDetailPanel renders defaults and custom detail', (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(960, 360),
        builder: (context, _) => const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                Expanded(
                  child: SettingsDetailPanel(
                    section: SettingsSection.appearance,
                    settings: AppSettings(),
                  ),
                ),
                Expanded(
                  child: SettingsDetailPanel(
                    section: SettingsSection.screen,
                    settings: AppSettings(
                      hideTopSystemBar: true,
                      hideBottomSystemBar: true,
                      themePreference: AppThemePreference.light,
                      fontSize: AppFontSize.small,
                    ),
                    title: 'Custom',
                    description: 'Desc',
                    icon: Icons.star,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Dettagli'), findsNWidgets(2));
    expect(find.text('Tema: Sistema'), findsOneWidget);
    expect(find.text('Custom'), findsOneWidget);
    expect(find.text('Desc'), findsOneWidget);
  });
}
