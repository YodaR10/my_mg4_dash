import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

import 'animated_background.dart';

class DemoView extends StatefulWidget {
  const DemoView({super.key});

  @override
  State<DemoView> createState() => _DemoViewState();
}

class _DemoViewState extends State<DemoView> {
  // Busy detail makes the refraction easy to read as the glass passes over it.
  // Served from the project's asset repo (same source as the other demos).
  static const String _imageUrl =
      'https://raw.githubusercontent.com/AhmeedGamil/liquid_glass_easy_assets'
      '/main/blending.jpg';

  // Top-left of each draggable shape — placed close so they start fused.
  Offset _card = const Offset(40, 170);
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

  @override
  Widget build(BuildContext context) {
    return LiquidGlassView(
      // backgroundWidget: const _Background(url: _imageUrl),
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
                    size: Size(248.w, 120.h),
                    shape: const LiquidGlassShape.continuousRoundedRectangle(
                      cornerRadius: 32,
                    ),
                    onMove: (d) => setState(() => _card += d),
                    child: const _CardContent(),
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

class _CardContent extends StatelessWidget {
  const _CardContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Liquid Glass',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Refraction over a live photo',
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}

/// The refractable background captured by [LiquidGlassView]: the network photo
/// (with a gradient fallback) plus a soft scrim for text legibility.
class _Background extends StatelessWidget {
  final String url;
  const _Background({required this.url});

  static const _fallback = DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2E1065), Color(0xFF0EA5E9), Color(0xFFF59E0B)],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _fallback,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const Stack(
              fit: StackFit.expand,
              children: [
                _fallback,
                Center(child: CircularProgressIndicator(color: Colors.white)),
              ],
            );
          },
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x33000000), Color(0x66000000)],
            ),
          ),
        ),
      ],
    );
  }
}
