import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

import '../features/demo/presentation/demo_view.dart';
import '../features/energy/presentation/energy_view.dart';
import '../features/home/presentation/home_view.dart';
import '../features/settings/presentation/settings_view.dart';
import 'providers/navigation_provider.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  static final _items = [
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(selectedTabIndexProvider);
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
            items: _items,
            selectedIndex: index,
            onChanged: (i) =>
              ref.read(selectedTabIndexProvider.notifier).setIndex(i),
          ),
          body: switch (index) {
            0 => const HomeView(),
            1 => const EnergyView(),
            2 => const DemoView(2),
            3 => const DemoView(3),
            4 => const DemoView(4),
            5 => const SettingsView(),
            _ => const DemoView(0),
          },
        );
      },
    );
  }
}
