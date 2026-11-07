import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_glass_demo/demo_view.dart';
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
      theme: ThemeData.dark(useMaterial3: true),
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
  bool fabOpened = false;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(960, 360),
      minTextAdapt: true,
      builder: (context, child) {
        return LiquidGlassScaffold(
          bottomNavigationBar: LiquidGlassTabBar(
            itemStyle: LiquidGlassTabItemStyle(
              iconSize: 25.w,
              axis: Axis.horizontal,
              labelFontSize: 14.sp,
            ),
            height: 40.h,
            width: 900.w,
            items: items,
            selectedIndex: index,
            onChanged: (i) => setState(() => index = i),
          ),
          floatingActionButton: LiquidGlassMorph(
            alignment: Alignment.bottomRight,
            motion: LiquidGlassMorphMotion.fluid,
            child: fabOpened
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LiquidGlassFab(
                        size: 40.w,
                        iconSize: 25.w,
                        onPressed: () {},
                        child: Icon(Icons.camera_alt_rounded, size: 20.w),
                      ),
                      const SizedBox(height: 12),
                      LiquidGlassFab(
                        size: 40.w,
                        iconSize: 25.w,
                        onPressed: () => setState(() => fabOpened = false),
                        child: const Icon(Icons.close),
                      ),
                    ],
                  )
                : LiquidGlassFab(
                    size: 40.w,
                    iconSize: 25.w,
                    onPressed: () => setState(() => fabOpened = true),
                    child: Icon(Icons.abc_sharp, size: 20.w),
                  ),
          ),
          body: switch (index) {
            0 => DemoView(0),
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
