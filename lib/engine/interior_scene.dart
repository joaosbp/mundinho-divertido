import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

/// Cena de interior da Casa do Jogador.
///
/// Renderiza quarto e cozinha com cores distintas do mundo exterior.
/// Suporta fade in/out de 300ms via controle manual de opacidade.
class InteriorScene extends PositionComponent {
  final VoidCallback onExit;

  double _opacity = 0;
  double? _targetOpacity;
  VoidCallback? _onFadeComplete;

  InteriorScene({
    required this.onExit,
    required Vector2 size,
    Vector2? position,
  }) : super(
          size: size,
          position: position ?? Vector2.zero(),
          anchor: Anchor.topLeft,
        );

  /// Inicia fade in (0 → 1) em 300ms.
  void enter() {
    _opacity = 0;
    _targetOpacity = 1.0;
    _onFadeComplete = null;
  }

  /// Inicia fade out (1 → 0) em 300ms e chama [onExit] ao terminar.
  void exit() {
    _targetOpacity = 0;
    _onFadeComplete = onExit;
  }

  @override
  Future<void> onLoad() async {
    // Fundo do interior (bege claro)
    add(
      RectangleComponent(
        position: Vector2.zero(),
        size: size,
        paint: Paint()..color = const Color(0xFFFFF8E1),
      ),
    );

    // ─── Quarto (lado esquerdo) ───
    add(
      RectangleComponent(
        position: Vector2(20, 20),
        size: Vector2(size.x / 2 - 30, size.y - 40),
        paint: Paint()..color = const Color(0xFFFFE0B2),
      ),
    );

    // Cama
    add(
      RectangleComponent(
        position: Vector2(50, size.y / 2),
        size: Vector2(70, 90),
        paint: Paint()..color = const Color(0xFF8D6E63),
      ),
    );

    // Travesseiro
    add(
      RectangleComponent(
        position: Vector2(55, size.y / 2 + 5),
        size: Vector2(60, 20),
        paint: Paint()..color = const Color(0xFFFFFFFF),
      ),
    );

    // ─── Cozinha (lado direito) ───
    add(
      RectangleComponent(
        position: Vector2(size.x / 2 + 10, 20),
        size: Vector2(size.x / 2 - 30, size.y - 40),
        paint: Paint()..color = const Color(0xFFFFCCBC),
      ),
    );

    // Geladeira
    add(
      RectangleComponent(
        position: Vector2(size.x / 2 + 30, 40),
        size: Vector2(40, 70),
        paint: Paint()..color = const Color(0xFFB0BEC5),
      ),
    );

    // Mesa
    add(
      RectangleComponent(
        position: Vector2(size.x / 2 + 90, size.y / 2 + 30),
        size: Vector2(60, 60),
        paint: Paint()..color = const Color(0xFF795548),
      ),
    );

    // Botão Sair
    add(
      ExitButton(
        position: Vector2(size.x - 90, 20),
        onTap: exit,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_targetOpacity != null) {
      final step = dt / 0.3; // 300ms total
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
      Paint()..color = Colors.white.withValues(alpha: _opacity),
    );
    super.renderTree(canvas);
    canvas.restore();
  }
}

/// Botão "Sair" no canto superior direito do interior.
class ExitButton extends PositionComponent with TapCallbacks {
  final VoidCallback onTap;

  ExitButton({
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
