import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../core/services/save_service.dart';

// ─── Dados dos itens disponíveis ───

class _ItemType {
  final String name;
  final Color color;
  final int shape; // 0=circle, 1=rect, 2=triangle

  const _ItemType(this.name, this.color, this.shape);
}

const List<_ItemType> _allItemTypes = [
  _ItemType('Maçã', Color(0xFFE53935), 0),
  _ItemType('Banana', Color(0xFFFFEB3B), 1),
  _ItemType('Cenoura', Color(0xFFFF9800), 2),
  _ItemType('Uva', Color(0xFF9C27B0), 0),
  _ItemType('Limão', Color(0xFF8BC34A), 0),
  _ItemType('Tomate', Color(0xFFD32F2F), 0),
  _ItemType('Abacaxi', Color(0xFFFFC107), 1),
  _ItemType('Morango', Color(0xFFF06292), 0),
  _ItemType('Laranja', Color(0xFFFF5722), 0),
  _ItemType('Pepino', Color(0xFF4CAF50), 1),
];

// ─── Componente de item na prateleira ───

class _ShelfItem extends PositionComponent with TapCallbacks {
  final _ItemType item;
  final VoidCallback onTap;
  bool _answered = false;
  bool _isCorrect = false;
  double _feedbackTimer = 0;

  _ShelfItem({
    required Vector2 position,
    required Vector2 size,
    required this.item,
    required this.onTap,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.center,
        );

  void markCorrect() {
    _answered = true;
    _isCorrect = true;
    _feedbackTimer = 0.8;
  }

  void markWrong() {
    _answered = true;
    _isCorrect = false;
    _feedbackTimer = 0.8;
  }

  bool get isAnswered => _answered;

  @override
  void update(double dt) {
    super.update(dt);
    if (_feedbackTimer > 0) {
      _feedbackTimer -= dt;
      if (_feedbackTimer <= 0) {
        _answered = false;
        _feedbackTimer = 0;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // Fundo do item
    final basePaint = Paint()..color = const Color(0xFFFFFFFF);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(6),
      ),
      basePaint,
    );

    // Shape do item
    final shapePaint = Paint()..color = item.color;
    switch (item.shape) {
      case 0: // circle
        canvas.drawCircle(
          Offset(size.x / 2, size.y / 2 - 4),
          size.x * 0.28,
          shapePaint,
        );
      case 1: // rect
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(size.x / 2, size.y / 2 - 4),
              width: size.x * 0.5,
              height: size.y * 0.4,
            ),
            const Radius.circular(4),
          ),
          shapePaint,
        );
      case 2: // triangle
        final path = Path()
          ..moveTo(size.x / 2, size.y * 0.2)
          ..lineTo(size.x * 0.75, size.y * 0.65)
          ..lineTo(size.x * 0.25, size.y * 0.65)
          ..close();
        canvas.drawPath(path, shapePaint);
    }

    // Nome do item
    final textPainter = TextPainter(
      text: TextSpan(
        text: item.name,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout(maxWidth: size.x - 4);
    textPainter.paint(
      canvas,
      Offset(
        (size.x - textPainter.width) / 2,
        size.y - textPainter.height - 2,
      ),
    );

    // Feedback overlay
    if (_answered) {
      final overlayColor = _isCorrect
          ? const Color(0x4D4CAF50)
          : const Color(0x4DF44336);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.x, size.y),
          const Radius.circular(6),
        ),
        Paint()..color = overlayColor,
      );

      final icon = _isCorrect ? '✅' : '❌';
      final iconPainter = TextPainter(
        text: TextSpan(
          text: icon,
          style: const TextStyle(fontSize: 22),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      iconPainter.layout();
      iconPainter.paint(
        canvas,
        Offset(
          (size.x - iconPainter.width) / 2,
          (size.y - iconPainter.height) / 2 - 4,
        ),
      );
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!_answered) {
      onTap();
    }
  }
}

// ─── Cena de interior do Mercadão com mini-jogo ───

class MercadaoInteriorScene extends PositionComponent {
  final VoidCallback onExit;

  double _opacity = 0;
  double? _targetOpacity;
  VoidCallback? _onFadeComplete;

  // Estado do mini-jogo
  bool _showingList = true;
  double _listTimer = 3.0;
  final List<_ItemType> _targetItems = [];
  final List<_ItemType> _shelfItems = [];
  final Set<String> _foundItems = {};
  final Set<String> _wrongItems = {};
  bool _gameComplete = false;
  double _resultTimer = 0;

  late TextComponent _timerText;
  late TextComponent _instructionText;
  late TextComponent _resultText;

  MercadaoInteriorScene({
    required this.onExit,
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

    // Sortear itens alvo (3-5)
    final rng = Random();
    final shuffled = List<_ItemType>.from(_allItemTypes)..shuffle(rng);
    _targetItems.addAll(shuffled.take(3 + rng.nextInt(3))); // 3 a 5 itens

    // Sortear itens da prateleira (8-10, incluindo os alvo)
    final remaining = shuffled.skip(_targetItems.length).toList();
    _shelfItems.addAll(_targetItems);
    _shelfItems.addAll(remaining.take(5 + rng.nextInt(3))); // +5 a 7 extras
    _shelfItems.shuffle(rng);

    // Fundo
    add(
      RectangleComponent(
        position: Vector2.zero(),
        size: size,
        paint: Paint()..color = const Color(0xFFFFF3E0),
      ),
    );

    // Prateleiras
    _buildShelves();

    // Texto de instrução
    _instructionText = TextComponent(
      text: 'Memorize a lista de compras!',
      position: Vector2(size.x / 2, 30),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.brown,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.white, blurRadius: 3),
          ],
        ),
      ),
    );
    add(_instructionText);

    // Timer
    _timerText = TextComponent(
      text: '3',
      position: Vector2(size.x / 2, 55),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.deepOrange,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(_timerText);

    // Texto de resultado (invisível inicialmente)
    _resultText = TextComponent(
      text: '',
      position: Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.green,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.white, blurRadius: 4),
          ],
        ),
      ),
    );
    add(_resultText);

    // Botão Sair
    add(
      _ExitButton(
        position: Vector2(size.x - 90, 20),
        onTap: exit,
      ),
    );
  }

  void _buildShelves() {
    final cols = 5;
    final rows = 2;
    final itemW = 64.0;
    final itemH = 72.0;
    final gapX = 12.0;
    final gapY = 16.0;
    final startX = (size.x - (cols * itemW + (cols - 1) * gapX)) / 2 + itemW / 2;
    final startY = 180.0;

    for (int i = 0; i < _shelfItems.length && i < cols * rows; i++) {
      final col = i % cols;
      final row = i ~/ cols;
      final item = _shelfItems[i];

      add(
        _ShelfItem(
          position: Vector2(
            startX + col * (itemW + gapX),
            startY + row * (itemH + gapY),
          ),
          size: Vector2(itemW, itemH),
          item: item,
          onTap: () => _onItemTapped(item),
        ),
      );
    }

    // Prateleiras (retângulos marrons por trás)
    for (int row = 0; row < rows; row++) {
      final shelfY = startY + row * (itemH + gapY) - itemH / 2 - 4;
      add(
        RectangleComponent(
          position: Vector2(startX - itemW / 2 - 8, shelfY + itemH + 4),
          size: Vector2(
            cols * itemW + (cols - 1) * gapX + 16,
            8,
          ),
          paint: Paint()..color = const Color(0xFF8D6E63),
        ),
      );
    }
  }

  void _onItemTapped(_ItemType item) {
    if (_showingList || _gameComplete) return;

    final itemKey = item.name;
    if (_foundItems.contains(itemKey) || _wrongItems.contains(itemKey)) return;

    final isTarget = _targetItems.any((t) => t.name == item.name);

    // Encontrar o componente visual correspondente
    for (final child in children) {
      if (child is _ShelfItem && child.item.name == item.name && !child.isAnswered) {
        if (isTarget) {
          child.markCorrect();
          _foundItems.add(itemKey);
        } else {
          child.markWrong();
          _wrongItems.add(itemKey);
        }
        break;
      }
    }

    // Verificar se completou
    if (_foundItems.length == _targetItems.length) {
      _gameComplete = true;
      _resultTimer = 2.5;
      _awardReward();
    }
  }

  void _awardReward() {
    final coins = _foundItems.length;
    final stars = _wrongItems.isEmpty ? 1 : 0;

    // Salvar recompensa
    final save = SaveService();
    if (save.isInitialized) {
      final data = save.playerData;
      save.savePlayerData(
        data.copyWith(
          coins: data.coins + coins,
          stars: data.stars + stars,
        ),
      );
    }

    final starText = stars > 0 ? ' + ⭐' : '';
    _resultText.text = 'Parabéns! +$coins moeda${coins != 1 ? 's' : ''}$starText';
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Fade
    if (_targetOpacity != null) {
      final step = dt / 0.3;
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

    // Fase de mostrar lista
    if (_showingList) {
      _listTimer -= dt;
      _timerText.text = _listTimer.ceil().clamp(0, 99).toString();
      if (_listTimer <= 0) {
        _showingList = false;
        _timerText.text = '';
        _instructionText.text = 'Encontre os itens da lista!';
      }
      return;
    }

    // Timer de resultado
    if (_gameComplete) {
      _resultTimer -= dt;
      if (_resultTimer <= 0) {
        _resultText.text = '';
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

    // Renderizar lista de compras sobreposta quando na fase inicial
    if (_showingList && _opacity > 0.9) {
      _renderShoppingList(canvas);
    }

    canvas.restore();
  }

  void _renderShoppingList(Canvas canvas) {
    final panelW = 280.0;
    final panelH = 60 + _targetItems.length * 36.0;
    final panelX = (size.x - panelW) / 2;
    final panelY = 90.0;

    // Painel
    final panelPaint = Paint()..color = const Color(0xFFFFFFFF);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(panelX, panelY, panelW, panelH),
        const Radius.circular(12),
      ),
      panelPaint,
    );
    final borderPaint = Paint()
      ..color = const Color(0xFFE53935)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(panelX, panelY, panelW, panelH),
        const Radius.circular(12),
      ),
      borderPaint,
    );

    // Título
    final titlePainter = TextPainter(
      text: const TextSpan(
        text: '📝 Lista de Compras',
        style: TextStyle(
          color: Colors.brown,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    titlePainter.layout();
    titlePainter.paint(canvas, Offset(panelX + (panelW - titlePainter.width) / 2, panelY + 10));

    // Itens
    for (int i = 0; i < _targetItems.length; i++) {
      final item = _targetItems[i];
      final itemY = panelY + 40 + i * 36;
      final itemX = panelX + 20;

      // Shape pequeno
      final shapePaint = Paint()..color = item.color;
      switch (item.shape) {
        case 0:
          canvas.drawCircle(Offset(itemX + 12, itemY + 12), 10, shapePaint);
        case 1:
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(itemX + 2, itemY + 4, 20, 16),
              const Radius.circular(3),
            ),
            shapePaint,
          );
        case 2:
          final path = Path()
            ..moveTo(itemX + 12, itemY + 2)
            ..lineTo(itemX + 22, itemY + 20)
            ..lineTo(itemX + 2, itemY + 20)
            ..close();
          canvas.drawPath(path, shapePaint);
      }

      // Nome
      final namePainter = TextPainter(
        text: TextSpan(
          text: item.name,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      namePainter.layout();
      namePainter.paint(canvas, Offset(itemX + 32, itemY + 4));
    }
  }
}

// ─── Botão Sair ───

class _ExitButton extends PositionComponent with TapCallbacks {
  final VoidCallback onTap;

  _ExitButton({
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
