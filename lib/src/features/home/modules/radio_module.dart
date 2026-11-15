import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/ui/adaptive_ink.dart';
import '../widgets/home_glass_tile.dart';
import '../widgets/home_module_header.dart';

/// Column 2: radio player spanning both rows.
class RadioModule extends StatelessWidget {
  const RadioModule({super.key});

  @override
  Widget build(BuildContext context) {
    final ink = AdaptiveInk.of(context);
    return HomeGlassTile(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeModuleHeader(
            icon: Icons.radio_rounded,
            label: 'Radio',
            trailing: Text(
              'FM 102.5',
              style: TextStyle(
                color: ink.secondary,
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 7.h),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: _Cover(
                    selected: true,
                    icon: Icons.music_note_rounded,
                  ),
                ),
                SizedBox(width: 6.w),
                const Expanded(
                  child: _Cover(
                    icon: Icons.graphic_eq_rounded,
                  ),
                ),
                SizedBox(width: 6.w),
                const Expanded(
                  child: _Cover(
                    icon: Icons.headphones_rounded,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Blinding Lights',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: ink.primary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'The Weeknd',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: ink.secondary,
              fontSize: 10.sp,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _RoundButton(icon: Icons.skip_previous_rounded),
              SizedBox(width: 16.w),
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: ink.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 27.w,
                  color: ink.onActive,
                ),
              ),
              SizedBox(width: 16.w),
              const _RoundButton(icon: Icons.skip_next_rounded),
            ],
          ),
        ],
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({
    required this.icon,
    this.selected = false,
  });

  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final ink = AdaptiveInk.of(context);
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: ink.primary.withValues(alpha: selected ? 0.16 : 0.08),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: ink.primary.withValues(alpha: selected ? 0.9 : 0.18),
            width: selected ? 2 : 1,
          ),
        ),
        child: Icon(
          icon,
          size: 22.w,
          color: ink.primary.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ink = AdaptiveInk.of(context);
    return Container(
      width: 34.w,
      height: 34.w,
      decoration: BoxDecoration(
        color: ink.primary.withValues(alpha: 0.08),
        shape: BoxShape.circle,
        border: Border.all(color: ink.primary.withValues(alpha: 0.16)),
      ),
      child: Icon(
        icon,
        size: 18.w,
        color: ink.primary.withValues(alpha: 0.85),
      ),
    );
  }
}
