import 'package:flame/components.dart';

import '../../../models/location_data.dart';
import '../../location_base.dart';
import '../building_sprite.dart';

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
  void onPlayerEnter() {}

  @override
  void onPlayerExit() {}
}

/// Componente visual da Padaria no mapa mundial.
class PadariaExterior extends BuildingSprite {
  PadariaExterior({required super.position})
      : super(
          size: Vector2(140, 110),
          spritePath: 'buildings/padaria.png',
        );
}

/// Partículas de cheirinho (♨️) que sobem da padaria.
class CheirinhoParticles extends PositionComponent {
  final List<_CheirinhoParticle> _particles = [];
  double _spawnTimer = 0;

  CheirinhoParticles({required super.position})
      : super(
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
