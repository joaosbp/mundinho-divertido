import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../entities/npcs/npc_base.dart';
import '../entities/npcs/prefeito_tico.dart';

/// Cena de interior da Prefeitura.
///
/// Renderiza salão principal com mesa do prefeito, bandeiras nas paredes
/// e o Prefeito Tico posicionado atrás da mesa.
class PrefeituraInteriorScene extends PositionComponent {
  final VoidCallback onExit;
  final void Function(NpcBase npc)? onNpcInteract;

  double _opacity = 0;
  double? _targetOpacity;
  VoidCallback? _onFadeComplete;
  late PrefeitoTico _prefeito;

  PrefeituraInteriorScene({
    required this.onExit,
    this.onNpcInteract,
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

    // Fundo do salão (bege claro)
    add(
      RectangleComponent(
        position: Vector2.zero(),
        size: size,
        paint: Paint()..color = const Color(0xFFF5F5DC),
      ),
    );

    // Piso (madeira)
    add(
      RectangleComponent(
        position: Vector2(20, size.y * 0.6),
        size: Vector2(size.x - 40, size.y * 0.4),
        paint: Paint()..color = const Color(0xFF8D6E63),
      ),
    );

    // Bandeiras nas paredes (esquerda)
    add(
      _BandeiraParede(
        position: Vector2(40, 60),
        size: Vector2(36, 50),
        isBrasil: true,
      ),
    );

    // Bandeiras nas paredes (direita)
    add(
      _BandeiraParede(
        position: Vector2(size.x - 76, 60),
        size: Vector2(36, 50),
        isBrasil: true,
      ),
    );

    // Mesa do prefeito (grande, no fundo)
    add(
      _MesaPrefeito(
        position: Vector2(size.x / 2 - 80, size.y * 0.35),
        size: Vector2(160, 60),
      ),
    );

    // Cadeira do prefeito
    add(
      _CadeiraPrefeito(
        position: Vector2(size.x / 2 - 20, size.y * 0.35 - 35),
        size: Vector2(40, 40),
      ),
    );

    // Prefeito Tico (estático atrás da mesa)
    _prefeito = PrefeitoTico(
      position: Vector2(size.x / 2, size.y * 0.35 - 10),
      onInteractCallback: () => onNpcInteract?.call(_prefeito),
    );
    add(_prefeito);

    // Tapete vermelho
    add(
      RectangleComponent(
        position: Vector2(size.x / 2 - 60, size.y * 0.6),
        size: Vector2(120, size.y * 0.35),
        paint: Paint()..color = const Color(0xFFB71C1C),
      ),
    );

    // Banco para visitantes (esquerda)
    add(
      _BancoVisitante(
        position: Vector2(size.x * 0.2, size.y * 0.7),
        size: Vector2(60, 24),
      ),
    );

    // Banco para visitantes (direita)
    add(
      _BancoVisitante(
        position: Vector2(size.x * 0.65, size.y * 0.7),
        size: Vector2(60, 24),
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

/// Bandeira decorativa na parede do interior.
class _BandeiraParede extends PositionComponent {
  final bool isBrasil;

  _BandeiraParede({
    required Vector2 position,
    required Vector2 size,
    this.isBrasil = true,
  }) : super(position: position, size: size, anchor: Anchor.topLeft);

  @override
  void render(Canvas canvas) {
    if (isBrasil) {
      // Fundo verde
      final greenPaint = Paint()..color = const Color(0xFF009C3B);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), greenPaint);

      // Losango amarelo
      final yellowPaint = Paint()..color = const Color(0xFFFFDF00);
      final diamondPath = Path()
        ..moveTo(size.x / 2, 4)
        ..lineTo(size.x - 4, size.y / 2)
        ..lineTo(size.x / 2, size.y - 4)
        ..lineTo(4, size.y / 2)
        ..close();
      canvas.drawPath(diamondPath, yellowPaint);

      // Círculo azul
      final bluePaint = Paint()..color = const Color(0xFF002776);
      canvas.drawCircle(
        Offset(size.x / 2, size.y / 2),
        size.y * 0.2,
        bluePaint,
      );
    }

    // Haste
    final polePaint = Paint()..color = const Color(0xFF616161);
    canvas.drawRect(Rect.fromLTWH(size.x / 2 - 2, -12, 4, 14), polePaint);
  }
}

/// Mesa do prefeito.
class _MesaPrefeito extends PositionComponent {
  _MesaPrefeito({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topLeft);

  @override
  void render(Canvas canvas) {
    // Tampo
    final topPaint = Paint()..color = const Color(0xFF5D4037);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), topPaint);

    // Borda
    final borderPaint = Paint()
      ..color = const Color(0xFF3E2723)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), borderPaint);

    // Gavetas
    final drawerPaint = Paint()..color = const Color(0xFF4E342E);
    for (int i = 0; i < 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(10 + i * 50, size.y * 0.3, 36, size.y * 0.4),
        drawerPaint,
      );
      // Maçaneta
      final knobPaint = Paint()..color = const Color(0xFFFFD54F);
      canvas.drawCircle(
        Offset(28 + i * 50, size.y * 0.5),
        3,
        knobPaint,
      );
    }
  }
}

/// Cadeira do prefeito.
class _CadeiraPrefeito extends PositionComponent {
  _CadeiraPrefeito({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topLeft);

  @override
  void render(Canvas canvas) {
    // Encosto
    final backPaint = Paint()..color = const Color(0xFF4E342E);
    canvas.drawRect(Rect.fromLTWH(5, 0, size.x - 10, size.y * 0.6), backPaint);

    // Assento
    final seatPaint = Paint()..color = const Color(0xFF795548);
    canvas.drawRect(
      Rect.fromLTWH(0, size.y * 0.5, size.x, size.y * 0.3),
      seatPaint,
    );

    // Pernas
    final legPaint = Paint()..color = const Color(0xFF3E2723);
    canvas.drawRect(Rect.fromLTWH(5, size.y * 0.75, 6, size.y * 0.25), legPaint);
    canvas.drawRect(
      Rect.fromLTWH(size.x - 11, size.y * 0.75, 6, size.y * 0.25),
      legPaint,
    );
  }
}

/// Banco para visitantes.
class _BancoVisitante extends PositionComponent {
  _BancoVisitante({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topLeft);

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color(0xFF795548);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y * 0.5), paint);
    final legPaint = Paint()..color = const Color(0xFF5D4037);
    canvas.drawRect(Rect.fromLTWH(4, size.y * 0.4, 5, size.y * 0.6), legPaint);
    canvas.drawRect(
      Rect.fromLTWH(size.x - 9, size.y * 0.4, 5, size.y * 0.6),
      legPaint,
    );
  }
}

/// Botão "Sair" no canto superior direito.
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
