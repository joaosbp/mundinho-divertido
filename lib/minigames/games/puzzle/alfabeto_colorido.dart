import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../../../core/services/save_service.dart';
import '../../minigame_base.dart';

/// Mini-jogo: "Alfabeto Colorido"
///
/// Letras A-E embaralhadas na tela.
/// O jogador toca nas letras na ordem correta A → B → C → D → E.
/// Feedback visual quando a letra está na posição correta.
/// Recompensa: moedas + estrela ao completar.
class AlfabetoColoridoMiniGame extends MiniGameBase {
  AlfabetoColoridoMiniGame()
      : super(
          id: 'alfabeto_colorido',
          name: 'Alfabeto Colorido',
          duration: const Duration(minutes: 2),
          skills: const ['alfabetizacao', 'sequencia', 'reconhecimento_letras'],
        );

  @override
  MiniGameResult onComplete() {
    return const MiniGameResult(
      stars: 3,
      coins: 15,
      message: 'Incrível! Você aprendeu o alfabeto!',
    );
  }
}

/// Cena do mini-jogo de alfabeto.
class AlfabetoColoridoScene extends PositionComponent {
  final VoidCallback onExit;

  double _opacity = 0;
  double? _targetOpacity;
  VoidCallback? _onFadeComplete;

  int _currentIndex = 0; // qual letra deve ser tocada (0=A, 1=B, ...)
  final List<_LetterState> _letters = [];
  bool _gameComplete = false;
  double _celebrationTimer = 0;

  late TextComponent _instructionText;
  late TextComponent _feedbackText;

  final Random _random = Random();

  AlfabetoColoridoScene({
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

    // Fundo lilás claro
    add(
      RectangleComponent(
        position: Vector2.zero(),
        size: size,
        paint: Paint()..color = const Color(0xFFF3E5F5),
      ),
    );

    // Título
    _instructionText = TextComponent(
      text: 'Toque na ordem: A → B → C → D → E',
      position: Vector2(size.x / 2, 28),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFF6A1B9A),
          fontSize: 20,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.white, blurRadius: 3),
          ],
        ),
      ),
    );
    add(_instructionText);

    // Feedback text
    _feedbackText = TextComponent(
      text: '',
      position: Vector2(size.x / 2, size.y / 2 - 40),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFF6A1B9A),
          fontSize: 36,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.white, blurRadius: 4),
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

    // Inicializar letras
    _initLetters();
  }

  void _initLetters() {
    const letters = ['A', 'B', 'C', 'D', 'E'];
    final colors = [
      const Color(0xFFEF5350),
      const Color(0xFF42A5F5),
      const Color(0xFFFFCA28),
      const Color(0xFF66BB6A),
      const Color(0xFFAB47BC),
    ];

    // Embaralhar posições
    final positions = _generatePositions(letters.length);

    for (int i = 0; i < letters.length; i++) {
      final pos = positions[i];
      _letters.add(
        _LetterState(
          letter: letters[i],
          color: colors[i],
          targetIndex: i,
          currentPos: pos,
          isCorrect: false,
        ),
      );

      add(
        _LetterButton(
          position: pos,
          letter: letters[i],
          color: colors[i],
          onTap: () => _onLetterTapped(letters[i]),
        ),
      );
    }
  }

  List<Vector2> _generatePositions(int count) {
    final marginX = 80.0;
    final marginY = 100.0;
    final availableW = size.x - marginX * 2;
    final availableH = size.y - marginY * 2;

    // Distribuir em grid 3x2
    final cols = 3;
    final rows = 2;
    final cellW = availableW / cols;
    final cellH = availableH / rows;

    final candidates = <Vector2>[];
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        candidates.add(Vector2(
          marginX + c * cellW + cellW / 2,
          marginY + r * cellH + cellH / 2,
        ));
      }
    }

    candidates.shuffle(_random);
    return candidates.sublist(0, count);
  }

  void _onLetterTapped(String letter) {
    if (_gameComplete) return;

    final expectedLetter = String.fromCharCode('A'.codeUnitAt(0) + _currentIndex);
    if (letter == expectedLetter) {
      // Acertou!
      _currentIndex++;
      _updateLetterVisuals();

      if (_currentIndex >= 5) {
        _gameComplete = true;
        _celebrationTimer = 2.5;
        _feedbackText.text = '🎉 Parabéns! 🎉';
        _instructionText.text = 'Você completou o alfabeto!';
        _awardReward();
      } else {
        _feedbackText.text = '✅ ${letter}';
        Future.delayed(const Duration(milliseconds: 600), () {
          if (!_gameComplete) _feedbackText.text = '';
        });
      }
    } else {
      // Errou
      _feedbackText.text = '❌ Tente ${String.fromCharCode('A'.codeUnitAt(0) + _currentIndex)}!';
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!_gameComplete) _feedbackText.text = '';
      });
    }
  }

  void _updateLetterVisuals() {
    // Remover letras antigas
    final toRemove = children.whereType<_LetterButton>().toList();
    for (final el in toRemove) {
      el.removeFromParent();
    }

    // Recriar com estados atualizados
    for (int i = 0; i < _letters.length; i++) {
      final state = _letters[i];
      state.isCorrect = state.targetIndex < _currentIndex;

      add(
        _LetterButton(
          position: state.currentPos,
          letter: state.letter,
          color: state.color,
          isLocked: state.isCorrect,
          onTap: () => _onLetterTapped(state.letter),
        ),
      );
    }
  }

  void _awardReward() {
    const coins = 15;
    const stars = 3;

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
  }

  void _onExitPressed() {
    if (!_gameComplete) {
      // Recompensa parcial
      final partialStars = _currentIndex >= 4 ? 2 : _currentIndex >= 2 ? 1 : 0;
      final partialCoins = _currentIndex * 2;

      final save = SaveService();
      if (save.isInitialized) {
        final data = save.playerData;
        save.savePlayerData(
          data.copyWith(
            coins: data.coins + partialCoins,
            stars: data.stars + partialStars,
          ),
        );
      }
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

    // Celebração
    if (_gameComplete) {
      _celebrationTimer -= dt;
      if (_celebrationTimer <= 0) {
        exit();
      }
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

    // Renderizar confetes se completou
    if (_gameComplete) {
      _renderConfetti(canvas);
    }

    canvas.restore();
  }

  void _renderConfetti(Canvas canvas) {
    final confettiColors = [
      Colors.red,
      Colors.blue,
      Colors.yellow,
      Colors.green,
      Colors.purple,
      Colors.orange,
    ];

    final time = DateTime.now().millisecondsSinceEpoch / 500;
    for (int i = 0; i < 30; i++) {
      final x = (sin(time + i * 0.5) * 0.5 + 0.5) * size.x;
      final y = ((time * 50 + i * 30) % size.y.toInt()).toDouble();
      final color = confettiColors[i % confettiColors.length];
      final paint = Paint()..color = color;

      canvas.drawCircle(Offset(x, y), 4, paint);
    }
  }
}

/// Estado de uma letra no jogo.
class _LetterState {
  final String letter;
  final Color color;
  final int targetIndex;
  final Vector2 currentPos;
  bool isCorrect;

  _LetterState({
    required this.letter,
    required this.color,
    required this.targetIndex,
    required this.currentPos,
    this.isCorrect = false,
  });
}

/// Botão de letra interativo.
class _LetterButton extends PositionComponent with TapCallbacks {
  final String letter;
  final Color color;
  final bool isLocked;
  final VoidCallback onTap;

  _LetterButton({
    required Vector2 position,
    required this.letter,
    required this.color,
    this.isLocked = false,
    required this.onTap,
  }) : super(
          position: position,
          size: Vector2.all(70),
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    // Fundo
    final bgPaint = Paint()..color = isLocked ? color.withValues(alpha: 0.4) : color;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(16),
      ),
      bgPaint,
    );

    // Borda
    final borderPaint = Paint()
      ..color = isLocked ? Colors.grey : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = isLocked ? 2 : 4;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(16),
      ),
      borderPaint,
    );

    // Checkmark se já acertou
    if (isLocked) {
      final checkPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;
      canvas.drawLine(
        Offset(size.x * 0.25, size.y * 0.5),
        Offset(size.x * 0.4, size.y * 0.65),
        checkPaint,
      );
      canvas.drawLine(
        Offset(size.x * 0.4, size.y * 0.65),
        Offset(size.x * 0.75, size.y * 0.3),
        checkPaint,
      );
    }

    // Letra
    final textPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: TextStyle(
          color: isLocked ? Colors.white70 : Colors.white,
          fontSize: 36,
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
    if (!isLocked) {
      onTap();
    }
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
