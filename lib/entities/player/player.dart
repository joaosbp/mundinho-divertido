import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Personagem jogável.
class Player extends SpriteComponent with HasGameReference {
  static const double _speed = 200.0;

  Vector2? _targetPosition;

  Player({required Vector2 position})
      : super(
          position: position,
          size: Vector2.all(48),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Placeholder: círculo colorido como sprite temporário
    // TODO: substituir por sprite real quando disponível
    sprite = await Sprite.load('player_placeholder.png');
  }

  @override
  void render(Canvas canvas) {
    // Render placeholder enquanto não há sprite
    final paint = Paint()..color = const Color(0xFFFF6B6B);
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      paint,
    );

    // Olhos simples
    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(const Offset(14, 16), 6, eyePaint);
    canvas.drawCircle(const Offset(34, 16), 6, eyePaint);

    final pupilPaint = Paint()..color = Colors.black;
    canvas.drawCircle(const Offset(14, 16), 3, pupilPaint);
    canvas.drawCircle(const Offset(34, 16), 3, pupilPaint);

    // Sorriso
    final smilePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawArc(
      Rect.fromCenter(center: const Offset(24, 28), width: 20, height: 12),
      0,
      3.14,
      false,
      smilePaint,
    );
  }

  void moveTo(Vector2 target) {
    _targetPosition = target;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_targetPosition != null) {
      final direction = _targetPosition! - position;
      final distance = direction.length;

      if (distance < 5) {
        _targetPosition = null;
      } else {
        direction.normalize();
        position += direction * _speed * dt;
      }
    }
  }
}
