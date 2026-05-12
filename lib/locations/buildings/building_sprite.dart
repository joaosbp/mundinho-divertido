import 'package:flame/components.dart';

/// Componente visual de um prédio/local no mapa mundial.
/// Usa sprite gerado por IA.
class BuildingSprite extends SpriteComponent with HasGameReference {
  final String spritePath;

  BuildingSprite({
    required Vector2 position,
    required Vector2 size,
    required this.spritePath,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite(spritePath);
  }
}
