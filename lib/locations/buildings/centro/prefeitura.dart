import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../models/location_data.dart';
import '../../location_base.dart';

/// Prefeitura — local do Centro, hub de missões.
class Prefeitura extends LocationBase {
  Prefeitura()
      : super(
          data: const LocationData(
            id: 'prefeitura',
            name: 'Prefeitura',
            districtId: 'centro',
            description: 'Edifício grandão com bandeira do Brasil, escadaria colorida.',
            operatingHours: '08:00-18:00',
            npcIds: ['prefeito_tico'],
            isUnlockedByDefault: true,
          ),
        );

  @override
  void onPlayerEnter() {
    // Som ambiente gerenciado pela cena de interior
  }

  @override
  void onPlayerExit() {
    // Limpeza gerenciada pela cena de interior
  }
}

/// Componente visual da Prefeitura no mapa mundial.
class PrefeituraExterior extends PositionComponent {
  PrefeituraExterior({
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2(140, 120),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Escadaria (base)
    add(
      _Escadaria(
        position: Vector2(size.x / 2 - 50, size.y - 20),
        size: Vector2(100, 20),
      ),
    );

    // Corpo principal do prédio
    add(
      _PredioCorpo(
        position: Vector2(size.x / 2 - 60, 20),
        size: Vector2(120, 80),
      ),
    );

    // Colunas
    add(
      _Coluna(
        position: Vector2(size.x / 2 - 45, 20),
        size: Vector2(12, 80),
      ),
    );
    add(
      _Coluna(
        position: Vector2(size.x / 2 - 6, 20),
        size: Vector2(12, 80),
      ),
    );
    add(
      _Coluna(
        position: Vector2(size.x / 2 + 33, 20),
        size: Vector2(12, 80),
      ),
    );

    // Bandeira do Brasil animada no topo
    add(
      _BandeiraBrasil(
        position: Vector2(size.x / 2 - 30, -10),
        size: Vector2(60, 36),
      ),
    );
  }
}

/// Escadaria da prefeitura.
class _Escadaria extends PositionComponent {
  _Escadaria({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topLeft);

  @override
  void render(Canvas canvas) {
    // Degraus
    final paint = Paint()..color = const Color(0xFFBDBDBD);
    for (int i = 0; i < 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(0, i * 7, size.x, 7),
        paint,
      );
    }
  }
}

/// Corpo principal do prédio (retângulo cinza).
class _PredioCorpo extends PositionComponent {
  _PredioCorpo({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topLeft);

  @override
  void render(Canvas canvas) {
    // Parede cinza
    final wallPaint = Paint()..color = const Color(0xFF9E9E9E);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      wallPaint,
    );

    // Topo triangular
    final roofPaint = Paint()..color = const Color(0xFF757575);
    final roofPath = Path()
      ..moveTo(-8, 0)
      ..lineTo(size.x / 2, -20)
      ..lineTo(size.x + 8, 0)
      ..close();
    canvas.drawPath(roofPath, roofPaint);

    // Porta central
    final doorPaint = Paint()..color = const Color(0xFF5D4037);
    canvas.drawRect(
      Rect.fromLTWH(size.x / 2 - 12, size.y - 30, 24, 30),
      doorPaint,
    );

    // Maçaneta
    final knobPaint = Paint()..color = const Color(0xFFFFD54F);
    canvas.drawCircle(
      Offset(size.x / 2 + 6, size.y - 14),
      2,
      knobPaint,
    );
  }
}

/// Coluna decorativa da prefeitura.
class _Coluna extends PositionComponent {
  _Coluna({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topLeft);

  @override
  void render(Canvas canvas) {
    // Corpo da coluna
    final colPaint = Paint()..color = const Color(0xFFE0E0E0);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      colPaint,
    );

    // Base
    final basePaint = Paint()..color = const Color(0xFFBDBDBD);
    canvas.drawRect(
      Rect.fromLTWH(-3, size.y - 6, size.x + 6, 6),
      basePaint,
    );

    // Capitel
    canvas.drawRect(
      Rect.fromLTWH(-3, 0, size.x + 6, 6),
      basePaint,
    );
  }
}

/// Bandeira do Brasil com animação de tremulação.
class _BandeiraBrasil extends PositionComponent {
  _BandeiraBrasil({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topLeft);

  double _waveTimer = 0;

  @override
  void update(double dt) {
    super.update(dt);
    _waveTimer += dt;
  }

  @override
  void render(Canvas canvas) {
    final wave = sin(_waveTimer * 4) * 0.15;
    final scaleX = 1.0 + wave.abs();

    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    canvas.scale(scaleX, 1.0);
    canvas.translate(-size.x / 2, -size.y / 2);

    // Fundo verde
    final greenPaint = Paint()..color = const Color(0xFF009C3B);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      greenPaint,
    );

    // Losango amarelo
    final yellowPaint = Paint()..color = const Color(0xFFFFDF00);
    final diamondPath = Path()
      ..moveTo(size.x / 2, 4)
      ..lineTo(size.x - 4, size.y / 2)
      ..lineTo(size.x / 2, size.y - 4)
      ..lineTo(4, size.y / 2)
      ..close();
    canvas.drawPath(diamondPath, yellowPaint);

    // Círculo azul
    final bluePaint = Paint()..color = const Color(0xFF002776);
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.y * 0.25,
      bluePaint,
    );

    // Faixa branca (simplificada)
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.x / 2, size.y / 2 + 2),
        width: size.y * 0.35,
        height: size.y * 0.2,
      ),
      2.8,
      1.8,
      false,
      whitePaint,
    );

    canvas.restore();

    // Mastro
    final polePaint = Paint()..color = const Color(0xFF616161);
    canvas.drawRect(
      Rect.fromLTWH(size.x / 2 - 2, -16, 4, 20),
      polePaint,
    );
  }
}
