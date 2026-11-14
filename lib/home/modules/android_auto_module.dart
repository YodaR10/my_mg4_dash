import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../ui/adaptive_ink.dart';
import '../widgets/home_glass_tile.dart';
import '../widgets/home_module_header.dart';

/// Column 1, row 2: Android Auto connection entry point.
class AndroidAutoModule extends StatelessWidget {
  const AndroidAutoModule({super.key});

  static const Color _androidGreen = Color(0xFF3DDC84);

  @override
  Widget build(BuildContext context) {
    final ink = AdaptiveInk.of(context);
    return HomeGlassTile(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeModuleHeader(
            icon: Icons.phone_android_rounded,
            label: 'Telefono',
          ),
          SizedBox(height: 7.h),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: _androidGreen.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _androidGreen.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.directions_car_filled_rounded,
                    size: 26.w,
                    color: _androidGreen,
                  ),
                  SizedBox(width: 9.w),
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
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Connetti via USB',
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
                    Icons.link_rounded,
                    size: 18.w,
                    color: ink.tertiary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
