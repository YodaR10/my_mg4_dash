import 'package:flutter/material.dart';

/// Brightness-aware foreground colors for content drawn over glass panels.
///
/// Dark theme keeps light ink, light theme switches to dark ink so text and
/// icons remain legible.
class AdaptiveInk {
  const AdaptiveInk._({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.faint,
    required this.border,
    required this.onActive,
  });

  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color faint;
  final Color border;

  /// Foreground used on strongly active/filled surfaces.
  final Color onActive;

  static AdaptiveInk of(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    if (dark) {
      return const AdaptiveInk._(
        primary: Colors.white,
        secondary: Color(0xB8FFFFFF),
        tertiary: Color(0x8FFFFFFF),
        faint: Color(0x29FFFFFF),
        border: Color(0x24FFFFFF),
        onActive: Color(0xFF101418),
      );
    }
    return const AdaptiveInk._(
      primary: Color(0xFF101418),
      secondary: Color(0xB8101418),
      tertiary: Color(0x8F101418),
      faint: Color(0x1F101418),
      border: Color(0x24101418),
      onActive: Colors.white,
    );
  }
}
