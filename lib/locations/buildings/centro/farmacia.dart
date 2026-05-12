import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../models/location_data.dart';
import '../../location_base.dart';

/// Farmácia — local de saúde com mini-jogo Remédio Certo.
class Farmacia extends LocationBase {
  Farmacia()
      : super(
          data: const LocationData(
            id: 'farmacia',
            name: 'Farmácia',
            districtId: 'centro',
            description: 'Farmácia com remédios coloridos e a Dra. Cássia!',
            isUnlockedByDefault: true,
            minigameIds: ['remedio_certo'],
          ),
        );

  @override
  void onPlayerEnter() {
    // Callback executado pela transição do MundinhoGame.
  }

  @override
  void onPlayerExit() {
    // Callback executado ao sair da farmácia.
  }
}

/// Componente visual da Farmácia no mapa mundial.
class FarmaciaExterior extends PositionComponent {
  FarmaciaExterior({required Vector2 position})
      : super(
          position: position,
          size: Vector2(140, 110),
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    // Parede principal (branca)
    final wallPaint = Paint()..color = const Color(0xFFFFFFFF);
    canvas.drawRect(
      Rect.fromLTWH(0, 25, size.x, size.y - 25),
      wallPaint,
    );

    // Borda da parede
    final wallBorder = Paint()
      ..color = const Color(0xFFCFD8DC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(
      Rect.fromLTWH(0, 25, size.x, size.y - 25),
      wallBorder,
    );

    // Cruz vermelha no topo
    final crossPaint = Paint()..color = const Color(0xFFE53935);
    final crossW = 36.0;
    final crossH = 12.0;
    final crossX = (size.x - crossW) / 2;
    final crossY = 4.0;
    // Horizontal
    canvas.drawRect(
      Rect.fromLTWH(crossX, crossY + crossW / 2 - crossH / 2, crossW, crossH),
      crossPaint,
    );
    // Vertical
    canvas.drawRect(
      Rect.fromLTWH(crossX + crossW / 2 - crossH / 2, crossY, crossH, crossW),
      crossPaint,
    );

    // Vitrine de remédios coloridos
    final vitrinePaint = Paint()..color = const Color(0xFFB3E5FC);
    canvas.drawRect(
      Rect.fromLTWH(10, 35, size.x - 20, 40),
      vitrinePaint,
    );
    final vitrineBorder = Paint()
      ..color = const Color(0xFF81D4FA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(
      Rect.fromLTWH(10, 35, size.x - 20, 40),
      vitrineBorder,
    );

    // Caixas de remédios coloridas na vitrine
    final remedioColors = [
      const Color(0xFFEF5350),
      const Color(0xFF42A5F5),
      const Color(0xFF66BB6A),
      const Color(0xFFFFCA28),
      const Color(0xFFAB47BC),
    ];
    for (int i = 0; i < remedioColors.length; i++) {
      final boxX = 18 + i * 24.0;
      final boxPaint = Paint()..color = remedioColors[i];
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(boxX, 40, 18, 28),
          const Radius.circular(3),
        ),
        boxPaint,
      );
      // Detalhe branco na caixa
      final detailPaint = Paint()..color = Colors.white.withValues(alpha: 0.4);
      canvas.drawRect(
        Rect.fromLTWH(boxX + 3, 46, 12, 4),
        detailPaint,
      );
    }

    // Porta de entrada
    final doorPaint = Paint()..color = const Color(0xFF90A4AE);
    canvas.drawRect(
      Rect.fromLTWH(size.x / 2 - 20, size.y - 50, 40, 50),
      doorPaint,
    );
    final doorBorder = Paint()
      ..color = const Color(0xFF78909C)
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

    // Letreiro "Farmácia"
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Farmácia',
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
        80,
      ),
    );
  }
}
