import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppThemePreference { system, light, dark }

class AppSettings {
  const AppSettings({
    this.themePreference = AppThemePreference.system,
    this.hideTopSystemBar = false,
    this.hideBottomSystemBar = false,
  });

  final AppThemePreference themePreference;
  final bool hideTopSystemBar;
  final bool hideBottomSystemBar;

  ThemeMode get themeMode => switch (themePreference) {
        AppThemePreference.system => ThemeMode.system,
        AppThemePreference.light => ThemeMode.light,
        AppThemePreference.dark => ThemeMode.dark,
      };

  AppSettings copyWith({
    AppThemePreference? themePreference,
    bool? hideTopSystemBar,
    bool? hideBottomSystemBar,
  }) {
    return AppSettings(
      themePreference: themePreference ?? this.themePreference,
      hideTopSystemBar: hideTopSystemBar ?? this.hideTopSystemBar,
      hideBottomSystemBar: hideBottomSystemBar ?? this.hideBottomSystemBar,
    );
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
