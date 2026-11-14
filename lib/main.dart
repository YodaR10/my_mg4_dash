import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_glass_demo/demo_view.dart';
import 'package:liquid_glass_demo/home/home_view.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

import 'energy_view.dart';

// =============================================================
// Liquid Glass Easy — headline example: lens over image, blended.
//
// A photo fills the screen and a few draggable glass shapes float on top, fused
// by a LiquidGlassBlender: drag any two together and they merge into one liquid
// surface (metaball), then pull apart as you separate them.
//
// Wrapped in LiquidGlassView so it refracts on BOTH backends — the live backdrop
// on Impeller, the captured backgroundWidget on Skia.
//
// -------------------------------------------------------------------------
// Want the full set of demos shown in the package README (control center,
// slider, toggle, nav bar, corner styles)? They live next to this file in
// example/lib/. Run the gallery with:
//
//     flutter run -t lib/gallery.dart
// -------------------------------------------------------------------------

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Compile every glass program before the first frame: the lens's two and
  // the blender's merged-surface entry. Without this the blender below paints
  // nothing until its shader arrives — not even a lone lens's frosted fallback.
  await LiquidGlassShaders.ensureLoaded();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      home: const LensImagePage(),
    );
  }
}

/// A page showcasing the blend over a photographic background.
class LensImagePage extends StatefulWidget {
  const LensImagePage({super.key});

  @override
  State<LensImagePage> createState() => _LensImagePageState();
}

class _LensImagePageState extends State<LensImagePage> {
  final items = [
    LiquidGlassTabBarItem(label: 'Home', icon: Icons.dashboard_outlined),
    LiquidGlassTabBarItem(
      label: 'Energy',
      icon: Icons.battery_charging_full_rounded,
    ),
    LiquidGlassTabBarItem(label: 'Map', icon: Icons.map_outlined),
    LiquidGlassTabBarItem(label: 'Climate', icon: Icons.thermostat_outlined),
    LiquidGlassTabBarItem(label: 'Apps', icon: Icons.apps_outlined),
    LiquidGlassTabBarItem(label: 'Settings', icon: Icons.settings_outlined),
  ];

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(960, 360),
      minTextAdapt: true,
      builder: (context, child) {
        // The bar capsule already follows the theme brightness; keep its
        // icons/labels monochrome and readable on both the light and dark
        // capsule instead of the default system blue.
        final Color tabInk = Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : const Color(0xFF14161A);
        return LiquidGlassScaffold(
          bottomNavigationBar: LiquidGlassTabBar(
            itemStyle: LiquidGlassTabItemStyle(
              iconSize: 22.w,
              axis: Axis.horizontal,
              labelFontSize: 13.sp,
              selectedColor: tabInk,
              unselectedColor: tabInk.withValues(alpha: 0.62),
            ),
            pillStyle: const LiquidGlassTabPillStyle(
              mode: LiquidGlassPillMode.none,
            ),
            height: 40.h,
            width: 840.w,
            margin: EdgeInsets.only(bottom: 12.h),
            items: items,
            selectedIndex: index,
            onChanged: (i) => setState(() => index = i),
          ),
          body: switch (index) {
            0 => const HomeView(),
            1 => const EnergyView(),
            2 => DemoView(2),
            3 => DemoView(3),
            4 => DemoView(4),
            5 => DemoView(5),
            _ => DemoView(0),
          },
        );
      },
    );
  }
}
