import 'package:shared_preferences/shared_preferences.dart';

import '../domain/app_settings.dart';

class AppSettingsRepository {
  const AppSettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const kThemePreference = 'settings.themePreference';
  static const kFontSize = 'settings.fontSize';
  static const kHideTopSystemBar = 'settings.hideTopSystemBar';
  static const kHideBottomSystemBar = 'settings.hideBottomSystemBar';
  static const kPanelBlur = 'settings.panelBlur';
  static const kPanelTintAlpha = 'settings.panelTintAlpha';
  static const kLoggingEnabled = 'settings.loggingEnabled';

  AppSettings load() {
    final themeName = _prefs.getString(kThemePreference);
    final fontName = _prefs.getString(kFontSize);
    return AppSettings(
      themePreference: AppThemePreference.values.firstWhere(
        (e) => e.name == themeName,
        orElse: () => AppThemePreference.system,
      ),
      fontSize: AppFontSize.values.firstWhere(
        (e) => e.name == fontName,
        orElse: () => AppFontSize.large,
      ),
      hideTopSystemBar: _prefs.getBool(kHideTopSystemBar) ?? false,
      hideBottomSystemBar: _prefs.getBool(kHideBottomSystemBar) ?? false,
      panelBlur: (_prefs.getDouble(kPanelBlur) ?? 1.0).clamp(0.0, 8.0),
      panelTintAlpha:
          (_prefs.getDouble(kPanelTintAlpha) ?? 0.08).clamp(0.05, 0.90),
      loggingEnabled: _prefs.getBool(kLoggingEnabled) ?? false,
    );
  }

  Future<void> save(AppSettings settings) async {
    await _prefs.setString(kThemePreference, settings.themePreference.name);
    await _prefs.setString(kFontSize, settings.fontSize.name);
    await _prefs.setBool(kHideTopSystemBar, settings.hideTopSystemBar);
    await _prefs.setBool(kHideBottomSystemBar, settings.hideBottomSystemBar);
    await _prefs.setDouble(kPanelBlur, settings.panelBlur);
    await _prefs.setDouble(kPanelTintAlpha, settings.panelTintAlpha);
    await _prefs.setBool(kLoggingEnabled, settings.loggingEnabled);
  }
}
