import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/ui/adaptive_ink.dart';
import '../widgets/home_glass_tile.dart';
import '../widgets/home_module_header.dart';

/// Column 3: temperature and fan on top, modes and seat heating below.
class ClimateModule extends StatelessWidget {
  const ClimateModule({super.key});

  static const Color _amber = Color(0xFFFFC857);

  @override
  Widget build(BuildContext context) {
    return HomeGlassTile(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const HomeModuleHeader(
            icon: Icons.thermostat_rounded,
            label: 'Clima',
          ),
          SizedBox(height: 7.h),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(child: _Temperature()),
                _Divider(),
                Expanded(child: _FanLevel()),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _ClimateToggle(
                          icon: Icons.auto_mode_rounded,
                          label: 'Auto',
                          active: true,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: _ClimateToggle(
                          icon: Icons.ac_unit_rounded,
                          label: 'A/C',
                          active: true,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: _ClimateToggle(
                          icon: Icons.loop_rounded,
                          label: 'Ricircolo',
                          active: false,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 7.h),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _SeatControl(
                          icon: Icons.event_seat_rounded,
                          label: 'SX',
                          level: 2,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: _SeatControl(
                          icon: Icons.drive_eta_rounded,
                          label: 'Volante',
                          level: 1,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: _SeatControl(
                          icon: Icons.event_seat_rounded,
                          label: 'DX',
                          level: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Temperature extends StatelessWidget {
  const _Temperature();

  @override
  Widget build(BuildContext context) {
    final ink = AdaptiveInk.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            '21.5°',
            style: TextStyle(
              color: ink.primary,
              fontSize: 30.sp,
              fontWeight: FontWeight.w300,
              height: 1,
            ),
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          'Int. 22° · Est. 18°',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: ink.secondary,
            fontSize: 8.5.sp,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    final ink = AdaptiveInk.of(context);
    return Container(
      width: 1,
      margin: EdgeInsets.symmetric(horizontal: 9.w),
      color: ink.primary.withValues(alpha: 0.12),
    );
  }
}

class _FanLevel extends StatelessWidget {
  const _FanLevel();

  @override
  Widget build(BuildContext context) {
    final ink = AdaptiveInk.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.air_rounded,
              size: 17.w,
              color: ink.secondary,
            ),
            SizedBox(width: 5.w),
            Text(
              'Ventola',
              style: TextStyle(
                color: ink.secondary,
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < 3; i++)
              Container(
                width: 7.w,
                height: (9 + i * 5).h,
                margin: EdgeInsets.only(right: 3.w),
                decoration: BoxDecoration(
                  color: i < 2
                      ? const Color(0xFF67E8F9)
                      : ink.primary.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
          ],
        ),
        SizedBox(height: 3.h),
        Text(
          'Livello 2',
          style: TextStyle(
            color: ink.tertiary,
            fontSize: 8.5.sp,
          ),
        ),
      ],
    );
  }
}

class _ClimateToggle extends StatelessWidget {
  const _ClimateToggle({
    required this.icon,
    required this.label,
    required this.active,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final ink = AdaptiveInk.of(context);
    final Color foreground = active ? ink.onActive : ink.primary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: active ? ink.primary : ink.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ink.primary.withValues(alpha: active ? 0 : 0.14),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15.w,
            color: active ? ink.onActive : ink.secondary,
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: foreground,
              fontSize: 8.5.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SeatControl extends StatelessWidget {
  const _SeatControl({
    required this.icon,
    required this.label,
    required this.level,
  });

  final IconData icon;
  final String label;
  final int level;

  @override
  Widget build(BuildContext context) {
    final ink = AdaptiveInk.of(context);
    final bool active = level > 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: ink.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ink.primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 16.w,
            color: active
                ? ClimateModule._amber
                : ink.tertiary,
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: ink.secondary,
              fontSize: 7.5.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 3; i++)
                Container(
                  width: 4.w,
                  height: 3.h,
                  margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                  decoration: BoxDecoration(
                    color: i < level
                        ? ClimateModule._amber
                        : ink.primary.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
