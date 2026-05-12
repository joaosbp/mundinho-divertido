import 'package:flame/components.dart';

import '../../../models/location_data.dart';
import '../../location_base.dart';
import '../building_sprite.dart';

/// Correios — local com mini-jogo Carteiro Express.
class Correios extends LocationBase {
  Correios()
      : super(
          data: const LocationData(
            id: 'correios',
            name: 'Correios',
            districtId: 'centro',
            description: 'Correios com caixa amarela gigante e o Seu Correio!',
            isUnlockedByDefault: true,
            minigameIds: ['carteiro_express'],
          ),
        );

  @override
  void onPlayerEnter() {}

  @override
  void onPlayerExit() {}
}

/// Componente visual dos Correios no mapa mundial.
class CorreiosExterior extends BuildingSprite {
  CorreiosExterior({required super.position})
      : super(
          size: Vector2(140, 110),
          spritePath: 'buildings/correios.png',
        );
}
