import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

import '../../../app/providers/app_settings_provider.dart';
import '../../../shared/widgets/animated_background.dart';
import '../../../shared/widgets/control_card.dart';
import '../../settings/domain/app_settings.dart';

class EnergyView extends StatefulWidget {
  const EnergyView({super.key});

  @override
  State<EnergyView> createState() => _EnergyViewState();
}

class _EnergyViewState extends State<EnergyView> {
  // Top-left of each draggable shape — placed close so they start fused.
  Offset _card = const Offset(40, 170);
  Offset _charge = const Offset(40, 300);
  Offset _circle = const Offset(60, 270);
  Offset _squircle = const Offset(150, 320);

  // The merged material: clear glass (NO blur), slight tint + saturation, an
  // optical rim and a gentle optical refraction.
  static const _groupStyle = LiquidGlassStyle(
    shape: LiquidGlassShape.continuousRoundedRectangle(cornerRadius: 36),
    color: Color(0x14FFFFFF),
    saturation: 1.05,
    blur: 3,
  );

  double volume = 0.5; // Valore iniziale del volume (da 0.0 a 1.0)

  @override
  Widget build(BuildContext context) {
    return LiquidGlassView(
      // Tuned for lower-end hardware: cheaper capture and fewer refreshes.
      pixelRatio: 0.6,
      refreshRate: LiquidGlassRefreshRate.low,
      backgroundWidget: const AnimatedBackground(),
      child: Stack(
        children: [
          Positioned.fill(
            child: LiquidGlassBlender(
              smoothness: 58,
              style: _groupStyle,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _draggable(
                    pos: _card,
                    size: Size(220.w, 110.h),
                    shape: const LiquidGlassShape.continuousRoundedRectangle(
                      cornerRadius: 32,
                    ),
                    onMove: (d) => setState(() => _card += d),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 22.w,
                        vertical: 22.h,
                      ),
                      child: Column(
                        children: [
                          LiquidGlassControlCard(
                            level: 0.40,
                            icon: Icons.battery_charging_full_rounded,
                            iconColor: Colors.greenAccent,
                            orientation: ControlOrientation.horizontal,
                            height: 40.h,
                            width: 200.w,
                          ),
                          const _ChargingLabel(),
                        ],
                      ),
                    ),
                  ),
                  _draggable(
                    pos: _charge,
                    size: Size(220.w, 110.h),
                    shape: const LiquidGlassShape.continuousRoundedRectangle(
                      cornerRadius: 32,
                    ),
                    onMove: (d) => setState(() => _charge += d),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 22.w,
                        vertical: 22.h,
                      ),
                      child: Column(
                        children: [
                          LiquidGlassSlider(
                            value: volume,
                            onChanged: (v) => setState(() => volume = v),
                            activeColor: Colors.white,
                            width: 280.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                  _draggable(
                    pos: _circle,
                    size: Size(120.w, 120.h),
                    shape: const LiquidGlassShape.roundedRectangle(
                      cornerRadius: 60,
                    ),
                    onMove: (d) => setState(() => _circle += d),
                    child: Icon(
                      Icons.favorite_rounded,
                      color: Colors.white,
                      size: 38.w,
                    ),
                  ),
                  _draggable(
                    pos: _squircle,
                    size: Size(140.w, 140.h),
                    shape: const LiquidGlassShape.squircle(cornerRadius: 40),
                    onMove: (d) => setState(() => _squircle += d),
                    child: Icon(
                      Icons.bolt_rounded,
                      color: Colors.white,
                      size: 40.w,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _draggable({
    required Offset pos,
    required Size size,
    required LiquidGlassShape shape,
    required ValueChanged<Offset> onMove,
    required Widget child,
  }) {
    return Positioned(
      left: pos.dx,
      top: pos.dy,
      width: size.width,
      height: size.height,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (e) => onMove(e.delta),
        child: LiquidGlassLens(
          style: LiquidGlassStyle(shape: shape),
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _ChargingLabel extends ConsumerWidget {
  const _ChargingLabel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double scale = ref.watch(appSettingsProvider).fontSize.scale;
    return Text(
      '40% - Charging',
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white70
            : const Color(0xB8101418),
        fontSize: 12.sp * scale,
      ),
    );
  }
}
