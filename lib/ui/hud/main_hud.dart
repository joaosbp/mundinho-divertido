import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

/// HUD principal do jogo — desenhado diretamente no viewport.
class MainHud extends PositionComponent {
  int stars;
  int coins;
  String playerName;

  final VoidCallback onPausePressed;
  final VoidCallback onInventoryPressed;
  final VoidCallback onMissionsPressed;

  late final TextComponent _nameText;
  late final TextComponent _coinsText;
  late final TextComponent _starsText;
  late final _HudButton _pauseBtn;
  late final _HudButton _inventoryBtn;
  late final _HudButton _missionsBtn;
  late final _MiniMap _miniMap;

  double _coinsAnim = 0;
  double _starsAnim = 0;

  MainHud({
    required Vector2 size,
    this.stars = 0,
    this.coins = 0,
    this.playerName = 'Jogador',
    required this.onPausePressed,
    required this.onInventoryPressed,
    required this.onMissionsPressed,
  }) : super(
          size: size,
          position: Vector2.zero(),
          anchor: Anchor.topLeft,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final padding = 16.0;

    // Nome do jogador
    _nameText = TextComponent(
      text: '👤 $playerName',
      position: Vector2(padding, padding),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(color: Colors.black87, blurRadius: 4)],
        ),
      ),
    );
    add(_nameText);

    // Moedas
    _coinsText = TextComponent(
      text: '🪙 $coins',
      position: Vector2(padding + 120, padding),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(color: Colors.black87, blurRadius: 4)],
        ),
      ),
    );
    add(_coinsText);

    // Estrelas
    _starsText = TextComponent(
      text: '⭐ $stars',
      position: Vector2(padding + 220, padding),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(color: Colors.black87, blurRadius: 4)],
        ),
      ),
    );
    add(_starsText);

    // Mini-mapa
    _miniMap = _MiniMap(
      position: Vector2(size.x - 100, padding),
      size: Vector2.all(56),
    );
    add(_miniMap);

    // Botão de pausa
    _pauseBtn = _HudButton(
      label: '⏸️',
      position: Vector2(size.x - 44, padding + 4),
      size: Vector2.all(36),
      onTap: onPausePressed,
    );
    add(_pauseBtn);

    // Botão inventário (base)
    _inventoryBtn = _HudButton(
      label: '🎒',
      position: Vector2(size.x / 2 - 50, size.y - 56),
      size: Vector2.all(48),
      onTap: onInventoryPressed,
    );
    add(_inventoryBtn);

    // Botão missões (base)
    _missionsBtn = _HudButton(
      label: '📜',
      position: Vector2(size.x / 2 + 10, size.y - 56),
      size: Vector2.all(48),
      onTap: onMissionsPressed,
    );
    add(_missionsBtn);


  }

  void updateValues({int? newCoins, int? newStars, String? newName}) {
    if (newCoins != null && newCoins != coins) {
      coins = newCoins;
      _coinsText.text = '🪙 $coins';
      _coinsAnim = 1.0;
    }
    if (newStars != null && newStars != stars) {
      stars = newStars;
      _starsText.text = '⭐ $stars';
      _starsAnim = 1.0;
    }
    if (newName != null && newName != playerName) {
      playerName = newName;
      _nameText.text = '👤 $playerName';
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Animação de escala nos números
    if (_coinsAnim > 0) {
      _coinsAnim -= dt * 3;
      if (_coinsAnim < 0) _coinsAnim = 0;
    }
    if (_starsAnim > 0) {
      _starsAnim -= dt * 3;
      if (_starsAnim < 0) _starsAnim = 0;
    }
  }

  @override
  void render(Canvas canvas) {
    // Desenha fundos das badges
    _drawBadgeBg(canvas, _nameText.position, _nameText.size);
    _drawBadgeBg(canvas, _coinsText.position, _coinsText.size);
    _drawBadgeBg(canvas, _starsText.position, _starsText.size);
    super.render(canvas);
  }

  void _drawBadgeBg(Canvas canvas, Vector2 pos, Vector2 textSize) {
    final paint = Paint()..color = const Color(0x88000000);
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(pos.x - 8, pos.y - 4, textSize.x + 16, textSize.y + 8),
      const Radius.circular(16),
    );
    canvas.drawRRect(rrect, paint);
  }
}

class _MiniMap extends PositionComponent {
  final List<Offset> points = const [
    Offset(-0.4, -0.3), // Casa
    Offset(0.1, 0.0), // Parque
    Offset(0.4, -0.2), // Mercadão
    Offset(0.6, 0.1), // Padaria
    Offset(0.8, -0.35), // Prefeitura
    Offset(0.0, 0.4), // Escola
    Offset(-0.5, 0.1), // Farmácia
    Offset(-0.7, 0.4), // Correios
  ];

  _MiniMap({required super.position, required super.size});

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);

    // Fundo verde
    final bgPaint = Paint()..color = const Color(0xFF7CB342);
    canvas.drawCircle(center, size.x / 2, bgPaint);

    // Ruas
    final streetPaint = Paint()..color = const Color(0xFF9E9E9E);
    canvas.drawRect(
      Rect.fromCenter(center: center, width: 4, height: size.y),
      streetPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(center: center, width: size.x, height: 4),
      streetPaint,
    );

    // Jogador
    final playerPaint = Paint()..color = Colors.blueAccent;
    canvas.drawCircle(center, 4, playerPaint);

    // Pontos dos locais
    final pointPaint = Paint()..color = Colors.amber;
    for (final p in points) {
      canvas.drawCircle(
        Offset(
          center.dx + p.dx * (size.x / 2 - 6),
          center.dy + p.dy * (size.y / 2 - 6),
        ),
        3,
        pointPaint,
      );
    }

    // Borda
    final borderPaint = Paint()
      ..color = Colors.white54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, size.x / 2, borderPaint);
  }
}

class _HudButton extends PositionComponent with TapCallbacks {
  final String label;
  final VoidCallback onTap;

  _HudButton({
    required super.position,
    required super.size,
    required this.label,
    required this.onTap,
  });

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color(0xB3FFFFFF);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);

    final textPainter = TextPainter(
      text: TextSpan(text: label, style: const TextStyle(fontSize: 22)),
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
    event.handled = true;
    onTap();
  }
}
