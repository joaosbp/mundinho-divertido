import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../core/services/save_service.dart';

// ─── Dados dos ingredientes e coberturas ───

class _Ingrediente {
  final String name;
  final Color color;
  final String emoji;

  const _Ingrediente(this.name, this.color, this.emoji);
}

const List<_Ingrediente> _ingredientes = [
  _Ingrediente('Farinha', Color(0xFFFFF8E1), '🌾'),
  _Ingrediente('Ovos', Color(0xFFFFF176), '🥚'),
  _Ingrediente('Leite', Color(0xFFBBDEFB), '🥛'),
];

class _Cobertura {
  final String name;
  final Color color;
  final String emoji;

  const _Cobertura(this.name, this.color, this.emoji);
}

const List<_Cobertura> _coberturas = [
  _Cobertura('Chocolate', Color(0xFF5D4037), '🍫'),
  _Cobertura('Morango', Color(0xFFE53935), '🍓'),
  _Cobertura('Chantilly', Color(0xFFFFF8E1), '🍦'),
];

// ─── Cena de interior da Padaria com mini-jogo ───

class PadariaInteriorScene extends PositionComponent {
  final VoidCallback onExit;

  double _opacity = 0;
  double? _targetOpacity;
  VoidCallback? _onFadeComplete;

  // Estado do mini-jogo
  int _currentStep = 0; // 0=misturar, 1=sovar, 2=assar, 3=decorar, 4=resultado
  final Set<String> _mixedIngredients = {};
  int _kneadCount = 0;
  static const int _kneadTarget = 10;
  double _bakeTimer = 0;
  static const double _bakeDuration = 3.0;
  String? _chosenCobertura;
  bool _gameComplete = false;
  double _resultTimer = 0;

  // Animações
  double _massaScale = 1.0;
  double _massaRotate = 0.0;
  double _fornoPulse = 0.0;
  _Ingrediente? _animatingIngrediente;
  // Animação de ingrediente sendo adicionado
  double _ingredienteAnimTimer = 0;

  late TextComponent _instructionText;
  late TextComponent _resultText;
  late TextComponent _progressText;

  PadariaInteriorScene({
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

    // Fundo (bege quente)
    add(
      RectangleComponent(
        position: Vector2.zero(),
        size: size,
        paint: Paint()..color = const Color(0xFFFFF3E0),
      ),
    );

    // Área de trabalho (mesa marrom claro)
    add(
      RectangleComponent(
        position: Vector2(20, size.y - 180),
        size: Vector2(size.x - 40, 160),
        paint: Paint()..color = const Color(0xFFD7CCC8),
      ),
    );

    // Forno (lado esquerdo)
    add(
      _FornoComponent(
        position: Vector2(40, 80),
        size: Vector2(80, 70),
      ),
    );

    // Balcão com doces (lado direito)
    _buildBalcao();

    // Texto de instrução
    _instructionText = TextComponent(
      text: 'Misture os ingredientes na tigela!',
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

    // Texto de progresso
    _progressText = TextComponent(
      text: '',
      position: Vector2(size.x / 2, 55),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.deepOrange,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(_progressText);

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

    // Construir elementos do passo atual
    _buildStepElements();
  }

  void _buildBalcao() {
    final balcaoX = size.x - 140;
    final balcaoY = 60.0;

    // Base do balcão
    add(
      RectangleComponent(
        position: Vector2(balcaoX, balcaoY + 30),
        size: Vector2(110, 60),
        paint: Paint()..color = const Color(0xFF8D6E63),
      ),
    );

    // Doces coloridos
    final docesColors = [
      const Color(0xFFF48FB1),
      const Color(0xFFCE93D8),
      const Color(0xFF90CAF9),
      const Color(0xFFA5D6A7),
      const Color(0xFFFFCC80),
      const Color(0xFFEF9A9A),
    ];
    for (int i = 0; i < docesColors.length; i++) {
      add(
        RectangleComponent(
          position: Vector2(
            balcaoX + 10 + (i % 3) * 32,
            balcaoY + 35 + (i ~/ 3) * 25,
          ),
          size: Vector2(24, 18),
          paint: Paint()..color = docesColors[i],
        ),
      );
    }

    // Vitrine de vidro
    add(
      RectangleComponent(
        position: Vector2(balcaoX, balcaoY),
        size: Vector2(110, 35),
        paint: Paint()..color = const Color(0x4DB3E5FC),
      ),
    );
  }

  void _buildStepElements() {
    // Remover elementos interativos antigos (exceto os fixos)
    final toRemove = children.whereType<_StepElement>().toList();
    for (final el in toRemove) {
      el.removeFromParent();
    }

    switch (_currentStep) {
      case 0:
        _buildMisturarStep();
        break;
      case 1:
        _buildSovarStep();
        break;
      case 2:
        _buildAssarStep();
        break;
      case 3:
        _buildDecorarStep();
        break;
    }
  }

  void _buildMisturarStep() {
    // Tigela no centro da mesa
    add(
      _TigelaComponent(
        position: Vector2(size.x / 2, size.y - 100),
        size: Vector2(80, 50),
      ),
    );

    // Ingredientes para arrastar
    for (int i = 0; i < _ingredientes.length; i++) {
      final ing = _ingredientes[i];
      add(
        _IngredienteButton(
          position: Vector2(80 + i * 110, size.y - 140),
          ingrediente: ing,
          onTap: () => _onIngredienteTapped(ing),
        ),
      );
    }
  }

  void _buildSovarStep() {
    // Massa no centro
    add(
      _MassaComponent(
        position: Vector2(size.x / 2, size.y - 100),
        onTap: _onMassaTapped,
      ),
    );

    // Barra de progresso
    _progressText.text = 'Sovadas: $_kneadCount / $_kneadTarget';
  }

  void _buildAssarStep() {
    // Massa pronta para ir ao forno
    add(
      _MassaParaForno(
        position: Vector2(size.x / 2, size.y - 100),
        onTap: _onColocarNoForno,
      ),
    );

    _progressText.text = 'Toque na massa para colocar no forno!';
  }

  void _buildDecorarStep() {
    // Bolo assado no centro
    add(
      _BoloAssado(
        position: Vector2(size.x / 2, size.y - 100),
      ),
    );

    // Opções de cobertura
    for (int i = 0; i < _coberturas.length; i++) {
      final cob = _coberturas[i];
      add(
        _CoberturaButton(
          position: Vector2(70 + i * 130, size.y - 140),
          cobertura: cob,
          onTap: () => _onCoberturaEscolhida(cob),
        ),
      );
    }

    _progressText.text = 'Escolha a cobertura!';
  }

  void _onIngredienteTapped(_Ingrediente ing) {
    if (_mixedIngredients.contains(ing.name)) return;

    _mixedIngredients.add(ing.name);
    _animatingIngrediente = ing;
    _ingredienteAnimTimer = 0.5;


    if (_mixedIngredients.length == _ingredientes.length) {
      Future.delayed(const Duration(milliseconds: 600), () {
        _currentStep = 1;
        _instructionText.text = 'Sove a massa com dedos rápidos!';
        _progressText.text = 'Sovadas: 0 / $_kneadTarget';
        _buildStepElements();
      });
    }
  }

  void _onMassaTapped() {
    _kneadCount++;
    _massaScale = 1.3;
    _massaRotate = (Random().nextDouble() - 0.5) * 0.3;
    _progressText.text = 'Sovadas: $_kneadCount / $_kneadTarget';

    if (_kneadCount >= _kneadTarget) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _currentStep = 2;
        _instructionText.text = 'Coloque a massa no forno!';
        _progressText.text = '';
        _buildStepElements();
      });
    }
  }

  void _onColocarNoForno() {
    _currentStep = 3;
    _bakeTimer = _bakeDuration;
    _instructionText.text = 'Assando...';
    _progressText.text = '';
    _buildStepElements();
  }

  void _onCoberturaEscolhida(_Cobertura cob) {
    _chosenCobertura = cob.name;
    _currentStep = 4;
    _gameComplete = true;
    _resultTimer = 3.0;
    _instructionText.text = '';
    _progressText.text = '';
    _awardReward();
    _buildStepElements();
  }

  void _awardReward() {
    const coins = 10;
    const stars = 2;

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

    _resultText.text = '⭐⭐ +$coins moedas!\nBolo de $_chosenCobertura!';
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

    // Animação de ingrediente voando
    if (_ingredienteAnimTimer > 0) {
      _ingredienteAnimTimer -= dt;
      if (_ingredienteAnimTimer <= 0) {
        _animatingIngrediente = null;
      }
    }

    // Animação da massa (scale/rotate)
    if (_massaScale > 1.0) {
      _massaScale = (_massaScale - dt * 2).clamp(1.0, 2.0);
    }
    if (_massaRotate != 0) {
      _massaRotate = (_massaRotate * (1 - dt * 5)).clamp(-0.01, 0.01);
      if (_massaRotate.abs() < 0.01) _massaRotate = 0;
    }

    // Pulso do forno durante assamento
    if (_currentStep == 3) {
      _fornoPulse += dt * 4;
      _bakeTimer -= dt;

      // Atualizar texto de progresso com barra visual
      final progress = 1.0 - (_bakeTimer / _bakeDuration).clamp(0.0, 1.0);
      final barCount = (progress * 10).round();
      final bar = '█' * barCount + '░' * (10 - barCount);
      _progressText.text = 'Assando: $bar ${(progress * 100).toInt()}%';

      if (_bakeTimer <= 0) {
        _currentStep = 3; // Vai para decorar
        _instructionText.text = 'Escolha a cobertura do bolo!';
        _progressText.text = '';
        _buildStepElements();
      }
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

    // Renderizar animação de ingrediente voando por cima
    if (_animatingIngrediente != null && _ingredienteAnimTimer > 0) {
      _renderIngredienteAnim(canvas);
    }

    // Renderizar barra de progresso do sovar se necessário
    if (_currentStep == 1) {
      _renderKneadProgress(canvas);
    }

    // Renderizar luz do forno piscando durante assar
    if (_currentStep == 3) {
      _renderFornoGlow(canvas);
    }

    canvas.restore();
  }

  void _renderIngredienteAnim(Canvas canvas) {
    final progress = 1.0 - (_ingredienteAnimTimer / 0.5);
    final startX = _ingredientes.indexWhere((i) => i.name == _animatingIngrediente!.name) * 110.0 + 80;
    final startY = size.y - 140;
    final endX = size.x / 2;
    final endY = size.y - 100;
    final x = startX + (endX - startX) * progress;
    final y = startY + (endY - startY) * progress;
    final scale = 1.0 + progress * 0.5;

    final textPainter = TextPainter(
      text: TextSpan(
        text: _animatingIngrediente!.emoji,
        style: TextStyle(fontSize: 28 * scale),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(x - textPainter.width / 2, y - textPainter.height / 2),
    );
  }

  void _renderKneadProgress(Canvas canvas) {
    final barW = 200.0;
    final barH = 16.0;
    final barX = (size.x - barW) / 2;
    final barY = 75.0;
    final progress = _kneadCount / _kneadTarget;

    // Fundo
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(barX, barY, barW, barH),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFFEEEEEE),
    );

    // Preenchimento
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(barX, barY, barW * progress, barH),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFFFF9800),
    );

    // Borda
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(barX, barY, barW, barH),
        const Radius.circular(8),
      ),
      Paint()
        ..color = const Color(0xFF8D6E63)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _renderFornoGlow(Canvas canvas) {
    final pulse = (sin(_fornoPulse) + 1) / 2; // 0..1
    final glowAlpha = 0.3 + pulse * 0.4;
    final glowPaint = Paint()
      ..color = const Color(0xFFFF9800).withValues(alpha: glowAlpha)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    canvas.drawCircle(
      Offset(80, 115),
      40 + pulse * 10,
      glowPaint,
    );
  }
}

// ─── Componentes interativos do mini-jogo ───

abstract class _StepElement extends PositionComponent {
  _StepElement({super.position, super.size, super.anchor});
}

class _TigelaComponent extends _StepElement {
  _TigelaComponent({required Vector2 position, required Vector2 size})
      : super(
          position: position,
          size: size,
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    // Tigela (semi-círculo)
    final paint = Paint()..color = const Color(0xFF90CAF9);
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.x, 0)
      ..quadraticBezierTo(size.x / 2, size.y, 0, 0)
      ..close();
    canvas.drawPath(path, paint);

    // Borda
    final borderPaint = Paint()
      ..color = const Color(0xFF42A5F5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawPath(path, borderPaint);

    // Texto "Tigela"
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '🥣',
        style: TextStyle(fontSize: 24),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.x - textPainter.width) / 2,
        size.y * 0.15,
      ),
    );
  }
}

class _IngredienteButton extends _StepElement with TapCallbacks {
  final _Ingrediente ingrediente;
  final VoidCallback onTap;

  _IngredienteButton({
    required Vector2 position,
    required this.ingrediente,
    required this.onTap,
  }) : super(
          position: position,
          size: Vector2(70, 60),
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    // Fundo
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(8),
      ),
      Paint()..color = ingrediente.color,
    );

    // Borda
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(8),
      ),
      Paint()
        ..color = const Color(0xFF8D6E63)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Emoji
    final emojiPainter = TextPainter(
      text: TextSpan(
        text: ingrediente.emoji,
        style: const TextStyle(fontSize: 22),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    emojiPainter.layout();
    emojiPainter.paint(
      canvas,
      Offset(
        (size.x - emojiPainter.width) / 2,
        4,
      ),
    );

    // Nome
    final namePainter = TextPainter(
      text: TextSpan(
        text: ingrediente.name,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    namePainter.layout(maxWidth: size.x - 4);
    namePainter.paint(
      canvas,
      Offset(
        (size.x - namePainter.width) / 2,
        size.y - namePainter.height - 4,
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }
}

class _MassaComponent extends _StepElement with TapCallbacks {
  final VoidCallback onTap;

  _MassaComponent({required Vector2 position, required this.onTap})
      : super(
          position: position,
          size: Vector2(100, 80),
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    final scene = parent as PadariaInteriorScene;
    final scale = scene._massaScale;
    final rotate = scene._massaRotate;

    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    canvas.scale(scale);
    canvas.rotate(rotate);
    canvas.translate(-size.x / 2, -size.y / 2);

    // Massa (amarelo claro, oval)
    final massaPaint = Paint()..color = const Color(0xFFFFF9C4);
    canvas.drawOval(
      Rect.fromLTWH(10, 15, size.x - 20, size.y - 30),
      massaPaint,
    );

    // Detalhes de textura
    final texturePaint = Paint()
      ..color = const Color(0xFFFFF176)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(size.x * 0.3, size.y * 0.4),
      Offset(size.x * 0.5, size.y * 0.5),
      texturePaint,
    );
    canvas.drawLine(
      Offset(size.x * 0.5, size.y * 0.5),
      Offset(size.x * 0.7, size.y * 0.4),
      texturePaint,
    );

    // Texto "Toque!"
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '👆 Toque!',
        style: TextStyle(
          color: Colors.brown,
          fontSize: 12,
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
        size.y - 18,
      ),
    );

    canvas.restore();
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }
}

class _MassaParaForno extends _StepElement with TapCallbacks {
  final VoidCallback onTap;

  _MassaParaForno({required Vector2 position, required this.onTap})
      : super(
          position: position,
          size: Vector2(100, 80),
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    // Massa já moldada (formato de bolo)
    final paint = Paint()..color = const Color(0xFFFFF9C4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(10, 10, size.x - 20, size.y - 30),
        const Radius.circular(8),
      ),
      paint,
    );

    // Texto indicativo
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '👆 Ao forno!',
        style: TextStyle(
          color: Colors.brown,
          fontSize: 12,
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
        size.y - 20,
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }
}

class _BoloAssado extends _StepElement {
  _BoloAssado({required Vector2 position})
      : super(
          position: position,
          size: Vector2(100, 90),
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    // Base do bolo (marrom dourado)
    final basePaint = Paint()..color = const Color(0xFFD7CCC8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(15, 30, size.x - 30, size.y - 40),
        const Radius.circular(6),
      ),
      basePaint,
    );

    // Topo do bolo (dourado)
    final topPaint = Paint()..color = const Color(0xFFFFCC80);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(15, 10, size.x - 30, 30),
        const Radius.circular(6),
      ),
      topPaint,
    );

    // Texto
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '🍰',
        style: TextStyle(fontSize: 28),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.x - textPainter.width) / 2,
        18,
      ),
    );
  }
}

class _CoberturaButton extends _StepElement with TapCallbacks {
  final _Cobertura cobertura;
  final VoidCallback onTap;

  _CoberturaButton({
    required Vector2 position,
    required this.cobertura,
    required this.onTap,
  }) : super(
          position: position,
          size: Vector2(90, 70),
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    // Fundo colorido
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(10),
      ),
      Paint()..color = cobertura.color,
    );

    // Borda
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(10),
      ),
      Paint()
        ..color = const Color(0xFF8D6E63)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Emoji
    final emojiPainter = TextPainter(
      text: TextSpan(
        text: cobertura.emoji,
        style: const TextStyle(fontSize: 26),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    emojiPainter.layout();
    emojiPainter.paint(
      canvas,
      Offset(
        (size.x - emojiPainter.width) / 2,
        6,
      ),
    );

    // Nome
    final namePainter = TextPainter(
      text: TextSpan(
        text: cobertura.name,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    namePainter.layout(maxWidth: size.x - 4);
    namePainter.paint(
      canvas,
      Offset(
        (size.x - namePainter.width) / 2,
        size.y - namePainter.height - 6,
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }
}

// ─── Componente do Forno ───

class _FornoComponent extends PositionComponent {
  _FornoComponent({required Vector2 position, required Vector2 size})
      : super(
          position: position,
          size: size,
          anchor: Anchor.topLeft,
        );

  @override
  void render(Canvas canvas) {
    // Corpo do forno
    final bodyPaint = Paint()..color = const Color(0xFF616161);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      bodyPaint,
    );

    // Porta do forno
    final doorPaint = Paint()..color = const Color(0xFF424242);
    canvas.drawRect(
      Rect.fromLTWH(8, 10, size.x - 16, size.y - 20),
      doorPaint,
    );

    // Luz interna (laranja)
    final lightPaint = Paint()..color = const Color(0xFFFF9800);
    canvas.drawRect(
      Rect.fromLTWH(14, 16, size.x - 28, size.y - 32),
      lightPaint,
    );

    // Grade do forno
    final gridPaint = Paint()
      ..color = const Color(0xFF616161)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (int i = 1; i < 4; i++) {
      final y = 16 + (size.y - 32) * i / 4;
      canvas.drawLine(
        Offset(14, y),
        Offset(size.x - 14, y),
        gridPaint,
      );
    }

    // Botões do forno
    final knobPaint = Paint()..color = const Color(0xFFFF5722);
    canvas.drawCircle(Offset(size.x - 12, 8), 4, knobPaint);
    canvas.drawCircle(Offset(size.x - 22, 8), 4, knobPaint);
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
