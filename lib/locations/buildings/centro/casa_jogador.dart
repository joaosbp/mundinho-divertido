import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../models/location_data.dart';
import '../../location_base.dart';

/// Casa do Jogador — primeiro local jogável do MVP.
class CasaJogador extends LocationBase {
  CasaJogador()
      : super(
          data: const LocationData(
            id: 'casa_jogador',
            name: 'Minha Casa',
            districtId: 'centro',
            description: 'Casa aconchegante com quarto e cozinha.',
            isUnlockedByDefault: true,
          ),
        );

  @override
  void onPlayerEnter() {
    // Callback executado pela transição do MundinhoGame.
  }

  @override
  void onPlayerExit() {
    // Callback executado ao sair da casa.
  }
}

/// Componente visual da Casa do Jogador no mapa mundial.
class CasaJogadorExterior extends PositionComponent {
  CasaJogadorExterior({required Vector2 position})
      : super(
          position: position,
          size: Vector2(120, 100),
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    // Parede
    final wallPaint = Paint()..color = const Color(0xFFD7CCC8);
    canvas.drawRect(
      Rect.fromLTWH(0, 30, size.x, size.y - 30),
      wallPaint,
    );

    // Telhado triangular
    final roofPaint = Paint()..color = const Color(0xFF8D6E63);
    final roofPath = Path()
      ..moveTo(-10, 30)
      ..lineTo(size.x / 2, 0)
      ..lineTo(size.x + 10, 30)
      ..close();
    canvas.drawPath(roofPath, roofPaint);

    // Porta
    final doorPaint = Paint()..color = const Color(0xFF5D4037);
    canvas.drawRect(
      Rect.fromLTWH(size.x / 2 - 15, size.y - 40, 30, 40),
      doorPaint,
    );

    // Janelas
    final windowPaint = Paint()..color = const Color(0xFF81D4FA);
    canvas.drawRect(
      Rect.fromLTWH(20, 45, 25, 25),
      windowPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.x - 45, 45, 25, 25),
      windowPaint,
    );
  }
}
