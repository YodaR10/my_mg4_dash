import 'package:flutter/material.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

import '../animated_background.dart';
import 'home_dashboard.dart';

/// Homepage shell.
///
/// The page owns its glass pipeline, so the modules inside [dashboard] can be
/// swapped without their lenses double-refracting through the scaffold chrome.
class HomeView extends StatelessWidget {
  const HomeView({super.key, this.dashboard = const HomeDashboard()});

  final Widget dashboard;

  @override
  Widget build(BuildContext context) {
    return LiquidGlassView(
      backgroundWidget: const AnimatedBackground(),
      child: SafeArea(bottom: false, child: dashboard),
    );
  }
}
