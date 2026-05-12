import 'package:flame/components.dart';

import '../../../models/location_data.dart';
import '../../location_base.dart';
import '../building_sprite.dart';

/// Prefeitura — local do Centro, hub de missões.
class Prefeitura extends LocationBase {
  Prefeitura()
      : super(
          data: const LocationData(
            id: 'prefeitura',
            name: 'Prefeitura',
            districtId: 'centro',
            description: 'Edifício grandão com bandeira do Brasil, escadaria colorida.',
            operatingHours: '08:00-18:00',
            npcIds: ['prefeito_tico'],
            isUnlockedByDefault: true,
          ),
        );

  @override
  void onPlayerEnter() {}

  @override
  void onPlayerExit() {}
}

/// Componente visual da Prefeitura no mapa mundial.
class PrefeituraExterior extends BuildingSprite {
  PrefeituraExterior({required super.position})
      : super(
          size: Vector2(140, 120),
          spritePath: 'buildings/prefeitura.png',
        );
}
