import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/logging/app_logger.dart';
import '../../../../core/ui/adaptive_ink.dart';
import '../../data/app_update_service.dart';
import '../../domain/app_settings.dart';
import '../settings_typography.dart';
import '../settings_view.dart';

typedef NotImplementedCallback = void Function(String feature);
typedef DetailCallback = void Function({
  required String title,
  required String description,
  required IconData icon,
});

class SettingsContent extends StatelessWidget {
  const SettingsContent({
    super.key,
    required this.section,
    required this.settings,
    required this.onUpdateSettings,
    required this.onNotImplemented,
    required this.onShowDetail,
  });

  final SettingsSection section;
  final AppSettings settings;
  final ValueChanged<AppSettings> onUpdateSettings;
  final NotImplementedCallback onNotImplemented;
  final DetailCallback onShowDetail;

  @override
  Widget build(BuildContext context) {
    final typo = SettingsTypography.forFontSize(settings.fontSize);
    final ink = AdaptiveInk.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          section.label,
          style: TextStyle(
            color: ink.primary,
            fontSize: typo.sectionTitle,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          _subtitleFor(section),
          style: TextStyle(
            color: ink.secondary,
            fontSize: typo.sectionSubtitle,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 14.h),
        Expanded(child: SingleChildScrollView(child: _buildBody(context))),
      ],
    );
  }

  String _subtitleFor(SettingsSection section) => switch (section) {
    SettingsSection.appearance => 'Personalizza il tema dell’interfaccia.',
    SettingsSection.screen =>
      'Gestisci le barre di sistema per la modalità fullscreen.',
    SettingsSection.system => 'Aggiornamenti e informazioni di sistema.',
    SettingsSection.audio => 'Impostazioni audio di base (mock).',
    SettingsSection.connectivity => 'Connessioni e dispositivi (mock).',
    SettingsSection.privacy => 'Privacy, permessi e sicurezza (mock).',
    SettingsSection.diagnostics =>
      'Raccogli ed esporta i log diagnostici su chiavetta USB.',
  };

  Widget _buildBody(BuildContext context) {
    switch (section) {
      case SettingsSection.appearance:
        return _AppearanceSection(
          settings: settings,
          onUpdateSettings: onUpdateSettings,
          onShowDetail: onShowDetail,
        );
      case SettingsSection.screen:
        return _ScreenSection(
          settings: settings,
          onUpdateSettings: onUpdateSettings,
          onShowDetail: onShowDetail,
        );
      case SettingsSection.system:
        return _SystemUpdatesSection(
          settings: settings,
          onUpdateSettings: onUpdateSettings,
          onShowDetail: onShowDetail,
        );
      case SettingsSection.audio:
        return _MockListSection(
          items: const [
            _MockItem(
              'Volume multimediale',
              Icons.volume_up_outlined,
              'Regola il volume principale del sistema.',
            ),
            _MockItem(
              'Suoni di sistema',
              Icons.notifications_active_outlined,
              'Attiva o disattiva i feedback sonori.',
            ),
            _MockItem(
              'Bilanciamento audio',
              Icons.equalizer_outlined,
              'Configura bassi, medi e alti.',
            ),
            _MockItem(
              'Uscita audio',
              Icons.speaker_outlined,
              'Seleziona il dispositivo di riproduzione.',
            ),
          ],
          onNotImplemented: onNotImplemented,
          onShowDetail: onShowDetail,
          fontSize: settings.fontSize,
        );
      case SettingsSection.connectivity:
        return _MockListSection(
          items: const [
            _MockItem(
              'Wi‑Fi',
              Icons.wifi_outlined,
              'Gestisci reti wireless disponibili.',
            ),
            _MockItem(
              'Bluetooth',
              Icons.bluetooth_outlined,
              'Associa e gestisci dispositivi Bluetooth.',
            ),
            _MockItem(
              'Android Auto',
              Icons.directions_car_outlined,
              'Configura la connessione con il telefono.',
            ),
            _MockItem(
              'Hotspot',
              Icons.wifi_tethering_outlined,
              'Condividi la connessione del veicolo.',
            ),
          ],
          onNotImplemented: onNotImplemented,
          onShowDetail: onShowDetail,
          fontSize: settings.fontSize,
        );
      case SettingsSection.privacy:
        return _MockListSection(
          items: const [
            _MockItem(
              'Permessi app',
              Icons.app_settings_alt_outlined,
              'Controlla i permessi concessi alle app.',
            ),
            _MockItem(
              'Posizione',
              Icons.location_on_outlined,
              'Gestisci accesso e precisione della posizione.',
            ),
            _MockItem(
              'Dati diagnostici',
              Icons.analytics_outlined,
              'Scegli quali dati condividere.',
            ),
            _MockItem(
              'Ripristino impostazioni',
              Icons.restart_alt_outlined,
              'Reimposta le preferenze ai valori iniziali.',
            ),
          ],
          onNotImplemented: onNotImplemented,
          onShowDetail: onShowDetail,
          fontSize: settings.fontSize,
        );
      case SettingsSection.diagnostics:
        return _DiagnosticsSection(
          settings: settings,
          onUpdateSettings: onUpdateSettings,
          onShowDetail: onShowDetail,
        );
    }
  }
}

class _AppearanceSection extends StatelessWidget {
  const _AppearanceSection({
    required this.settings,
    required this.onUpdateSettings,
    required this.onShowDetail,
  });

  final AppSettings settings;
  final ValueChanged<AppSettings> onUpdateSettings;
  final DetailCallback onShowDetail;

  @override
  Widget build(BuildContext context) {
    final typo = SettingsTypography.forFontSize(settings.fontSize);
    final ink = AdaptiveInk.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _OptionTile(
          icon: Icons.brightness_auto_outlined,
          title: 'Sistema',
          subtitle: 'Segue l’impostazione del dispositivo',
          selected: settings.themePreference == AppThemePreference.system,
          fontSize: settings.fontSize,
          onTap: () {
            onUpdateSettings(
              settings.copyWith(themePreference: AppThemePreference.system),
            );
            onShowDetail(
              title: 'Tema: Sistema',
              description: 'L’app usa automaticamente il tema chiaro o scuro in base alle impostazioni di sistema.',
              icon: Icons.brightness_auto_outlined,
            );
          },
        ),
        SizedBox(height: 10.h),
        _OptionTile(
          icon: Icons.light_mode_outlined,
          title: 'Chiaro',
          subtitle: 'Interfaccia con aspetto chiaro',
          selected: settings.themePreference == AppThemePreference.light,
          fontSize: settings.fontSize,
          onTap: () {
            onUpdateSettings(
              settings.copyWith(themePreference: AppThemePreference.light),
            );
            onShowDetail(
              title: 'Tema: Chiaro',
              description: 'L’app utilizza sempre il tema chiaro, indipendentemente dal sistema.',
              icon: Icons.light_mode_outlined,
            );
          },
        ),
        SizedBox(height: 10.h),
        _OptionTile(
          icon: Icons.dark_mode_outlined,
          title: 'Scuro',
          subtitle: 'Interfaccia con aspetto scuro',
          selected: settings.themePreference == AppThemePreference.dark,
          fontSize: settings.fontSize,
          onTap: () {
            onUpdateSettings(
              settings.copyWith(themePreference: AppThemePreference.dark),
            );
            onShowDetail(
              title: 'Tema: Scuro',
              description: 'L’app utilizza sempre il tema scuro, indipendentemente dal sistema.',
              icon: Icons.dark_mode_outlined,
            );
          },
        ),
        SizedBox(height: 16.h),
        Text(
          'Dimensione caratteri',
          style: TextStyle(
            color: ink.secondary,
            fontSize: typo.detailLabel,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        _OptionTile(
          icon: Icons.format_size_outlined,
          title: 'Grande',
          subtitle: 'Dimensione predefinita',
          selected: settings.fontSize == AppFontSize.large,
          fontSize: settings.fontSize,
          onTap: () {
            onUpdateSettings(settings.copyWith(fontSize: AppFontSize.large));
            onShowDetail(
              title: 'Caratteri: Grande',
              description: 'Usa la dimensione dei caratteri predefinita per i pannelli diversi da Home.',
              icon: Icons.format_size_outlined,
            );
          },
        ),
        SizedBox(height: 10.h),
        _OptionTile(
          icon: Icons.format_size_outlined,
          title: 'Medio',
          subtitle: 'Caratteri leggermente più piccoli',
          selected: settings.fontSize == AppFontSize.medium,
          fontSize: settings.fontSize,
          onTap: () {
            onUpdateSettings(settings.copyWith(fontSize: AppFontSize.medium));
            onShowDetail(
              title: 'Caratteri: Medio',
              description: 'Riduce leggermente i caratteri nei pannelli diversi da Home per mostrare più informazioni.',
              icon: Icons.format_size_outlined,
            );
          },
        ),
        SizedBox(height: 10.h),
        _OptionTile(
          icon: Icons.format_size_outlined,
          title: 'Piccolo',
          subtitle: 'Caratteri più compatti',
          selected: settings.fontSize == AppFontSize.small,
          fontSize: settings.fontSize,
          onTap: () {
            onUpdateSettings(settings.copyWith(fontSize: AppFontSize.small));
            onShowDetail(
              title: 'Caratteri: Piccolo',
              description: 'Riduce ulteriormente i caratteri nei pannelli diversi da Home per massimizzare le informazioni a schermo.',
              icon: Icons.format_size_outlined,
            );
          },
        ),
        SizedBox(height: 16.h),
        Text(
          'Pannelli',
          style: TextStyle(
            color: ink.secondary,
            fontSize: typo.detailLabel,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        _SliderTile(
          icon: Icons.blur_on_outlined,
          title: 'Sfocatura',
          value: settings.panelBlur.clamp(0.0, 6.0),
          min: 0,
          max: 6,
          divisions: 12,
          valueLabel: settings.panelBlur.toStringAsFixed(1),
          fontSize: settings.fontSize,
          onChanged: (v) {
            onUpdateSettings(settings.copyWith(panelBlur: v));
            onShowDetail(
              title: 'Sfocatura pannelli',
              description: 'Regola la sfocatura del vetro dei pannelli. Valori bassi (0–2) migliorano molto le prestazioni su dispositivi meno potenti; la tinta compensa la leggibilità.',
              icon: Icons.blur_on_outlined,
            );
          },
        ),
        SizedBox(height: 10.h),
        _SliderTile(
          icon: Icons.opacity_outlined,
          title: 'Opacità pannelli',
          value: settings.panelTintAlpha.clamp(0.05, 0.90),
          min: 0.05,
          max: 0.90,
          divisions: 85,
          valueLabel: '${(settings.panelTintAlpha * 100).round()}%',
          fontSize: settings.fontSize,
          note: 'Regola questo valore in modo tale che tutto sia ben leggibile con lo sfondo corrente',
          onChanged: (v) {
            onUpdateSettings(settings.copyWith(panelTintAlpha: v));
            onShowDetail(
              title: 'Opacità pannelli',
              description: 'Regola l’opacità della tinta dei pannelli (5–90%). Aumenta o riduci per mantenere i contenuti ben leggibili con lo sfondo corrente.',
              icon: Icons.opacity_outlined,
            );
          },
        ),
      ],
    );
  }
}

class _ScreenSection extends StatelessWidget {
  const _ScreenSection({
    required this.settings,
    required this.onUpdateSettings,
    required this.onShowDetail,
  });

  final AppSettings settings;
  final ValueChanged<AppSettings> onUpdateSettings;
  final DetailCallback onShowDetail;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ToggleTile(
          icon: Icons.vertical_align_top_outlined,
          title: 'Nascondi la barra superiore',
          subtitle:
              'Nasconde ora/segnale per coprire la barra di sistema in alto',
          value: settings.hideTopSystemBar,
          fontSize: settings.fontSize,
          onChanged: (v) {
            onUpdateSettings(settings.copyWith(hideTopSystemBar: v));
            onShowDetail(
              title: 'Barra superiore',
              description: v
                  ? 'La barra di sistema superiore (ora/segnale) è nascosta: l’app può coprire quell’area.'
                  : 'La barra di sistema superiore (ora/segnale) è visibile.',
              icon: Icons.vertical_align_top_outlined,
            );
          },
        ),
        SizedBox(height: 10.h),
        _ToggleTile(
          icon: Icons.touch_app_outlined,
          title: 'Nascondi barra dei pulsanti',
          subtitle:
              'Nasconde i pulsanti di sistema inferiori per coprire la barra',
          value: settings.hideBottomSystemBar,
          fontSize: settings.fontSize,
          onChanged: (v) {
            onUpdateSettings(settings.copyWith(hideBottomSystemBar: v));
            onShowDetail(
              title: 'Barra dei pulsanti',
              description: v
                  ? 'La barra di sistema inferiore (pulsanti) è nascosta: l’app può coprire quell’area.'
                  : 'La barra di sistema inferiore (pulsanti) è visibile.',
              icon: Icons.touch_app_outlined,
            );
          },
        ),
        SizedBox(height: 12.h),
        _InfoNote(
          fontSize: settings.fontSize,
          text: 'La barra di navigazione dell’app in basso resta sempre visibile. Puoi nascondere una o entrambe le barre di sistema.',
        ),
      ],
    );
  }
}

class _SystemUpdatesSection extends StatefulWidget {
  const _SystemUpdatesSection({
    required this.settings,
    required this.onUpdateSettings,
    required this.onShowDetail,
  });

  final AppSettings settings;
  final ValueChanged<AppSettings> onUpdateSettings;
  final DetailCallback onShowDetail;

  @override
  State<_SystemUpdatesSection> createState() => _SystemUpdatesSectionState();
}

class _SystemUpdatesSectionState extends State<_SystemUpdatesSection> {
  final AppUpdateService _service = AppUpdateService();
  PackageInfo? _packageInfo;
  bool _checking = false;
  bool _downloading = false;
  double _progress = 0;
  String _status = 'Nessun controllo effettuato.';
  UpdateCheckResult? _lastResult;

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => _packageInfo = info);
    widget.onShowDetail(
      title: 'Versione software',
      description: _versionDescription(null),
      icon: Icons.info_outline,
    );
  }

  String _versionDescription(UpdateCheckResult? result) {
    final info = _packageInfo;
    final current = info == null ? '—' : '${info.version}+${info.buildNumber}';
    final channelLabel = widget.settings.updateChannel == AppUpdateChannel.beta
        ? 'Beta (pre-release)'
        : 'Stabile';
    final buf = StringBuffer()
      ..writeln('Versione installata: $current')
      ..writeln('Canale aggiornamenti: $channelLabel');
    if (result != null) {
      if (result.error != null) {
        buf
          ..writeln()
          ..writeln('Errore: ${result.error}');
      } else if (result.latest == null) {
        buf
          ..writeln()
          ..writeln('Nessuna release trovata per questo canale.');
      } else if (result.hasUpdate) {
        final l = result.latest!;
        buf
          ..writeln()
          ..writeln('Aggiornamento disponibile: ${l.versionName} (${l.tag})')
          ..writeln(
            l.isPrerelease ? 'Tipo: pre-release (beta)' : 'Tipo: stabile',
          );
        if (l.body.trim().isNotEmpty) {
          final notes = l.body.trim();
          buf
            ..writeln()
            ..writeln('Note:')
            ..writeln(
              notes.length > 600 ? '${notes.substring(0, 600)}…' : notes,
            );
        }
      } else {
        buf
          ..writeln()
          ..writeln('L\'app è aggiornata per il canale selezionato.');
      }
    } else {
      buf
        ..writeln()
        ..writeln(_status);
    }
    return buf.toString();
  }

  Future<void> _check() async {
    if (_checking || _downloading) return;
    setState(() {
      _checking = true;
      _status = 'Controllo aggiornamenti in corso…';
    });
    widget.onShowDetail(
      title: 'Verifica aggiornamenti',
      description: _versionDescription(null),
      icon: Icons.system_update_alt_outlined,
    );
    final result = await _service.check(widget.settings.updateChannel);
    if (!mounted) return;
    setState(() {
      _checking = false;
      _lastResult = result;
      if (result.error != null) {
        _status = 'Errore durante il controllo.';
      } else if (result.latest == null) {
        _status = 'Nessuna release trovata per questo canale.';
      } else if (result.hasUpdate) {
        _status = 'Disponibile: ${result.latest!.versionName}';
      } else {
        _status = 'Nessun aggiornamento disponibile.';
      }
    });
    widget.onShowDetail(
      title: 'Verifica aggiornamenti',
      description: _versionDescription(result),
      icon: Icons.system_update_alt_outlined,
    );
  }

  Future<void> _downloadAndInstall() async {
    final release = _lastResult?.latest;
    if (release == null || _downloading) return;
    setState(() {
      _downloading = true;
      _progress = 0;
    });
    widget.onShowDetail(
      title: 'Aggiornamento',
      description: 'Download di ${release.apkName} in corso…',
      icon: Icons.download_outlined,
    );
    try {
      final file = await _service.downloadApk(
        release,
        onProgress: (r, t) {
          if (!mounted) return;
          setState(() => _progress = t > 0 ? r / t : 0);
        },
      );
      if (!mounted) return;
      widget.onShowDetail(
        title: 'Aggiornamento',
        description:
            'Download completato (${release.apkName}). Avvio installazione…\nConferma l\'installazione del pacchetto quando richiesto.',
        icon: Icons.system_update_alt_outlined,
      );
      await _service.installApk(file);
    } catch (e) {
      if (!mounted) return;
      setState(() => _status = 'Errore: $e');
      widget.onShowDetail(
        title: 'Aggiornamento',
        description: 'Errore durante download/installazione:\n$e',
        icon: Icons.error_outline,
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Aggiornamento fallito: $e'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
            margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          ),
        );
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final typo = SettingsTypography.forFontSize(widget.settings.fontSize);
    final ink = AdaptiveInk.of(context);
    final info = _packageInfo;
    final current = info == null ? '—' : '${info.version}+${info.buildNumber}';
    final result = _lastResult;
    final hasUpdate = result?.hasUpdate == true;
    final latest = result?.latest;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Canale aggiornamenti',
          style: TextStyle(
            color: ink.secondary,
            fontSize: typo.detailLabel,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        _OptionTile(
          icon: Icons.verified_outlined,
          title: 'Stabile',
          subtitle: 'Solo release stabili (consigliato)',
          selected: widget.settings.updateChannel == AppUpdateChannel.stable,
          fontSize: widget.settings.fontSize,
          onTap: () {
            widget.onUpdateSettings(
              widget.settings.copyWith(updateChannel: AppUpdateChannel.stable),
            );
            widget.onShowDetail(
              title: 'Canale: Stabile',
              description: 'Verranno proposte solo le release stabili pubblicate su GitHub.',
              icon: Icons.verified_outlined,
            );
          },
        ),
        SizedBox(height: 10.h),
        _OptionTile(
          icon: Icons.science_outlined,
          title: 'Beta',
          subtitle: 'Include pre-release beta per test',
          selected: widget.settings.updateChannel == AppUpdateChannel.beta,
          fontSize: widget.settings.fontSize,
          onTap: () {
            widget.onUpdateSettings(
              widget.settings.copyWith(updateChannel: AppUpdateChannel.beta),
            );
            widget.onShowDetail(
              title: 'Canale: Beta',
              description: 'Verranno proposte le pre-release beta (tag con suffisso -beta) pubblicate su GitHub.',
              icon: Icons.science_outlined,
            );
          },
        ),
        SizedBox(height: 14.h),
        _ActionTile(
          icon: Icons.info_outline,
          title: 'Versione installata',
          subtitle: current,
          fontSize: widget.settings.fontSize,
          trailing: null,
          onTap: () {
            widget.onShowDetail(
              title: 'Versione software',
              description: _versionDescription(result),
              icon: Icons.info_outline,
            );
          },
        ),
        SizedBox(height: 10.h),
        _ActionTile(
          icon: Icons.system_update_alt_outlined,
          title: _checking ? 'Controllo in corso…' : 'Verifica aggiornamenti',
          subtitle: _status,
          fontSize: widget.settings.fontSize,
          trailing: _checking
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ink.secondary,
                  ),
                )
              : _ChevronIcon(fontSize: widget.settings.fontSize),
          onTap: _check,
        ),
        if (hasUpdate && latest != null) ...[
          SizedBox(height: 10.h),
          _ActionTile(
            icon: Icons.download_outlined,
            title: _downloading
                ? 'Download… ${(_progress * 100).toStringAsFixed(0)}%'
                : 'Scarica e installa ${latest.versionName}',
            subtitle: latest.isPrerelease
                ? 'Pre-release beta • ${latest.apkName}'
                : 'Release stabile • ${latest.apkName}',
            fontSize: widget.settings.fontSize,
            trailing: _downloading
                ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      value: _progress > 0 ? _progress : null,
                      strokeWidth: 2,
                      color: ink.secondary,
                    ),
                  )
                : _ChevronIcon(fontSize: widget.settings.fontSize),
            onTap: _downloadAndInstall,
          ),
        ],
        if (latest != null && latest.body.trim().isNotEmpty) ...[
          SizedBox(height: 12.h),
          _InfoNote(
            fontSize: widget.settings.fontSize,
            text:
                'Note di rilascio (${latest.tag}):\n${latest.body.trim().length > 400 ? '${latest.body.trim().substring(0, 400)}…' : latest.body.trim()}',
          ),
        ],
        SizedBox(height: 12.h),
        _InfoNote(
          fontSize: widget.settings.fontSize,
          text: 'La verifica usa le Release GitHub del progetto (YodaR10/my_mg4_dash). Su MG4 l\'installazione dell\'APK richiede conferma e potrebbe dipendere dai permessi del sistema.',
        ),
      ],
    );
  }
}

class _MockItem {
  const _MockItem(this.title, this.icon, this.description);
  final String title;
  final IconData icon;
  final String description;
}

class _MockListSection extends StatelessWidget {
  const _MockListSection({
    required this.items,
    required this.onNotImplemented,
    required this.onShowDetail,
    required this.fontSize,
  });

  final List<_MockItem> items;
  final NotImplementedCallback onNotImplemented;
  final DetailCallback onShowDetail;
  final AppFontSize fontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          _ActionTile(
            icon: items[i].icon,
            title: items[i].title,
            subtitle: items[i].description,
            fontSize: fontSize,
            trailing: _ChevronIcon(fontSize: fontSize),
            onTap: () {
              onShowDetail(
                title: items[i].title,
                description: items[i].description,
                icon: items[i].icon,
              );
              onNotImplemented(items[i].title);
            },
          ),
          if (i != items.length - 1) SizedBox(height: 10.h),
        ],
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    required this.fontSize,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final AppFontSize fontSize;

  @override
  Widget build(BuildContext context) {
    final typo = SettingsTypography.forFontSize(fontSize);
    final ink = AdaptiveInk.of(context);
    final Color fg = selected ? ink.onActive : ink.primary;
    final Color sub = selected
        ? ink.onActive.withValues(alpha: 0.75)
        : ink.secondary;
    return _BaseTile(
      selected: selected,
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: typo.tileIcon, color: fg),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: fg,
                    fontSize: typo.tileTitle,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: sub,
                    fontSize: typo.tileSubtitle,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: fg,
            size: typo.radioIcon,
          ),
        ],
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.fontSize,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final AppFontSize fontSize;

  @override
  Widget build(BuildContext context) {
    final typo = SettingsTypography.forFontSize(fontSize);
    final ink = AdaptiveInk.of(context);
    return _BaseTile(
      selected: value,
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Icon(icon, size: typo.tileIcon, color: ink.primary),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: ink.primary,
                    fontSize: typo.tileTitle,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: ink.secondary,
                    fontSize: typo.tileSubtitle,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          _SimpleSwitch(value: value, onChanged: onChanged, fontSize: fontSize),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.fontSize,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final AppFontSize fontSize;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final typo = SettingsTypography.forFontSize(fontSize);
    final ink = AdaptiveInk.of(context);
    return _BaseTile(
      selected: false,
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: typo.tileIcon, color: ink.primary),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: ink.primary,
                    fontSize: typo.tileTitle,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ink.secondary,
                    fontSize: typo.tileSubtitle,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[SizedBox(width: 8.w), trailing!],
        ],
      ),
    );
  }
}

class _BaseTile extends StatelessWidget {
  const _BaseTile({
    required this.selected,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ink = AdaptiveInk.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          decoration: BoxDecoration(
            color: selected
                ? ink.primary.withValues(alpha: 0.20)
                : ink.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: ink.primary.withValues(alpha: selected ? 0.34 : 0.14),
            ),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 48.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _SimpleSwitch extends StatelessWidget {
  const _SimpleSwitch({
    required this.value,
    required this.onChanged,
    required this.fontSize,
  });
  final bool value;
  final ValueChanged<bool> onChanged;
  final AppFontSize fontSize;

  @override
  Widget build(BuildContext context) {
    final typo = SettingsTypography.forFontSize(fontSize);
    final ink = AdaptiveInk.of(context);
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: typo.switchWidth,
        height: typo.switchHeight,
        padding: EdgeInsets.all(typo.switchPadding),
        decoration: BoxDecoration(
          color: value ? ink.primary : ink.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: ink.primary.withValues(alpha: value ? 0 : 0.20),
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: typo.switchThumb,
            height: typo.switchThumb,
            decoration: BoxDecoration(
              color: value ? ink.onActive : ink.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChevronIcon extends StatelessWidget {
  const _ChevronIcon({required this.fontSize});
  final AppFontSize fontSize;

  @override
  Widget build(BuildContext context) {
    final typo = SettingsTypography.forFontSize(fontSize);
    final ink = AdaptiveInk.of(context);
    return Icon(
      Icons.chevron_right,
      color: ink.tertiary,
      size: typo.chevronIcon,
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.valueLabel,
    required this.onChanged,
    required this.fontSize,
    this.note,
  });

  final IconData icon;
  final String title;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String valueLabel;
  final ValueChanged<double> onChanged;
  final AppFontSize fontSize;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final typo = SettingsTypography.forFontSize(fontSize);
    final ink = AdaptiveInk.of(context);
    return Container(
      decoration: BoxDecoration(
        color: ink.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ink.primary.withValues(alpha: 0.14)),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 48.h),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: typo.tileIcon, color: ink.primary),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: ink.primary,
                        fontSize: typo.tileTitle,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    valueLabel,
                    style: TextStyle(
                      color: ink.secondary,
                      fontSize: typo.tileSubtitle,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3.h,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7.r),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 14.r),
                  activeTrackColor: ink.primary,
                  inactiveTrackColor: ink.primary.withValues(alpha: 0.22),
                  thumbColor: ink.primary,
                  overlayColor: ink.primary.withValues(alpha: 0.12),
                ),
                child: Slider(
                  value: value.clamp(min, max),
                  min: min,
                  max: max,
                  divisions: divisions,
                  label: valueLabel,
                  onChanged: onChanged,
                ),
              ),
              if (note != null) ...[
                SizedBox(height: 2.h),
                Text(
                  note!,
                  style: TextStyle(
                    color: ink.secondary,
                    fontSize: typo.note,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoNote extends StatelessWidget {
  const _InfoNote({required this.text, required this.fontSize});
  final String text;
  final AppFontSize fontSize;

  @override
  Widget build(BuildContext context) {
    final typo = SettingsTypography.forFontSize(fontSize);
    final ink = AdaptiveInk.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ink.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: ink.primary.withValues(alpha: 0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: typo.noteIcon, color: ink.secondary),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: ink.secondary,
                fontSize: typo.note,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagnosticsSection extends StatefulWidget {
  const _DiagnosticsSection({
    required this.settings,
    required this.onUpdateSettings,
    required this.onShowDetail,
  });

  final AppSettings settings;
  final ValueChanged<AppSettings> onUpdateSettings;
  final DetailCallback onShowDetail;

  @override
  State<_DiagnosticsSection> createState() => _DiagnosticsSectionState();
}

class _DiagnosticsSectionState extends State<_DiagnosticsSection> {
  bool _exporting = false;

  Future<void> _export() async {
    if (_exporting) return;
    setState(() => _exporting = true);
    widget.onShowDetail(
      title: 'Esportazione log',
      description: 'Esportazione del log in corso… Inserisci una chiavetta USB se disponibile.',
      icon: Icons.usb_outlined,
    );
    final result = await AppLogger.instance.exportToUsb();
    if (!mounted) return;
    setState(() => _exporting = false);
    widget.onShowDetail(
      title: 'Esportazione log',
      description: result,
      icon: result.startsWith('Log esportato')
          ? Icons.check_circle_outline
          : Icons.usb_outlined,
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(result),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final settings = widget.settings;
    final logPath = AppLogger.instance.logFilePath ?? '—';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ToggleTile(
          icon: Icons.bug_report_outlined,
          title: 'Abilita raccolta log',
          subtitle: 'Registra errori ed eventi dell’app per la diagnostica',
          value: settings.loggingEnabled,
          fontSize: settings.fontSize,
          onChanged: (v) {
            widget.onUpdateSettings(settings.copyWith(loggingEnabled: v));
            widget.onShowDetail(
              title: 'Raccolta log',
              description: v
                  ? 'La raccolta log è attiva. Riproduci il problema, poi esporta il log su chiavetta USB.\n\nFile: $logPath'
                  : 'La raccolta log è disattivata. I nuovi eventi non verranno registrati.\n\nFile: $logPath',
              icon: Icons.bug_report_outlined,
            );
          },
        ),
        SizedBox(height: 10.h),
        _ActionTile(
          icon: Icons.usb_outlined,
          title: _exporting
              ? 'Esportazione in corso…'
              : 'Esporta log su chiavetta USB',
          subtitle: 'Copia il file di log su una memoria USB collegata',
          fontSize: settings.fontSize,
          trailing: _exporting
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AdaptiveInk.of(context).secondary,
                  ),
                )
              : _ChevronIcon(fontSize: settings.fontSize),
          onTap: _export,
        ),
        SizedBox(height: 12.h),
        _InfoNote(
          fontSize: settings.fontSize,
          text: '1) Inserisci una chiavetta USB.\n2) Attiva la raccolta log e riproduci il problema.\n3) Tocca “Esporta log su chiavetta USB”. Il file verrà salvato nella cartella my_mg4_dash_logs sulla chiavetta (se accessibile).',
        ),
      ],
    );
  }
}
