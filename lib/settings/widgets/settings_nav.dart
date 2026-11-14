import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../settings_typography.dart';
import '../settings_view.dart';

class SettingsNav extends StatelessWidget {
  const SettingsNav({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final SettingsSection selected;
  final ValueChanged<SettingsSection> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(6.w, 4.h, 6.w, 10.h),
          child: Text(
            'Impostazioni',
            style: TextStyle(
              color: Colors.white,
              fontSize: SettingsTypography.navHeader,
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
              final Color fg = active ? const Color(0xFF101418) : Colors.white;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onSelect(section),
                  borderRadius: BorderRadius.circular(14.r),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: active
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: Colors.white
                            .withValues(alpha: active ? 0 : 0.14),
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
                            Icon(section.icon, size: 20.w, color: fg),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                section.label,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: fg,
                                  fontSize: SettingsTypography.navItem,
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
