import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../home/widgets/home_theme.dart';
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
    final HomeInk ink = HomeInk.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(6.w, 4.h, 6.w, 10.h),
          child: Text(
            'Impostazioni',
            style: TextStyle(
              color: ink.primary,
              fontSize: 20.sp,
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
              final Color fg = active ? ink.onSelected : ink.primary;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onSelect(section),
                  borderRadius: BorderRadius.circular(14.r),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: active ? ink.selected : ink.surface,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: active ? Colors.transparent : ink.outline,
                      ),
                    ),
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(minHeight: HomeTokens.minTarget),
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
                                  fontSize: 14.sp,
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
