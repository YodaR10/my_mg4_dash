import 'package:flutter/material.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

import '../../settings/app_settings.dart';

/// Shared glass surface for panels.
///
/// Follows the app theme (dark/light) like the bottom bar and respects
/// user-configured blur and tint opacity.
class HomeGlassTile extends StatelessWidget {
  const HomeGlassTile({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context).settings;
    final brightness = Theme.of(context).brightness;
    final Color tintBase =
        brightness == Brightness.dark ? Colors.black : Colors.white;
    final style = LiquidGlassStyle(
      shape: const LiquidGlassShape.continuousRoundedRectangle(cornerRadius: 22),
      color: tintBase.withValues(alpha: settings.panelTintAlpha.clamp(0.0, 0.4)),
      saturation: 1.05,
      refractionIndex: 1.04,
      refractionWidth: 10,
      blur: settings.panelBlur.clamp(0.0, 12.0),
    );
    return LiquidGlassLens(
      style: style,
      child: Padding(padding: padding, child: child),
    );
  }
}
