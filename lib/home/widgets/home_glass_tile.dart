import 'package:flutter/material.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

import 'home_theme.dart';

/// Shared glass surface for every homepage module.
///
/// A module only owns its content: the surface, its shape, its tint and the
/// adaptive verdict live here, so the module can be moved to another slot
/// without changing how it looks.
class HomeGlassTile extends StatelessWidget {
  const HomeGlassTile({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  static const LiquidGlassStyle _style = LiquidGlassStyle(
    shape: LiquidGlassShape.continuousRoundedRectangle(cornerRadius: 22),
    color: Color(0x14FFFFFF),
    saturation: 1,
    refractionIndex: 1.04,
    refractionWidth: 10,
    blur: 2,
    adaptivity: HomeTokens.adaptivity,
  );

  @override
  Widget build(BuildContext context) {
    return LiquidGlassLens(
      style: _style,
      child: Builder(
        builder: (context) {
          // The lens wraps its child in an adaptive DefaultTextStyle; capture
          // the current content color so descendants can derive tones from it.
          final Color ink =
              DefaultTextStyle.of(context).style.color ??
              (Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFFF7F8FA)
                  : const Color(0xFF14161A));
          return HomeInk(
            color: ink,
            child: Padding(padding: padding, child: child),
          );
        },
      ),
    );
  }
}
