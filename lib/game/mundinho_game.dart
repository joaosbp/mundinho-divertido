import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

/// Jogo principal - placeholder para a mecânica que o JV vai definir.
/// Por enquanto tem uma cena colorida com bolinhas interativas para testar.
class MundinhoGame extends FlameGame with TapCallbacks {
  final Random _random = Random();

  @override
  Color backgroundColor() => const Color(0xFF87CEEB);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Adiciona um texto de boas-vindas
    add(
      TextComponent(
        text: 'Mundinho Divertido!',
        position: Vector2(size.x / 2, 60),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black26,
                offset: Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );

    // Adiciona bolinhas coloridas para interação
    for (var i = 0; i < 8; i++) {
      add(BolinhaComponent(
        position: Vector2(
          50 + _random.nextDouble() * (size.x - 100),
          120 + _random.nextDouble() * (size.y - 200),
        ),
        color: _randomColor(),
      ));
    }
  }

  Color _randomColor() {
    final colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,
    ];
    return colors[_random.nextInt(colors.length)];
  }
}

/// Bolinha que pulsa quando tocada - demonstração de interação.
class BolinhaComponent extends CircleComponent with TapCallbacks {
  Color color;

  BolinhaComponent({
    required Vector2 position,
    required this.color,
  }) : super(
          position: position,
          radius: 30,
          paint: Paint()..color = color,
          anchor: Anchor.center,
        );

  @override
  void onTapDown(TapDownEvent event) {
    // Muda de cor e dá um pulinho
    color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    paint.color = color;

    add(
      ScaleEffect.to(
        Vector2.all(1.4),
        EffectController(
          duration: 0.15,
          reverseDuration: 0.15,
        ),
      ),
    );
  }
}
