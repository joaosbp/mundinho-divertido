import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'npc_base.dart';

/// Seu Correio — funcionário dos Correios.
///
/// Visual: círculo azul com boné vermelho, camisa social.
/// Não se move (sem patrulha).
class SeuCorreio extends NpcBase {
  final VoidCallback onInteractCallback;

  SeuCorreio({
    required super.position,
    required this.onInteractCallback,
  }) : super(
          nome: 'Seu Correio',
          dialogos: const [
            'Olá! Preciso entregar cartas para 3 locais. Você pode me ajudar?',
            'Memorize a rota e entregue as cartas na ordem certa!',
            'Bom trabalho! Você é um carteiro nato!',
          ],
          size: Vector2.all(44),
          patrolBounds: null, // Estático, não se move
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
    // Seu Correio é estático — não chama movimento do pai
  }

  @override
  void onInteract() {
    onInteractCallback();
  }

  @override
  void render(Canvas canvas) {
    // Corpo (círculo azul — camisa social)
    final bodyPaint = Paint()..color = const Color(0xFF42A5F5);
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2 + 4),
      size.x / 2,
      bodyPaint,
    );

    // Borda do corpo
    final borderPaint = Paint()
      ..color = const Color(0xFF1E88E5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2 + 4),
      size.x / 2,
      borderPaint,
    );

    // Boné vermelho
    final capPaint = Paint()..color = const Color(0xFFE53935);
    // Aba do boné
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.x / 2, size.y / 2 - 16),
        width: 36,
        height: 6,
      ),
      capPaint,
    );
    // Copa do boné
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.x / 2, size.y / 2 - 14),
        width: 30,
        height: 18,
      ),
      3.14,
      3.14,
      false,
      capPaint,
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
      ..color = const Color(0xFF212121)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawArc(
      Rect.fromCenter(center: const Offset(22, 26), width: 12, height: 6),
      0,
      3.14,
      false,
      smilePaint,
    );

    // Gravata (vermelha)
    final tiePaint = Paint()..color = const Color(0xFFD32F2F);
    final tiePath = Path()
      ..moveTo(size.x / 2, size.y / 2 + 8)
      ..lineTo(size.x / 2 - 5, size.y / 2 + 18)
      ..lineTo(size.x / 2 + 5, size.y / 2 + 18)
      ..close();
    canvas.drawPath(tiePath, tiePaint);
  }
}
