import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../models/location_data.dart';
import '../../location_base.dart';

/// Escola — local do Centro, hub de mini-jogos educativos.
class Escola extends LocationBase {
  Escola()
      : super(
          data: const LocationData(
            id: 'escola',
            name: 'Escola',
            districtId: 'centro',
            description: 'Prédio colorido com muro, playground e bandeira.',
            operatingHours: '07:00-17:00',
            npcIds: ['tia_julia'],
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

/// Componente visual da Escola no mapa mundial.
class EscolaExterior extends PositionComponent {
  EscolaExterior({
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2(160, 140),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Muro ao redor
    add(
      _Muro(
        position: Vector2(-20, size.y - 30),
        size: Vector2(size.x + 40, 30),
      ),
    );

    // Prédio principal
    add(
      _PredioEscola(
        position: Vector2(size.x / 2 - 60, 10),
        size: Vector2(120, 90),
      ),
    );

    // Playground — escorregador
    add(
      _Escorregador(
        position: Vector2(size.x - 50, size.y - 50),
        size: Vector2(40, 40),
      ),
    );

    // Playground — gangorra
    add(
      _Gangorra(
        position: Vector2(20, size.y - 45),
        size: Vector2(50, 30),
      ),
    );

    // Árvore
    add(
      _ArvoreEscola(
        position: Vector2(10, 20),
        size: Vector2(40, 50),
      ),
    );

    // Bandeira
    add(
      _BandeiraEscola(
        position: Vector2(size.x / 2 - 20, -15),
        size: Vector2(40, 28),
      ),
    );
  }
}

/// Muro ao redor da escola.
class _Muro extends PositionComponent {
  _Muro({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topLeft);

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color(0xFFBDBDBD);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);

    // Tijolinhos
    final brickPaint = Paint()
      ..color = const Color(0xFF9E9E9E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (int row = 0; row < 3; row++) {
      final y = row * (size.y / 3);
      canvas.drawLine(Offset(0, y), Offset(size.x, y), brickPaint);
      for (int col = 0; col < size.x / 12; col++) {
        final x = (col * 12 + (row % 2 == 0 ? 0 : 6)).toDouble();
        canvas.drawLine(Offset(x, y), Offset(x, y + size.y / 3), brickPaint);
      }
    }
  }
}

/// Prédio principal da escola.
class _PredioEscola extends PositionComponent {
  _PredioEscola({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topLeft);

  @override
  void render(Canvas canvas) {
    // Corpo (amarelo claro)
    final wallPaint = Paint()..color = const Color(0xFFFFF59D);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), wallPaint);

    // Telhado vermelho
    final roofPaint = Paint()..color = const Color(0xFFE53935);
    final roofPath = Path()
      ..moveTo(-10, 0)
      ..lineTo(size.x / 2, -20)
      ..lineTo(size.x + 10, 0)
      ..close();
    canvas.drawPath(roofPath, roofPaint);

    // Porta central
    final doorPaint = Paint()..color = const Color(0xFF5D4037);
    canvas.drawRect(
      Rect.fromLTWH(size.x / 2 - 14, size.y - 35, 28, 35),
      doorPaint,
    );

    // Maçaneta
    final knobPaint = Paint()..color = const Color(0xFFFFD54F);
    canvas.drawCircle(
      Offset(size.x / 2 + 6, size.y - 16),
      2.5,
      knobPaint,
    );

    // Janelas
    final windowPaint = Paint()..color = const Color(0xFF81D4FA);
    final windowFramePaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Janela esquerda
    canvas.drawRect(
      Rect.fromLTWH(15, 20, 30, 30),
      windowPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(15, 20, 30, 30),
      windowFramePaint,
    );
    canvas.drawLine(
      Offset(30, 20),
      Offset(30, 50),
      windowFramePaint,
    );
    canvas.drawLine(
      Offset(15, 35),
      Offset(45, 35),
      windowFramePaint,
    );

    // Janela direita
    canvas.drawRect(
      Rect.fromLTWH(size.x - 45, 20, 30, 30),
      windowPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.x - 45, 20, 30, 30),
      windowFramePaint,
    );
    canvas.drawLine(
      Offset(size.x - 30, 20),
      Offset(size.x - 30, 50),
      windowFramePaint,
    );
    canvas.drawLine(
      Offset(size.x - 45, 35),
      Offset(size.x - 15, 35),
      windowFramePaint,
    );
  }
}

/// Escorregador no playground.
class _Escorregador extends PositionComponent {
  _Escorregador({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topLeft);

  @override
  void render(Canvas canvas) {
    // Escada
    final ladderPaint = Paint()..color = const Color(0xFF757575);
    canvas.drawRect(Rect.fromLTWH(0, 0, 8, size.y), ladderPaint);
    canvas.drawRect(Rect.fromLTWH(20, 0, 8, size.y), ladderPaint);
    for (int i = 0; i < 4; i++) {
      canvas.drawRect(
        Rect.fromLTWH(0, i * 10 + 2, 28, 4),
        ladderPaint,
      );
    }

    // Rampa
    final slidePaint = Paint()..color = const Color(0xFF42A5F5);
    final path = Path()
      ..moveTo(28, 0)
      ..lineTo(size.x, size.y - 8)
      ..lineTo(size.x, size.y)
      ..lineTo(28, 8)
      ..close();
    canvas.drawPath(path, slidePaint);
  }
}

/// Gangorra no playground.
class _Gangorra extends PositionComponent {
  _Gangorra({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topLeft);

  double _tiltTimer = 0;

  @override
  void update(double dt) {
    super.update(dt);
    _tiltTimer += dt;
  }

  @override
  void render(Canvas canvas) {
    final tilt = sin(_tiltTimer * 2) * 0.08;

    // Base
    final basePaint = Paint()..color = const Color(0xFF757575);
    canvas.drawRect(
      Rect.fromLTWH(size.x / 2 - 4, size.y - 10, 8, 10),
      basePaint,
    );

    // Prancha
    canvas.save();
    canvas.translate(size.x / 2, size.y - 10);
    canvas.rotate(tilt);
    canvas.translate(-size.x / 2, -(size.y - 10));

    final plankPaint = Paint()..color = const Color(0xFF8D6E63);
    canvas.drawRect(
      Rect.fromLTWH(0, size.y - 16, size.x, 6),
      plankPaint,
    );

    // Assentos
    final seatPaint = Paint()..color = const Color(0xFFEF5350);
    canvas.drawRect(Rect.fromLTWH(4, size.y - 22, 12, 8), seatPaint);
    canvas.drawRect(Rect.fromLTWH(size.x - 16, size.y - 22, 12, 8), seatPaint);

    canvas.restore();
  }
}

/// Árvore decorativa.
class _ArvoreEscola extends PositionComponent {
  _ArvoreEscola({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topLeft);

  @override
  void render(Canvas canvas) {
    // Tronco
    final trunkPaint = Paint()..color = const Color(0xFF795548);
    canvas.drawRect(
      Rect.fromLTWH(size.x / 2 - 6, size.y * 0.4, 12, size.y * 0.6),
      trunkPaint,
    );

    // Copa
    final leafPaint = Paint()..color = const Color(0xFF66BB6A);
    canvas.drawCircle(
      Offset(size.x / 2, size.y * 0.3),
      size.x * 0.4,
      leafPaint,
    );
    canvas.drawCircle(
      Offset(size.x * 0.3, size.y * 0.4),
      size.x * 0.25,
      leafPaint,
    );
    canvas.drawCircle(
      Offset(size.x * 0.7, size.y * 0.4),
      size.x * 0.25,
      leafPaint,
    );
  }
}

/// Bandeira da escola com animação de tremulação.
class _BandeiraEscola extends PositionComponent {
  _BandeiraEscola({required Vector2 position, required Vector2 size})
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
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), greenPaint);

    // Losango amarelo
    final yellowPaint = Paint()..color = const Color(0xFFFFDF00);
    final diamondPath = Path()
      ..moveTo(size.x / 2, 3)
      ..lineTo(size.x - 3, size.y / 2)
      ..lineTo(size.x / 2, size.y - 3)
      ..lineTo(3, size.y / 2)
      ..close();
    canvas.drawPath(diamondPath, yellowPaint);

    // Círculo azul
    final bluePaint = Paint()..color = const Color(0xFF002776);
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.y * 0.22,
      bluePaint,
    );

    // Faixa branca simplificada
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.x / 2, size.y / 2 + 1),
        width: size.y * 0.32,
        height: size.y * 0.16,
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
      Rect.fromLTWH(size.x / 2 - 2, -14, 4, 16),
      polePaint,
    );
  }
}
