import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

import '../animated_background.dart';
import '../home/widgets/home_glass_tile.dart';
import 'app_settings.dart';
import 'widgets/settings_content.dart';
import 'widgets/settings_detail_panel.dart';
import 'widgets/settings_nav.dart';

enum SettingsSection {
  appearance('Aspetto', Icons.palette_outlined),
  screen('Schermo e barre', Icons.fullscreen_outlined),
  system('Sistema', Icons.system_update_outlined),
  audio('Audio', Icons.volume_up_outlined),
  connectivity('Connettività', Icons.wifi_outlined),
  privacy('Privacy e sicurezza', Icons.shield_outlined);

  const SettingsSection(this.label, this.icon);
  final String label;
  final IconData icon;
}

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  SettingsSection _selected = SettingsSection.appearance;
  String? _detailTitle;
  String? _detailDescription;
  IconData? _detailIcon;

  void _selectSection(SettingsSection section) {
    setState(() {
      _selected = section;
      _detailTitle = null;
      _detailDescription = null;
      _detailIcon = null;
    });
  }

  void _showDetail({
    required String title,
    required String description,
    required IconData icon,
  }) {
    setState(() {
      _detailTitle = title;
      _detailDescription = description;
      _detailIcon = icon;
    });
  }

  void _showNotImplemented(BuildContext context, {String? feature}) {
    _showDetail(
      title: feature ?? 'Funzione non disponibile',
      description: 'Questa funzione non è ancora disponibile in questa demo.',
      icon: Icons.construction_outlined,
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('non implementato ancora'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final AppSettingsScope scope = AppSettingsScope.of(context);
    return LiquidGlassView(
      backgroundWidget: const AnimatedBackground(monochrome: true),
      adaptiveSampling: const LiquidGlassAdaptiveSampling(),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 60.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: HomeGlassTile(
                  padding: EdgeInsets.all(10.w),
                  child: Builder(
                    builder: (context) => SettingsNav(
                      selected: _selected,
                      onSelect: _selectSection,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                flex: 2,
                child: HomeGlassTile(
                  padding: EdgeInsets.all(14.w),
                  child: Builder(
                    builder: (context) => SettingsContent(
                      section: _selected,
                      settings: scope.settings,
                      onUpdateSettings: scope.update,
                      onNotImplemented: (feature) =>
                          _showNotImplemented(context, feature: feature),
                      onShowDetail: _showDetail,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                flex: 1,
                child: HomeGlassTile(
                  padding: EdgeInsets.all(14.w),
                  child: Builder(
                    builder: (context) => SettingsDetailPanel(
                      section: _selected,
                      settings: scope.settings,
                      title: _detailTitle,
                      description: _detailDescription,
                      icon: _detailIcon,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
