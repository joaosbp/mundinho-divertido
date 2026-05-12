import '../../../missions/mission_base.dart';

/// Missão M1: "O Bolo da Vovó Maria"
class MBoloVovoMaria extends MissionBase {
  MBoloVovoMaria()
      : super(
          id: 'M1',
          title: 'O Bolo da Vovó Maria',
          description: 'Vovó Maria precisa de ajuda para fazer um bolo para a festa da cidade.',
          arcId: 'city_awakens',
          steps: const [
            MissionStep(
              id: 'M1_S1',
              description: 'Ir ao Mercadão buscar ingredientes',
              targetLocationId: 'mercadao',
              minigameId: 'lista_compras',
            ),
            MissionStep(
              id: 'M1_S2',
              description: 'Ir à Padaria pegar farinha especial',
              targetLocationId: 'padaria',
              minigameId: 'padeiro_mirim',
            ),
            MissionStep(
              id: 'M1_S3',
              description: 'Levar o bolo para a Prefeitura',
              targetLocationId: 'prefeitura',
            ),
          ],
          rewards: const [
            MissionReward(stars: 1, coins: 15, itemId: 'chapeu_chef'),
          ],
        );
}
