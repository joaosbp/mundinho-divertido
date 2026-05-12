import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../entities/npcs/npc_base.dart';
import '../entities/npcs/tia_julia.dart';
import '../minigames/games/creative/pintura_livre.dart';
import '../minigames/games/math/matematica_lousa.dart';
import '../minigames/games/puzzle/alfabeto_colorido.dart';
import '../ui/dialogs/npc_dialogue.dart';

/// Cena de interior da Escola.
///
/// Renderiza sala de aula com 3 áreas de mini-jogos visualmente divididas,
/// lousa, mesas, cadeiras coloridas e a Tia Júlia perto da lousa.
class EscolaInteriorScene extends PositionComponent {
  final VoidCallback onExit;

  double _opacity = 0;
  double? _targetOpacity;
  VoidCallback? _onFadeComplete;

  late TiaJulia _tiaJulia;
  bool _isDialogueOpen = false;
  NpcDialogueOverlay? _dialogueOverlay;

  // Referências às cenas dos mini-jogos
  MatematicaLousaScene? _mathScene;
  AlfabetoColoridoScene? _alfabetoScene;
  PinturaLivreScene? _pinturaScene;
  bool _inMiniGame = false;

  EscolaInteriorScene({
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

    // Fundo da sala (bege claro)
    add(
      RectangleComponent(
        position: Vector2.zero(),
        size: size,
        paint: Paint()..color = const Color(0xFFFFF8E1),
      ),
    );

    // Piso (madeira clara)
    add(
      RectangleComponent(
        position: Vector2(20, size.y * 0.45),
        size: Vector2(size.x - 40, size.y * 0.55),
        paint: Paint()..color = const Color(0xFFD7CCC8),
      ),
    );

    // ─── Lousa (fundo, topo) ───
    add(
      _Lousa(
        position: Vector2(size.x / 2 - 120, 30),
        size: Vector2(240, 80),
      ),
    );

    // ─── Tia Júlia (estática perto da lousa) ───
    _tiaJulia = TiaJulia(
      position: Vector2(size.x / 2 + 80, 85),
      onInteractCallback: _onTiaJuliaInteract,
    );
    add(_tiaJulia);

    // ─── Mesa do professor ───
    add(
      _MesaProfessor(
        position: Vector2(size.x / 2 - 50, 110),
        size: Vector2(100, 30),
      ),
    );

    // ─── 3 Áreas de mini-jogos ───
    final areaW = (size.x - 80) / 3;
    final areaH = size.y * 0.35;
    final areaY = size.y * 0.55;

    // Área 1: Matemática (esquerda)
    add(
      _MiniGameArea(
        position: Vector2(20, areaY),
        size: Vector2(areaW, areaH),
        title: '🔢 Matemática',
        color: const Color(0xFFC8E6C9),
        accentColor: const Color(0xFF2E7D32),
        icon: '🔢',
        onTap: _enterMathGame,
      ),
    );

    // Área 2: Alfabeto (centro)
    add(
      _MiniGameArea(
        position: Vector2(40 + areaW, areaY),
        size: Vector2(areaW, areaH),
        title: '🔤 Alfabeto',
        color: const Color(0xFFE1BEE7),
        accentColor: const Color(0xFF6A1B9A),
        icon: '🔤',
        onTap: _enterAlfabetoGame,
      ),
    );

    // Área 3: Pintura (direita)
    add(
      _MiniGameArea(
        position: Vector2(60 + areaW * 2, areaY),
        size: Vector2(areaW, areaH),
        title: '🎨 Pintura',
        color: const Color(0xFFFFF9C4),
        accentColor: const Color(0xFFF57F17),
        icon: '🎨',
        onTap: _enterPinturaGame,
      ),
    );

    // Mesas e cadeiras coloridas (decoração)
    _buildMesasCadeiras();

    // Botão Sair
    add(
      ExitButton(
        position: Vector2(size.x - 90, 20),
        onTap: exit,
      ),
    );
  }

  void _buildMesasCadeiras() {
    final colors = [
      const Color(0xFFEF5350),
      const Color(0xFF42A5F5),
      const Color(0xFFFFCA28),
      const Color(0xFF66BB6A),
      const Color(0xFFAB47BC),
      const Color(0xFFFF7043),
    ];

    // Duas fileiras de mesas
    for (int row = 0; row < 2; row++) {
      for (int col = 0; col < 3; col++) {
        final x = 50 + col * (size.x - 100) / 3 + 30;
        final y = size.y * 0.48 + row * 50;
        final color = colors[(row * 3 + col) % colors.length];

        // Mesa
        add(
          RectangleComponent(
            position: Vector2(x, y),
            size: Vector2(50, 28),
            paint: Paint()..color = color.withValues(alpha: 0.6),
          ),
        );

        // Cadeira (atrás)
        add(
          RectangleComponent(
            position: Vector2(x + 10, y - 14),
            size: Vector2(30, 14),
            paint: Paint()..color = color.withValues(alpha: 0.8),
          ),
        );
      }
    }
  }

  void _onTiaJuliaInteract() {
    if (_isDialogueOpen || _inMiniGame) return;

    _isDialogueOpen = true;
    _tiaJulia.estado = NpcState.interacting;

    _dialogueOverlay = NpcDialogueOverlay(
      npcName: _tiaJulia.nome,
      text: _tiaJulia.dialogos.first,
      onClose: _closeDialogue,
      size: size,
      avatarColor: const Color(0xFF81C784),
    );

    add(_dialogueOverlay!);
    _dialogueOverlay!.show();
  }

  void _closeDialogue() {
    if (_dialogueOverlay == null) return;

    _dialogueOverlay!.removeFromParent();
    _dialogueOverlay = null;
    _isDialogueOpen = false;
    _tiaJulia.estado = NpcState.idle;
  }

  void _enterMathGame() {
    if (_inMiniGame) return;
    _inMiniGame = true;

    _mathScene = MatematicaLousaScene(
      size: size,
      onExit: _exitMathGame,
    );
    add(_mathScene!);
    _mathScene!.enter();
  }

  void _exitMathGame() {
    if (_mathScene == null) return;

    _mathScene!.removeFromParent();
    _mathScene = null;
    _inMiniGame = false;
  }

  void _enterAlfabetoGame() {
    if (_inMiniGame) return;
    _inMiniGame = true;

    _alfabetoScene = AlfabetoColoridoScene(
      size: size,
      onExit: _exitAlfabetoGame,
    );
    add(_alfabetoScene!);
    _alfabetoScene!.enter();
  }

  void _exitAlfabetoGame() {
    if (_alfabetoScene == null) return;

    _alfabetoScene!.removeFromParent();
    _alfabetoScene = null;
    _inMiniGame = false;
  }

  void _enterPinturaGame() {
    if (_inMiniGame) return;
    _inMiniGame = true;

    _pinturaScene = PinturaLivreScene(
      size: size,
      onExit: _exitPinturaGame,
    );
    add(_pinturaScene!);
    _pinturaScene!.enter();
  }

  void _exitPinturaGame() {
    if (_pinturaScene == null) return;

    _pinturaScene!.removeFromParent();
    _pinturaScene = null;
    _inMiniGame = false;
  }

  @override
  void update(double dt) {
    super.update(dt);

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
  }

  @override
  void renderTree(Canvas canvas) {
    if (_opacity <= 0.01) return;

    canvas.saveLayer(
      null,
      Paint()..color = Colors.white.withValues(alpha: _opacity),
    );
    super.renderTree(canvas);
    canvas.restore();
  }
}

/// Lousa da sala de aula.
class _Lousa extends PositionComponent {
  _Lousa({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topLeft);

  @override
  void render(Canvas canvas) {
    // Fundo verde escuro
    final bgPaint = Paint()..color = const Color(0xFF1B5E20);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), bgPaint);

    // Borda de madeira
    final framePaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), framePaint);

    // Prateleira da lousa
    final shelfPaint = Paint()..color = const Color(0xFF795548);
    canvas.drawRect(Rect.fromLTWH(-8, size.y - 4, size.x + 16, 8), shelfPaint);

    // Giz (branco e amarelo)
    final chalkWhite = Paint()..color = Colors.white70;
    canvas.drawRect(Rect.fromLTWH(20, size.y + 2, 24, 4), chalkWhite);
    final chalkYellow = Paint()..color = const Color(0xFFFFF59D);
    canvas.drawRect(Rect.fromLTWH(50, size.y + 2, 24, 4), chalkYellow);

    // Texto na lousa
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '1 + 1 = 2     A B C',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout(maxWidth: size.x - 20);
    textPainter.paint(
      canvas,
      Offset(
        (size.x - textPainter.width) / 2,
        (size.y - textPainter.height) / 2,
      ),
    );
  }
}

/// Mesa do professor.
class _MesaProfessor extends PositionComponent {
  _MesaProfessor({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topLeft);

  @override
  void render(Canvas canvas) {
    // Tampo
    final topPaint = Paint()..color = const Color(0xFF8D6E63);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), topPaint);

    // Borda
    final borderPaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), borderPaint);

    // Livro em cima
    final bookPaint = Paint()..color = const Color(0xFFEF5350);
    canvas.drawRect(Rect.fromLTWH(10, 4, 20, 14), bookPaint);
    final book2Paint = Paint()..color = const Color(0xFF42A5F5);
    canvas.drawRect(Rect.fromLTWH(14, 2, 20, 14), book2Paint);
  }
}

/// Área visual de um mini-jogo na sala de aula.
class _MiniGameArea extends PositionComponent with TapCallbacks {
  final String title;
  final Color color;
  final Color accentColor;
  final String icon;
  final VoidCallback onTap;

  _MiniGameArea({
    required Vector2 position,
    required Vector2 size,
    required this.title,
    required this.color,
    required this.accentColor,
    required this.icon,
    required this.onTap,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.topLeft,
        );

  @override
  void render(Canvas canvas) {
    // Fundo
    final bgPaint = Paint()..color = color;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(12),
    );
    canvas.drawRRect(rrect, bgPaint);

    // Borda
    final borderPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRRect(rrect, borderPaint);

    // Ícone grande
    final iconPainter = TextPainter(
      text: TextSpan(
        text: icon,
        style: const TextStyle(fontSize: 36),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    iconPainter.layout();
    iconPainter.paint(
      canvas,
      Offset(
        (size.x - iconPainter.width) / 2,
        size.y * 0.2,
      ),
    );

    // Título
    final textPainter = TextPainter(
      text: TextSpan(
        text: title,
        style: TextStyle(
          color: accentColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout(maxWidth: size.x - 8);
    textPainter.paint(
      canvas,
      Offset(
        (size.x - textPainter.width) / 2,
        size.y * 0.6,
      ),
    );

    // "Toque para jogar"
    final hintPainter = TextPainter(
      text: TextSpan(
        text: 'Toque!',
        style: TextStyle(
          color: accentColor.withValues(alpha: 0.7),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    hintPainter.layout();
    hintPainter.paint(
      canvas,
      Offset(
        (size.x - hintPainter.width) / 2,
        size.y * 0.78,
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }
}

/// Botão "Sair" no canto superior direito.
class ExitButton extends PositionComponent with TapCallbacks {
  final VoidCallback onTap;

  ExitButton({
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
