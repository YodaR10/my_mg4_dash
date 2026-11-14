import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_settings.dart';
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
    final typo = SettingsTypography.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          section.label,
          style: TextStyle(
            color: Colors.white,
            fontSize: typo.sectionTitle,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          _subtitleFor(section),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.72),
            fontSize: typo.sectionSubtitle,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 14.h),
        Expanded(
          child: SingleChildScrollView(
            child: _buildBody(context),
          ),
        ),
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
        return _SystemSection(
          onNotImplemented: onNotImplemented,
          onShowDetail: onShowDetail,
        );
      case SettingsSection.audio:
        return _MockListSection(
          items: const [
            _MockItem('Volume multimediale', Icons.volume_up_outlined,
                'Regola il volume principale del sistema.'),
            _MockItem('Suoni di sistema', Icons.notifications_active_outlined,
                'Attiva o disattiva i feedback sonori.'),
            _MockItem('Bilanciamento audio', Icons.equalizer_outlined,
                'Configura bassi, medi e alti.'),
            _MockItem('Uscita audio', Icons.speaker_outlined,
                'Seleziona il dispositivo di riproduzione.'),
          ],
          onNotImplemented: onNotImplemented,
          onShowDetail: onShowDetail,
        );
      case SettingsSection.connectivity:
        return _MockListSection(
          items: const [
            _MockItem('Wi‑Fi', Icons.wifi_outlined,
                'Gestisci reti wireless disponibili.'),
            _MockItem('Bluetooth', Icons.bluetooth_outlined,
                'Associa e gestisci dispositivi Bluetooth.'),
            _MockItem('Android Auto', Icons.directions_car_outlined,
                'Configura la connessione con il telefono.'),
            _MockItem('Hotspot', Icons.wifi_tethering_outlined,
                'Condividi la connessione del veicolo.'),
          ],
          onNotImplemented: onNotImplemented,
          onShowDetail: onShowDetail,
        );
      case SettingsSection.privacy:
        return _MockListSection(
          items: const [
            _MockItem('Permessi app', Icons.app_settings_alt_outlined,
                'Controlla i permessi concessi alle app.'),
            _MockItem('Posizione', Icons.location_on_outlined,
                'Gestisci accesso e precisione della posizione.'),
            _MockItem('Dati diagnostici', Icons.analytics_outlined,
                'Scegli quali dati condividere.'),
            _MockItem('Ripristino impostazioni', Icons.restart_alt_outlined,
                'Reimposta le preferenze ai valori iniziali.'),
          ],
          onNotImplemented: onNotImplemented,
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
    final typo = SettingsTypography.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _OptionTile(
          icon: Icons.brightness_auto_outlined,
          title: 'Sistema',
          subtitle: 'Segue l’impostazione del dispositivo',
          selected: settings.themePreference == AppThemePreference.system,
          onTap: () {
            onUpdateSettings(
              settings.copyWith(themePreference: AppThemePreference.system),
            );
            onShowDetail(
              title: 'Tema: Sistema',
              description:
                  'L’app usa automaticamente il tema chiaro o scuro in base alle impostazioni di sistema.',
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
          onTap: () {
            onUpdateSettings(
              settings.copyWith(themePreference: AppThemePreference.light),
            );
            onShowDetail(
              title: 'Tema: Chiaro',
              description:
                  'L’app utilizza sempre il tema chiaro, indipendentemente dal sistema.',
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
          onTap: () {
            onUpdateSettings(
              settings.copyWith(themePreference: AppThemePreference.dark),
            );
            onShowDetail(
              title: 'Tema: Scuro',
              description:
                  'L’app utilizza sempre il tema scuro, indipendentemente dal sistema.',
              icon: Icons.dark_mode_outlined,
            );
          },
        ),
        SizedBox(height: 16.h),
        Text(
          'Dimensione caratteri',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.72),
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
          onTap: () {
            onUpdateSettings(settings.copyWith(fontSize: AppFontSize.large));
            onShowDetail(
              title: 'Caratteri: Grande',
              description:
                  'Usa la dimensione dei caratteri predefinita per i pannelli diversi da Home.',
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
          onTap: () {
            onUpdateSettings(settings.copyWith(fontSize: AppFontSize.medium));
            onShowDetail(
              title: 'Caratteri: Medio',
              description:
                  'Riduce leggermente i caratteri nei pannelli diversi da Home per mostrare più informazioni.',
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
          onTap: () {
            onUpdateSettings(settings.copyWith(fontSize: AppFontSize.small));
            onShowDetail(
              title: 'Caratteri: Piccolo',
              description:
                  'Riduce ulteriormente i caratteri nei pannelli diversi da Home per massimizzare le informazioni a schermo.',
              icon: Icons.format_size_outlined,
            );
          },
        ),
        SizedBox(height: 16.h),
        Text(
          'Pannelli',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.72),
            fontSize: typo.detailLabel,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        _SliderTile(
          icon: Icons.blur_on_outlined,
          title: 'Sfocatura',
          value: settings.panelBlur,
          min: 0,
          max: 8,
          divisions: 16,
          valueLabel: settings.panelBlur.toStringAsFixed(1),
          onChanged: (v) {
            onUpdateSettings(settings.copyWith(panelBlur: v));
            onShowDetail(
              title: 'Sfocatura pannelli',
              description:
                  'Regola la sfocatura del vetro dei pannelli. In tema scuro e chiaro la tinta segue l’aspetto selezionato (come la barra inferiore).',
              icon: Icons.blur_on_outlined,
            );
          },
        ),
        SizedBox(height: 10.h),
        _SliderTile(
          icon: Icons.opacity_outlined,
          title: 'Trasparenza tinta',
          value: settings.panelTintAlpha,
          min: 0.0,
          max: 0.25,
          divisions: 25,
          valueLabel: '${(settings.panelTintAlpha * 100).round()}%',
          onChanged: (v) {
            onUpdateSettings(settings.copyWith(panelTintAlpha: v));
            onShowDetail(
              title: 'Trasparenza pannelli',
              description:
                  'Regola l’intensità della tinta dei pannelli. Valori più bassi rendono il vetro più trasparente.',
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
        const _InfoNote(
          text:
              'La barra di navigazione dell’app in basso resta sempre visibile. Puoi nascondere una o entrambe le barre di sistema.',
        ),
      ],
    );
  }
}

class _SystemSection extends StatelessWidget {
  const _SystemSection({
    required this.onNotImplemented,
    required this.onShowDetail,
  });

  final NotImplementedCallback onNotImplemented;
  final DetailCallback onShowDetail;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ActionTile(
          icon: Icons.system_update_alt_outlined,
          title: 'Verifica aggiornamenti',
          subtitle: 'Controlla se è disponibile una nuova versione',
          trailing: _ChevronIcon(),
          onTap: () {
            onShowDetail(
              title: 'Verifica aggiornamenti',
              description:
                  'Ultimo controllo: —\nNessun aggiornamento verificato in questa demo.',
              icon: Icons.system_update_alt_outlined,
            );
            onNotImplemented('Verifica aggiornamenti');
          },
        ),
        SizedBox(height: 10.h),
        _ActionTile(
          icon: Icons.info_outline,
          title: 'Versione software',
          subtitle: 'Informazioni sulla versione corrente',
          trailing: _ChevronIcon(),
          onTap: () {
            onShowDetail(
              title: 'Versione software',
              description: 'Dettagli versione non disponibili in questa demo.',
              icon: Icons.info_outline,
            );
            onNotImplemented('Versione software');
          },
        ),
        SizedBox(height: 10.h),
        _ActionTile(
          icon: Icons.description_outlined,
          title: 'Note di rilascio',
          subtitle: 'Novità e modifiche recenti',
          trailing: _ChevronIcon(),
          onTap: () {
            onShowDetail(
              title: 'Note di rilascio',
              description:
                  'Le note di rilascio non sono disponibili in questa demo.',
              icon: Icons.description_outlined,
            );
            onNotImplemented('Note di rilascio');
          },
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
  });

  final List<_MockItem> items;
  final NotImplementedCallback onNotImplemented;
  final DetailCallback onShowDetail;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          _ActionTile(
            icon: items[i].icon,
            title: items[i].title,
            subtitle: items[i].description,
            trailing: _ChevronIcon(),
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
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final typo = SettingsTypography.of(context);
    final Color fg = selected ? const Color(0xFF101418) : Colors.white;
    final Color sub = selected
        ? const Color(0xFF101418).withValues(alpha: 0.75)
        : Colors.white.withValues(alpha: 0.72);
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
                Text(title,
                    style: TextStyle(
                        color: fg,
                        fontSize: typo.tileTitle,
                        fontWeight: FontWeight.w700)),
                SizedBox(height: 2.h),
                Text(subtitle,
                    style: TextStyle(
                        color: sub,
                        fontSize: typo.tileSubtitle,
                        fontWeight: FontWeight.w500)),
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
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final typo = SettingsTypography.of(context);
    return _BaseTile(
      selected: value,
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Icon(icon, size: typo.tileIcon, color: Colors.white),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: typo.tileTitle,
                        fontWeight: FontWeight.w700)),
                SizedBox(height: 2.h),
                Text(subtitle,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.72),
                        fontSize: typo.tileSubtitle,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          _SimpleSwitch(value: value, onChanged: onChanged),
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
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final typo = SettingsTypography.of(context);
    return _BaseTile(
      selected: false,
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: typo.tileIcon, color: Colors.white),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: typo.tileTitle,
                        fontWeight: FontWeight.w700)),
                SizedBox(height: 2.h),
                Text(subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.72),
                        fontSize: typo.tileSubtitle,
                        fontWeight: FontWeight.w500)),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          decoration: BoxDecoration(
            color: selected
                ? Colors.white.withValues(alpha: 0.20)
                : Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Colors.white
                  .withValues(alpha: selected ? 0.34 : 0.14),
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
  const _SimpleSwitch({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final typo = SettingsTypography.of(context);
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: typo.switchWidth,
        height: typo.switchHeight,
        padding: EdgeInsets.all(typo.switchPadding),
        decoration: BoxDecoration(
          color: value ? Colors.white : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: Colors.white.withValues(alpha: value ? 0 : 0.20),
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: typo.switchThumb,
            height: typo.switchThumb,
            decoration: BoxDecoration(
              color: value ? const Color(0xFF101418) : Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChevronIcon extends StatelessWidget {
  const _ChevronIcon();

  @override
  Widget build(BuildContext context) {
    final typo = SettingsTypography.of(context);
    return Icon(
      Icons.chevron_right,
      color: Colors.white.withValues(alpha: 0.55),
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
  });

  final IconData icon;
  final String title;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String valueLabel;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final typo = SettingsTypography.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
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
                  Icon(icon, size: typo.tileIcon, color: Colors.white),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: typo.tileTitle,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    valueLabel,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.78),
                      fontSize: typo.tileSubtitle,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3.h,
                  thumbShape:
                      RoundSliderThumbShape(enabledThumbRadius: 7.r),
                  overlayShape:
                      RoundSliderOverlayShape(overlayRadius: 14.r),
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white.withValues(alpha: 0.22),
                  thumbColor: Colors.white,
                  overlayColor: Colors.white.withValues(alpha: 0.12),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoNote extends StatelessWidget {
  const _InfoNote({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final typo = SettingsTypography.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline,
              size: typo.noteIcon, color: Colors.white.withValues(alpha: 0.8)),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.78),
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
