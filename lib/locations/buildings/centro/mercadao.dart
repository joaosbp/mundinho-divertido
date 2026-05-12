import 'package:flame/components.dart';

import '../../../models/location_data.dart';
import '../../location_base.dart';
import '../building_sprite.dart';

/// Mercadão — local de compras com mini-jogo Lista de Compras.
class Mercadao extends LocationBase {
  Mercadao()
      : super(
          data: const LocationData(
            id: 'mercadao',
            name: 'Mercadão',
            districtId: 'centro',
            description: 'Mercado colorido com frutas, legumes e muitas delícias!',
            isUnlockedByDefault: true,
            minigameIds: ['lista_compras'],
          ),
        );

  @override
  void onPlayerEnter() {}

  @override
  void onPlayerExit() {}
}

/// Componente visual do Mercadão no mapa mundial.
class MercadaoExterior extends BuildingSprite {
  MercadaoExterior({required super.position})
      : super(
          size: Vector2(140, 110),
          spritePath: 'buildings/mercadao.png',
        );
}
