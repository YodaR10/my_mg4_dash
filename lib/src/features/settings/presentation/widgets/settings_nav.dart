import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/ui/adaptive_ink.dart';
import '../../domain/app_settings.dart';
import '../settings_typography.dart';
import '../settings_view.dart';

class SettingsNav extends StatelessWidget {
  const SettingsNav({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.fontSize,
  });

  final SettingsSection selected;
  final ValueChanged<SettingsSection> onSelect;
  final AppFontSize fontSize;

  @override
  Widget build(BuildContext context) {
    final typo = SettingsTypography.forFontSize(fontSize);
    final ink = AdaptiveInk.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(6.w, 4.h, 6.w, 10.h),
          child: Text(
            'Impostazioni',
            style: TextStyle(
              color: ink.primary,
              fontSize: typo.navHeader,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: SettingsSection.values.length,
            separatorBuilder: (_, _) => SizedBox(height: 8.h),
            itemBuilder: (context, i) {
              final SettingsSection section = SettingsSection.values[i];
              final bool active = section == selected;
              final Color fg = active ? ink.onActive : ink.primary;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onSelect(section),
                  borderRadius: BorderRadius.circular(14.r),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: active
                          ? ink.primary
                          : ink.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: ink.primary.withValues(alpha: active ? 0 : 0.14),
                      ),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: 48.h),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 8.h,
                        ),
                        child: Row(
                          children: [
                            Icon(section.icon, size: typo.navIcon, color: fg),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                section.label,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: fg,
                                  fontSize: typo.navItem,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
