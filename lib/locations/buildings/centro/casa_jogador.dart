import 'package:flame/components.dart';

import '../../../models/location_data.dart';
import '../../location_base.dart';
import '../building_sprite.dart';

/// Casa do Jogador — primeiro local jogável do MVP.
class CasaJogador extends LocationBase {
  CasaJogador()
      : super(
          data: const LocationData(
            id: 'casa_jogador',
            name: 'Minha Casa',
            districtId: 'centro',
            description: 'Casa aconchegante com quarto e cozinha.',
            isUnlockedByDefault: true,
          ),
        );

  @override
  void onPlayerEnter() {}

  @override
  void onPlayerExit() {}
}

/// Componente visual da Casa do Jogador no mapa mundial.
class CasaJogadorExterior extends BuildingSprite {
  CasaJogadorExterior({required super.position})
      : super(
          size: Vector2(120, 100),
          spritePath: 'buildings/casa_jogador.png',
        );
}
