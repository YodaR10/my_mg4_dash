import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../ui/adaptive_ink.dart';
import '../app_settings.dart';
import '../settings_typography.dart';
import '../settings_view.dart';

class SettingsDetailPanel extends StatelessWidget {
  const SettingsDetailPanel({
    super.key,
    required this.section,
    required this.settings,
    this.title,
    this.description,
    this.icon,
  });

  final SettingsSection section;
  final AppSettings settings;
  final String? title;
  final String? description;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final typo = SettingsTypography.of(context);
    final ink = AdaptiveInk.of(context);
    final String resolvedTitle = title ?? _defaultTitle(section, settings);
    final String resolvedDescription =
        description ?? _defaultDescription(section, settings);
    final IconData resolvedIcon = icon ?? _defaultIcon(section);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Dettagli',
          style: TextStyle(
            color: ink.secondary,
            fontSize: typo.detailLabel,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: ink.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: ink.primary.withValues(alpha: 0.14)),
            ),
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ink.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: ink.primary.withValues(alpha: 0.16),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        resolvedIcon,
                        size: typo.detailHeroIcon,
                        color: ink.primary.withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  resolvedTitle,
                  style: TextStyle(
                    color: ink.primary,
                    fontSize: typo.detailTitle,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    child: Text(
                      resolvedDescription,
                      style: TextStyle(
                        color: ink.secondary,
                        fontSize: typo.detailBody,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  IconData _defaultIcon(SettingsSection section) => switch (section) {
        SettingsSection.appearance => Icons.palette_outlined,
        SettingsSection.screen => Icons.fullscreen_outlined,
        SettingsSection.system => Icons.system_update_outlined,
        SettingsSection.audio => Icons.volume_up_outlined,
        SettingsSection.connectivity => Icons.wifi_outlined,
        SettingsSection.privacy => Icons.shield_outlined,
      };

  String _defaultTitle(SettingsSection section, AppSettings settings) =>
      switch (section) {
        SettingsSection.appearance => 'Tema: ${_themeLabel(settings)}',
        SettingsSection.screen => 'Modalità fullscreen',
        SettingsSection.system => 'Sistema',
        SettingsSection.audio => 'Audio',
        SettingsSection.connectivity => 'Connettività',
        SettingsSection.privacy => 'Privacy e sicurezza',
      };

  String _defaultDescription(SettingsSection section, AppSettings settings) =>
      switch (section) {
        SettingsSection.appearance =>
          'Personalizza tema e dimensione dei caratteri.\n\nTema: ${_themeLabel(settings)}\nCaratteri: ${_fontSizeLabel(settings)} (pannelli diversi da Home)',
        SettingsSection.screen =>
          'Nascondi una o entrambe le barre di sistema per coprirle.\n\nBarra superiore: ${settings.hideTopSystemBar ? "nascosta" : "visibile"}\nBarra dei pulsanti: ${settings.hideBottomSystemBar ? "nascosta" : "visibile"}\n\nLa barra di navigazione dell’app resta sempre visibile.',
        SettingsSection.system =>
          'Controlla aggiornamenti e informazioni software. Alcune azioni sono di esempio in questa demo.',
        SettingsSection.audio =>
          'Spazio per impostazioni audio. Seleziona una voce al centro per i dettagli.',
        SettingsSection.connectivity =>
          'Spazio per Wi‑Fi, Bluetooth e altre connessioni. Seleziona una voce al centro per i dettagli.',
        SettingsSection.privacy =>
          'Spazio per permessi e sicurezza. Seleziona una voce al centro per i dettagli.',
      };

  String _themeLabel(AppSettings settings) =>
      switch (settings.themePreference) {
        AppThemePreference.system => 'Sistema',
        AppThemePreference.light => 'Chiaro',
        AppThemePreference.dark => 'Scuro',
      };

  String _fontSizeLabel(AppSettings settings) => switch (settings.fontSize) {
        AppFontSize.large => 'Grande',
        AppFontSize.medium => 'Medio',
        AppFontSize.small => 'Piccolo',
      };
}
