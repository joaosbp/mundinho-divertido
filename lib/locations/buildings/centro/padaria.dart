import '../../../models/location_data.dart';
import '../../location_base.dart';

/// Padaria — local do Centro.
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
  void onPlayerEnter() {
    // TODO: som de sininho da porta, cheirinho animado (ícone)
  }
}
