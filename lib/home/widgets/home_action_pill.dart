import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../ui/adaptive_ink.dart';

/// Mock action chip used inside the homepage cards.
///
/// These are plain translucent fills, not `LiquidGlassLens`es: the card is the
/// only glass surface, so controls never stack glass on glass.
class HomeActionPill extends StatelessWidget {
  const HomeActionPill({
    super.key,
    required this.icon,
    required this.label,
    this.trailing,
    this.active = false,
    this.expanded = false,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final bool active;

  /// Stretches the pill to its parent width and pushes [trailing] to the end.
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final ink = AdaptiveInk.of(context);
    final Color foreground = active ? ink.onActive : ink.primary;
    final Widget text = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: foreground,
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: active ? ink.primary : ink.primary.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: ink.primary.withValues(alpha: active ? 0 : 0.16),
        ),
      ),
      child: Row(
        mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Icon(icon, size: 14.w, color: foreground),
          SizedBox(width: 5.w),
          if (expanded) Expanded(child: text) else Flexible(child: text),
          if (trailing != null) ...[SizedBox(width: 4.w), trailing!],
        ],
      ),
    );
  }
}
