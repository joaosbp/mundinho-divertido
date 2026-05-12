import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../core/services/audio_service.dart';
import '../core/services/save_service.dart';
import '../entities/npcs/cidadao_parque.dart';
import '../entities/npcs/npc_base.dart';
import '../entities/player/player.dart';
import '../locations/buildings/centro/casa_jogador.dart';
import '../locations/buildings/centro/mercadao.dart';
import '../locations/buildings/centro/padaria.dart';
import '../locations/buildings/centro/parque_central.dart';
import '../locations/location_manager.dart';
import '../ui/dialogs/npc_dialogue.dart';

import 'interior_scene.dart';
import 'mercadao_interior_scene.dart';
import 'padaria_interior_scene.dart';

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

  // Parque Central
  late ParqueCentralArea _parqueArea;
  final Vector2 _parquePosition = Vector2(600, 400);
  final Vector2 _parqueSize = Vector2(300, 240);
  static const double _parqueInteractDistance = 120.0;
  bool _nearParque = false;
  late TextComponent _parqueHint;
  bool _parqueHintAdded = false;

  // Mercadão
  late MercadaoExterior _mercadaoExterior;
  final Vector2 _mercadaoPosition = Vector2(900, 300);
  static const double _mercadaoEnterDistance = 100.0;
  bool _nearMercadao = false;
  late TextComponent _mercadaoHint;
  bool _mercadaoHintAdded = false;
  MercadaoInteriorScene? _mercadaoInteriorScene;

  // Padaria
  late PadariaExterior _padariaExterior;
  late CheirinhoParticles _padariaCheirinho;
  final Vector2 _padariaPosition = Vector2(1100, 500);
  static const double _padariaEnterDistance = 100.0;
  bool _nearPadaria = false;
  late TextComponent _padariaHint;
  bool _padariaHintAdded = false;
  PadariaInteriorScene? _padariaInteriorScene;

  // NPC
  late CidadaoParque _cidadao;

  // Diálogo
  NpcDialogueOverlay? _dialogueOverlay;
  bool _isDialogueOpen = false;

  // Player animation states
  bool _isSitting = false;
  double _sitTimer = 0;
  bool _isSliding = false;
  double _slideTimer = 0;
  Vector2? _slideTarget;
  static const double _slideDuration = 1.5;
  static const double _sitDuration = 3.0;
  Vector2? _preSitPosition;

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

    // Adicionar Parque Central ao mundo
    _parqueArea = ParqueCentralArea(
      position: _parquePosition,
      size: _parqueSize,
      onInteract: _onParqueInteract,
    );
    await world.add(_parqueArea);

    // Adicionar Mercadão ao mundo
    _mercadaoExterior = MercadaoExterior(position: _mercadaoPosition);
    await world.add(_mercadaoExterior);

    // Adicionar Padaria ao mundo
    _padariaExterior = PadariaExterior(position: _padariaPosition);
    await world.add(_padariaExterior);
    _padariaCheirinho = CheirinhoParticles(position: _padariaPosition + Vector2(0, -20));
    await world.add(_padariaCheirinho);

    // Adicionar NPC ao parque
    _cidadao = CidadaoParque(
      position: _parquePosition + Vector2(_parqueSize.x / 2, _parqueSize.y / 2),
      patrolBounds: _parqueArea.patrolBounds,
    );
    // Override onInteract para abrir diálogo
    _cidadao = _CidadaoWithCallback(
      base: _cidadao,
      onInteractCallback: _openNpcDialogue,
    );
    await world.add(_cidadao);

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

    // Dica do parque
    _parqueHint = TextComponent(
      text: 'Parque Central',
      position: _parquePosition + Vector2(_parqueSize.x / 2, -20),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.black87, blurRadius: 4),
          ],
        ),
      ),
    );

    // Dica do Mercadão
    _mercadaoHint = TextComponent(
      text: 'Entrar',
      position: _mercadaoPosition + Vector2(0, -80),
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

    // Dica da Padaria
    _padariaHint = TextComponent(
      text: 'Entrar',
      position: _padariaPosition + Vector2(0, -80),
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

    if (_inInterior || _isDialogueOpen) return;

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

    // Detectar proximidade com parque
    final parqueCenter = _parquePosition + Vector2(_parqueSize.x / 2, _parqueSize.y / 2);
    final distParque = _player.position.distanceTo(parqueCenter);
    _nearParque = distParque < _parqueInteractDistance;

    if (_nearParque && !_parqueHintAdded) {
      world.add(_parqueHint);
      _parqueHintAdded = true;
    } else if (!_nearParque && _parqueHintAdded) {
      _parqueHint.removeFromParent();
      _parqueHintAdded = false;
    }

    // Detectar proximidade com mercadão
    final distMercadao = _player.position.distanceTo(_mercadaoPosition);
    _nearMercadao = distMercadao < _mercadaoEnterDistance;

    if (_nearMercadao && !_mercadaoHintAdded) {
      world.add(_mercadaoHint);
      _mercadaoHintAdded = true;
    } else if (!_nearMercadao && _mercadaoHintAdded) {
      _mercadaoHint.removeFromParent();
      _mercadaoHintAdded = false;
    }

    // Detectar proximidade com padaria
    final distPadaria = _player.position.distanceTo(_padariaPosition);
    _nearPadaria = distPadaria < _padariaEnterDistance;

    if (_nearPadaria && !_padariaHintAdded) {
      world.add(_padariaHint);
      _padariaHintAdded = true;
    } else if (!_nearPadaria && _padariaHintAdded) {
      _padariaHint.removeFromParent();
      _padariaHintAdded = false;
    }

    // Player sitting animation
    if (_isSitting) {
      _sitTimer += dt;
      if (_sitTimer >= _sitDuration) {
        _isSitting = false;
        _sitTimer = 0;
        // Restore position
        if (_preSitPosition != null) {
          _player.position = _preSitPosition!;
          _preSitPosition = null;
        }
      }
      return; // Block movement while sitting
    }

    // Player sliding animation
    if (_isSliding) {
      _slideTimer += dt;
      if (_slideTimer >= _slideDuration) {
        _isSliding = false;
        _slideTimer = 0;
        _slideTarget = null;
      } else {
        // Slide movement (fast, downward)
        final progress = _slideTimer / _slideDuration;
        final slideDirection = Vector2(0.3, 1); // slide down-right
        _player.position += slideDirection * 120 * dt;
      }
      return; // Block normal movement while sliding
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    // Ignora toques no mundo quando no interior ou diálogo aberto
    if (_inInterior) return;

    if (_isDialogueOpen) {
      // Diálogo consome o toque
      return;
    }

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

    // Verificar toque no mercadão quando próximo
    if (_nearMercadao) {
      final mercadaoRect = Rect.fromCenter(
        center: Offset(_mercadaoPosition.x, _mercadaoPosition.y),
        width: _mercadaoExterior.size.x,
        height: _mercadaoExterior.size.y,
      );
      if (mercadaoRect.contains(Offset(worldPos.x, worldPos.y))) {
        _enterMercadaoInterior();
        return;
      }
    }

    // Verificar toque na padaria quando próximo
    if (_nearPadaria) {
      final padariaRect = Rect.fromCenter(
        center: Offset(_padariaPosition.x, _padariaPosition.y),
        width: _padariaExterior.size.x,
        height: _padariaExterior.size.y,
      );
      if (padariaRect.contains(Offset(worldPos.x, worldPos.y))) {
        _enterPadariaInterior();
        return;
      }
    }

    // Toque no mundo = mover jogador (exceto se sentado/deslizando)
    if (!_isSitting && !_isSliding) {
      _player.moveTo(worldPos);
    }
  }

  /// Callback quando o player interage com elementos do parque.
  void _onParqueInteract(String interactionType, Vector2 position) {
    final dist = _player.position.distanceTo(position);
    if (dist > 80) {
      // Mover player perto do elemento primeiro
      _player.moveTo(position);
      return;
    }

    switch (interactionType) {
      case 'banco':
        _playerSit(position);
        break;
      case 'escorregador':
        _playerSlide(position);
        break;
    }
  }

  void _playerSit(Vector2 bancoPos) {
    if (_isSitting || _isSliding) return;
    _isSitting = true;
    _sitTimer = 0;
    _preSitPosition = _player.position.clone();
    // Move player to bench position
    _player.position = bancoPos + Vector2(0, 10);
  }

  void _playerSlide(Vector2 escorregadorPos) {
    if (_isSitting || _isSliding) return;
    _isSliding = true;
    _slideTimer = 0;
    // Move player to top of slide
    _player.position = escorregadorPos + Vector2(-15, -25);
  }

  void _openNpcDialogue() {
    if (_isDialogueOpen) return;
    _isDialogueOpen = true;

    // Pausa movimento do NPC
    _cidadao.estado = NpcState.interacting;

    _dialogueOverlay = NpcDialogueOverlay(
      npcName: _cidadao.nome,
      text: _cidadao.dialogos.first,
      onClose: _closeNpcDialogue,
      size: camera.viewport.size,
      avatarColor: const Color(0xFF42A5F5),
    );

    camera.viewport.add(_dialogueOverlay!);
    _dialogueOverlay!.show();
  }

  void _closeNpcDialogue() {
    if (_dialogueOverlay == null) return;

    camera.viewport.remove(_dialogueOverlay!);
    _dialogueOverlay = null;
    _isDialogueOpen = false;

    // Resume NPC
    _cidadao.estado = NpcState.idle;
  }

  void _removeAllHints() {
    if (_hintAdded) {
      _enterHint.removeFromParent();
      _hintAdded = false;
    }
    if (_parqueHintAdded) {
      _parqueHint.removeFromParent();
      _parqueHintAdded = false;
    }
    if (_mercadaoHintAdded) {
      _mercadaoHint.removeFromParent();
      _mercadaoHintAdded = false;
    }
    if (_padariaHintAdded) {
      _padariaHint.removeFromParent();
      _padariaHintAdded = false;
    }
  }

  /// Transiciona para o interior da Casa do Jogador.
  void _enterInterior() {
    _inInterior = true;
    _removeAllHints();

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

  /// Transiciona para o interior do Mercadão.
  void _enterMercadaoInterior() {
    _inInterior = true;
    _removeAllHints();

    LocationManager().enter('mercadao');

    _mercadaoInteriorScene = MercadaoInteriorScene(
      size: camera.viewport.size,
      onExit: _exitMercadaoInterior,
    );
    camera.viewport.add(_mercadaoInteriorScene!);
    _mercadaoInteriorScene!.enter();
  }

  /// Sai do interior do Mercadão e volta ao mundo.
  void _exitMercadaoInterior() {
    if (_mercadaoInteriorScene == null) return;

    camera.viewport.remove(_mercadaoInteriorScene!);
    _mercadaoInteriorScene = null;
    _inInterior = false;

    LocationManager().exit('mercadao');

    _player.position = _mercadaoPosition + Vector2(0, 100);
    _player.moveTo(_player.position);
  }

  /// Transiciona para o interior da Padaria.
  void _enterPadariaInterior() {
    _inInterior = true;
    _removeAllHints();

    LocationManager().enter('padaria');

    _padariaInteriorScene = PadariaInteriorScene(
      size: camera.viewport.size,
      onExit: _exitPadariaInterior,
    );
    camera.viewport.add(_padariaInteriorScene!);
    _padariaInteriorScene!.enter();
  }

  /// Sai do interior da Padaria e volta ao mundo.
  void _exitPadariaInterior() {
    if (_padariaInteriorScene == null) return;

    camera.viewport.remove(_padariaInteriorScene!);
    _padariaInteriorScene = null;
    _inInterior = false;

    LocationManager().exit('padaria');

    _player.position = _padariaPosition + Vector2(0, 100);
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

    // TODO: Adicionar mais prédios, NPCs, objetos interativos

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

/// Wrapper para injetar callback de interação no CidadaoParque.
class _CidadaoWithCallback extends CidadaoParque {
  final VoidCallback onInteractCallback;

  _CidadaoWithCallback({
    required CidadaoParque base,
    required this.onInteractCallback,
  }) : super(
          position: base.position,
          patrolBounds: base.patrolBounds,
        );

  @override
  void onInteract() {
    onInteractCallback();
  }
}
