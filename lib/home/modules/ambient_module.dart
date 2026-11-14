import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/home_glass_tile.dart';
import '../widgets/home_module_header.dart';
import '../widgets/home_theme.dart';

/// Column 4, row 1: weather, date and time.
///
/// Glanceable ambient information: temperature first, time second, metadata
/// last. All monochrome — the sun icon carries the meaning, not a yellow tint.
class AmbientModule extends StatelessWidget {
  const AmbientModule({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeGlassTile(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: Builder(
        builder: (context) {
          final HomeInk ink = HomeInk.of(context);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeModuleHeader(icon: Icons.wb_sunny_rounded, label: 'Oggi'),
              SizedBox(height: 6.h),
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.wb_sunny_rounded, size: 30.w, color: ink.primary),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '18°',
                            maxLines: 1,
                            style: TextStyle(
                              color: ink.primary,
                              fontSize: 28.sp,
                              height: 1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Sereno',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: ink.secondary,
                              fontSize: 13.sp,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '14:32',
                          maxLines: 1,
                          style: TextStyle(
                            color: ink.primary,
                            fontSize: 20.sp,
                            height: 1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Sab 14 nov',
                          maxLines: 1,
                          style: TextStyle(
                            color: ink.secondary,
                            fontSize: 12.sp,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
