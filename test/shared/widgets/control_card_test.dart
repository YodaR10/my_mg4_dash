import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_demo/src/shared/widgets/control_card.dart';

void main() {
  testWidgets('LiquidGlassControlCard renders vertical and horizontal', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              LiquidGlassControlCard(
                level: 0.5,
                icon: Icons.bolt,
                iconColor: Colors.green,
              ),
              LiquidGlassControlCard(
                level: 0.7,
                icon: Icons.battery_full,
                iconColor: Colors.blue,
                orientation: ControlOrientation.horizontal,
                width: 200,
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
    expect(find.byType(LiquidGlassControlCard), findsNWidgets(2));
    expect(find.byIcon(Icons.bolt), findsOneWidget);
    expect(find.byIcon(Icons.battery_full), findsOneWidget);
  });
}
