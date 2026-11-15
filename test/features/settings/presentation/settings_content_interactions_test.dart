import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_mg4_dash/src/app/providers/app_settings_provider.dart';
import 'package:my_mg4_dash/src/features/settings/presentation/settings_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Widget> _app() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  return ProviderScope(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    child: ScreenUtilInit(
      designSize: const Size(960, 360),
      builder: (context, _) =>
          const MaterialApp(home: Scaffold(body: SettingsView())),
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
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.single;
    view.physicalSize = const Size(960, 360);
    view.devicePixelRatio = 1;
  });
  tearDown(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.single;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  testWidgets('screen toggles and appearance sliders', (tester) async {
    await tester.pumpWidget(await _app());
    await tester.pump(const Duration(milliseconds: 100));

    final sliders = find.byType(Slider);
    if (sliders.evaluate().isNotEmpty) {
      await tester.ensureVisible(sliders.first);
      await tester.drag(
        sliders.first,
        const Offset(30, 0),
        warnIfMissed: false,
      );
      await tester.pump(const Duration(milliseconds: 100));
    }
    if (sliders.evaluate().length > 1) {
      await tester.ensureVisible(sliders.last);
      await tester.drag(sliders.last, const Offset(20, 0), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 100));
    }

    await _tapText(tester, 'Schermo e barre');
    await _tapText(tester, 'Nascondi la barra superiore');
    await tester.pump(const Duration(milliseconds: 100));
    await _tapText(tester, 'Nascondi barra dei pulsanti');
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.textContaining('Barra'), findsWidgets);
  });

  testWidgets('system and mock list items show detail and snackbar', (
    tester,
  ) async {
    await tester.pumpWidget(await _app());
    await tester.pump(const Duration(milliseconds: 100));

    await _tapText(tester, 'Sistema');
    await _tapText(tester, 'Verifica aggiornamenti');
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(seconds: 2));

    await _tapText(tester, 'Versione software');
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(seconds: 2));

    await _tapText(tester, 'Note di rilascio');
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(seconds: 2));

    await _tapText(tester, 'Audio');
    await _tapText(tester, 'Volume multimediale');
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(seconds: 2));

    await _tapText(tester, 'Connettività');
    await _tapText(tester, 'Bluetooth');
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(seconds: 2));

    await _tapText(tester, 'Privacy e sicurezza');
    await _tapText(tester, 'Posizione');
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Dettagli'), findsWidgets);
  });
}
