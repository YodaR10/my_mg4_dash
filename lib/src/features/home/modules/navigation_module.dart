import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/ui/adaptive_ink.dart';
import '../widgets/home_glass_tile.dart';
import '../widgets/home_module_header.dart';

/// Column 1, row 1: quick navigation to home and office.
class NavigationModule extends StatelessWidget {
  const NavigationModule({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeGlassTile(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeModuleHeader(
            icon: Icons.navigation_rounded,
            label: 'Navigazione',
          ),
          SizedBox(height: 7.h),
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
    final ink = AdaptiveInk.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w),
      decoration: BoxDecoration(
        color: ink.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ink.primary.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 19.w, color: ink.primary),
          SizedBox(width: 8.w),
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
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  eta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ink.secondary,
                    fontSize: 9.5.sp,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 16.w,
            color: ink.tertiary,
          ),
        ],
      ),
    );
  }
}
