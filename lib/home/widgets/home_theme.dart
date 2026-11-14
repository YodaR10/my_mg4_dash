import 'package:flutter/material.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

/// Monochrome design tokens for the homepage.
///
/// The page is intentionally colorless: hierarchy comes from opacity,
/// surface fill and type weight, never from hue. Everything resolves from
/// [HomeInk], which follows the glass adaptivity verdict, so the same widgets
/// stay legible on a dark or a light backdrop.
abstract final class HomeTokens {
  /// Minimum interactive target. At the 960×360 design size one unit equals
  /// one logical pixel, so this is a true 48 dp target.
  static const double minTarget = 48;

  /// Minimum gap between two adjacent targets.
  static const double gap = 8;

  /// Shared adaptivity for every homepage tile.
  ///
  /// Neutral glass and neutral content; the hysteresis band (0.55–0.65)
  /// keeps the verdict from strobing over the mid-grey waves.
  static const LiquidGlassAdaptivity adaptivity = LiquidGlassAdaptivity(
    glassColorOnDark: Color(0x24000000),
    contentColorOnDark: Color(0xFFF7F8FA),
    glassColorOnLight: Color(0x44FFFFFF),
    contentColorOnLight: Color(0xFF14161A),
    brightnessFallback: LiquidGlassBrightnessFallback.platform,
    darkBelow: 0.55,
    lightAbove: 0.65,
  );
}

/// The monochrome ink scale of a homepage tile.
///
/// `LiquidGlassLens` installs an adaptive `DefaultTextStyle`/`IconTheme`; a
/// [HomeGlassTile] reads the active content color once and exposes it here so
/// nested widgets can derive secondary tones without hardcoding white/black
/// (which would opt out of adaptivity).
@immutable
class HomeInk extends InheritedWidget {
  const HomeInk({super.key, required this.color, required super.child});

  /// Primary content color (text/icons) for the current verdict.
  final Color color;

  static HomeInk of(BuildContext context) {
    final HomeInk? ink = context.dependOnInheritedWidgetOfExactType<HomeInk>();
    assert(ink != null, 'HomeInk.of() called outside a HomeGlassTile');
    return ink!;
  }

  /// Primary content.
  Color get primary => color;

  /// Supporting labels and metadata.
  Color get secondary => color.withValues(alpha: 0.72);

  /// Hints, units, chevrons.
  Color get tertiary => color.withValues(alpha: 0.52);

  /// Subtle control surface.
  Color get surface => color.withValues(alpha: 0.07);

  /// Raised/selected control surface.
  Color get surfaceActive => color.withValues(alpha: 0.16);

  /// Hairline border.
  Color get outline => color.withValues(alpha: 0.2);

  /// Emphasised border (selected state).
  Color get outlineActive => color.withValues(alpha: 0.6);

  /// Solid selected fill.
  Color get selected => color.withValues(alpha: 0.92);

  /// Content color that contrasts [selected].
  Color get onSelected => color.computeLuminance() > 0.5
      ? const Color(0xFF15171A)
      : const Color(0xFFF7F8FA);

  /// Arbitrary opacity step on the ink color.
  Color alpha(double value) => color.withValues(alpha: value);

  @override
  bool updateShouldNotify(HomeInk oldWidget) => color != oldWidget.color;
}
