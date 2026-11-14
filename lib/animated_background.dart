import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});
  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(); // Ripete l'animazione all'infinito
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    // Plain background widget: `LiquidGlassScaffold` owns the page shell and
    // `LiquidGlassView` uses this as its refractable `backgroundWidget`.
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: WavePainter(_controller.value, brightness: brightness),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class MyBackgroundPainter extends CustomPainter {
  final double animationValue;
  MyBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    // Esempio semplice: un cerchio che si muove in base all'animazione
    final center = Offset(
      size.width * 0.5 + (math.sin(animationValue * 2 * math.pi) * 100),
      size.height * 0.5,
    );

    canvas.drawCircle(center, 150, paint);
  }

  @override
  bool shouldRepaint(covariant MyBackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class WavePainter extends CustomPainter {
  final double progress;
  final Brightness brightness;

  WavePainter(this.progress, {this.brightness = Brightness.dark});

  @override
  void paint(Canvas canvas, Size size) {
    final bool dark = brightness == Brightness.dark;
    // Muted base and waves to avoid an overly bright background.
    final bgPaint = Paint()
      ..color = dark ? const Color(0xFF0B1020) : const Color(0xFFB8C2CF)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final double intensity = dark ? 0.22 : 0.14;
    final waves = [
      WaveConfig(
        color: (dark ? Colors.cyanAccent : Colors.blueGrey).withValues(
          alpha: intensity + 0.04,
        ),
        amplitude: 30.0,
        frequency: 1.5,
        phaseShift: progress * 2 * math.pi,
        verticalOffset: size.height * 0.5,
      ),
      WaveConfig(
        color: (dark ? Colors.indigoAccent : Colors.indigo).withValues(
          alpha: intensity + 0.02,
        ),
        amplitude: 45.0,
        frequency: 1.0,
        phaseShift: (progress * 2 * math.pi) + (math.pi / 3),
        verticalOffset: size.height * 0.55,
      ),
      WaveConfig(
        color: (dark ? Colors.blueAccent : Colors.blueGrey).withValues(
          alpha: intensity,
        ),
        amplitude: 25.0,
        frequency: 2.0,
        phaseShift: (progress * 2 * math.pi) - (math.pi / 2),
        verticalOffset: size.height * 0.45,
      ),
      WaveConfig(
        color: (dark ? Colors.deepPurpleAccent : Colors.blueGrey).withValues(
          alpha: intensity - 0.02,
        ),
        amplitude: 50.0,
        frequency: 0.8,
        phaseShift: (progress * 2 * math.pi) + math.pi,
        verticalOffset: size.height * 0.6,
      ),
    ];

    for (var wave in waves) {
      final paint = Paint()
        ..color = wave.color
        ..style = PaintingStyle.fill;

      final path = Path();
      path.moveTo(0, size.height);

      // Generazione dei punti dell'onda lungo la larghezza dello schermo
      for (double x = 0; x <= size.width; x += 5) {
        // Formula sinusoidale combinata
        final double normalizedX = x / size.width;
        final double y =
            wave.verticalOffset +
            math.sin(
                  (normalizedX * wave.frequency * 2 * math.pi) +
                      wave.phaseShift,
                ) *
                wave.amplitude +
            // progress * 2 * pi (non pi) per completare un ciclo intero:
            // al reset 1 -> 0 il valore e la velocita' restano continui
            math.cos(normalizedX * math.pi + progress * 2 * math.pi) * 10;

        path.lineTo(x, y);
      }

      // Chiudiamo il tracciato verso il basso per riempire l'area sottostante
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.brightness != brightness;
  }
}

class WaveConfig {
  final Color color;
  final double amplitude;
  final double frequency;
  final double phaseShift;
  final double verticalOffset;

  WaveConfig({
    required this.color,
    required this.amplitude,
    required this.frequency,
    required this.phaseShift,
    required this.verticalOffset,
  });
}
