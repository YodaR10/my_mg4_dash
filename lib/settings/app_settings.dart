import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    this.panelBlur = 2.0,
    this.panelTintAlpha = 0.08,
  });

  static const _kThemePreference = 'settings.themePreference';
  static const _kFontSize = 'settings.fontSize';
  static const _kHideTopSystemBar = 'settings.hideTopSystemBar';
  static const _kHideBottomSystemBar = 'settings.hideBottomSystemBar';
  static const _kPanelBlur = 'settings.panelBlur';
  static const _kPanelTintAlpha = 'settings.panelTintAlpha';

  final AppThemePreference themePreference;
  final AppFontSize fontSize;
  final bool hideTopSystemBar;
  final bool hideBottomSystemBar;

  /// Gaussian blur sigma for glass panels.
  final double panelBlur;

  /// Panel tint opacity (0.05 = 5%, 0.90 = 90%).
  final double panelTintAlpha;

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
  }) {
    return AppSettings(
      themePreference: themePreference ?? this.themePreference,
      fontSize: fontSize ?? this.fontSize,
      hideTopSystemBar: hideTopSystemBar ?? this.hideTopSystemBar,
      hideBottomSystemBar: hideBottomSystemBar ?? this.hideBottomSystemBar,
      panelBlur: panelBlur ?? this.panelBlur,
      panelTintAlpha: panelTintAlpha ?? this.panelTintAlpha,
    );
  }

  static Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString(_kThemePreference);
    final fontName = prefs.getString(_kFontSize);
    return AppSettings(
      themePreference: AppThemePreference.values.firstWhere(
        (e) => e.name == themeName,
        orElse: () => AppThemePreference.system,
      ),
      fontSize: AppFontSize.values.firstWhere(
        (e) => e.name == fontName,
        orElse: () => AppFontSize.large,
      ),
      hideTopSystemBar: prefs.getBool(_kHideTopSystemBar) ?? false,
      hideBottomSystemBar: prefs.getBool(_kHideBottomSystemBar) ?? false,
      panelBlur: (prefs.getDouble(_kPanelBlur) ?? 2.0).clamp(0.0, 12.0),
      panelTintAlpha:
          (prefs.getDouble(_kPanelTintAlpha) ?? 0.08).clamp(0.05, 0.90),
    );
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemePreference, themePreference.name);
    await prefs.setString(_kFontSize, fontSize.name);
    await prefs.setBool(_kHideTopSystemBar, hideTopSystemBar);
    await prefs.setBool(_kHideBottomSystemBar, hideBottomSystemBar);
    await prefs.setDouble(_kPanelBlur, panelBlur);
    await prefs.setDouble(_kPanelTintAlpha, panelTintAlpha);
  }
}

class AppSettingsScope extends InheritedWidget {
  const AppSettingsScope({
    super.key,
    required this.settings,
    required this.update,
    required super.child,
  });

  final AppSettings settings;
  final ValueChanged<AppSettings> update;

  static AppSettingsScope of(BuildContext context) {
    final AppSettingsScope? scope =
        context.dependOnInheritedWidgetOfExactType<AppSettingsScope>();
    assert(scope != null, 'AppSettingsScope.of() called outside scope');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppSettingsScope oldWidget) {
    return settings != oldWidget.settings || update != oldWidget.update;
  }
}

Future<void> applySystemUi(AppSettings settings) async {
  final List<SystemUiOverlay> overlays = <SystemUiOverlay>[
    if (!settings.hideTopSystemBar) SystemUiOverlay.top,
    if (!settings.hideBottomSystemBar) SystemUiOverlay.bottom,
  ];
  if (overlays.length == 2) {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  } else if (overlays.isEmpty) {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: const <SystemUiOverlay>[],
    );
  } else {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: overlays,
    );
  }
}
