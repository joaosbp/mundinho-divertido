import '../../minigame_base.dart';

/// Mini-jogo: "Carteiro Express"
///
/// O jogador memoriza uma rota de 3 locais e repete a sequência
/// tocando nos ícones na ordem correta.
/// Implementação visual está em [CorreiosInteriorScene].
class CarteiroExpressMiniGame extends MiniGameBase {
  CarteiroExpressMiniGame()
      : super(
          id: 'carteiro_express',
          name: 'Carteiro Express',
          duration: const Duration(minutes: 2),
          skills: const ['memoria', 'sequencia', 'atencao'],
        );

  @override
  void onStart() {
    // A lógica visual é gerenciada pelo CorreiosInteriorScene.
  }

  @override
  MiniGameResult onComplete() {
    return const MiniGameResult(
      stars: 1,
      coins: 8,
      message: 'Parabéns! Você entregou todas as cartas!',
      extras: {'sticker': 'Carteiro Express'},
    );
  }
}
