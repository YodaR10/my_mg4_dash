import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_demo/src/app/providers/app_settings_provider.dart';
import 'package:liquid_glass_demo/src/features/demo/presentation/demo_view.dart';
import 'package:liquid_glass_demo/src/features/energy/presentation/energy_view.dart';
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('DemoView renders and toggles FAB morph', (tester) async {
    tester.view.physicalSize = const Size(960, 360);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(await _wrap(const DemoView(2)));
    await tester.pump();
    expect(find.text('Page 3'), findsOneWidget);
    expect(find.text('Liquid Glass'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.abc_sharp), warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byIcon(Icons.camera_alt_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close), warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('EnergyView renders controls', (tester) async {
    tester.view.physicalSize = const Size(960, 360);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(await _wrap(const EnergyView()));
    await tester.pump();
    expect(find.text('40% - Charging'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
    expect(find.byIcon(Icons.bolt_rounded), findsOneWidget);
  });
}
