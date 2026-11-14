import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../ui/adaptive_ink.dart';
import '../widgets/home_action_pill.dart';
import '../widgets/home_glass_tile.dart';
import '../widgets/home_module_header.dart';

/// Column 4, row 2: two recent apps and a shortcut to the full app list.
class AppsModule extends StatelessWidget {
  const AppsModule({super.key});

  @override
  Widget build(BuildContext context) {
    final ink = AdaptiveInk.of(context);
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
                  ),
                ),
                SizedBox(width: 6.w),
                const Expanded(
                  child: _AppTile(
                    icon: Icons.map_rounded,
                    label: 'Mappe',
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
              color: ink.tertiary,
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
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ink = AdaptiveInk.of(context);
    return Container(
      decoration: BoxDecoration(
        color: ink.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ink.primary.withValues(alpha: 0.16)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22.w, color: ink.primary),
          SizedBox(height: 3.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: ink.primary,
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
