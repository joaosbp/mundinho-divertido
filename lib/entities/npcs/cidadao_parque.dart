import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'npc_base.dart';

/// NPC cidadão que fica no Parque Central.
/// Renderiza como círculo colorido com chapéu (placeholder visual).
class CidadaoParque extends NpcBase {
  CidadaoParque({required Vector2 position, Rect? patrolBounds})
      : super(
          nome: 'Cidadão',
          dialogos: const ['Olá! O parque é ótimo para brincar! 🌳'],
          position: position,
          size: Vector2.all(40),
          patrolBounds: patrolBounds,
        );

  @override
  void onInteract() {
    // O diálogo é gerenciado pelo MundinhoGame via callback
    // Este método será chamado pelo onTapDown do NpcBase
  }

  @override
  void render(Canvas canvas) {
    // Corpo (círculo colorido)
    final bodyPaint = Paint()..color = const Color(0xFF42A5F5);
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2 + 4),
      size.x / 2,
      bodyPaint,
    );

    // Chapéu (triângulo sobreposto)
    final hatPaint = Paint()..color = const Color(0xFFEF6C00);
    final hatPath = Path()
      ..moveTo(size.x / 2 - 14, size.y / 2 - 6)
      ..lineTo(size.x / 2, size.y / 2 - 22)
      ..lineTo(size.x / 2 + 14, size.y / 2 - 6)
      ..close();
    canvas.drawPath(hatPath, hatPaint);

    // Aba do chapéu
    final brimPaint = Paint()..color = const Color(0xFFE65100);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.x / 2, size.y / 2 - 4),
        width: 32,
        height: 8,
      ),
      brimPaint,
    );

    // Olhos
    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(const Offset(14, 20), 5, eyePaint);
    canvas.drawCircle(const Offset(26, 20), 5, eyePaint);

    final pupilPaint = Paint()..color = Colors.black;
    canvas.drawCircle(const Offset(14, 20), 2.5, pupilPaint);
    canvas.drawCircle(const Offset(26, 20), 2.5, pupilPaint);

    // Sorriso
    final smilePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawArc(
      Rect.fromCenter(center: const Offset(20, 26), width: 14, height: 8),
      0,
      3.14,
      false,
      smilePaint,
    );
  }
}
