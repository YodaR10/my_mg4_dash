import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/home_glass_tile.dart';
import '../widgets/home_module_header.dart';
import '../widgets/home_theme.dart';

/// Column 1, row 1: critical navigation destinations.
///
/// Two full-width destinations, each at least [HomeTokens.minTarget] tall —
/// the fastest possible path (one tap) for the most common driving task.
class NavigationModule extends StatelessWidget {
  const NavigationModule({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeGlassTile(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const HomeModuleHeader(
            icon: Icons.navigation_rounded,
            label: 'Navigazione',
          ),
          SizedBox(height: 6.h),
          const Expanded(
            child: _DestinationButton(
              icon: Icons.home_rounded,
              label: 'Casa',
              eta: '12 min',
            ),
          ),
          SizedBox(height: 6.h),
          const Expanded(
            child: _DestinationButton(
              icon: Icons.work_rounded,
              label: 'Ufficio',
              eta: '24 min',
            ),
          ),
        ],
      ),
    );
  }
}

class _DestinationButton extends StatelessWidget {
  const _DestinationButton({
    required this.icon,
    required this.label,
    required this.eta,
  });

  final IconData icon;
  final String label;
  final String eta;

  @override
  Widget build(BuildContext context) {
    final HomeInk ink = HomeInk.of(context);

    return Container(
      constraints: const BoxConstraints(minHeight: HomeTokens.minTarget),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: ink.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ink.outline),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20.w, color: ink.primary),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ink.primary,
                    fontSize: 16.sp,
                    height: 1.1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  eta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ink.secondary,
                    fontSize: 12.sp,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, size: 18.w, color: ink.tertiary),
        ],
      ),
    );
  }
}
