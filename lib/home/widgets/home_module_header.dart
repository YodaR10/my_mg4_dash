import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_theme.dart';

/// Section label shared by the homepage cards.
///
/// Kept at 14 `.sp` / medium weight so it stays readable at a glance; no
/// hardcoded color, so it follows the tile's adaptive content color.
class HomeModuleHeader extends StatelessWidget {
  const HomeModuleHeader({
    super.key,
    required this.icon,
    required this.label,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final HomeInk ink = HomeInk.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 16.h),
      child: Row(
        children: [
          Icon(icon, size: 16.w, color: ink.secondary),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: ink.secondary,
                fontSize: 14.sp,
                height: 1.1,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
