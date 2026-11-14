import 'package:flutter_test/flutter_test.dart';

import 'package:liquid_glass_demo/main.dart';

void main() {
  testWidgets('renders the liquid glass shell and first page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    // Tab bar items from `main.dart`.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Energy'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    // First page selected by default.
    expect(find.text('Page 1'), findsOneWidget);
  });
}
