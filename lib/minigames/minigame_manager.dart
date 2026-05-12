import 'dart:developer' as developer;

import '../core/services/analytics_service.dart';
import 'minigame_base.dart';

/// Registro e launcher de mini-jogos.
class MiniGameManager {
  static final MiniGameManager _instance = MiniGameManager._internal();
  factory MiniGameManager() => _instance;
  MiniGameManager._internal();

  final Map<String, MiniGameBase Function()> _registry = {};

  /// Registra um mini-jogo com factory.
  void register(String id, MiniGameBase Function() factory) {
    _registry[id] = factory;
    developer.log('Minigame registered: $id');
  }

  /// Verifica se o mini-jogo existe.
  bool has(String id) => _registry.containsKey(id);

  /// Cria uma instância do mini-jogo.
  MiniGameBase? create(String id) {
    final factory = _registry[id];
    if (factory == null) {
      developer.log('Minigame not found: $id');
      return null;
    }
    final game = factory();
    AnalyticsService().logMinigameStart(id);
    return game;
  }

  /// Retorna IDs de todos os mini-jogos registrados.
  List<String> get allIds => List.unmodifiable(_registry.keys);
}
