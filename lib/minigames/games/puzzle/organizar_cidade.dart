import '../../../minigames/minigame_base.dart';

/// Mini-jogo: "Organizar a Cidade"
class OrganizarCidadeMiniGame extends MiniGameBase {
  OrganizarCidadeMiniGame()
      : super(
          id: 'organizar_cidade',
          name: 'Organizar a Cidade',
          duration: const Duration(minutes: 3),
          skills: const ['categorizacao', 'raciocinio_espacial'],
        );

  @override
  void onStart() {
    // TODO: spawn elementos arrastáveis, configurar zonas de drop
  }

  @override
  MiniGameResult onComplete() {
    return const MiniGameResult(
      stars: 3,
      coins: 10,
      message: 'Parabéns! A cidade está organizada!',
    );
  }
}
