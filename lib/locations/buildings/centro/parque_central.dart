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
    required super.position,
    required super.size,
    this.onInteract,
  }) : super(anchor: Anchor.topLeft);

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

    // Árvores decorativas
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

/// Árvore decorativa usando sprite.
class TreeDecoration extends SpriteComponent with HasGameReference {
  TreeDecoration({required super.position})
      : super(
          size: Vector2.all(48),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite('buildings/arvore.png');
  }
}

/// Banco interativo usando sprite.
class Banco extends SpriteComponent with TapCallbacks, HasGameReference {
  final VoidCallback onTap;

  Banco({
    required super.position,
    required this.onTap,
  }) : super(
          size: Vector2(50, 30),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite('buildings/banco.png');
  }

  @override
  void onTapDown(TapDownEvent event) {
    event.handled = true;
    onTap();
  }
}

/// Escorregador interativo usando sprite.
class Escorregador extends SpriteComponent with TapCallbacks, HasGameReference {
  final VoidCallback onTap;

  Escorregador({
    required super.position,
    required this.onTap,
  }) : super(
          size: Vector2(60, 80),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite('buildings/escorregador.png');
  }

  @override
  void onTapDown(TapDownEvent event) {
    event.handled = true;
    onTap();
  }
}

/// Fonte com partículas de água animadas usando sprite.
class Fonte extends SpriteComponent with HasGameReference {
  Fonte({required super.position})
      : super(
          size: Vector2(60, 60),
          anchor: Anchor.center,
        );

  final List<_WaterParticle> _particles = [];
  double _spawnTimer = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite('buildings/fonte_parque.png');
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
      particle.speed *= 0.98;
    }

    _particles.removeWhere((p) => p.life <= 0);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Partículas de água sobre o sprite
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
