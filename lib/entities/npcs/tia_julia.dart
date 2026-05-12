import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'npc_base.dart';

/// Tia Júlia — professora da escola, estática perto da lousa.
///
/// Visual: círculo verde com óculos, blusa amarela.
/// Não se move (sem patrulha).
class TiaJulia extends NpcBase {
  final VoidCallback? onInteractCallback;

  TiaJulia({
    required Vector2 position,
    this.onInteractCallback,
  }) : super(
          nome: 'Tia Júlia',
          dialogos: const [
            'Bem-vindo à escola! Escolha um jogo para aprender!',
          ],
          position: position,
          size: Vector2.all(44),
          patrolBounds: null, // não se move
        );

  @override
  void onInteract() {
    onInteractCallback?.call();
  }

  @override
  void update(double dt) {
    // Tia Júlia não anda — override para desabilitar movimento aleatório
    // Mantém o estado idle sempre
    estado = NpcState.idle;
  }

  @override
  void render(Canvas canvas) {
    // Corpo (círculo verde — rosto)
    final facePaint = Paint()..color = const Color(0xFF81C784);
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      facePaint,
    );

    // Blusa amarela (parte inferior)
    final shirtPaint = Paint()..color = const Color(0xFFFFEB3B);
    final shirtPath = Path()
      ..moveTo(4, size.y * 0.55)
      ..lineTo(size.x - 4, size.y * 0.55)
      ..lineTo(size.x - 2, size.y - 2)
      ..lineTo(2, size.y - 2)
      ..close();
    canvas.drawPath(shirtPath, shirtPaint);

    // Óculos (dois círculos pretos)
    final glassesPaint = Paint()
      ..color = const Color(0xFF212121)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(
      Offset(size.x * 0.32, size.y * 0.38),
      7,
      glassesPaint,
    );
    canvas.drawCircle(
      Offset(size.x * 0.68, size.y * 0.38),
      7,
      glassesPaint,
    );
    // Ponte dos óculos
    canvas.drawLine(
      Offset(size.x * 0.39, size.y * 0.38),
      Offset(size.x * 0.61, size.y * 0.38),
      glassesPaint,
    );

    // Olhos (brancos com pupilas pretas)
    final eyeWhitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(size.x * 0.32, size.y * 0.38),
      4,
      eyeWhitePaint,
    );
    canvas.drawCircle(
      Offset(size.x * 0.68, size.y * 0.38),
      4,
      eyeWhitePaint,
    );

    final pupilPaint = Paint()..color = const Color(0xFF212121);
    canvas.drawCircle(
      Offset(size.x * 0.32, size.y * 0.38),
      2,
      pupilPaint,
    );
    canvas.drawCircle(
      Offset(size.x * 0.68, size.y * 0.38),
      2,
      pupilPaint,
    );

    // Sorriso
    final smilePaint = Paint()
      ..color = const Color(0xFF212121)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.x / 2, size.y * 0.55),
        width: 16,
        height: 10,
      ),
      0.2,
      2.7,
      false,
      smilePaint,
    );

    // Cabelo (topo)
    final hairPaint = Paint()..color = const Color(0xFF5D4037);
    canvas.drawCircle(
      Offset(size.x / 2, size.y * 0.18),
      10,
      hairPaint,
    );
    canvas.drawCircle(
      Offset(size.x * 0.25, size.y * 0.22),
      8,
      hairPaint,
    );
    canvas.drawCircle(
      Offset(size.x * 0.75, size.y * 0.22),
      8,
      hairPaint,
    );
  }
}
