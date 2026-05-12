import 'package:flame/components.dart';

/// Representação do mapa da cidade (grid + objetos).
///
/// Placeholder para expansão futura com pathfinding e colisões.
class WorldMap extends Component {
  final Vector2 size;

  WorldMap({required this.size});

  bool isWalkable(Vector2 position) {
    // TODO: verificar colisões com prédios, água, etc.
    return position.x >= 0 &&
        position.y >= 0 &&
        position.x <= size.x &&
        position.y <= size.y;
  }
}
