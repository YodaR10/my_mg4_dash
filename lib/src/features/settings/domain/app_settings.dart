import 'package:flutter/material.dart';

enum AppThemePreference { system, light, dark }

enum AppFontSize { small, medium, large }

extension AppFontSizeScale on AppFontSize {
  double get scale => switch (this) {
        AppFontSize.large => 1.0,
        AppFontSize.medium => 0.9,
        AppFontSize.small => 0.8,
      };
}

class AppSettings {
  const AppSettings({
    this.themePreference = AppThemePreference.system,
    this.fontSize = AppFontSize.large,
    this.hideTopSystemBar = false,
    this.hideBottomSystemBar = false,
    this.panelBlur = 1.0,
    this.panelTintAlpha = 0.08,
    this.loggingEnabled = false,
  });

  final AppThemePreference themePreference;
  final AppFontSize fontSize;
  final bool hideTopSystemBar;
  final bool hideBottomSystemBar;

  /// Gaussian blur sigma for glass panels.
  final double panelBlur;

  /// Panel tint opacity (0.05 = 5%, 0.90 = 90%).
  final double panelTintAlpha;

  /// Enables on-device diagnostic logging and export.
  final bool loggingEnabled;

  ThemeMode get themeMode => switch (themePreference) {
        AppThemePreference.system => ThemeMode.system,
        AppThemePreference.light => ThemeMode.light,
        AppThemePreference.dark => ThemeMode.dark,
      };

  AppSettings copyWith({
    AppThemePreference? themePreference,
    AppFontSize? fontSize,
    bool? hideTopSystemBar,
    bool? hideBottomSystemBar,
    double? panelBlur,
    double? panelTintAlpha,
    bool? loggingEnabled,
  }) {
    return AppSettings(
      themePreference: themePreference ?? this.themePreference,
      fontSize: fontSize ?? this.fontSize,
      hideTopSystemBar: hideTopSystemBar ?? this.hideTopSystemBar,
      hideBottomSystemBar: hideBottomSystemBar ?? this.hideBottomSystemBar,
      panelBlur: panelBlur ?? this.panelBlur,
      panelTintAlpha: panelTintAlpha ?? this.panelTintAlpha,
      loggingEnabled: loggingEnabled ?? this.loggingEnabled,
    );
  }
}
