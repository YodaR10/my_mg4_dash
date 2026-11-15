import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

import '../modules/ambient_module.dart';
import '../modules/android_auto_module.dart';
import '../modules/apps_module.dart';
import '../modules/climate_module.dart';
import '../modules/navigation_module.dart';
import '../modules/radio_module.dart';

/// The homepage grid: four columns by two rows.
///
/// Every slot is a plain [Widget] with a default module. To swap two elements
/// later, pass different widgets here — the layout, the glass surface and the
/// spacing stay unchanged:
///
/// ```dart
/// HomeDashboard(
///   navigation: const RadioModule(),
///   radio: const NavigationModule(),
/// )
/// ```
class HomeDashboard extends StatelessWidget {
  const HomeDashboard({
    super.key,
    this.navigation = const NavigationModule(),
    this.androidAuto = const AndroidAutoModule(),
    this.radio = const RadioModule(),
    this.climate = const ClimateModule(),
    this.ambient = const AmbientModule(),
    this.apps = const AppsModule(),
  });

  final Widget navigation;
  final Widget androidAuto;
  final Widget radio;
  final Widget climate;
  final Widget ambient;
  final Widget apps;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 56.h),
      // Batch non-overlapping tile lenses so they share one backdrop read.
      child: LiquidGlassBatch(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(child: navigation),
                  SizedBox(height: 10.h),
                  Expanded(child: androidAuto),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(child: radio),
            SizedBox(width: 10.w),
            Expanded(child: climate),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: ambient),
                  SizedBox(height: 10.h),
                  Expanded(child: apps),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
