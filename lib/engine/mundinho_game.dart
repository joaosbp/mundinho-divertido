import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../core/services/audio_service.dart';
import '../core/services/save_service.dart';
import '../entities/npcs/cidadao_parque.dart';
import '../entities/npcs/npc_base.dart';
import '../entities/npcs/prefeito_tico.dart';
import '../entities/player/player.dart';
import '../locations/buildings/centro/casa_jogador.dart';
import '../locations/buildings/centro/correios.dart';
import '../locations/buildings/centro/escola.dart';
import '../locations/buildings/centro/farmacia.dart';
import '../locations/buildings/centro/mercadao.dart';
import '../locations/buildings/centro/padaria.dart';
import '../locations/buildings/centro/parque_central.dart';
import '../locations/buildings/centro/prefeitura.dart';
import '../locations/location_manager.dart';
import '../missions/definitions/arc1/t1_bem_vindo.dart';
import '../missions/mission_base.dart';
import '../missions/mission_manager.dart';
import '../ui/dialogs/npc_dialogue.dart';
import '../ui/hud/main_hud.dart';
import '../ui/overlays/inventory_overlay.dart';
import '../ui/overlays/pause_menu.dart';
import '../ui/overlays/settings_overlay.dart';
import '../ui/overlays/toast_overlay.dart';

import 'correios_interior_scene.dart';
import 'escola_interior_scene.dart';
import 'farmacia_interior_scene.dart';
import 'interior_scene.dart';
import 'mercadao_interior_scene.dart';
import 'padaria_interior_scene.dart';
import 'prefeitura_interior_scene.dart';

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

  // Prefeitura
  late PrefeituraExterior _prefeituraExterior;
  final Vector2 _prefeituraPosition = Vector2(1300, 200);
  static const double _prefeituraEnterDistance = 100.0;
  bool _nearPrefeitura = false;
  late TextComponent _prefeituraHint;
  bool _prefeituraHintAdded = false;
  PrefeituraInteriorScene? _prefeituraInteriorScene;

  // Escola
  late EscolaExterior _escolaExterior;
  final Vector2 _escolaPosition = Vector2(500, 800);
  static const double _escolaEnterDistance = 100.0;
  bool _nearEscola = false;
  late TextComponent _escolaHint;
  bool _escolaHintAdded = false;
  EscolaInteriorScene? _escolaInteriorScene;

  // Farmácia
  late FarmaciaExterior _farmaciaExterior;
  final Vector2 _farmaciaPosition = Vector2(200, 500);
  static const double _farmaciaEnterDistance = 100.0;
  bool _nearFarmacia = false;
  late TextComponent _farmaciaHint;
  bool _farmaciaHintAdded = false;
  FarmaciaInteriorScene? _farmaciaInteriorScene;

  // Correios
  late CorreiosExterior _correiosExterior;
  final Vector2 _correiosPosition = Vector2(100, 800);
  static const double _correiosEnterDistance = 100.0;
  bool _nearCorreios = false;
  late TextComponent _correiosHint;
  bool _correiosHintAdded = false;
  CorreiosInteriorScene? _correiosInteriorScene;

  // NPC
  late CidadaoParque _cidadao;

  // Diálogo
  NpcDialogueOverlay? _dialogueOverlay;
  bool _isDialogueOpen = false;

  // Diálogo com Prefeito Tico (múltiplas falas)

  // Missão tutorial
  final MissionManager _missionManager = MissionManager();
  bool _tutorialStarted = false;
  bool _visitedCasaDuringTutorial = false;
  bool _visitedParqueDuringTutorial = false;
  late TextComponent _missionHud;
  bool _missionHudAdded = false;

  // ─── UI Overlays ───
  bool _isPaused = false;
  bool _showSettings = false;
  bool _showInventory = false;
  bool _showMissions = true;

  // HUD
  MainHud? _mainHud;

  // Inventário
  final List<InventoryItem> _inventoryItems = [];

  // Toasts
  final List<ToastMessage> _toasts = [];
  ToastOverlayComponent? _toastComponent;
  int _toastIdCounter = 0;

  // Player animation states
  bool _isSitting = false;
  double _sitTimer = 0;
  bool _isSliding = false;
  double _slideTimer = 0;
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
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // Atualiza tamanho dos componentes de UI quando a tela muda
    _mainHud?.size = camera.viewport.size;
    _toastComponent?.size = camera.viewport.size;
  }

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

    // Adicionar Prefeitura ao mundo
    _prefeituraExterior = PrefeituraExterior(position: _prefeituraPosition);
    await world.add(_prefeituraExterior);

    // Adicionar Escola ao mundo
    _escolaExterior = EscolaExterior(position: _escolaPosition);
    await world.add(_escolaExterior);

    // Adicionar Farmácia ao mundo
    _farmaciaExterior = FarmaciaExterior(position: _farmaciaPosition);
    await world.add(_farmaciaExterior);

    // Adicionar Correios ao mundo
    _correiosExterior = CorreiosExterior(position: _correiosPosition);
    await world.add(_correiosExterior);

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

    // Dica da Prefeitura
    _prefeituraHint = TextComponent(
      text: 'Entrar',
      position: _prefeituraPosition + Vector2(0, -100),
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

    // Dica da Escola
    _escolaHint = TextComponent(
      text: 'Entrar',
      position: _escolaPosition + Vector2(0, -90),
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

    // Dica da Farmácia
    _farmaciaHint = TextComponent(
      text: 'Entrar',
      position: _farmaciaPosition + Vector2(0, -80),
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

    // Dica dos Correios
    _correiosHint = TextComponent(
      text: 'Entrar',
      position: _correiosPosition + Vector2(0, -80),
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

    // HUD de missão ativa
    _missionHud = TextComponent(
      text: '',
      position: Vector2(16, 16),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.amber,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.black87, blurRadius: 3),
          ],
        ),
      ),
    );

    // Registrar missão tutorial
    _missionManager.register(TBemVindo());

    // Carregar save
    final save = SaveService();
    if (!save.isInitialized) {
      await save.initialize();
    }
    // TODO: aplicar dados salvos (posição, aparência, etc.)

    // Inicializar HUD
    _initHud();

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

    // Tracker de missão: visitou parque
    if (_nearParque) {
      _checkVisitLocation('parque_central');
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

    // Detectar proximidade com prefeitura
    final distPrefeitura = _player.position.distanceTo(_prefeituraPosition);
    _nearPrefeitura = distPrefeitura < _prefeituraEnterDistance;

    if (_nearPrefeitura && !_prefeituraHintAdded) {
      world.add(_prefeituraHint);
      _prefeituraHintAdded = true;
    } else if (!_nearPrefeitura && _prefeituraHintAdded) {
      _prefeituraHint.removeFromParent();
      _prefeituraHintAdded = false;
    }

    // Detectar proximidade com escola
    final distEscola = _player.position.distanceTo(_escolaPosition);
    _nearEscola = distEscola < _escolaEnterDistance;

    if (_nearEscola && !_escolaHintAdded) {
      world.add(_escolaHint);
      _escolaHintAdded = true;
    } else if (!_nearEscola && _escolaHintAdded) {
      _escolaHint.removeFromParent();
      _escolaHintAdded = false;
    }

    // Detectar proximidade com farmácia
    final distFarmacia = _player.position.distanceTo(_farmaciaPosition);
    _nearFarmacia = distFarmacia < _farmaciaEnterDistance;

    if (_nearFarmacia && !_farmaciaHintAdded) {
      world.add(_farmaciaHint);
      _farmaciaHintAdded = true;
    } else if (!_nearFarmacia && _farmaciaHintAdded) {
      _farmaciaHint.removeFromParent();
      _farmaciaHintAdded = false;
    }

    // Detectar proximidade com correios
    final distCorreios = _player.position.distanceTo(_correiosPosition);
    _nearCorreios = distCorreios < _correiosEnterDistance;

    if (_nearCorreios && !_correiosHintAdded) {
      world.add(_correiosHint);
      _correiosHintAdded = true;
    } else if (!_nearCorreios && _correiosHintAdded) {
      _correiosHint.removeFromParent();
      _correiosHintAdded = false;
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
      } else {
        // Slide movement (fast, downward)
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

    // Verificar toque na prefeitura quando próximo
    if (_nearPrefeitura) {
      final prefeituraRect = Rect.fromCenter(
        center: Offset(_prefeituraPosition.x, _prefeituraPosition.y),
        width: _prefeituraExterior.size.x,
        height: _prefeituraExterior.size.y,
      );
      if (prefeituraRect.contains(Offset(worldPos.x, worldPos.y))) {
        _enterPrefeituraInterior();
        return;
      }
    }

    // Verificar toque na escola quando próximo
    if (_nearEscola) {
      final escolaRect = Rect.fromCenter(
        center: Offset(_escolaPosition.x, _escolaPosition.y),
        width: _escolaExterior.size.x,
        height: _escolaExterior.size.y,
      );
      if (escolaRect.contains(Offset(worldPos.x, worldPos.y))) {
        _enterEscolaInterior();
        return;
      }
    }

    // Verificar toque na farmácia quando próximo
    if (_nearFarmacia) {
      final farmaciaRect = Rect.fromCenter(
        center: Offset(_farmaciaPosition.x, _farmaciaPosition.y),
        width: _farmaciaExterior.size.x,
        height: _farmaciaExterior.size.y,
      );
      if (farmaciaRect.contains(Offset(worldPos.x, worldPos.y))) {
        _enterFarmaciaInterior();
        return;
      }
    }

    // Verificar toque nos correios quando próximo
    if (_nearCorreios) {
      final correiosRect = Rect.fromCenter(
        center: Offset(_correiosPosition.x, _correiosPosition.y),
        width: _correiosExterior.size.x,
        height: _correiosExterior.size.y,
      );
      if (correiosRect.contains(Offset(worldPos.x, worldPos.y))) {
        _enterCorreiosInterior();
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
    if (_prefeituraHintAdded) {
      _prefeituraHint.removeFromParent();
      _prefeituraHintAdded = false;
    }
    if (_escolaHintAdded) {
      _escolaHint.removeFromParent();
      _escolaHintAdded = false;
    }
    if (_farmaciaHintAdded) {
      _farmaciaHint.removeFromParent();
      _farmaciaHintAdded = false;
    }
    if (_correiosHintAdded) {
      _correiosHint.removeFromParent();
      _correiosHintAdded = false;
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

    // Tracker de missão: visitou casa
    _checkVisitLocation('casa_jogador');
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

  /// Transiciona para o interior da Prefeitura.
  void _enterPrefeituraInterior() {
    _inInterior = true;
    _removeAllHints();

    LocationManager().enter('prefeitura');

    // Inicia missão tutorial automaticamente na primeira vez
    if (!_tutorialStarted) {
      _tutorialStarted = true;
      _missionManager.start('t1_bem_vindo');
      _updateMissionHud();
    }

    _prefeituraInteriorScene = PrefeituraInteriorScene(
      size: camera.viewport.size,
      onExit: _exitPrefeituraInterior,
      onNpcInteract: _onPrefeitoTicoInteract,
    );
    camera.viewport.add(_prefeituraInteriorScene!);
    _prefeituraInteriorScene!.enter();
  }

  /// Sai do interior da Prefeitura e volta ao mundo.
  void _exitPrefeituraInterior() {
    if (_prefeituraInteriorScene == null) return;

    camera.viewport.remove(_prefeituraInteriorScene!);
    _prefeituraInteriorScene = null;
    _inInterior = false;

    LocationManager().exit('prefeitura');

    _player.position = _prefeituraPosition + Vector2(0, 100);
    _player.moveTo(_player.position);
  }

  /// Transiciona para o interior dos Correios.
  void _enterCorreiosInterior() {
    _inInterior = true;
    _removeAllHints();

    LocationManager().enter('correios');

    _correiosInteriorScene = CorreiosInteriorScene(
      size: camera.viewport.size,
      onExit: _exitCorreiosInterior,
    );
    camera.viewport.add(_correiosInteriorScene!);
    _correiosInteriorScene!.enter();
  }

  /// Sai do interior dos Correios e volta ao mundo.
  void _exitCorreiosInterior() {
    if (_correiosInteriorScene == null) return;

    camera.viewport.remove(_correiosInteriorScene!);
    _correiosInteriorScene = null;
    _inInterior = false;

    LocationManager().exit('correios');

    _player.position = _correiosPosition + Vector2(0, 100);
    _player.moveTo(_player.position);
  }

  /// Transiciona para o interior da Farmácia.
  void _enterFarmaciaInterior() {
    _inInterior = true;
    _removeAllHints();

    LocationManager().enter('farmacia');

    _farmaciaInteriorScene = FarmaciaInteriorScene(
      size: camera.viewport.size,
      onExit: _exitFarmaciaInterior,
    );
    camera.viewport.add(_farmaciaInteriorScene!);
    _farmaciaInteriorScene!.enter();
  }

  /// Sai do interior da Farmácia e volta ao mundo.
  void _exitFarmaciaInterior() {
    if (_farmaciaInteriorScene == null) return;

    camera.viewport.remove(_farmaciaInteriorScene!);
    _farmaciaInteriorScene = null;
    _inInterior = false;

    LocationManager().exit('farmacia');

    _player.position = _farmaciaPosition + Vector2(0, 100);
    _player.moveTo(_player.position);
  }

  /// Transiciona para o interior da Escola.
  void _enterEscolaInterior() {
    _inInterior = true;
    _removeAllHints();

    LocationManager().enter('escola');

    _escolaInteriorScene = EscolaInteriorScene(
      size: camera.viewport.size,
      onExit: _exitEscolaInterior,
    );
    camera.viewport.add(_escolaInteriorScene!);
    _escolaInteriorScene!.enter();
  }

  /// Sai do interior da Escola e volta ao mundo.
  void _exitEscolaInterior() {
    if (_escolaInteriorScene == null) return;

    camera.viewport.remove(_escolaInteriorScene!);
    _escolaInteriorScene = null;
    _inInterior = false;

    LocationManager().exit('escola');

    _player.position = _escolaPosition + Vector2(0, 100);
    _player.moveTo(_player.position);
  }

  /// Chamado quando o jogador interage com o Prefeito Tico.
  void _onPrefeitoTicoInteract(NpcBase npc) {
    if (_isDialogueOpen) return;

    final mission = _missionManager.get('t1_bem_vindo');
    final stepIndex = _missionManager.exportProgress().steps['t1_bem_vindo'];

    // Determina qual diálogo mostrar baseado no progresso da missão
    String texto;
    if (mission != null && stepIndex != null) {
      if (stepIndex == 0) {
        // Passo 1: primeira conversa com Tico
        texto = (npc as PrefeitoTico).proximoDialogo;
        _missionManager.advanceStep('t1_bem_vindo');
        _updateMissionHud();
      } else if (stepIndex == 1) {
        // Passo 2: precisa visitar locais primeiro
        if (_visitedCasaDuringTutorial && _visitedParqueDuringTutorial) {
          texto = 'Incrível! Você já explorou a cidade! Vamos completar sua missão.';
          _missionManager.advanceStep('t1_bem_vindo');
          _updateMissionHud();
        } else {
          final faltam = <String>[];
          if (!_visitedCasaDuringTutorial) faltam.add('Casa');
          if (!_visitedParqueDuringTutorial) faltam.add('Parque');
          texto = 'Ainda falta visitar: ${faltam.join(' e ')}. Volte quando terminar!';
        }
      } else if (stepIndex == 2) {
        // Passo 3: conversa final
        texto = 'Parabéns! Você completou a missão! Aqui está sua recompensa.';
        final rewards = _missionManager.complete('t1_bem_vindo');
        _showRewardFeedback(rewards);
        _updateMissionHud();
      } else {
        texto = 'Obrigado por ajudar o Mundinho!';
      }
    } else {
      // Missão não iniciada — mostra diálogo genérico
      texto = (npc as PrefeitoTico).proximoDialogo;
    }

    _isDialogueOpen = true;
    npc.estado = NpcState.interacting;

    _dialogueOverlay = NpcDialogueOverlay(
      npcName: npc.nome,
      text: texto,
      onClose: () => _closePrefeitoDialogue(npc),
      size: camera.viewport.size,
      avatarColor: const Color(0xFF7B1FA2),
    );

    camera.viewport.add(_dialogueOverlay!);
    _dialogueOverlay!.show();
  }

  void _closePrefeitoDialogue(NpcBase npc) {
    if (_dialogueOverlay == null) return;

    camera.viewport.remove(_dialogueOverlay!);
    _dialogueOverlay = null;
    _isDialogueOpen = false;
    npc.estado = NpcState.idle;
  }

  /// Verifica se o jogador está visitando um local para a missão tutorial.
  void _checkVisitLocation(String locationId) {
    final stepIndex = _missionManager.exportProgress().steps['t1_bem_vindo'];
    if (stepIndex == 1) {
      if (locationId == 'casa_jogador') {
        _visitedCasaDuringTutorial = true;
      } else if (locationId == 'parque_central') {
        _visitedParqueDuringTutorial = true;
      }
      _updateMissionHud();
    }
  }

  /// Atualiza o HUD de missão ativa.
  void _updateMissionHud() {
    final inProgress = _missionManager.inProgressMissions;
    if (inProgress.isEmpty) {
      if (_missionHudAdded) {
        _missionHud.removeFromParent();
        _missionHudAdded = false;
      }
      return;
    }

    final mission = inProgress.first;
    final stepIndex = _missionManager.exportProgress().steps[mission.id] ?? 0;
    final stepDesc = stepIndex < mission.steps.length
        ? mission.steps[stepIndex].description
        : 'Finalizando...';

    _missionHud.text = '⭐ Missão: ${mission.title}\n🎯 $stepDesc';

    if (!_missionHudAdded) {
      camera.viewport.add(_missionHud);
      _missionHudAdded = true;
    }
  }

  /// Mostra feedback visual da recompensa via toast.
  void _showRewardFeedback(List<MissionReward> rewards) {
    final totalStars = rewards.fold(0, (sum, r) => sum + r.stars);
    final totalCoins = rewards.fold(0, (sum, r) => sum + r.coins);
    _showToast(
      '🎉 Missão completa! +$totalStars⭐ +$totalCoins🪙',
      type: ToastType.mission,
    );
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

  // ─── UI Integration ───

  void _initHud() {
    _mainHud = MainHud(
      size: camera.viewport.size,
      playerName: SaveService().playerData.playerName,
      coins: SaveService().playerData.coins,
      stars: SaveService().playerData.stars,
      onPausePressed: _openPauseMenu,
      onInventoryPressed: _openInventory,
      onMissionsPressed: _toggleMissionHud,
    );
    camera.viewport.add(_mainHud!);

    // Toast component
    _toastComponent = ToastOverlayComponent(
      toasts: _toasts,
    );
    camera.viewport.add(_toastComponent!);
  }

  void _openPauseMenu() {
    if (_isPaused) return;
    _isPaused = true;
    pauseEngine();
    AudioService().pauseMusic();

    final overlay = PauseMenuOverlay(
      onResume: _closePauseMenu,
      onSettings: _openSettings,
      onQuit: _quitToMenu,
    );
    overlay.size = camera.viewport.size;
    camera.viewport.add(overlay);
  }

  void _closePauseMenu() {
    _isPaused = false;
    // Remove todos os overlays de pausa/config
    for (final c in List<Component>.from(camera.viewport.children)) {
      if (c is PauseMenuOverlay || c is SettingsOverlayComponent) {
        c.removeFromParent();
      }
    }
    _showSettings = false;
    resumeEngine();
    AudioService().resumeMusic();
  }

  void _openSettings() {
    if (_showSettings) return;
    _showSettings = true;

    // Remove pause menu
    for (final c in List<Component>.from(camera.viewport.children)) {
      if (c is PauseMenuOverlay) {
        c.removeFromParent();
      }
    }

    final overlay = SettingsOverlayComponent(
      onBack: () {
        _showSettings = false;
        // Volta para o pause menu
        for (final c in List<Component>.from(camera.viewport.children)) {
          if (c is SettingsOverlayComponent) {
            c.removeFromParent();
          }
        }
        final pauseOverlay = PauseMenuOverlay(
          onResume: _closePauseMenu,
          onSettings: _openSettings,
          onQuit: _quitToMenu,
        );
        pauseOverlay.size = camera.viewport.size;
        camera.viewport.add(pauseOverlay);
      },
    );
    overlay.size = camera.viewport.size;
    camera.viewport.add(overlay);
  }

  void _quitToMenu() {
    _closePauseMenu();
    // TODO: navegar para menu — atualmente só resume
  }

  void _openInventory() {
    if (_showInventory) return;
    _showInventory = true;
    pauseEngine();

    final overlay = InventoryOverlayComponent(
      items: _inventoryItems,
      onClose: () {
        _showInventory = false;
        for (final c in List<Component>.from(camera.viewport.children)) {
          if (c is InventoryOverlayComponent) {
            c.removeFromParent();
          }
        }
        resumeEngine();
      },
    );
    overlay.size = camera.viewport.size;
    camera.viewport.add(overlay);
  }

  void _toggleMissionHud() {
    _showMissions = !_showMissions;
    if (_showMissions) {
      _updateMissionHud();
    } else {
      if (_missionHudAdded) {
        _missionHud.removeFromParent();
        _missionHudAdded = false;
      }
    }
  }

  void _showToast(String text, {ToastType type = ToastType.info}) {
    _toastIdCounter++;
    _toasts.add(ToastMessage(
      id: 'toast_$_toastIdCounter',
      text: text,
      type: type,
    ));
    _toastComponent?.updateToasts(List.from(_toasts));

    // Auto-remove após duração + animação
    Future.delayed(const Duration(seconds: 3), () {
      if (_toasts.isNotEmpty) {
        _toasts.removeAt(0);
        _toastComponent?.updateToasts(List.from(_toasts));
      }
    });
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
