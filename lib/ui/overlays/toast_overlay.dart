import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Tipos de toast com cores pré-definidas.
enum ToastType { coins, mission, item, info }

/// Toast individual — mensagem temporária animada.
class ToastMessage {
  final String id;
  final String text;
  final ToastType type;
  final Duration duration;

  ToastMessage({
    required this.id,
    required this.text,
    this.type = ToastType.info,
    this.duration = const Duration(seconds: 2),
  });
}

/// Gerenciador de toasts — exibe mensagens no topo da tela.
class ToastOverlayComponent extends PositionComponent {
  List<ToastMessage> toasts;

  final Map<String, double> _progress = {};
  final Map<String, double> _slideProgress = {};

  ToastOverlayComponent({
    this.toasts = const [],
  }) : super(
          position: Vector2.zero(),
          anchor: Anchor.topLeft,
        );

  void updateToasts(List<ToastMessage> newToasts) {
    toasts = newToasts;
    // Inicializa progresso dos novos
    for (final t in toasts) {
      if (!_progress.containsKey(t.id)) {
        _progress[t.id] = 0.0;
        _slideProgress[t.id] = 0.0;
      }
    }
    // Remove antigos
    final ids = toasts.map((t) => t.id).toSet();
    _progress.removeWhere((k, _) => !ids.contains(k));
    _slideProgress.removeWhere((k, _) => !ids.contains(k));
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final entry in _slideProgress.entries) {
      if (entry.value < 1.0) {
        _slideProgress[entry.key] = (entry.value + dt * 4).clamp(0.0, 1.0);
      }
    }
    for (final entry in _progress.entries) {
      final msg = toasts.firstWhere((t) => t.id == entry.key);
      final maxProgress = msg.duration.inMilliseconds / 1000.0 + 0.3;
      _progress[entry.key] = (entry.value + dt).clamp(0.0, maxProgress);
    }
  }

  @override
  void render(Canvas canvas) {
    double yOffset = 12;
    for (final msg in toasts) {
      final slide = _slideProgress[msg.id] ?? 0.0;
      final progress = _progress[msg.id] ?? 0.0;
      final maxProgress = msg.duration.inMilliseconds / 1000.0 + 0.3;

      double opacity = 1.0;
      if (progress > maxProgress - 0.3) {
        opacity = 1.0 - ((progress - (maxProgress - 0.3)) / 0.3);
      }
      opacity = opacity.clamp(0.0, 1.0);

      final slideY = -60 * (1 - slide);

      _drawToast(canvas, msg, yOffset + slideY, opacity);
      yOffset += 56;
    }
  }

  void _drawToast(
      Canvas canvas, ToastMessage msg, double yOffset, double opacity) {
    if (opacity <= 0.01) return;

    final textPainter = TextPainter(
      text: TextSpan(
        text: msg.text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black.withOpacity(opacity),
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout(maxWidth: size.x - 64);

    final padding = 16.0;
    final toastW = textPainter.width + padding * 2;
    final toastH = textPainter.height + padding;
    final toastX = (size.x - toastW) / 2;
    final toastY = yOffset;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(toastX, toastY, toastW, toastH),
      const Radius.circular(16),
    );

    final bgPaint = Paint()
      ..color = _bgColor(msg.type).withOpacity(opacity);
    final borderPaint = Paint()
      ..color = _borderColor(msg.type).withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.12 * opacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawRRect(rect, shadowPaint);
    canvas.drawRRect(rect, bgPaint);
    canvas.drawRRect(rect, borderPaint);

    textPainter.paint(
      canvas,
      Offset(toastX + padding, toastY + padding / 2),
    );
  }

  Color _bgColor(ToastType type) {
    switch (type) {
      case ToastType.coins:
        return const Color(0xFFFFF8E1);
      case ToastType.mission:
        return const Color(0xFFE8F5E9);
      case ToastType.item:
        return const Color(0xFFF3E5F5);
      case ToastType.info:
        return const Color(0xFFE3F2FD);
    }
  }

  Color _borderColor(ToastType type) {
    switch (type) {
      case ToastType.coins:
        return const Color(0xFFFFCA28);
      case ToastType.mission:
        return const Color(0xFF66BB6A);
      case ToastType.item:
        return const Color(0xFFAB47BC);
      case ToastType.info:
        return const Color(0xFF42A5F5);
    }
  }
}
