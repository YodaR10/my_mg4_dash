import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_demo/src/core/ui/adaptive_ink.dart';

void main() {
  group('AdaptiveInk', () {
    testWidgets('returns dark palette in dark theme', (tester) async {
      late AdaptiveInk ink;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Builder(
            builder: (context) {
              ink = AdaptiveInk.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(ink.primary, Colors.white);
      expect(ink.onActive, const Color(0xFF101418));
      expect(ink.secondary, const Color(0xB8FFFFFF));
    });

    testWidgets('returns light palette in light theme', (tester) async {
      late AdaptiveInk ink;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Builder(
            builder: (context) {
              ink = AdaptiveInk.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(ink.primary, const Color(0xFF101418));
      expect(ink.onActive, Colors.white);
      expect(ink.secondary, const Color(0xB8101418));
    });
  });
}
