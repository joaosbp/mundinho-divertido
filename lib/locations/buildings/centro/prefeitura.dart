import '../../../models/location_data.dart';
import '../../location_base.dart';

/// Prefeitura — local do Centro.
class Prefeitura extends LocationBase {
  Prefeitura()
      : super(
          data: const LocationData(
            id: 'prefeitura',
            name: 'Prefeitura',
            districtId: 'centro',
            description: 'Edifício grandão com bandeira do Brasil, escadaria colorida.',
            operatingHours: '08:00-18:00',
            npcIds: ['prefeito_tico', 'secretaria_ana'],
            minigameIds: ['organizar_cidade'],
            isUnlockedByDefault: true,
          ),
        );

  @override
  void onPlayerEnter() {
    // TODO: tocar som ambiente, mostrar interior
  }

  @override
  void onPlayerExit() {
    // TODO: parar som ambiente
  }
}
