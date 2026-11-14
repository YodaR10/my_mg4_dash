import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

import 'animated_background.dart';

class DemoView extends StatefulWidget {
  final int index;

  const DemoView(this.index, {super.key});

  @override
  State<DemoView> createState() => _DemoViewState();
}

class _DemoViewState extends State<DemoView> {
  // Top-left of each draggable shape — placed close so they start fused.
  Offset _card = const Offset(40, 170);
  Offset _circle = const Offset(60, 270);
  Offset _squircle = const Offset(150, 320);

  bool _fabOpened = false;

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
    return LiquidGlassScaffold(
      appBar: LiquidGlassAppBar(
        title: Text('Page ${widget.index + 1}'),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: LiquidGlassMorph(
        alignment: Alignment.bottomRight,
        motion: LiquidGlassMorphMotion.fluid,
        child: _fabOpened
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
                    onPressed: () => setState(() => _fabOpened = false),
                    child: const Icon(Icons.close),
                  ),
                ],
              )
            : LiquidGlassFab(
                size: 40.w,
                iconSize: 25.w,
                onPressed: () => setState(() => _fabOpened = true),
                child: Icon(Icons.abc_sharp, size: 20.w),
              ),
      ),
      body: LiquidGlassView(
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
