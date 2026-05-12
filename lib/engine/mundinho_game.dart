import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../core/services/audio_service.dart';
import '../core/services/save_service.dart';
import '../entities/player/player.dart';
import '../locations/buildings/centro/casa_jogador.dart';
import '../locations/location_manager.dart';

import 'interior_scene.dart';

/// FlameGame principal do Mundinho Divertido.
///
/// Responsável por:
/// - Inicializar o mundo e câmera
/// - Gerenciar o ciclo dia/noite
/// - Coordenar interações entre sistemas
/// - Gerenciar transições entre mundo e interior
class MundinhoGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  late Player _player;
  final Vector2 _worldSize = Vector2(1600, 1200);

  // Casa do Jogador
  late CasaJogadorExterior _casaExterior;
  final Vector2 _casaPosition = Vector2(300, 250);
  static const double _enterDistance = 100.0;
  bool _nearCasa = false;
  bool _inInterior = false;
  InteriorScene? _interiorScene;
  late TextComponent _enterHint;
  bool _hintAdded = false;

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

    // Adicionar Casa do Jogador ao mundo
    _casaExterior = CasaJogadorExterior(position: _casaPosition);
    await world.add(_casaExterior);

    // Dica "Entrar" próxima à casa
    _enterHint = TextComponent(
      text: 'Entrar',
      position: _casaPosition + Vector2(0, -80),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.black87, blurRadius: 4),
          ],
        ),
      ),
    );

    // Carregar save
    final save = SaveService();
    if (save.isInitialized) {
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

    // Detectar proximidade com casa
    if (!_inInterior) {
      final distance = _player.position.distanceTo(_casaPosition);
      _nearCasa = distance < _enterDistance;

      if (_nearCasa && !_hintAdded) {
        world.add(_enterHint);
        _hintAdded = true;
      } else if (!_nearCasa && _hintAdded) {
        _enterHint.removeFromParent();
        _hintAdded = false;
      }
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    // Ignora toques no mundo quando no interior
    if (_inInterior) return;

    final worldPos = camera.globalToLocal(event.canvasPosition);

    // Verificar toque na casa quando próximo
    if (_nearCasa) {
      final casaRect = Rect.fromCenter(
        center: Offset(_casaPosition.x, _casaPosition.y),
        width: _casaExterior.size.x,
        height: _casaExterior.size.y,
      );
      if (casaRect.contains(Offset(worldPos.x, worldPos.y))) {
        _enterInterior();
        return;
      }
    }

    // Toque no mundo = mover jogador
    _player.moveTo(worldPos);
  }

  /// Transiciona para o interior da Casa do Jogador.
  void _enterInterior() {
    _inInterior = true;

    // Remove dica se estiver visível
    if (_hintAdded) {
      _enterHint.removeFromParent();
      _hintAdded = false;
    }

    // Notifica o LocationManager
    LocationManager().enter('casa_jogador');

    // Cria cena de interior no viewport (fixo na tela)
    _interiorScene = InteriorScene(
      size: camera.viewport.size,
      onExit: _exitInterior,
    );
    camera.viewport.add(_interiorScene!);
    _interiorScene!.enter();
  }

  /// Sai do interior e volta ao mundo.
  void _exitInterior() {
    if (_interiorScene == null) return;

    camera.viewport.remove(_interiorScene!);
    _interiorScene = null;
    _inInterior = false;

    // Notifica o LocationManager
    LocationManager().exit('casa_jogador');

    // Reposiciona jogador em frente à casa
    _player.position = _casaPosition + Vector2(0, 100);
    _player.moveTo(_player.position);
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
