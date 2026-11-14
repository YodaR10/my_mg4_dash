import 'package:flutter/material.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

/// Shared glass surface for every homepage module.
///
/// A module only owns its content: the surface, its shape and its tint live
/// here, so the module can be moved to another slot without changing how it
/// looks.
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
    saturation: 1.05,
    refractionIndex: 1.04,
    refractionWidth: 10,
    blur: 2,
  );

  @override
  Widget build(BuildContext context) {
    return LiquidGlassLens(
      style: _style,
      child: Padding(padding: padding, child: child),
    );
  }
}
