import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../core/services/save_service.dart';
import '../entities/npcs/npc_base.dart';
import '../entities/npcs/seu_correio.dart';
import '../ui/dialogs/npc_dialogue.dart';

// ─── Dados dos locais para o mini-jogo ───

class _LocalData {
  final String id;
  final String name;
  final String emoji;
  final Color color;

  const _LocalData(this.id, this.name, this.emoji, this.color);
}

const List<_LocalData> _locais = [
  _LocalData('casa_jogador', 'Casa', '🏠', Color(0xFFEF5350)),
  _LocalData('parque_central', 'Parque', '🌳', Color(0xFF66BB6A)),
  _LocalData('mercadao', 'Mercadão', '🛒', Color(0xFF42A5F5)),
  _LocalData('padaria', 'Padaria', '🥖', Color(0xFFFFCA28)),
  _LocalData('prefeitura', 'Prefeitura', '🏛️', Color(0xFF7B1FA2)),
  _LocalData('escola', 'Escola', '📚', Color(0xFF81C784)),
  _LocalData('farmacia', 'Farmácia', '💊', Color(0xFF26A69A)),
  _LocalData('correios', 'Correios', '📮', Color(0xFFFFD600)),
];

// Estados do mini-jogo
enum _GameState {
  idle,
  showingSequence,
  hidingSequence,
  playerInput,
  wrongFeedback,
  complete,
}

// ─── Cena de interior dos Correios com mini-jogo ───

class CorreiosInteriorScene extends PositionComponent {
  final VoidCallback onExit;

  double _opacity = 0;
  double? _targetOpacity;
  VoidCallback? _onFadeComplete;

  // NPC
  late SeuCorreio _seuCorreio;
  bool _isDialogueOpen = false;
  NpcDialogueOverlay? _dialogueOverlay;

  // Estado do mini-jogo
  _GameState _gameState = _GameState.idle;
  final List<int> _sequence = [];
  double _showTimer = 0;
  int _showingIndex = -1;
  double _hideTimer = 0;
  final List<int> _playerSequence = [];
  double _resultTimer = 0;
  int _wrongAttempts = 0;

  late TextComponent _instructionText;
  late TextComponent _resultText;
  late TextComponent _sequenceText;

  // Cards dos locais
  final List<_LocalCard> _localCards = [];

  CorreiosInteriorScene({
    required this.onExit,
    required Vector2 size,
    Vector2? position,
  }) : super(
          size: size,
          position: position ?? Vector2.zero(),
          anchor: Anchor.topLeft,
        );

  void enter() {
    _opacity = 0;
    _targetOpacity = 1.0;
    _onFadeComplete = null;
  }

  void exit() {
    _targetOpacity = 0;
    _onFadeComplete = onExit;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Fundo (bege claro)
    add(
      RectangleComponent(
        position: Vector2.zero(),
        size: size,
        paint: Paint()..color = const Color(0xFFFFF8E1),
      ),
    );

    // Piso (cinza claro)
    add(
      RectangleComponent(
        position: Vector2(0, size.y * 0.6),
        size: Vector2(size.x, size.y * 0.4),
        paint: Paint()..color = const Color(0xFFECEFF1),
      ),
    );

    // Balcão central
    _buildBalcao();

    // Caixas de cartas empilhadas (esquerda)
    _buildCaixasCartas();

    // Mapa simplificado na parede (direita)
    _buildMapaParede();

    // Seu Correio atrás do balcão
    _seuCorreio = SeuCorreio(
      position: Vector2(size.x / 2 + 60, size.y * 0.35),
      onInteractCallback: _onSeuCorreioInteract,
    );
    add(_seuCorreio);

    // Texto de instrução
    _instructionText = TextComponent(
      text: 'Toque no Seu Correio para começar!',
      position: Vector2(size.x / 2, 24),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFF37474F),
          fontSize: 16,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.white, blurRadius: 3),
          ],
        ),
      ),
    );
    add(_instructionText);

    // Texto da sequência
    _sequenceText = TextComponent(
      text: '',
      position: Vector2(size.x / 2, 52),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFF1565C0),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(_sequenceText);

    // Texto de resultado
    _resultText = TextComponent(
      text: '',
      position: Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.green,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.white, blurRadius: 4),
          ],
        ),
      ),
    );
    add(_resultText);

    // Construir cards dos locais (área inferior)
    _buildLocalCards();

    // Botão Sair
    add(
      _ExitButton(
        position: Vector2(size.x - 90, 20),
        onTap: exit,
      ),
    );
  }

  void _buildBalcao() {
    // Balcão central (fundo)
    add(
      RectangleComponent(
        position: Vector2(size.x / 2 - 100, size.y * 0.4),
        size: Vector2(200, 50),
        paint: Paint()..color = const Color(0xFF8D6E63),
      ),
    );

    // Borda do balcão
    add(
      RectangleComponent(
        position: Vector2(size.x / 2 - 100, size.y * 0.4),
        size: Vector2(200, 4),
        paint: Paint()..color = const Color(0xFF6D4C41),
      ),
    );

    // Painel do balcão
    add(
      RectangleComponent(
        position: Vector2(size.x / 2 - 90, size.y * 0.4 + 8),
        size: Vector2(180, 36),
        paint: Paint()..color = const Color(0x4DFFECB3),
      ),
    );
  }

  void _buildCaixasCartas() {
    final colors = [
      const Color(0xFFEF5350),
      const Color(0xFF42A5F5),
      const Color(0xFF66BB6A),
      const Color(0xFFFFCA28),
      const Color(0xFFAB47BC),
    ];

    for (int i = 0; i < 5; i++) {
      final boxPaint = Paint()..color = colors[i];
      add(
        RectangleComponent(
          position: Vector2(20, 70 + i * 16),
          size: Vector2(30, 14),
          paint: boxPaint,
        ),
      );
    }
  }

  void _buildMapaParede() {
    // Quadro do mapa
    final framePaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    add(
      RectangleComponent(
        position: Vector2(size.x - 130, 60),
        size: Vector2(110, 80),
        paint: Paint()..color = const Color(0xFFFFFDE7),
      ),
    );
    add(
      RectangleComponent(
        position: Vector2(size.x - 130, 60),
        size: Vector2(110, 80),
        paint: framePaint,
      ),
    );

    // Retângulos representando locais no mapa
    final mapLocals = [
      _LocalData('casa_jogador', '', '', const Color(0xFFEF5350)),
      _LocalData('parque_central', '', '', const Color(0xFF66BB6A)),
      _LocalData('mercadao', '', '', const Color(0xFF42A5F5)),
      _LocalData('padaria', '', '', const Color(0xFFFFCA28)),
    ];

    for (int i = 0; i < mapLocals.length; i++) {
      final row = i ~/ 2;
      final col = i % 2;
      add(
        RectangleComponent(
          position: Vector2(
            size.x - 120 + col * 45,
            68 + row * 30,
          ),
          size: Vector2(38, 22),
          paint: Paint()..color = mapLocals[i].color.withValues(alpha: 0.6),
        ),
      );
    }

    // Label "Mapa da Cidade"
    add(
      TextComponent(
        text: 'Mapa',
        position: Vector2(size.x - 75, 44),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFF5D4037),
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _buildLocalCards() {
    final cardSize = Vector2(70, 80);
    final cols = 4;
    final spacingX = (size.x - 40 - cols * cardSize.x) / (cols - 1);
    final spacingY = 16.0;
    final startX = 20.0;
    final startY = size.y * 0.62;

    _localCards.clear();

    for (int i = 0; i < _locais.length; i++) {
      final row = i ~/ cols;
      final col = i % cols;
      final x = startX + col * (cardSize.x + spacingX) + cardSize.x / 2;
      final y = startY + row * (cardSize.y + spacingY) + cardSize.y / 2;

      final card = _LocalCard(
        position: Vector2(x, y),
        size: cardSize,
        local: _locais[i],
        index: i,
        onTap: () => _onLocalCardTapped(i),
      );
      _localCards.add(card);
      add(card);
    }
  }

  void _onSeuCorreioInteract() {
    if (_isDialogueOpen || _gameState != _GameState.idle) return;

    _isDialogueOpen = true;
    _seuCorreio.estado = NpcState.interacting;

    _dialogueOverlay = NpcDialogueOverlay(
      npcName: _seuCorreio.nome,
      text: _seuCorreio.proximoDialogo,
      onClose: _closeDialogue,
      size: size,
      avatarColor: const Color(0xFF42A5F5),
    );

    add(_dialogueOverlay!);
    _dialogueOverlay!.show();

    // Se for o primeiro diálogo, inicia o mini-jogo após fechar
    if (_seuCorreio.dialogos.indexOf(_seuCorreio.proximoDialogo) == 0 ||
        _gameState == _GameState.idle) {
      // Guardamos que devemos iniciar após fechar
      _pendingStartGame = true;
    }
  }

  bool _pendingStartGame = false;

  void _closeDialogue() {
    if (_dialogueOverlay == null) return;

    _dialogueOverlay!.removeFromParent();
    _dialogueOverlay = null;
    _isDialogueOpen = false;
    _seuCorreio.estado = NpcState.idle;

    if (_pendingStartGame) {
      _pendingStartGame = false;
      _startGame();
    }
  }

  void _startGame() {
    if (_gameState != _GameState.idle && _gameState != _GameState.complete) return;

    // Gera sequência aleatória de 3 locais
    final rng = Random();
    _sequence.clear();
    _playerSequence.clear();
    _showingIndex = -1;
    _wrongAttempts = 0;

    final indices = List.generate(_locais.length, (i) => i)..shuffle(rng);
    _sequence.addAll(indices.take(3));

    _gameState = _GameState.showingSequence;
    _showTimer = 0;
    _instructionText.text = 'Memorize a rota!';
    _resultText.text = '';

    // Desabilita interação nos cards durante sequência
    _setCardsEnabled(false);
  }

  void _setCardsEnabled(bool enabled) {
    for (final card in _localCards) {
      card.setEnabled(enabled);
    }
  }

  void _onLocalCardTapped(int index) {
    if (_gameState != _GameState.playerInput) return;

    _playerSequence.add(index);

    // Verifica se acertou o próximo da sequência
    final currentStep = _playerSequence.length - 1;
    if (_playerSequence[currentStep] != _sequence[currentStep]) {
      // Errou!
      _gameState = _GameState.wrongFeedback;
      _wrongAttempts++;
      _instructionText.text = 'Ops! Vamos ver de novo...';
      _playerSequence.clear();
      _sequenceText.text = '';
      _setCardsEnabled(false);

      // Mostra a sequência novamente após um delay
      Future.delayed(const Duration(seconds: 1), () {
        _gameState = _GameState.showingSequence;
        _showTimer = 0;
        _showingIndex = -1;
        _instructionText.text = 'Memorize a rota!';
      });
      return;
    }

    // Acertou este passo
    _localCards[index].flashCorrect();

    // Atualiza texto com progresso
    final progress = _playerSequence.map((i) => _locais[i].emoji).join(' → ');
    _sequenceText.text = progress;

    // Verifica se completou
    if (_playerSequence.length == _sequence.length) {
      _gameState = _GameState.complete;
      _resultTimer = 3.0;
      _instructionText.text = 'Rota completa! 🎉';
      _sequenceText.text =
          _sequence.map((i) => _locais[i].emoji).join(' → ');
      _awardReward();
      _setCardsEnabled(false);
    }
  }

  void _awardReward() {
    final coins = (8 - _wrongAttempts * 2).clamp(4, 8);
    final stars = _wrongAttempts == 0 ? 2 : 1;

    final save = SaveService();
    if (save.isInitialized) {
      final data = save.playerData;
      save.savePlayerData(
        data.copyWith(
          coins: data.coins + coins,
          stars: data.stars + stars,
        ),
      );
    }

    _resultText.text =
        '🎉 Parabéns! +$coins🪙 +$stars⭐\nAdesivo: Carteiro Express 📮';
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Fade
    if (_targetOpacity != null) {
      final step = dt / 0.3;
      if (_opacity < _targetOpacity!) {
        _opacity = (_opacity + step).clamp(0.0, _targetOpacity!);
      } else {
        _opacity = (_opacity - step).clamp(_targetOpacity!, 1.0);
      }
      if ((_opacity - _targetOpacity!).abs() < 0.01) {
        _opacity = _targetOpacity!;
        _targetOpacity = null;
        _onFadeComplete?.call();
        _onFadeComplete = null;
      }
    }

    // Lógica do mini-jogo
    switch (_gameState) {
      case _GameState.showingSequence:
        _showTimer += dt;
        final indexToShow = (_showTimer / 1.5).floor();

        if (indexToShow > _showingIndex) {
          _showingIndex = indexToShow;
          if (_showingIndex < _sequence.length) {
            // Destaca o local atual na sequência
            final local = _locais[_sequence[_showingIndex]];
            _sequenceText.text =
                '${local.emoji} ${local.name}';
            _localCards[_sequence[_showingIndex]].flashHighlight();
          } else {
            // Terminou de mostrar
            _gameState = _GameState.hidingSequence;
            _hideTimer = 0;
            _sequenceText.text = '...';
          }
        }
        break;

      case _GameState.hidingSequence:
        _hideTimer += dt;
        if (_hideTimer >= 1.0) {
          _gameState = _GameState.playerInput;
          _instructionText.text =
              'Toque nos locais na ordem certa!';
          _sequenceText.text = '';
          _setCardsEnabled(true);
        }
        break;

      case _GameState.complete:
        _resultTimer -= dt;
        if (_resultTimer <= 0) {
          _resultText.text = '';
          _instructionText.text = 'Toque no Seu Correio para jogar de novo!';
          _sequenceText.text = '';
          _gameState = _GameState.idle;
        }
        break;

      default:
        break;
    }
  }

  @override
  void renderTree(Canvas canvas) {
    if (_opacity <= 0.01) return;

    canvas.saveLayer(
      null,
      Paint()..color = Colors.white.withValues(alpha: _opacity),
    );
    super.renderTree(canvas);
    canvas.restore();
  }
}

// ─── Card de local (clicável) ───

class _LocalCard extends PositionComponent with TapCallbacks {
  final _LocalData local;
  final int index;
  final VoidCallback onTap;
  bool _enabled = false;
  double _flashTimer = 0;
  bool _isFlashing = false;
  bool _isCorrectFlash = false;

  _LocalCard({
    required Vector2 position,
    required Vector2 size,
    required this.local,
    required this.index,
    required this.onTap,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.center,
        );

  void setEnabled(bool value) => _enabled = value;

  void flashHighlight() {
    _isFlashing = true;
    _isCorrectFlash = false;
    _flashTimer = 0.8;
  }

  void flashCorrect() {
    _isFlashing = true;
    _isCorrectFlash = true;
    _flashTimer = 0.5;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_flashTimer > 0) {
      _flashTimer -= dt;
      if (_flashTimer <= 0) {
        _isFlashing = false;
        _flashTimer = 0;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    Color bgColor;
    if (_isFlashing) {
      bgColor = _isCorrectFlash
          ? const Color(0xFFC8E6C9)
          : const Color(0xFFFFF59D);
    } else if (_enabled) {
      bgColor = const Color(0xFFFFFFFF);
    } else {
      bgColor = const Color(0xFFF5F5F5);
    }

    final bgPaint = Paint()..color = bgColor;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(12),
    );
    canvas.drawRRect(rrect, bgPaint);

    // Borda
    final borderColor = _isFlashing
        ? (_isCorrectFlash ? const Color(0xFF4CAF50) : const Color(0xFFFFCA28))
        : (_enabled ? local.color : const Color(0xFFCFD8DC));
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _isFlashing ? 3 : 2;
    canvas.drawRRect(rrect, borderPaint);

    // Emoji do local
    final emojiPainter = TextPainter(
      text: TextSpan(
        text: local.emoji,
        style: const TextStyle(fontSize: 28),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    emojiPainter.layout();
    emojiPainter.paint(
      canvas,
      Offset(
        (size.x - emojiPainter.width) / 2,
        8,
      ),
    );

    // Nome do local
    final namePainter = TextPainter(
      text: TextSpan(
        text: local.name,
        style: TextStyle(
          color: _enabled ? Colors.black87 : Colors.black45,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    namePainter.layout(maxWidth: size.x - 8);
    namePainter.paint(
      canvas,
      Offset(
        (size.x - namePainter.width) / 2,
        size.y - namePainter.height - 8,
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_enabled) {
      onTap();
    }
  }
}

// ─── Botão Sair ───

class _ExitButton extends PositionComponent with TapCallbacks {
  final VoidCallback onTap;

  _ExitButton({
    required Vector2 position,
    required this.onTap,
  }) : super(
          position: position,
          size: Vector2(70, 32),
          anchor: Anchor.topLeft,
        );

  @override
  void render(Canvas canvas) {
    final bgPaint = Paint()..color = const Color(0xFFEF5350);
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(6),
    );
    canvas.drawRRect(rrect, bgPaint);

    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Sair',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.x - textPainter.width) / 2,
        (size.y - textPainter.height) / 2,
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }
}
