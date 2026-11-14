import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/home_action_pill.dart';
import '../widgets/home_glass_tile.dart';
import '../widgets/home_module_header.dart';
import '../widgets/home_theme.dart';

/// Column 4, row 2: two recent apps and a shortcut to the full list.
class AppsModule extends StatelessWidget {
  const AppsModule({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeGlassTile(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: Builder(
        builder: (context) {
          final HomeInk ink = HomeInk.of(context);
          return Column(
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
                    SizedBox(width: HomeTokens.gap.w),
                    const Expanded(
                      child: _AppTile(icon: Icons.map_rounded, label: 'Mappe'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6.h),
              Flexible(
                flex: 0,
                child: HomeActionPill(
                  icon: Icons.apps_rounded,
                  label: 'Tutte le app',
                  expanded: true,
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    size: 18.w,
                    color: ink.tertiary,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AppTile extends StatelessWidget {
  const _AppTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final HomeInk ink = HomeInk.of(context);

    return Container(
      constraints: const BoxConstraints(minHeight: HomeTokens.minTarget),
      decoration: BoxDecoration(
        color: ink.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ink.outline),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20.w, color: ink.primary),
          SizedBox(height: 4.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: ink.primary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
