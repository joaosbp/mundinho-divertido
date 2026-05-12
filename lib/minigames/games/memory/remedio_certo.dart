import '../../minigame_base.dart';

/// Mini-jogo: "Remédio Certo"
///
/// O jogador combina sintomas com os remédios corretos.
/// Implementação visual está em [FarmaciaInteriorScene].
class RemedioCertoMiniGame extends MiniGameBase {
  RemedioCertoMiniGame()
      : super(
          id: 'remedio_certo',
          name: 'Remédio Certo',
          duration: const Duration(minutes: 2),
          skills: const ['memoria', 'atencao', 'associacao'],
        );

  @override
  void onStart() {
    // A lógica visual é gerenciada pelo FarmaciaInteriorScene.
  }

  @override
  MiniGameResult onComplete() {
    return const MiniGameResult(
      stars: 1,
      coins: 5,
      message: 'Parabéns! Você acertou todos os remédios!',
      extras: {'sticker': 'Doutorzinho'},
    );
  }
}
