import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../models/location_data.dart';
import '../../location_base.dart';

/// Mercadão — local de compras com mini-jogo Lista de Compras.
class Mercadao extends LocationBase {
  Mercadao()
      : super(
          data: const LocationData(
            id: 'mercadao',
            name: 'Mercadão',
            districtId: 'centro',
            description: 'Mercado colorido com frutas, legumes e muitas delícias!',
            isUnlockedByDefault: true,
            minigameIds: ['lista_compras'],
          ),
        );

  @override
  void onPlayerEnter() {
    // Callback executado pela transição do MundinhoGame.
  }

  @override
  void onPlayerExit() {
    // Callback executado ao sair do mercadão.
  }
}

/// Componente visual do Mercadão no mapa mundial.
class MercadaoExterior extends PositionComponent {
  MercadaoExterior({required Vector2 position})
      : super(
          position: position,
          size: Vector2(140, 110),
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    // Parede principal (vermelho)
    final wallPaint = Paint()..color = const Color(0xFFE53935);
    canvas.drawRect(
      Rect.fromLTWH(0, 25, size.x, size.y - 25),
      wallPaint,
    );

    // Toldo listrado (branco e vermelho)
    const stripeCount = 7;
    final stripeWidth = size.x / stripeCount;
    for (int i = 0; i < stripeCount; i++) {
      final stripePaint = Paint()
        ..color = i.isEven ? const Color(0xFFFFFFFF) : const Color(0xFFE53935);
      canvas.drawRect(
        Rect.fromLTWH(i * stripeWidth, 0, stripeWidth + 1, 28),
        stripePaint,
      );
    }

    // Borda do toldo
    final awningBorder = Paint()
      ..color = const Color(0xFFB71C1C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, 28),
      awningBorder,
    );

    // Porta de entrada
    final doorPaint = Paint()..color = const Color(0xFF5D4037);
    canvas.drawRect(
      Rect.fromLTWH(size.x / 2 - 20, size.y - 50, 40, 50),
      doorPaint,
    );

    // Maçaneta
    final knobPaint = Paint()..color = const Color(0xFFFFD54F);
    canvas.drawCircle(
      Offset(size.x / 2 + 12, size.y - 25),
      4,
      knobPaint,
    );

    // Janela lateral esquerda
    final windowPaint = Paint()..color = const Color(0xFF81D4FA);
    canvas.drawRect(
      Rect.fromLTWH(15, 40, 30, 30),
      windowPaint,
    );
    final windowFrame = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(
      Rect.fromLTWH(15, 40, 30, 30),
      windowFrame,
    );

    // Janela lateral direita
    canvas.drawRect(
      Rect.fromLTWH(size.x - 45, 40, 30, 30),
      windowPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.x - 45, 40, 30, 30),
      windowFrame,
    );

    // Letreiro "Mercadão"
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Mercadão',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.black54, blurRadius: 3),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.x - textPainter.width) / 2,
        32,
      ),
    );
  }
}
