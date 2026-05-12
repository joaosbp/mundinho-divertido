import '../../minigame_base.dart';

/// Mini-jogo: "Padeiro Mirim"
///
/// O jogador segue uma receita em 4 passos sequenciais:
/// 1. Misturar ingredientes (farinha, ovos, leite)
/// 2. Sovar a massa (10 toques)
/// 3. Assar no forno (3 segundos)
/// 4. Decorar com cobertura
///
/// A implementação visual está em [PadariaInteriorScene].
class PadeiroMirimMiniGame extends MiniGameBase {
  PadeiroMirimMiniGame()
      : super(
          id: 'padeiro_mirim',
          name: 'Padeiro Mirim',
          duration: const Duration(minutes: 3),
          skills: const ['sequencia', 'coordenacao_motora', 'atencao'],
        );

  @override
  void onStart() {
    // A lógica visual é gerenciada pelo PadariaInteriorScene.
  }

  @override
  MiniGameResult onComplete() {
    return const MiniGameResult(
      stars: 2,
      coins: 10,
      message: 'Parabéns! Você fez um delicioso bolo!',
    );
  }
}
