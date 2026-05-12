import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'npc_base.dart';

/// Dra. Cássia — médica da Farmácia.
///
/// Visual: círculo branco com jaleco, cabelo preso, estetoscópio.
/// Não se move (sem patrulha).
class DraCassia extends NpcBase {
  final VoidCallback onInteractCallback;

  DraCassia({
    required super.position,
    required this.onInteractCallback,
  }) : super(
          nome: 'Dra. Cássia',
          dialogos: const [
            'Olá! Qual o seu sintoma? Vou te ajudar a encontrar o remédio certo!',
            'Lembre-se: febre precisa de comprimido vermelho!',
            'Dor de cabeça? O azul é o remédio certo!',
            'Barriguinha chata? O verde vai te ajudar!',
            'Você está ficando um expert em remédios!',
          ],
          size: Vector2.all(44),
          patrolBounds: null, // Estática, não se move
        );

  int _dialogoIndex = 0;

  String get proximoDialogo {
    final texto = dialogos[_dialogoIndex];
    _dialogoIndex = (_dialogoIndex + 1) % dialogos.length;
    return texto;
  }

  void resetDialogo() {
    _dialogoIndex = 0;
  }

  @override
  void update(double dt) {
    // Dra. Cássia é estática — não chama movimento do pai
  }

  @override
  void onInteract() {
    onInteractCallback();
  }

  @override
  void render(Canvas canvas) {
    // Corpo (círculo branco — jaleco)
    final bodyPaint = Paint()..color = const Color(0xFFFFFFFF);
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2 + 4),
      size.x / 2,
      bodyPaint,
    );

    // Borda do jaleco
    final borderPaint = Paint()
      ..color = const Color(0xFFB0BEC5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2 + 4),
      size.x / 2,
      borderPaint,
    );

    // Cabelo preso (coque castanho)
    final hairPaint = Paint()..color = const Color(0xFF5D4037);
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2 - 10),
      14,
      hairPaint,
    );
    // Coque
    canvas.drawCircle(
      Offset(size.x / 2 + 10, size.y / 2 - 14),
      7,
      hairPaint,
    );

    // Rosto (pele)
    final facePaint = Paint()..color = const Color(0xFFFFE0B2);
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2 + 2),
      14,
      facePaint,
    );

    // Olhos
    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(const Offset(15, 18), 5, eyePaint);
    canvas.drawCircle(const Offset(29, 18), 5, eyePaint);

    final pupilPaint = Paint()..color = Colors.black;
    canvas.drawCircle(const Offset(15, 18), 2.5, pupilPaint);
    canvas.drawCircle(const Offset(29, 18), 2.5, pupilPaint);

    // Sorriso
    final smilePaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawArc(
      Rect.fromCenter(center: const Offset(22, 26), width: 12, height: 6),
      0,
      3.14,
      false,
      smilePaint,
    );

    // Estetoscópio (tubo verde-água em volta do pescoço)
    final stethPaint = Paint()
      ..color = const Color(0xFF26A69A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final stethPath = Path()
      ..moveTo(size.x / 2 - 8, size.y / 2 + 10)
      ..quadraticBezierTo(size.x / 2, size.y / 2 + 18, size.x / 2 + 8, size.y / 2 + 10)
      ..quadraticBezierTo(size.x / 2 + 12, size.y / 2 + 4, size.x / 2 + 6, size.y / 2 - 2);
    canvas.drawPath(stethPath, stethPaint);

    // Peça do estetoscópio (círculo pequeno)
    final stethHeadPaint = Paint()..color = const Color(0xFF26A69A);
    canvas.drawCircle(
      Offset(size.x / 2 + 6, size.y / 2 + 14),
      4,
      stethHeadPaint,
    );
  }
}
