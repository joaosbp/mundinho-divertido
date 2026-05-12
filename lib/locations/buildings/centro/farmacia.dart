import 'package:flame/components.dart';

import '../../../models/location_data.dart';
import '../../location_base.dart';
import '../building_sprite.dart';

/// Farmácia — local de saúde com mini-jogo Remédio Certo.
class Farmacia extends LocationBase {
  Farmacia()
      : super(
          data: const LocationData(
            id: 'farmacia',
            name: 'Farmácia',
            districtId: 'centro',
            description: 'Farmácia com remédios coloridos e a Dra. Cássia!',
            isUnlockedByDefault: true,
            minigameIds: ['remedio_certo'],
          ),
        );

  @override
  void onPlayerEnter() {}

  @override
  void onPlayerExit() {}
}

/// Componente visual da Farmácia no mapa mundial.
class FarmaciaExterior extends BuildingSprite {
  FarmaciaExterior({required super.position})
      : super(
          size: Vector2(140, 110),
          spritePath: 'buildings/farmacia.png',
        );
}
