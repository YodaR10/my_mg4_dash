import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../home/widgets/home_theme.dart';
import '../app_settings.dart';
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
    final HomeInk ink = HomeInk.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          section.label,
          style: TextStyle(
            color: ink.primary,
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          _subtitleFor(section),
          style: TextStyle(
            color: ink.secondary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 14.h),
        Expanded(
          child: SingleChildScrollView(
            child: _buildBody(context, ink),
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
        SettingsSection.privacy =>
          'Privacy, permessi e sicurezza (mock).',
      };

  Widget _buildBody(BuildContext context, HomeInk ink) {
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
    return Column(
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
          subtitle: 'Nasconde ora/segnale per coprire la barra di sistema in alto',
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
          subtitle: 'Nasconde i pulsanti di sistema inferiori per coprire la barra',
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
        _InfoNote(
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
    final HomeInk ink = HomeInk.of(context);
    return Column(
      children: [
        _ActionTile(
          icon: Icons.system_update_alt_outlined,
          title: 'Verifica aggiornamenti',
          subtitle: 'Controlla se è disponibile una nuova versione',
          trailing: Icon(Icons.chevron_right, color: ink.tertiary, size: 22.w),
          onTap: () {
            onShowDetail(
              title: 'Verifica aggiornamenti',
              description: 'Ultimo controllo: —\nNessun aggiornamento verificato in questa demo.',
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
          trailing: Icon(Icons.chevron_right, color: ink.tertiary, size: 22.w),
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
          trailing: Icon(Icons.chevron_right, color: ink.tertiary, size: 22.w),
          onTap: () {
            onShowDetail(
              title: 'Note di rilascio',
              description: 'Le note di rilascio non sono disponibili in questa demo.',
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
    final HomeInk ink = HomeInk.of(context);
    return Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          _ActionTile(
            icon: items[i].icon,
            title: items[i].title,
            subtitle: items[i].description,
            trailing: Icon(Icons.chevron_right, color: ink.tertiary, size: 22.w),
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
    final HomeInk ink = HomeInk.of(context);
    final Color fg = selected ? ink.onSelected : ink.primary;
    final Color sub = selected ? ink.onSelected.withValues(alpha: 0.8) : ink.secondary;
    return _BaseTile(
      selected: selected,
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 22.w, color: fg),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: fg, fontSize: 16.sp, fontWeight: FontWeight.w700)),
                SizedBox(height: 2.h),
                Text(subtitle,
                    style: TextStyle(
                        color: sub, fontSize: 13.sp, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: fg,
            size: 22.w,
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
    final HomeInk ink = HomeInk.of(context);
    return _BaseTile(
      selected: value,
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Icon(icon, size: 22.w, color: ink.primary),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: ink.primary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700)),
                SizedBox(height: 2.h),
                Text(subtitle,
                    style: TextStyle(
                        color: ink.secondary,
                        fontSize: 13.sp,
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
    final HomeInk ink = HomeInk.of(context);
    return _BaseTile(
      selected: false,
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 22.w, color: ink.primary),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: ink.primary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700)),
                SizedBox(height: 2.h),
                Text(subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: ink.secondary,
                        fontSize: 13.sp,
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
    final HomeInk ink = HomeInk.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          decoration: BoxDecoration(
            color: selected ? ink.surfaceActive : ink.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: selected ? ink.outlineActive : ink.outline,
            ),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: HomeTokens.minTarget),
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
    final HomeInk ink = HomeInk.of(context);
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 52.w,
        height: 30.h,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: value ? ink.selected : ink.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: value ? Colors.transparent : ink.outline),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22.w,
            height: 22.w,
            decoration: BoxDecoration(
              color: value ? ink.onSelected : ink.primary,
              shape: BoxShape.circle,
            ),
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
    final HomeInk ink = HomeInk.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ink.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: ink.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18.w, color: ink.secondary),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: ink.secondary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
