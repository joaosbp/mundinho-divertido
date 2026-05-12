import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

/// Overlay de diálogo que aparece quando o player toca em um NPC.
/// Balão com avatar do NPC (círculo colorido), texto e botão "Fechar".
/// Animação de fade in/out (200ms).
class NpcDialogueOverlay extends PositionComponent with TapCallbacks {
  final String npcName;
  final String text;
  final VoidCallback onClose;
  final Color avatarColor;

  double _opacity = 0;
  double? _targetOpacity;
  VoidCallback? _onFadeComplete;
  bool _isClosing = false;

  NpcDialogueOverlay({
    required this.npcName,
    required this.text,
    required this.onClose,
    required Vector2 size,
    this.avatarColor = const Color(0xFF42A5F5),
  }) : super(
          size: size,
          position: Vector2.zero(),
          anchor: Anchor.topLeft,
        );

  void show() {
    _opacity = 0;
    _targetOpacity = 1.0;
    _onFadeComplete = null;
    _isClosing = false;
  }

  void close() {
    if (_isClosing) return;
    _isClosing = true;
    _targetOpacity = 0;
    _onFadeComplete = onClose;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_targetOpacity != null) {
      final step = dt / 0.2; // 200ms
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
  }

  @override
  void renderTree(Canvas canvas) {
    if (_opacity <= 0.01) return;

    canvas.saveLayer(
      null,
      Paint()..color = Colors.white.withOpacity(_opacity),
    );
    super.renderTree(canvas);
    canvas.restore();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Fundo escuro semi-transparente
    add(
      RectangleComponent(
        position: Vector2.zero(),
        size: size,
        paint: Paint()..color = const Color(0x88000000),
      ),
    );

    // Painel do diálogo (centralizado)
    final panelWidth = size.x * 0.8;
    final panelHeight = size.y * 0.35;
    final panelX = (size.x - panelWidth) / 2;
    final panelY = (size.y - panelHeight) / 2;

    add(
      RoundedPanel(
        position: Vector2(panelX, panelY),
        size: Vector2(panelWidth, panelHeight),
        color: const Color(0xFFFFF8E1),
      ),
    );

    // Avatar do NPC
    add(
      NpcAvatar(
        position: Vector2(panelX + 20, panelY + 20),
        size: Vector2.all(50),
        color: avatarColor,
      ),
    );

    // Nome do NPC
    add(
      TextComponent(
        text: npcName,
        position: Vector2(panelX + 80, panelY + 20),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFF3E2723),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    // Texto do diálogo
    add(
      TextComponent(
        text: text,
        position: Vector2(panelX + 20, panelY + 80),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFF3E2723),
            fontSize: 14,
          ),
        ),
      ),
    );

    // Botão Fechar
    add(
      CloseButton(
        position: Vector2(
          panelX + panelWidth - 90,
          panelY + panelHeight - 45,
        ),
        onTap: close,
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Consome o toque para não propagar para o mundo
    event.handled = true;
  }
}

/// Painel arredondado para o diálogo.
class RoundedPanel extends PositionComponent {
  final Color color;

  RoundedPanel({
    required Vector2 position,
    required Vector2 size,
    required this.color,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.topLeft,
        );

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = color;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(12),
    );
    canvas.drawRRect(rrect, paint);

    // Borda sutil
    final borderPaint = Paint()
      ..color = const Color(0xFF8D6E63)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(rrect, borderPaint);
  }
}

/// Avatar circular do NPC (placeholder visual).
class NpcAvatar extends PositionComponent {
  final Color color;

  NpcAvatar({
    required Vector2 position,
    required Vector2 size,
    required this.color,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.topLeft,
        );

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = color;
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      paint,
    );

    // Chapéu (triângulo)
    final hatPaint = Paint()..color = const Color(0xFFEF6C00);
    final hatPath = Path()
      ..moveTo(size.x / 2 - 10, size.y / 2 - 8)
      ..lineTo(size.x / 2, size.y / 2 - 18)
      ..lineTo(size.x / 2 + 10, size.y / 2 - 8)
      ..close();
    canvas.drawPath(hatPath, hatPaint);

    // Olhos
    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(const Offset(18, 20), 4, eyePaint);
    canvas.drawCircle(const Offset(32, 20), 4, eyePaint);

    final pupilPaint = Paint()..color = Colors.black;
    canvas.drawCircle(const Offset(18, 20), 2, pupilPaint);
    canvas.drawCircle(const Offset(32, 20), 2, pupilPaint);

    // Sorriso
    final smilePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawArc(
      Rect.fromCenter(center: const Offset(25, 28), width: 12, height: 6),
      0,
      3.14,
      false,
      smilePaint,
    );
  }
}

/// Botão "Fechar" do diálogo.
class CloseButton extends PositionComponent with TapCallbacks {
  final VoidCallback onTap;

  CloseButton({
    required Vector2 position,
    required this.onTap,
  }) : super(
          position: position,
          size: Vector2(70, 32),
          anchor: Anchor.topLeft,
        );

  @override
  void render(Canvas canvas) {
    final bgPaint = Paint()..color = const Color(0xFF66BB6A);
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(6),
    );
    canvas.drawRRect(rrect, bgPaint);

    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Fechar',
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
    event.handled = true;
    onTap();
  }
}
