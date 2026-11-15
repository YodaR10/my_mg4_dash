import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/ui/adaptive_ink.dart';
import '../widgets/home_glass_tile.dart';
import '../widgets/home_module_header.dart';

/// Column 4, row 1: weather, date and time.
class AmbientModule extends StatelessWidget {
  const AmbientModule({super.key});

  @override
  Widget build(BuildContext context) {
    final ink = AdaptiveInk.of(context);
    return HomeGlassTile(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeModuleHeader(icon: Icons.wb_sunny_rounded, label: 'Oggi'),
          const Spacer(),
          Row(
            children: [
              Icon(
                Icons.wb_sunny_rounded,
                size: 28.w,
                color: const Color(0xFFFFD166),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '18°',
                      style: TextStyle(
                        color: ink.primary,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                    Text(
                      'Sereno',
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '14:32',
                    style: TextStyle(
                      color: ink.primary,
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                  Text(
                    'Sab 14 nov',
                    maxLines: 1,
                    style: TextStyle(
                      color: ink.secondary,
                      fontSize: 9.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
