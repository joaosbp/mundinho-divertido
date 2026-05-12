import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

/// Menu de pausa — overlay semitransparente com opções.
class PauseMenuOverlay extends PositionComponent with TapCallbacks {
  final VoidCallback onResume;
  final VoidCallback onSettings;
  final VoidCallback onQuit;

  double _opacity = 0;
  double _targetOpacity = 1.0;

  PauseMenuOverlay({
    required this.onResume,
    required this.onSettings,
    required this.onQuit,
  }) : super(
          position: Vector2.zero(),
          anchor: Anchor.topLeft,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _opacity = 0;
    _targetOpacity = 1.0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if ((_targetOpacity - _opacity).abs() > 0.01) {
      final step = dt / 0.2;
      if (_opacity < _targetOpacity) {
        _opacity = (_opacity + step).clamp(0.0, _targetOpacity);
      } else {
        _opacity = (_opacity - step).clamp(_targetOpacity, 1.0);
      }
    } else {
      _opacity = _targetOpacity;
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
  void render(Canvas canvas) {
    // Fundo escuro
    final bgPaint = Paint()..color = const Color(0xB3000000);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), bgPaint);

    final panelW = 320.0;
    final panelH = 320.0;
    final panelX = (size.x - panelW) / 2;
    final panelY = (size.y - panelH) / 2;

    // Painel
    final panelPaint = Paint()..color = AppColors.greyLight;
    final panelRrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(panelX, panelY, panelW, panelH),
      const Radius.circular(24),
    );
    canvas.drawRRect(panelRrect, panelPaint);

    // Sombra sutil
    final shadowPaint = Paint()
      ..color = Colors.black26
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawRRect(panelRrect, shadowPaint);
    canvas.drawRRect(panelRrect, panelPaint);

    // Título
    final titlePainter = TextPainter(
      text: const TextSpan(
        text: '⏸️ Pausa',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    titlePainter.layout();
    titlePainter.paint(
      canvas,
      Offset(panelX + (panelW - titlePainter.width) / 2, panelY + 24),
    );

    // Botões
    _drawButton(canvas, panelX + 24, panelY + 80, panelW - 48, 52,
        '▶️ Continuar', AppColors.success, onResume);
    _drawButton(canvas, panelX + 24, panelY + 148, panelW - 48, 52,
        '⚙️ Configurações', AppColors.info, onSettings);
    _drawButton(canvas, panelX + 24, panelY + 216, panelW - 48, 52,
        '🏠 Sair para Menu', AppColors.warning, onQuit);
  }

  void _drawButton(Canvas canvas, double x, double y, double w, double h,
      String text, Color color, VoidCallback onTap) {
    final rect = Rect.fromLTWH(x, y, w, h);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(16));

    final paint = Paint()..color = color;
    canvas.drawRRect(rrect, paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(x + (w - textPainter.width) / 2, y + (h - textPainter.height) / 2),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    event.handled = true;
    final local = event.localPosition;

    final panelW = 320.0;
    final panelH = 320.0;
    final panelX = (size.x - panelW) / 2;
    final panelY = (size.y - panelH) / 2;

    if (_hitButton(local, panelX + 24, panelY + 80, panelW - 48, 52)) {
      onResume();
    } else if (_hitButton(
        local, panelX + 24, panelY + 148, panelW - 48, 52)) {
      onSettings();
    } else if (_hitButton(
        local, panelX + 24, panelY + 216, panelW - 48, 52)) {
      onQuit();
    }
  }

  bool _hitButton(Vector2 pos, double x, double y, double w, double h) {
    return pos.x >= x && pos.x <= x + w && pos.y >= y && pos.y <= y + h;
  }
}
