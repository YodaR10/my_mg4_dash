import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/home_glass_tile.dart';
import '../widgets/home_module_header.dart';
import '../widgets/home_theme.dart';

/// Column 2: the now-playing card spanning both rows.
///
/// One artwork, one track, three controls — the minimum needed to understand
/// and act on playback. Controls are 48–56 dp targets; playback state is a
/// monochrome progress line, not a colored accent.
class RadioModule extends StatelessWidget {
  const RadioModule({super.key});

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
              HomeModuleHeader(
                icon: Icons.radio_rounded,
                label: 'Radio',
                trailing: Text(
                  'FM 102.5',
                  style: TextStyle(
                    color: ink.secondary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Flexible(
                flex: 5,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 120.w),
                      decoration: BoxDecoration(
                        color: ink.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: ink.outline),
                      ),
                      child: Icon(
                        Icons.music_note_rounded,
                        size: 44.w,
                        color: ink.primary,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Blinding Lights',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ink.primary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'The Weeknd',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(color: ink.secondary, fontSize: 13.sp),
              ),
              SizedBox(height: 10.h),
              _Progress(value: 0.4, ink: ink),
              const Spacer(),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _RoundButton(icon: Icons.skip_previous_rounded, ink: ink),
                    SizedBox(width: 16.w),
                    Container(
                      width: 56.w,
                      height: 56.w,
                      decoration: BoxDecoration(
                        color: ink.selected,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        size: 28.w,
                        color: ink.onSelected,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    _RoundButton(icon: Icons.skip_next_rounded, ink: ink),
                  ],
                ),
              ),
              const Spacer(),
            ],
          );
        },
      ),
    );
  }
}

/// Monochrome playback progress: filled part in the ink color, rest as a
/// hairline track.
class _Progress extends StatelessWidget {
  const _Progress({required this.value, required this.ink});

  final double value;
  final HomeInk ink;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 3.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: ink.alpha(0.16)),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value,
              child: ColoredBox(color: ink.alpha(0.8)),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.ink});

  final IconData icon;
  final HomeInk ink;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: HomeTokens.minTarget,
      height: HomeTokens.minTarget,
      decoration: BoxDecoration(
        color: ink.surface,
        shape: BoxShape.circle,
        border: Border.all(color: ink.outline),
      ),
      child: Icon(icon, size: 20.w, color: ink.primary),
    );
  }
}
