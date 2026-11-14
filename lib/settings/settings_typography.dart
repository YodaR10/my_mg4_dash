import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Compact typography for non-home panels (e.g. Settings).
///
/// Slightly smaller than the homepage to fit more information, while staying
/// legible on a ~9 cm automotive display.
class SettingsTypography {
  const SettingsTypography._();

  static double get sectionTitle => 21.sp;
  static double get sectionSubtitle => 13.sp;

  static double get navHeader => 18.sp;
  static double get navItem => 13.sp;

  static double get tileTitle => 15.sp;
  static double get tileSubtitle => 12.sp;

  static double get detailLabel => 13.sp;
  static double get detailTitle => 18.sp;
  static double get detailBody => 13.sp;

  static double get note => 12.sp;
}
