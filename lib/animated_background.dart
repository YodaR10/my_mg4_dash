import 'dart:math';

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
      duration: Duration(seconds: 10),
    )..repeat(); // Ripete l'animazione all'infinito
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Sfondo animato tramite Painter
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: MyBackgroundPainter(_controller.value),
                child: Container(),
              );
            },
          ),
          // Contenuto della tua pagina
          Center(
            child: Text(
              "Contenuto in primo piano",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
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
      size.width * 0.5 + (sin(animationValue * 2 * pi) * 100),
      size.height * 0.5,
    );

    canvas.drawCircle(center, 150, paint);
  }

  @override
  bool shouldRepaint(covariant MyBackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
