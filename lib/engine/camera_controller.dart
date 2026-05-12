import 'package:flame/components.dart';

/// Controle de câmera com bounds do mundo.
class CameraController {
  final Vector2 worldSize;
  final Vector2 viewportSize;

  CameraController({
    required this.worldSize,
    required this.viewportSize,
  });

  /// Limita a posição da câmera para não mostrar área fora do mundo.
  Vector2 clampPosition(Vector2 position) {
    final minX = viewportSize.x / 2;
    final minY = viewportSize.y / 2;
    final maxX = worldSize.x - viewportSize.x / 2;
    final maxY = worldSize.y - viewportSize.y / 2;

    return Vector2(
      position.x.clamp(minX, maxX),
      position.y.clamp(minY, maxY),
    );
  }
}
