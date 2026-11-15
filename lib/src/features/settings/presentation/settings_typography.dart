import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../domain/app_settings.dart';

/// Compact typography for non-home panels (e.g. Settings).
///
/// Sizes scale with [AppSettings.fontSize]: large is the default, medium and
/// small reduce text to fit more information while staying legible on a ~9 cm
/// automotive display.
class SettingsTypography {
  const SettingsTypography._(this._scale);

  /// Scale factor relative to the "large" (default) size.
  final double _scale;
  double get scale => _scale;

  static const SettingsTypography large = SettingsTypography._(1.0);
  static const SettingsTypography medium = SettingsTypography._(0.9);
  static const SettingsTypography small = SettingsTypography._(0.8);

  static SettingsTypography forFontSize(AppFontSize size) => switch (size) {
        AppFontSize.large => large,
        AppFontSize.medium => medium,
        AppFontSize.small => small,
      };

  // Text
  double get sectionTitle => 17.sp * _scale;
  double get sectionSubtitle => 12.sp * _scale;

  double get navHeader => 15.sp * _scale;
  double get navItem => 12.sp * _scale;

  double get tileTitle => 14.sp * _scale;
  double get tileSubtitle => 11.sp * _scale;

  double get detailLabel => 12.sp * _scale;
  double get detailTitle => 15.sp * _scale;
  double get detailBody => 12.sp * _scale;

  double get note => 11.sp * _scale;

  // Icons / controls (scale with font size)
  double get tileIcon => 20.w * _scale;
  double get radioIcon => 20.w * _scale;
  double get chevronIcon => 20.w * _scale;
  double get navIcon => 18.w * _scale;
  double get noteIcon => 16.w * _scale;
  double get detailHeroIcon => 56.w * _scale;

  double get switchWidth => 48.w * _scale;
  double get switchHeight => 28.h * _scale;
  double get switchPadding => 3.w * _scale;
  double get switchThumb => 20.w * _scale;
}
