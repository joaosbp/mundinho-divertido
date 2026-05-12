import 'dart:async';

/// Resultado de um mini-jogo.
class MiniGameResult {
  final int stars; // 0-3
  final int coins;
  final String message;
  final Map<String, dynamic>? extras;

  const MiniGameResult({
    required this.stars,
    required this.coins,
    required this.message,
    this.extras,
  });
}

/// Classe base para todos os mini-jogos.
///
/// Cada mini-jogo estende esta classe e registra-se no [MiniGameManager].
abstract class MiniGameBase {
  final String id;
  final String name;
  final Duration duration;
  final List<String> skills; // habilidades trabalhadas

  MiniGameBase({
    required this.id,
    required this.name,
    this.duration = const Duration(minutes: 2),
    this.skills = const [],
  });

  /// Chamado quando o mini-jogo inicia.
  void onStart() {
    // Override em subclasses
  }

  /// Chamado a cada frame do mini-jogo.
  void update(double dt) {
    // Override em subclasses
  }

  /// Chamado quando o mini-jogo termina (sucesso, timeout ou abandono).
  MiniGameResult onComplete() {
    return const MiniGameResult(
      stars: 1,
      coins: 5,
      message: 'Bom trabalho!',
    );
  }

  /// Chamado quando o jogador abandona.
  MiniGameResult onAbandon() {
    return const MiniGameResult(
      stars: 0,
      coins: 0,
      message: 'Tente de novo quando quiser!',
    );
  }
}
