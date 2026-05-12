import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../core/services/audio_service.dart';
import '../core/services/save_service.dart';
import '../entities/player/player.dart';

/// FlameGame principal do Mundinho Divertido.
///
/// Responsável por:
/// - Inicializar o mundo e câmera
/// - Gerenciar o ciclo dia/noite
/// - Coordenar interações entre sistemas
class MundinhoGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  late Player _player;
  final Vector2 _worldSize = Vector2(1600, 1200);

  // Ciclo dia/noite (15 min reais = 1 dia no jogo)
  double _dayTime = 0.0; // 0.0 = 06:00, 0.5 = 12:00, 1.0 = 18:00, etc.
  static const double _dayDurationSeconds = 15 * 60; // 15 minutos

  int get gameHour => (6 + (_dayTime * 24).toInt()) % 24;
  bool get isDaytime => gameHour >= 6 && gameHour < 18;

  @override
  Color backgroundColor() => const Color(0xFF87CEEB);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Configurar câmera para seguir o jogador
    camera.viewfinder.anchor = Anchor.topLeft;

    // Adicionar mundo
    await world.add(_buildWorld());

    // Criar jogador
    _player = Player(position: Vector2(_worldSize.x / 2, _worldSize.y / 2));
    await world.add(_player);

    // Câmera segue o jogador
    camera.follow(_player);

    // Carregar save
    final save = SaveService();
    if (save.isInitialized) {
      final playerData = save.playerData;
      // TODO: aplicar dados salvos (posição, aparência, etc.)
    }

    // Áudio ambiente
    AudioService().playMusic('ambient');
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Atualizar ciclo dia/noite
    _dayTime += dt / _dayDurationSeconds;
    if (_dayTime >= 1.0) _dayTime -= 1.0;

    // TODO: atualizar cores do céu conforme horário
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    // Toque no mundo = mover jogador
    final worldPos = camera.globalToLocal(event.canvasPosition);
    _player.moveTo(worldPos);
  }

  Component _buildWorld() {
    final world = PositionComponent();

    // Chão/grama
    world.add(
      RectangleComponent(
        position: Vector2.zero(),
        size: _worldSize,
        paint: Paint()..color = const Color(0xFF7CB342),
      ),
    );

    // Ruas (placeholder visual)
    world.add(
      RectangleComponent(
        position: Vector2(_worldSize.x / 2 - 40, 0),
        size: Vector2(80, _worldSize.y),
        paint: Paint()..color = const Color(0xFF9E9E9E),
      ),
    );
    world.add(
      RectangleComponent(
        position: Vector2(0, _worldSize.y / 2 - 40),
        size: Vector2(_worldSize.x, 80),
        paint: Paint()..color = const Color(0xFF9E9E9E),
      ),
    );

    // TODO: Adicionar prédios, NPCs, objetos interativos

    return world;
  }

  void pauseGame() {
    pauseEngine();
    AudioService().stopMusic();
  }

  void resumeGame() {
    resumeEngine();
    AudioService().playMusic('ambient');
  }
}
