import 'package:flame/components.dart';

import '../../../models/location_data.dart';
import '../../location_base.dart';
import '../building_sprite.dart';

/// Escola — local do Centro, hub de mini-jogos educativos.
class Escola extends LocationBase {
  Escola()
      : super(
          data: const LocationData(
            id: 'escola',
            name: 'Escola',
            districtId: 'centro',
            description: 'Prédio colorido com muro, playground e bandeira.',
            operatingHours: '07:00-17:00',
            npcIds: ['tia_julia'],
            isUnlockedByDefault: true,
          ),
        );

  @override
  void onPlayerEnter() {}

  @override
  void onPlayerExit() {}
}

/// Componente visual da Escola no mapa mundial.
class EscolaExterior extends BuildingSprite {
  EscolaExterior({required super.position})
      : super(
          size: Vector2(160, 140),
          spritePath: 'buildings/escola.png',
        );
}
