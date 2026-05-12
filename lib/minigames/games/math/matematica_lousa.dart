import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../../../core/services/save_service.dart';
import '../../minigame_base.dart';

/// Mini-jogo: "Matemática na Lousa"
///
/// Mostra 3-5 objetos coloridos na tela.
/// O jogador conta e toca no número correto (1-5).
/// Feedback ✅/❌ e recompensa em moedas por acerto.
class MatematicaLousaMiniGame extends MiniGameBase {
  MatematicaLousaMiniGame()
      : super(
          id: 'matematica_lousa',
          name: 'Matemática na Lousa',
          duration: const Duration(minutes: 2),
          skills: const ['contagem', 'reconhecimento_numerico', 'atencao'],
        );

  @override
  MiniGameResult onComplete() {
    return const MiniGameResult(
      stars: 2,
      coins: 10,
      message: 'Parabéns! Você contou tudo certinho!',
    );
  }
}

/// Cena do mini-jogo de matemática (roda em tela cheia dentro do interior).
class MatematicaLousaScene extends PositionComponent {
  final VoidCallback onExit;

  double _opacity = 0;
  double? _targetOpacity;
  VoidCallback? _onFadeComplete;

  late int _targetCount;
  int _currentRound = 0;
  static const int _maxRounds = 5;
  bool _roundActive = false;
  bool _showingFeedback = false;
  double _feedbackTimer = 0;
  static const double _feedbackDuration = 1.0;

  int _correctAnswers = 0;

  late TextComponent _titleText;
  late TextComponent _feedbackText;
  late TextComponent _roundText;

  final Random _random = Random();
  final List<Vector2> _objectPositions = [];

  MatematicaLousaScene({
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

    // Fundo verde estilo lousa
    add(
      RectangleComponent(
        position: Vector2.zero(),
        size: size,
        paint: Paint()..color = const Color(0xFF2E7D32),
      ),
    );

    // Borda da lousa
    add(
      RectangleComponent(
        position: Vector2(12, 12),
        size: Vector2(size.x - 24, size.y - 24),
        paint: Paint()
          ..color = const Color(0xFF1B5E20)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
      ),
    );

    // Título
    _titleText = TextComponent(
      text: 'Conte os círculos!',
      position: Vector2(size.x / 2, 28),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.black45, blurRadius: 3),
          ],
        ),
      ),
    );
    add(_titleText);

    // Round indicator
    _roundText = TextComponent(
      text: 'Rodada 1/$_maxRounds',
      position: Vector2(size.x - 20, 28),
      anchor: Anchor.centerRight,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
    add(_roundText);

    // Feedback text (invisível inicialmente)
    _feedbackText = TextComponent(
      text: '',
      position: Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.black54, blurRadius: 4),
          ],
        ),
      ),
    );
    add(_feedbackText);

    // Botão Sair
    add(
      _ExitButton(
        position: Vector2(size.x - 80, 16),
        onTap: _onExitPressed,
      ),
    );

    // Iniciar primeira rodada
    _startRound();
  }

  void _startRound() {
    _currentRound++;
    _roundText.text = 'Rodada $_currentRound/$_maxRounds';
    _targetCount = _random.nextInt(3) + 3; // 3 a 5
    _roundActive = true;
    _showingFeedback = false;
    _feedbackText.text = '';

    // Gerar posições aleatórias para os objetos
    _objectPositions.clear();
    for (int i = 0; i < _targetCount; i++) {
      double x, y;
      int attempts = 0;
      do {
        x = 60 + _random.nextDouble() * (size.x - 120);
        y = 80 + _random.nextDouble() * (size.y - 220);
        attempts++;
      } while (attempts < 50 && _isTooClose(x, y));
      _objectPositions.add(Vector2(x, y));
    }

    // Reconstruir botões de números
    _buildNumberButtons();
  }

  bool _isTooClose(double x, double y) {
    for (final pos in _objectPositions) {
      if ((pos.x - x).abs() < 40 && (pos.y - y).abs() < 40) return true;
    }
    return false;
  }

  void _buildNumberButtons() {
    // Remover botões antigos
    final toRemove = children.whereType<_NumberButton>().toList();
    for (final el in toRemove) {
      el.removeFromParent();
    }

    // Criar botões 1-5
    final buttonY = size.y - 70;
    final spacing = size.x / 6;
    for (int i = 1; i <= 5; i++) {
      add(
        _NumberButton(
          position: Vector2(spacing * i, buttonY),
          number: i,
          onTap: () => _onNumberTapped(i),
        ),
      );
    }
  }

  void _onNumberTapped(int number) {
    if (!_roundActive || _showingFeedback) return;

    final correct = number == _targetCount;
    _showingFeedback = true;
    _feedbackTimer = _feedbackDuration;

    if (correct) {
      _correctAnswers++;
      _feedbackText.text = '✅';
      _awardCoins(2);
    } else {
      _feedbackText.text = '❌';
    }
  }

  void _awardCoins(int amount) {
    final save = SaveService();
    if (save.isInitialized) {
      final data = save.playerData;
      save.savePlayerData(
        data.copyWith(coins: data.coins + amount),
      );
    }
  }

  void _onExitPressed() {
    // Calcular recompensa final
    final stars = _correctAnswers >= 4 ? 3 : _correctAnswers >= 2 ? 2 : 1;
    final coins = _correctAnswers * 2;

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

    exit();
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

    // Feedback timer
    if (_showingFeedback) {
      _feedbackTimer -= dt;
      if (_feedbackTimer <= 0) {
        _showingFeedback = false;
        _feedbackText.text = '';

        if (_currentRound >= _maxRounds) {
          // Fim do jogo
          _showEndGame();
        } else {
          _startRound();
        }
      }
    }
  }

  void _showEndGame() {
    _roundActive = false;
    final stars = _correctAnswers >= 4 ? 3 : _correctAnswers >= 2 ? 2 : 1;
    _feedbackText.text = '🎉 $_correctAnswers/$_maxRounds\n⭐' * stars;

    // Remover botões de números
    final toRemove = children.whereType<_NumberButton>().toList();
    for (final el in toRemove) {
      el.removeFromParent();
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

    // Renderizar objetos coloridos (círculos)
    if (_roundActive && !_showingFeedback) {
      _renderObjects(canvas);
    }

    canvas.restore();
  }

  void _renderObjects(Canvas canvas) {
    final colors = [
      const Color(0xFFEF5350),
      const Color(0xFF42A5F5),
      const Color(0xFFFFCA28),
      const Color(0xFF66BB6A),
      const Color(0xFFAB47BC),
      const Color(0xFFFF7043),
      const Color(0xFF26C6DA),
    ];

    for (int i = 0; i < _objectPositions.length; i++) {
      final pos = _objectPositions[i];
      final color = colors[i % colors.length];
      final paint = Paint()..color = color;

      canvas.drawCircle(
        Offset(pos.x, pos.y),
        18,
        paint,
      );

      // Brilho
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(
        Offset(pos.x - 5, pos.y - 5),
        8,
        highlightPaint,
      );
    }
  }
}

/// Botão numérico para o mini-jogo de matemática.
class _NumberButton extends PositionComponent with TapCallbacks {
  final int number;
  final VoidCallback onTap;

  _NumberButton({
    required Vector2 position,
    required this.number,
    required this.onTap,
  }) : super(
          position: position,
          size: Vector2.all(50),
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    // Fundo
    final bgPaint = Paint()..color = const Color(0xFF1565C0);
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      bgPaint,
    );

    // Borda
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      borderPaint,
    );

    // Número
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$number',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
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

/// Botão Sair.
class _ExitButton extends PositionComponent with TapCallbacks {
  final VoidCallback onTap;

  _ExitButton({
    required Vector2 position,
    required this.onTap,
  }) : super(
          position: position,
          size: Vector2(60, 28),
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
          fontSize: 12,
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
