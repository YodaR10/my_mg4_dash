import 'package:flutter/material.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

class LiquidGlassControlCard extends StatelessWidget {
  final double
  level; // Valore da 0.0 a 1.0 (es. 0.4 per la luminosità, 0.25 per il volume)
  final IconData icon;
  final Color iconColor;

  const LiquidGlassControlCard({
    super.key,
    required this.level,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 110.0;
    const double cardHeight = 260.0;

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // 1. Contenitore principale a capsula con effetto Liquid Glass (sfondo trasparente/vetro)
          LiquidGlassLens(
            style: const LiquidGlassStyle(
              shape: LiquidGlassShape.squircle(cornerRadius: 45),
              refractionIndex: 1.03,
            ),
            child: Container(
              width: cardWidth,
              height: cardHeight,
              color: Colors.white.withOpacity(0.04),
            ),
          ),

          // 2. Sezione inferiore solida (bianca) che copre la parte bassa in base al livello
          ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: Align(
              alignment: Alignment.bottomCenter,
              heightFactor: level, // Controlla l'altezza della sezione bianca
              child: Container(
                width: cardWidth,
                height: cardHeight,
                color: Colors.white,
              ),
            ),
          ),

          // 3. Icona centrata nella parte inferiore
          Positioned(bottom: 30, child: Icon(icon, color: iconColor, size: 34)),
        ],
      ),
    );
  }
}
