import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_theme.dart';

/// Mock action chip used inside the homepage cards.
///
/// These are plain translucent fills, not `LiquidGlassLens`es: the card is the
/// only glass surface, so controls never stack glass on glass. The visual
/// height is pinned to the 48 dp minimum target; selection is conveyed by
/// luminance and border strength, never by color.
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
    final HomeInk ink = HomeInk.of(context);
    final Color foreground = active ? ink.onSelected : ink.primary;
    final Widget text = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: foreground,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
    );

    return Container(
      constraints: const BoxConstraints(minHeight: HomeTokens.minTarget),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: active ? ink.selected : ink.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: active ? Colors.transparent : ink.outline,
        ),
      ),
      child: Row(
        mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Icon(icon, size: 18.w, color: foreground),
          SizedBox(width: 8.w),
          if (expanded) Expanded(child: text) else Flexible(child: text),
          if (trailing != null) ...[SizedBox(width: 6.w), trailing!],
        ],
      ),
    );
  }
}
