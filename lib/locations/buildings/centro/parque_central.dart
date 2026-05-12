import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../../../models/location_data.dart';
import '../../location_base.dart';

/// Parque Central — área de mundo aberto com elementos interativos.
class ParqueCentral extends LocationBase {
  ParqueCentral()
      : super(
          data: const LocationData(
            id: 'parque_central',
            name: 'Parque Central',
            districtId: 'centro',
            description: 'Parque arborizado com bancos, escorregador e fonte.',
            isUnlockedByDefault: true,
          ),
        );
}

/// Componente visual do Parque Central no mapa mundial.
class ParqueCentralArea extends PositionComponent {
  final void Function(String interactionType, Vector2 position)? onInteract;

  ParqueCentralArea({
    required Vector2 position,
    required Vector2 size,
    this.onInteract,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.topLeft,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Grama mais clara do parque
    add(
      RectangleComponent(
        position: Vector2.zero(),
        size: size,
        paint: Paint()..color = const Color(0xFF9CCC65),
      ),
    );

    // Árvores decorativas (círculos verdes)
    final treePositions = [
      Vector2(30, 30),
      Vector2(size.x - 50, 40),
      Vector2(50, size.y - 60),
      Vector2(size.x - 60, size.y - 50),
      Vector2(size.x / 2 - 20, 20),
    ];

    for (final treePos in treePositions) {
      add(TreeDecoration(position: treePos));
    }

    // Banco
    add(
      Banco(
        position: Vector2(size.x * 0.15, size.y * 0.4),
        onTap: () => onInteract?.call('banco', Vector2(size.x * 0.15, size.y * 0.4)),
      ),
    );

    // Escorregador
    add(
      Escorregador(
        position: Vector2(size.x * 0.65, size.y * 0.15),
        onTap: () => onInteract?.call('escorregador', Vector2(size.x * 0.65, size.y * 0.15)),
      ),
    );

    // Fonte
    add(Fonte(position: Vector2(size.x * 0.45, size.y * 0.6)));
  }

  /// Retorna os bounds do parque para patrulha do NPC.
  Rect get patrolBounds => Rect.fromLTWH(
        position.x + 20,
        position.y + 20,
        size.x - 40,
        size.y - 40,
      );
}

/// Árvore decorativa (placeholder visual).
class TreeDecoration extends PositionComponent {
  TreeDecoration({required Vector2 position})
      : super(
          position: position,
          size: Vector2.all(36),
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    // Tronco
    final trunkPaint = Paint()..color = const Color(0xFF795548);
    canvas.drawRect(
      Rect.fromCenter(center: Offset(size.x / 2, size.y - 8), width: 8, height: 16),
      trunkPaint,
    );

    // Copa
    final leafPaint = Paint()..color = const Color(0xFF2E7D32);
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2 - 4),
      size.x / 2.2,
      leafPaint,
    );
  }
}

/// Banco interativo.
class Banco extends PositionComponent with TapCallbacks {
  final VoidCallback onTap;

  Banco({
    required Vector2 position,
    required this.onTap,
  }) : super(
          position: position,
          size: Vector2(50, 24),
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    // Assento
    final seatPaint = Paint()..color = const Color(0xFF8D6E63);
    canvas.drawRect(
      Rect.fromCenter(center: Offset(size.x / 2, size.y / 2 - 2), width: size.x, height: 10),
      seatPaint,
    );

    // Encosto
    canvas.drawRect(
      Rect.fromCenter(center: Offset(size.x / 2, size.y / 2 - 10), width: size.x, height: 6),
      seatPaint,
    );

    // Pernas
    final legPaint = Paint()..color = const Color(0xFF5D4037);
    canvas.drawRect(
      Rect.fromCenter(center: Offset(6, size.y - 4), width: 4, height: 8),
      legPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset(size.x - 6, size.y - 4), width: 4, height: 8),
      legPaint,
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    event.handled = true;
    onTap();
  }
}

/// Escorregador interativo.
class Escorregador extends PositionComponent with TapCallbacks {
  final VoidCallback onTap;

  Escorregador({
    required Vector2 position,
    required this.onTap,
  }) : super(
          position: position,
          size: Vector2(60, 80),
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    // Escada (lado esquerdo)
    final ladderPaint = Paint()..color = const Color(0xFF78909C);
    canvas.drawRect(
      Rect.fromLTWH(4, 0, 6, size.y),
      ladderPaint,
    );

    // Degraus
    for (int i = 0; i < 5; i++) {
      canvas.drawRect(
        Rect.fromLTWH(0, 10 + i * 14, 14, 3),
        ladderPaint,
      );
    }

    // Rampa (diagonal)
    final slidePaint = Paint()
      ..color = const Color(0xFF29B6F6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(20, 0)
      ..lineTo(size.x - 4, size.y - 10);
    canvas.drawPath(path, slidePaint);

    // Topo da rampa
    final topPaint = Paint()..color = const Color(0xFF0288D1);
    canvas.drawRect(
      Rect.fromLTWH(16, -2, 12, 6),
      topPaint,
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    event.handled = true;
    onTap();
  }
}

/// Fonte com partículas de água animadas.
class Fonte extends PositionComponent {
  Fonte({required Vector2 position})
      : super(
          position: position,
          size: Vector2(60, 60),
          anchor: Anchor.center,
        );

  final List<_WaterParticle> _particles = [];
  double _spawnTimer = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _spawnTimer += dt;
    if (_spawnTimer > 0.15) {
      _spawnTimer = 0;
      _particles.add(_WaterParticle(
        x: size.x / 2 + (Random().nextDouble() - 0.5) * 16,
        y: size.y / 2 - 8,
        speed: 40 + Random().nextDouble() * 30,
      ));
    }

    for (final particle in _particles) {
      particle.y -= particle.speed * dt;
      particle.life -= dt;
      particle.speed *= 0.98; // desacelera
    }

    _particles.removeWhere((p) => p.life <= 0);
  }

  @override
  void render(Canvas canvas) {
    // Base da fonte
    final basePaint = Paint()..color = const Color(0xFFB0BEC5);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.x / 2, size.y / 2 + 8), width: size.x, height: 24),
      basePaint,
    );

    // Topo da fonte (pilastra)
    final pillarPaint = Paint()..color = const Color(0xFF90A4AE);
    canvas.drawRect(
      Rect.fromCenter(center: Offset(size.x / 2, size.y / 2 - 4), width: 14, height: 20),
      pillarPaint,
    );

    // Partículas de água
    for (final particle in _particles) {
      final alpha = (particle.life / 1.2 * 255).clamp(0, 255).toInt();
      final waterPaint = Paint()
        ..color = Color.fromARGB(alpha, 66, 165, 245);
      canvas.drawCircle(
        Offset(particle.x, particle.y),
        3 + (1 - particle.life / 1.2) * 2,
        waterPaint,
      );
    }
  }
}

class _WaterParticle {
  double x;
  double y;
  double speed;
  double life;

  _WaterParticle({
    required this.x,
    required this.y,
    required this.speed,
    this.life = 1.2,
  });
}
