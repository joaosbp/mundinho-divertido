import 'package:flame/components.dart';

/// Personagem jogável — Mundo.
/// Usa sprite gerado por IA (mundo_idle.png).
class Player extends SpriteComponent with HasGameReference {
  static const double _speed = 200.0;

  Vector2? _targetPosition;

  Player({required Vector2 position})
      : super(
          position: position,
          size: Vector2.all(64),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite('characters/player/mundo_idle.png');
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
