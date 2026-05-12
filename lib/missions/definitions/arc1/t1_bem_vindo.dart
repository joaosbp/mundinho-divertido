import '../../mission_base.dart';

/// Missão Tutorial: "Bem-vindo ao Mundinho!"
///
/// Passos:
/// 1. Falar com Prefeito Tico (toque no NPC)
/// 2. Visitar 2 locais: Casa do Jogador + Parque Central
/// 3. Voltar para Prefeitura e falar com Tico novamente
///
/// Recompensa: 1 estrela + 10 moedas
class TBemVindo extends MissionBase {
  TBemVindo()
      : super(
          id: 't1_bem_vindo',
          title: 'Bem-vindo ao Mundinho!',
          description:
              'O Prefeito Tico quer te conhecer! Fale com ele, explore a cidade e volte para reportar.',
          arcId: 'arc1',
          steps: const [
            MissionStep(
              id: 'falar_tico_primeira',
              description: 'Fale com o Prefeito Tico na Prefeitura',
              targetNpcId: 'prefeito_tico',
              targetLocationId: 'prefeitura',
            ),
            MissionStep(
              id: 'visitar_casa_parque',
              description: 'Visite a Casa do Jogador e o Parque Central',
              targetLocationId: 'casa_jogador,parque_central',
            ),
            MissionStep(
              id: 'falar_tico_final',
              description: 'Volte à Prefeitura e fale com o Prefeito Tico',
              targetNpcId: 'prefeito_tico',
              targetLocationId: 'prefeitura',
            ),
          ],
          rewards: const [
            MissionReward(stars: 1, coins: 10),
          ],
          isRepeatable: false,
        );

  @override
  void onStart() {
    // Missão iniciada — o HUD mostrará o indicador
  }

  @override
  void onStepComplete(int stepIndex) {
    // Passo completado
  }

  @override
  List<MissionReward> onComplete() {
    return rewards;
  }
}
