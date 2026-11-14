import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/home_glass_tile.dart';
import '../widgets/home_module_header.dart';
import '../widgets/home_theme.dart';

/// Column 3: climate, spanning both rows.
///
/// Temperature and fan values sit in the top half; the two button rows fill
/// the bottom half. State is shown with fill/border strength (luminance), so
/// the same widget reads correctly on dark and light glass.
class ClimateModule extends StatelessWidget {
  const ClimateModule({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeGlassTile(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const HomeModuleHeader(
            icon: Icons.thermostat_rounded,
            label: 'Clima',
          ),
          SizedBox(height: 6.h),
          Expanded(
            child: Column(
              children: [
                const Expanded(
                  child: Row(
                    children: [
                      Expanded(flex: 5, child: _TemperatureValue()),
                      _Divider(),
                      Expanded(flex: 3, child: _FanLevel()),
                    ],
                  ),
                ),
                SizedBox(height: 6.h),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Expanded(
                              child: _ToggleChip(
                                icon: Icons.auto_mode_rounded,
                                label: 'Auto',
                                active: true,
                              ),
                            ),
                            SizedBox(width: HomeTokens.gap.w),
                            const Expanded(
                              child: _ToggleChip(
                                icon: Icons.ac_unit_rounded,
                                label: 'A/C',
                                active: true,
                              ),
                            ),
                            SizedBox(width: HomeTokens.gap.w),
                            const Expanded(
                              child: _ToggleChip(
                                icon: Icons.loop_rounded,
                                label: 'Ricircolo',
                                active: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: HomeTokens.gap.h),
                      Expanded(
                        child: Row(
                          children: [
                            const Expanded(
                              child: _SeatControl(
                                icon: Icons.event_seat_rounded,
                                label: 'SX',
                                level: 2,
                              ),
                            ),
                            SizedBox(width: HomeTokens.gap.w),
                            const Expanded(
                              child: _SeatControl(
                                icon: Icons.drive_eta_rounded,
                                label: 'Volante',
                                level: 1,
                              ),
                            ),
                            SizedBox(width: HomeTokens.gap.w),
                            const Expanded(
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
          ),
        ],
      ),
    );
  }
}

class _TemperatureValue extends StatelessWidget {
  const _TemperatureValue();

  @override
  Widget build(BuildContext context) {
    final HomeInk ink = HomeInk.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            '21.5°',
            maxLines: 1,
            style: TextStyle(
              color: ink.primary,
              fontSize: 32.sp,
              height: 1,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Est. 18°',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: ink.secondary, fontSize: 13.sp),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      color: HomeInk.of(context).alpha(0.16),
    );
  }
}

class _FanLevel extends StatelessWidget {
  const _FanLevel();

  @override
  Widget build(BuildContext context) {
    final HomeInk ink = HomeInk.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ventola',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: ink.secondary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < 3; i++)
              Container(
                width: 6.w,
                height: (8 + i * 5).h,
                margin: EdgeInsets.only(right: 4.w),
                decoration: BoxDecoration(
                  color: i < 2 ? ink.alpha(0.85) : ink.alpha(0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          'Livello 2',
          style: TextStyle(color: ink.tertiary, fontSize: 12.sp),
        ),
      ],
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    required this.icon,
    required this.label,
    required this.active,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final HomeInk ink = HomeInk.of(context);
    final Color foreground = active ? ink.onSelected : ink.secondary;

    return Container(
      decoration: BoxDecoration(
        color: active ? ink.selected : ink.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: active ? Colors.transparent : ink.outline,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18.w, color: foreground),
          SizedBox(height: 3.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: foreground,
              fontSize: 12.sp,
              height: 1,
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
    final HomeInk ink = HomeInk.of(context);
    final bool active = level > 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: active ? ink.surfaceActive : ink.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: active ? ink.outlineActive : ink.outline),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15.w,
                color: active ? ink.primary : ink.tertiary,
              ),
              SizedBox(width: 3.w),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: active ? ink.primary : ink.secondary,
                    fontSize: 12.sp,
                    height: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 3; i++)
                Container(
                  width: 4.w,
                  height: 3.h,
                  margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                  decoration: BoxDecoration(
                    color: i < level ? ink.alpha(0.8) : ink.alpha(0.16),
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
