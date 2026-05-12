import '../../minigame_base.dart';

/// Mini-jogo: "Lista de Compras"
///
/// O jogador memoriza uma lista de itens e depois os encontra nas prateleiras.
/// Implementação visual está em [MercadaoInteriorScene].
class ListaComprasMiniGame extends MiniGameBase {
  ListaComprasMiniGame()
      : super(
          id: 'lista_compras',
          name: 'Lista de Compras',
          duration: const Duration(minutes: 2),
          skills: const ['memoria', 'atencao', 'reconhecimento_visual'],
        );

  @override
  void onStart() {
    // A lógica visual é gerenciada pelo MercadaoInteriorScene.
  }

  @override
  MiniGameResult onComplete() {
    return const MiniGameResult(
      stars: 1,
      coins: 5,
      message: 'Parabéns! Você completou a lista de compras!',
    );
  }
}
