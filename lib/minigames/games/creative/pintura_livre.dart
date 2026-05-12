import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../../minigame_base.dart';

/// Mini-jogo: "Pintura Livre"
///
/// Tela branca com paleta de 8 cores na parte inferior.
/// O jogador toca na cor e depois na tela para pintar (círculos).
/// Botão "Limpar" para apagar.
/// Botão "Salvar" (mock, apenas feedback visual).
/// Sem recompensa (modo livre).
class PinturaLivreMiniGame extends MiniGameBase {
  PinturaLivreMiniGame()
      : super(
          id: 'pintura_livre',
          name: 'Pintura Livre',
          duration: const Duration(minutes: 5),
          skills: const ['criatividade', 'coordenacao_motora', 'cores'],
        );

  @override
  MiniGameResult onComplete() {
    return const MiniGameResult(
      stars: 0,
      coins: 0,
      message: 'Que arte linda!',
    );
  }
}

/// Um traço de tinta na tela.
class _PaintStroke {
  final Offset position;
  final Color color;
  final double radius;

  _PaintStroke({
    required this.position,
    required this.color,
    required this.radius,
  });
}

/// Cena do mini-jogo de pintura livre.
class PinturaLivreScene extends PositionComponent with TapCallbacks {
  final VoidCallback onExit;

  double _opacity = 0;
  double? _targetOpacity;
  VoidCallback? _onFadeComplete;

  Color _selectedColor = Colors.red;
  final List<_PaintStroke> _strokes = [];
  bool _showSavedFeedback = false;
  double _savedFeedbackTimer = 0;

  static const double _paletteHeight = 70;
  static const double _brushSize = 14;

  late TextComponent _titleText;
  late TextComponent _feedbackText;

  PinturaLivreScene({
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

    // Fundo branco (tela)
    add(
      RectangleComponent(
        position: Vector2.zero(),
        size: Vector2(size.x, size.y - _paletteHeight),
        paint: Paint()..color = Colors.white,
      ),
    );

    // Área da paleta
    add(
      RectangleComponent(
        position: Vector2(0, size.y - _paletteHeight),
        size: Vector2(size.x, _paletteHeight),
        paint: Paint()..color = const Color(0xFFF5F5F5),
      ),
    );

    // Borda da paleta
    add(
      RectangleComponent(
        position: Vector2(0, size.y - _paletteHeight),
        size: Vector2(size.x, 3),
        paint: Paint()..color = const Color(0xFFBDBDBD),
      ),
    );

    // Título
    _titleText = TextComponent(
      text: '🎨 Pintura Livre',
      position: Vector2(size.x / 2, 20),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFF424242),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(_titleText);

    // Feedback text
    _feedbackText = TextComponent(
      text: '',
      position: Vector2(size.x / 2, size.y / 2 - 30),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFF4CAF50),
          fontSize: 28,
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
        position: Vector2(size.x - 70, 14),
        onTap: exit,
      ),
    );

    // Botão Limpar
    add(
      _ActionButton(
        position: Vector2(16, 14),
        label: '🗑️ Limpar',
        color: const Color(0xFF757575),
        onTap: _clearCanvas,
      ),
    );

    // Botão Salvar
    add(
      _ActionButton(
        position: Vector2(110, 14),
        label: '💾 Salvar',
        color: const Color(0xFF4CAF50),
        onTap: _onSave,
      ),
    );

    // Cores da paleta
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.pink,
      const Color(0xFF795548), // marrom
    ];

    final spacing = (size.x - 32) / colors.length;
    for (int i = 0; i < colors.length; i++) {
      add(
        _ColorButton(
          position: Vector2(16 + i * spacing + spacing / 2, size.y - _paletteHeight / 2),
          color: colors[i],
          isSelected: colors[i] == _selectedColor,
          onTap: () => _selectColor(colors[i]),
        ),
      );
    }
  }

  void _selectColor(Color color) {
    _selectedColor = color;

    // Atualizar visual dos botões
    final buttons = children.whereType<_ColorButton>().toList();
    for (final btn in buttons) {
      btn.isSelected = btn.color == color;
    }
  }

  void _clearCanvas() {
    _strokes.clear();
  }

  void _onSave() {
    _showSavedFeedback = true;
    _savedFeedbackTimer = 1.5;
    _feedbackText.text = '💾 Salvo!';
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    final localPos = event.localPosition;

    // Só pinta se estiver na área da tela (não na paleta)
    if (localPos.y < size.y - _paletteHeight - 10) {
      _strokes.add(_PaintStroke(
        position: Offset(localPos.x, localPos.y),
        color: _selectedColor,
        radius: _brushSize,
      ));
    }
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

    // Saved feedback timer
    if (_showSavedFeedback) {
      _savedFeedbackTimer -= dt;
      if (_savedFeedbackTimer <= 0) {
        _showSavedFeedback = false;
        _feedbackText.text = '';
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

    // Renderizar traços de pintura
    for (final stroke in _strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(stroke.position, stroke.radius, paint);

      // Centro mais opaco
      final centerPaint = Paint()..color = stroke.color;
      canvas.drawCircle(stroke.position, stroke.radius * 0.6, centerPaint);
    }

    canvas.restore();
  }
}

/// Botão de cor na paleta.
class _ColorButton extends PositionComponent with TapCallbacks {
  final Color color;
  bool isSelected;
  final VoidCallback onTap;

  _ColorButton({
    required Vector2 position,
    required this.color,
    this.isSelected = false,
    required this.onTap,
  }) : super(
          position: position,
          size: Vector2.all(42),
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    // Sombra se selecionado
    if (isSelected) {
      final shadowPaint = Paint()
        ..color = Colors.black26
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(
        Offset(size.x / 2, size.y / 2 + 2),
        size.x / 2 + 4,
        shadowPaint,
      );
    }

    // Círculo de cor
    final paint = Paint()..color = color;
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      paint,
    );

    // Borda
    final borderPaint = Paint()
      ..color = isSelected ? Colors.white : Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = isSelected ? 3 : 1.5;
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      borderPaint,
    );

    // Indicador de seleção
    if (isSelected) {
      final checkPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
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
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }
}

/// Botão de ação (Limpar / Salvar).
class _ActionButton extends PositionComponent with TapCallbacks {
  final String label;
  final Color color;
  final VoidCallback onTap;

  _ActionButton({
    required Vector2 position,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(
          position: position,
          size: Vector2(88, 30),
          anchor: Anchor.topLeft,
        );

  @override
  void render(Canvas canvas) {
    final bgPaint = Paint()..color = color;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(6),
    );
    canvas.drawRRect(rrect, bgPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
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

/// Botão Sair.
class _ExitButton extends PositionComponent with TapCallbacks {
  final VoidCallback onTap;

  _ExitButton({
    required Vector2 position,
    required this.onTap,
  }) : super(
          position: position,
          size: Vector2(50, 26),
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
          fontSize: 11,
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
