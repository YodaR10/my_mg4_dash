import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:liquid_glass_demo/main.dart';

void main() {
  testWidgets('renders the liquid glass shell and first page', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(960, 360);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());
    await tester.pump();

    // Tab bar items from `main.dart`.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Energy'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    // First page selected by default: the homepage dashboard.
    expect(find.text('Navigazione'), findsOneWidget);
    expect(find.text('Radio'), findsOneWidget);
    expect(find.text('Clima'), findsOneWidget);
  });
}
