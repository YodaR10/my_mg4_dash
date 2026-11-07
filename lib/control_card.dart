import 'package:flutter/material.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

enum ControlOrientation { vertical, horizontal }

class LiquidGlassControlCard extends StatelessWidget {
  final double level; // Valore da 0.0 a 1.0
  final IconData icon;
  final Color iconColor;
  final ControlOrientation orientation;
  final double? width; // Parametro opzionale per la larghezza
  final double? height; // Parametro opzionale per l'altezza

  const LiquidGlassControlCard({
    super.key,
    required this.level,
    required this.icon,
    required this.iconColor,
    this.orientation = ControlOrientation.vertical,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final bool isVertical = orientation == ControlOrientation.vertical;

    // Se non vengono passati, usa valori di default coerenti con l'orientamento
    final double cardWidth = width ?? (isVertical ? 110.0 : 260.0);
    final double cardHeight = height ?? (isVertical ? 260.0 : 110.0);

    // Adatta il raggio di curvatura in base alla dimensione minore per mantenere l'effetto capsula perfetto
    final double cornerRadius = isVertical ? cardWidth / 2 : cardHeight / 2;
    final BorderRadius outerRadius = BorderRadius.circular(cornerRadius);

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Stack(
        alignment: isVertical ? Alignment.bottomCenter : Alignment.centerLeft,
        children: [
          // 1. Contenitore principale a capsula con effetto Liquid Glass (vetro)
          LiquidGlassLens(
            style: LiquidGlassStyle(
              shape: LiquidGlassShape.squircle(cornerRadius: cornerRadius),
              refractionIndex: 1.03,
            ),
            child: Container(
              width: cardWidth,
              height: cardHeight,
              color: Colors.white.withValues(alpha: 0.04),
            ),
          ),

          // 2. Sezione solida (bianca) con taglio NETTO (senza arrotondamenti interni)
          ClipRRect(
            borderRadius: outerRadius,
            child: Align(
              alignment: isVertical
                  ? Alignment.bottomCenter
                  : Alignment.centerLeft,
              // heightFactor per verticale, widthFactor per orizzontale
              heightFactor: isVertical ? level : null,
              widthFactor: !isVertical ? level : null,
              child: Container(
                width: cardWidth,
                height: cardHeight,
                color: Colors.white,
              ),
            ),
          ),

          // 3. Icona posizionata coerentemente con l'orientamento
          Positioned(
            bottom: isVertical ? 20 : null,
            left: !isVertical ? 20 : null,
            child: Icon(icon, color: iconColor, size: 34),
          ),
        ],
      ),
    );
  }
}
