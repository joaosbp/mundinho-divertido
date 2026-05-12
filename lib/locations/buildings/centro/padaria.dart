import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../models/location_data.dart';
import '../../location_base.dart';

/// Padaria — local do Centro com mini-jogo Padeiro Mirim.
class Padaria extends LocationBase {
  Padaria()
      : super(
          data: const LocationData(
            id: 'padaria',
            name: 'Pão Quentinho',
            districtId: 'centro',
            description: 'Forno à vista, cheirinho de pão, vitrine de doces.',
            operatingHours: '05:00-20:00',
            npcIds: ['dona_rosa', 'padeiro_tiago'],
            minigameIds: ['padeiro_mirim'],
            isUnlockedByDefault: true,
          ),
        );

  @override
  void onPlayerEnter() {
    // Som de sininho da porta, cheirinho animado (ícone)
  }

  @override
  void onPlayerExit() {
    // Callback ao sair da padaria
  }
}

/// Componente visual da Padaria no mapa mundial.
class PadariaExterior extends PositionComponent {
  PadariaExterior({required Vector2 position})
      : super(
          position: position,
          size: Vector2(140, 110),
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    // Parede principal (amarelo-claro/pão)
    final wallPaint = Paint()..color = const Color(0xFFFFF8E1);
    canvas.drawRect(
      Rect.fromLTWH(0, 20, size.x, size.y - 20),
      wallPaint,
    );

    // Telhado marrom
    final roofPaint = Paint()..color = const Color(0xFF8D6E63);
    final roofPath = Path()
      ..moveTo(-10, 20)
      ..lineTo(size.x / 2, -5)
      ..lineTo(size.x + 10, 20)
      ..close();
    canvas.drawPath(roofPath, roofPaint);

    // Borda do telhado
    final roofBorder = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(roofPath, roofBorder);

    // Forno visível (lado esquerdo, retângulo cinza com luz laranja)
    final fornoPaint = Paint()..color = const Color(0xFF616161);
    canvas.drawRect(
      Rect.fromLTWH(10, 45, 35, 40),
      fornoPaint,
    );
    // Abertura do forno
    final fornoAberturaPaint = Paint()..color = const Color(0xFF424242);
    canvas.drawRect(
      Rect.fromLTWH(15, 50, 25, 30),
      fornoAberturaPaint,
    );
    // Luz do forno (laranja brilhante)
    final fornoLuzPaint = Paint()..color = const Color(0xFFFF9800);
    canvas.drawRect(
      Rect.fromLTWH(18, 55, 19, 20),
      fornoLuzPaint,
    );

    // Vitrine de doces (lado direito)
    final vitrinePaint = Paint()..color = const Color(0xFFB3E5FC);
    canvas.drawRect(
      Rect.fromLTWH(size.x - 55, 40, 45, 45),
      vitrinePaint,
    );
    // Borda da vitrine
    final vitrineBorder = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(
      Rect.fromLTWH(size.x - 55, 40, 45, 45),
      vitrineBorder,
    );

    // Doces coloridos na vitrine
    final doces = [
      const Color(0xFFF48FB1), // rosa
      const Color(0xFFCE93D8), // roxo
      const Color(0xFF90CAF9), // azul
      const Color(0xFFA5D6A7), // verde
    ];
    for (int i = 0; i < doces.length; i++) {
      final docePaint = Paint()..color = doces[i];
      canvas.drawCircle(
        Offset(size.x - 47 + (i % 2) * 18, 50 + (i ~/ 2) * 18),
        6,
        docePaint,
      );
    }

    // Porta de entrada (centro, abaixo)
    final doorPaint = Paint()..color = const Color(0xFF8D6E63);
    canvas.drawRect(
      Rect.fromLTWH(size.x / 2 - 18, size.y - 50, 36, 50),
      doorPaint,
    );

    // Maçaneta
    final knobPaint = Paint()..color = const Color(0xFFFFD54F);
    canvas.drawCircle(
      Offset(size.x / 2 + 10, size.y - 25),
      4,
      knobPaint,
    );

    // Letreiro "Pão Quentinho"
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Pão Quentinho',
        style: TextStyle(
          color: Color(0xFF5D4037),
          fontSize: 12,
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
        5,
      ),
    );
  }
}

/// Partículas de cheirinho (♨️) que sobem da padaria.
class CheirinhoParticles extends PositionComponent {
  final List<_CheirinhoParticle> _particles = [];
  double _spawnTimer = 0;

  CheirinhoParticles({required Vector2 position})
      : super(
          position: position,
          size: Vector2(60, 80),
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);

    _spawnTimer += dt;
    if (_spawnTimer > 1.2) {
      _spawnTimer = 0;
      _particles.add(_CheirinhoParticle(
        x: size.x / 2 + (_randomOffset()),
        y: size.y - 10,
      ));
    }

    for (final p in _particles) {
      p.y -= 20 * dt;
      p.life -= dt;
      p.opacity = (p.life / 2.0).clamp(0.0, 1.0);
    }

    _particles.removeWhere((p) => p.life <= 0);
  }

  double _randomOffset() {
    return (DateTime.now().millisecond % 20 - 10).toDouble();
  }

  @override
  void render(Canvas canvas) {
    for (final p in _particles) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: '♨️',
          style: TextStyle(
            fontSize: 14 + (2.0 - p.life) * 4,
            color: Colors.white.withValues(alpha: p.opacity * 0.7),
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(p.x - textPainter.width / 2, p.y),
      );
    }
  }
}

class _CheirinhoParticle {
  double x;
  double y;
  double life;
  double opacity;

  _CheirinhoParticle({required this.x, required this.y})
      : life = 2.0,
        opacity = 1.0;
}
