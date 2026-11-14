import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../ui/adaptive_ink.dart';

/// Small label shared by the homepage cards.
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
    final ink = AdaptiveInk.of(context);
    return Row(
      children: [
        Icon(icon, size: 14.w, color: ink.secondary),
        SizedBox(width: 5.w),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: ink.secondary,
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}
