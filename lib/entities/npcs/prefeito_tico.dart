import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'npc_base.dart';

/// Prefeito Tico — NPC estático atrás da mesa da Prefeitura.
///
/// Visual: círculo roxo com bigode, gravata e chapéu de prefeito.
/// Não se move (sem patrulha).
class PrefeitoTico extends NpcBase {
  final VoidCallback onInteractCallback;

  PrefeitoTico({
    required super.position,
    required this.onInteractCallback,
  }) : super(
          nome: 'Prefeito Tico',
          dialogos: const [
            'Bem-vindo ao Mundinho! Sou o Prefeito Tico.',
            'Nossa cidade precisa de ajuda! Você pode explorar e ajudar?',
            'Volte aqui quando completar suas tarefas!',
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
    // Prefeito é estático — não chama movimento do pai
    // Override vazio para impedir patrulha
  }

  @override
  void onInteract() {
    onInteractCallback();
  }

  @override
  void render(Canvas canvas) {
    // Corpo (círculo roxo)
    final bodyPaint = Paint()..color = const Color(0xFF7B1FA2);
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2 + 4),
      size.x / 2,
      bodyPaint,
    );

    // Gravata (triângulo vermelho no peito)
    final tiePaint = Paint()..color = const Color(0xFFD32F2F);
    final tiePath = Path()
      ..moveTo(size.x / 2, size.y / 2 + 8)
      ..lineTo(size.x / 2 - 6, size.y / 2 + 20)
      ..lineTo(size.x / 2 + 6, size.y / 2 + 20)
      ..close();
    canvas.drawPath(tiePath, tiePaint);

    // Bigode (curva preta abaixo do nariz)
    final mustachePaint = Paint()
      ..color = const Color(0xFF212121)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final mustachePath = Path()
      ..moveTo(size.x / 2 - 10, size.y / 2 - 2)
      ..quadraticBezierTo(size.x / 2 - 4, size.y / 2 + 4, size.x / 2, size.y / 2 - 2)
      ..quadraticBezierTo(size.x / 2 + 4, size.y / 2 + 4, size.x / 2 + 10, size.y / 2 - 2);
    canvas.drawPath(mustachePath, mustachePaint);

    // Chapéu de prefeito (cartola alta)
    final hatPaint = Paint()..color = const Color(0xFF212121);
    // Aba do chapéu
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.x / 2, size.y / 2 - 14),
        width: 36,
        height: 8,
      ),
      hatPaint,
    );
    // Copa alta
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.x / 2, size.y / 2 - 24),
        width: 20,
        height: 18,
      ),
      hatPaint,
    );
    // Faixa dourada no chapéu
    final bandPaint = Paint()..color = const Color(0xFFFFD54F);
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.x / 2, size.y / 2 - 20),
        width: 20,
        height: 3,
      ),
      bandPaint,
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
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawArc(
      Rect.fromCenter(center: const Offset(22, 26), width: 14, height: 8),
      0,
      3.14,
      false,
      smilePaint,
    );
  }
}
