import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/home_glass_tile.dart';
import '../widgets/home_module_header.dart';

/// Column 2: radio player spanning both rows.
class RadioModule extends StatelessWidget {
  const RadioModule({super.key});

  @override
  Widget build(BuildContext context) {
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
                color: Colors.white.withValues(alpha: 0.65),
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
                    colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
                  ),
                ),
                SizedBox(width: 6.w),
                const Expanded(
                  child: _Cover(
                    icon: Icons.graphic_eq_rounded,
                    colors: [Color(0xFF0EA5E9), Color(0xFF14B8A6)],
                  ),
                ),
                SizedBox(width: 6.w),
                const Expanded(
                  child: _Cover(
                    icon: Icons.headphones_rounded,
                    colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
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
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'The Weeknd',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
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
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 27.w,
                  color: const Color(0xFF101418),
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
    required this.colors,
    this.selected = false,
  });

  final IconData icon;
  final List<Color> colors;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: Colors.white.withValues(alpha: selected ? 0.9 : 0.18),
            width: selected ? 2 : 1,
          ),
        ),
        child: Icon(
          icon,
          size: 22.w,
          color: Colors.white.withValues(alpha: 0.9),
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
    return Container(
      width: 34.w,
      height: 34.w,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Icon(
        icon,
        size: 18.w,
        color: Colors.white.withValues(alpha: 0.85),
      ),
    );
  }
}
