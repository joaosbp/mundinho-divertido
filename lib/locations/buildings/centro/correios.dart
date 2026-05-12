import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../models/location_data.dart';
import '../../location_base.dart';

/// Correios — local com mini-jogo Carteiro Express.
class Correios extends LocationBase {
  Correios()
      : super(
          data: const LocationData(
            id: 'correios',
            name: 'Correios',
            districtId: 'centro',
            description: 'Correios com caixa amarela gigante e o Seu Correio!',
            isUnlockedByDefault: true,
            minigameIds: ['carteiro_express'],
          ),
        );

  @override
  void onPlayerEnter() {
    // Callback executado pela transição do MundinhoGame.
  }

  @override
  void onPlayerExit() {
    // Callback executado ao sair dos correios.
  }
}

/// Componente visual dos Correios no mapa mundial.
class CorreiosExterior extends PositionComponent {
  CorreiosExterior({required Vector2 position})
      : super(
          position: position,
          size: Vector2(140, 110),
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    // Parede principal (amarela clarinha)
    final wallPaint = Paint()..color = const Color(0xFFFFF9C4);
    canvas.drawRect(
      Rect.fromLTWH(0, 25, size.x, size.y - 25),
      wallPaint,
    );

    // Borda da parede
    final wallBorder = Paint()
      ..color = const Color(0xFFFBC02D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(
      Rect.fromLTWH(0, 25, size.x, size.y - 25),
      wallBorder,
    );

    // Caixa de correio amarela gigante 📮 no topo
    final boxPaint = Paint()..color = const Color(0xFFFFD600);
    final boxRrect = RRect.fromRectAndRadius(
      Rect.fromLTWH((size.x - 50) / 2, 2, 50, 28),
      const Radius.circular(4),
    );
    canvas.drawRRect(boxRrect, boxPaint);

    // Abertura da caixa
    final slotPaint = Paint()..color = const Color(0xFF212121);
    canvas.drawRect(
      Rect.fromLTWH((size.x - 30) / 2, 10, 30, 8),
      slotPaint,
    );

    // Bandeira da caixa
    final flagPaint = Paint()..color = const Color(0xFFE53935);
    final flagPath = Path()
      ..moveTo((size.x + 30) / 2, 4)
      ..lineTo((size.x + 30) / 2 + 10, 8)
      ..lineTo((size.x + 30) / 2, 14)
      ..close();
    canvas.drawPath(flagPath, flagPaint);

    // Carrinho de cartas (lado esquerdo)
    final cartPaint = Paint()..color = const Color(0xFF90A4AE);
    canvas.drawRect(
      Rect.fromLTWH(8, 55, 28, 20),
      cartPaint,
    );
    // Rodas do carrinho
    final wheelPaint = Paint()..color = const Color(0xFF546E7A);
    canvas.drawCircle(const Offset(16, 80), 4, wheelPaint);
    canvas.drawCircle(const Offset(28, 80), 4, wheelPaint);
    // Alça do carrinho
    final handlePaint = Paint()
      ..color = const Color(0xFF607D8B)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      const Offset(8, 65),
      const Offset(2, 55),
      handlePaint,
    );
    // Cartas no carrinho
    final letterPaint = Paint()..color = const Color(0xFFFFFFFF);
    canvas.drawRect(
      Rect.fromLTWH(10, 50, 10, 12),
      letterPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(18, 48, 10, 12),
      letterPaint,
    );

    // Caixas de cartas empilhadas (direita)
    final stackColors = [
      const Color(0xFFEF5350),
      const Color(0xFF42A5F5),
      const Color(0xFF66BB6A),
    ];
    for (int i = 0; i < stackColors.length; i++) {
      final stackPaint = Paint()..color = stackColors[i];
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.x - 36, 48 + i * 14, 26, 12),
          const Radius.circular(2),
        ),
        stackPaint,
      );
    }

    // Porta de entrada
    final doorPaint = Paint()..color = const Color(0xFF8D6E63);
    canvas.drawRect(
      Rect.fromLTWH(size.x / 2 - 20, size.y - 50, 40, 50),
      doorPaint,
    );
    final doorBorder = Paint()
      ..color = const Color(0xFF6D4C41)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(
      Rect.fromLTWH(size.x / 2 - 20, size.y - 50, 40, 50),
      doorBorder,
    );

    // Maçaneta
    final knobPaint = Paint()..color = const Color(0xFFFFD54F);
    canvas.drawCircle(
      Offset(size.x / 2 + 12, size.y - 25),
      4,
      knobPaint,
    );

    // Letreiro "Correios"
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Correios',
        style: TextStyle(
          color: Color(0xFF37474F),
          fontSize: 14,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.white, blurRadius: 3),
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
        82,
      ),
    );
  }
}
