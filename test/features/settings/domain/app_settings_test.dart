import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_mg4_dash/src/features/settings/domain/app_settings.dart';

void main() {
  group('AppSettings', () {
    test('defaults are expected', () {
      const settings = AppSettings();
      expect(settings.themePreference, AppThemePreference.system);
      expect(settings.fontSize, AppFontSize.large);
      expect(settings.hideTopSystemBar, isFalse);
      expect(settings.hideBottomSystemBar, isFalse);
      expect(settings.panelBlur, 1.0);
      expect(settings.panelTintAlpha, 0.08);
      expect(settings.themeMode, ThemeMode.system);
    });

    test('themeMode maps preferences', () {
      expect(
        const AppSettings(themePreference: AppThemePreference.light).themeMode,
        ThemeMode.light,
      );
      expect(
        const AppSettings(themePreference: AppThemePreference.dark).themeMode,
        ThemeMode.dark,
      );
    });

    test('copyWith updates selected fields', () {
      const settings = AppSettings();
      final updated = settings.copyWith(
        themePreference: AppThemePreference.dark,
        fontSize: AppFontSize.small,
        hideTopSystemBar: true,
        hideBottomSystemBar: true,
        panelBlur: 6.5,
        panelTintAlpha: 0.4,
      );

      expect(updated.themePreference, AppThemePreference.dark);
      expect(updated.fontSize, AppFontSize.small);
      expect(updated.hideTopSystemBar, isTrue);
      expect(updated.hideBottomSystemBar, isTrue);
      expect(updated.panelBlur, 6.5);
      expect(updated.panelTintAlpha, 0.4);
    });
  });

  group('AppFontSize', () {
    test('scales are correct', () {
      expect(AppFontSize.large.scale, 1.0);
      expect(AppFontSize.medium.scale, 0.9);
      expect(AppFontSize.small.scale, 0.8);
    });
  });
}
