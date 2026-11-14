import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/home_action_pill.dart';
import '../widgets/home_glass_tile.dart';
import '../widgets/home_module_header.dart';

/// Column 4, row 2: two recent apps and a shortcut to the full app list.
class AppsModule extends StatelessWidget {
  const AppsModule({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeGlassTile(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const HomeModuleHeader(icon: Icons.apps_rounded, label: 'App'),
          SizedBox(height: 6.h),
          Expanded(
            child: Row(
              children: [
                const Expanded(
                  child: _AppTile(
                    icon: Icons.music_note_rounded,
                    label: 'Musica',
                    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                  ),
                ),
                SizedBox(width: 6.w),
                const Expanded(
                  child: _AppTile(
                    icon: Icons.map_rounded,
                    label: 'Mappe',
                    colors: [Color(0xFF0EA5E9), Color(0xFF22C55E)],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 6.h),
          HomeActionPill(
            icon: Icons.apps_rounded,
            label: 'Tutte le app',
            expanded: true,
            trailing: Icon(
              Icons.chevron_right_rounded,
              size: 15.w,
              color: Colors.white.withValues(alpha: 0.54),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppTile extends StatelessWidget {
  const _AppTile({
    required this.icon,
    required this.label,
    required this.colors,
  });

  final IconData icon;
  final String label;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22.w, color: Colors.white),
          SizedBox(height: 3.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
