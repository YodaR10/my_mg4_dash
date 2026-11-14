import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/home_glass_tile.dart';
import '../widgets/home_module_header.dart';
import '../widgets/home_theme.dart';

/// Column 1, row 2: phone projection entry point.
///
/// One neutral card, one target. No brand colors: the action is communicated by
/// position, icon and type weight instead of hue.
class AndroidAutoModule extends StatelessWidget {
  const AndroidAutoModule({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeGlassTile(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: Builder(
        builder: (context) {
          final HomeInk ink = HomeInk.of(context);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HomeModuleHeader(
                icon: Icons.phone_android_rounded,
                label: 'Telefono',
              ),
              SizedBox(height: 6.h),
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: HomeTokens.minTarget,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: ink.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: ink.outline),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.directions_car_filled_rounded,
                        size: 26.w,
                        color: ink.primary,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Android Auto',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: ink.primary,
                                fontSize: 15.sp,
                                height: 1.15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Connetti via USB',
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
                      Icon(Icons.link_rounded, size: 18.w, color: ink.tertiary),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
