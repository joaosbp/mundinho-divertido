import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../core/services/save_service.dart';
import '../entities/npcs/dra_cassia.dart';
import '../entities/npcs/npc_base.dart';
import '../ui/dialogs/npc_dialogue.dart';

// ─── Dados dos sintomas e remédios ───

class _Sintoma {
  final String name;
  final String emoji;
  final String desc;

  const _Sintoma(this.name, this.emoji, this.desc);
}

class _Remedio {
  final String name;
  final Color color;
  final String colorName;

  const _Remedio(this.name, this.color, this.colorName);
}

const List<_Sintoma> _sintomas = [
  _Sintoma('Febre', '🤒', 'Estou com febre!'),
  _Sintoma('Dor de Cabeça', '🤕', 'Minha cabeça dói!'),
  _Sintoma('Barriguinha', '🤢', 'Minha barriga não está legal!'),
];

const List<_Remedio> _remedios = [
  _Remedio('Comprimido Vermelho', Color(0xFFEF5350), 'vermelho'),
  _Remedio('Comprimido Azul', Color(0xFF42A5F5), 'azul'),
  _Remedio('Comprimido Verde', Color(0xFF66BB6A), 'verde'),
];

// Mapeamento correto: febre → vermelho, dor de cabeça → azul, barriguinha → verde
const Map<int, int> _correctMatch = {
  0: 0, // Febre → Vermelho
  1: 1, // Dor de Cabeça → Azul
  2: 2, // Barriguinha → Verde
};

// ─── Cena de interior da Farmácia com mini-jogo ───

class FarmaciaInteriorScene extends PositionComponent {
  final VoidCallback onExit;

  double _opacity = 0;
  double? _targetOpacity;
  VoidCallback? _onFadeComplete;

  // Estado do mini-jogo
  int? _selectedSintomaIndex; // null = nenhum sintoma selecionado
  final Set<int> _matchedPairs = {}; // pares já acertados
  final Set<int> _attemptedWrong = {}; // tentativas erradas (sintoma index)
  bool _gameComplete = false;
  double _resultTimer = 0;
  double _dicaTimer = 0;
  String? _dicaText;

  late TextComponent _instructionText;
  late TextComponent _resultText;
  late TextComponent _dicaTextComponent;

  // NPC
  late DraCassia _draCassia;
  bool _isDialogueOpen = false;
  NpcDialogueOverlay? _dialogueOverlay;

  FarmaciaInteriorScene({
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

    // Fundo (branco claro, ambiente hospitalar)
    add(
      RectangleComponent(
        position: Vector2.zero(),
        size: size,
        paint: Paint()..color = const Color(0xFFF5F5F5),
      ),
    );

    // Piso (azul claro)
    add(
      RectangleComponent(
        position: Vector2(0, size.y * 0.6),
        size: Vector2(size.x, size.y * 0.4),
        paint: Paint()..color = const Color(0xFFE3F2FD),
      ),
    );

    // Prateleiras de remédios
    _buildPrateleiras();

    // Balcão
    _buildBalcao();

    // Balança no balcão
    _buildBalanca();

    // Dra. Cássia atrás do balcão
    _draCassia = DraCassia(
      position: Vector2(size.x / 2 + 60, size.y * 0.35),
      onInteractCallback: _onDraCassiaInteract,
    );
    add(_draCassia);

    // Texto de instrução
    _instructionText = TextComponent(
      text: 'Toque no sintoma, depois no remédio certo!',
      position: Vector2(size.x / 2, 24),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFF37474F),
          fontSize: 16,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.white, blurRadius: 3),
          ],
        ),
      ),
    );
    add(_instructionText);

    // Texto de dica da Dra. Cássia
    _dicaTextComponent = TextComponent(
      text: '',
      position: Vector2(size.x / 2, 50),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFF26A69A),
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
    add(_dicaTextComponent);

    // Texto de resultado
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

    // Construir elementos do mini-jogo
    _buildMiniGameElements();

    // Botão Sair
    add(
      _ExitButton(
        position: Vector2(size.x - 90, 20),
        onTap: exit,
      ),
    );
  }

  void _buildPrateleiras() {
    // Prateleira superior (esquerda)
    add(
      _Prateleira(
        position: Vector2(20, 80),
        size: Vector2(120, 90),
      ),
    );

    // Prateleira superior (direita)
    add(
      _Prateleira(
        position: Vector2(size.x - 140, 80),
        size: Vector2(120, 90),
      ),
    );
  }

  void _buildBalcao() {
    // Balcão central (fundo)
    add(
      RectangleComponent(
        position: Vector2(size.x / 2 - 100, size.y * 0.4),
        size: Vector2(200, 50),
        paint: Paint()..color = const Color(0xFF90A4AE),
      ),
    );

    // Borda do balcão
    add(
      RectangleComponent(
        position: Vector2(size.x / 2 - 100, size.y * 0.4),
        size: Vector2(200, 4),
        paint: Paint()..color = const Color(0xFF78909C),
      ),
    );

    // Painel de vidro do balcão
    add(
      RectangleComponent(
        position: Vector2(size.x / 2 - 90, size.y * 0.4 + 8),
        size: Vector2(180, 36),
        paint: Paint()..color = const Color(0x4DB3E5FC),
      ),
    );
  }

  void _buildBalanca() {
    add(
      _Balanca(
        position: Vector2(size.x / 2 - 70, size.y * 0.4 - 30),
        size: Vector2(40, 30),
      ),
    );
  }

  void _buildMiniGameElements() {
    // Área dos sintomas (esquerda, na metade inferior)
    final sintomaY = size.y * 0.68;
    final sintomaSpacing = size.x / 4;

    for (int i = 0; i < _sintomas.length; i++) {
      final sintoma = _sintomas[i];
      add(
        _SintomaCard(
          position: Vector2(sintomaSpacing * (i + 0.5), sintomaY),
          size: Vector2(90, 100),
          sintoma: sintoma,
          index: i,
          onTap: () => _onSintomaTapped(i),
        ),
      );
    }

    // Área dos remédios (direita, mais abaixo)
    final remedioY = size.y * 0.85;
    final remedioSpacing = size.x / 4;

    for (int i = 0; i < _remedios.length; i++) {
      final remedio = _remedios[i];
      add(
        _RemedioCard(
          position: Vector2(remedioSpacing * (i + 0.5), remedioY),
          size: Vector2(80, 70),
          remedio: remedio,
          index: i,
          onTap: () => _onRemedioTapped(i),
        ),
      );
    }
  }

  void _onSintomaTapped(int index) {
    if (_gameComplete || _matchedPairs.contains(index)) return;

    _selectedSintomaIndex = index;
    _instructionText.text =
        'Agora toque no remédio certo para ${_sintomas[index].name}!';
    _dicaText = null;
    _dicaTextComponent.text = '';

    // Atualizar visual dos cards
    _updateCardVisuals();
  }

  void _onRemedioTapped(int remedioIndex) {
    if (_gameComplete) return;
    if (_selectedSintomaIndex == null) {
      _dicaText = 'Primeiro toque em um sintoma!';
      _dicaTimer = 2.0;
      return;
    }

    final sintomaIndex = _selectedSintomaIndex!;

    if (_matchedPairs.contains(sintomaIndex)) {
      _selectedSintomaIndex = null;
      _updateCardVisuals();
      return;
    }

    final isCorrect = _correctMatch[sintomaIndex] == remedioIndex;

    if (isCorrect) {
      _matchedPairs.add(sintomaIndex);
      _selectedSintomaIndex = null;
      _instructionText.text =
          '✅ Correto! ${_sintomas[sintomaIndex].name} → ${_remedios[remedioIndex].name}';
      _dicaText = 'Muito bem! Continue!';
      _dicaTimer = 2.0;
    } else {
      _attemptedWrong.add(sintomaIndex);
      _selectedSintomaIndex = null;
      _instructionText.text =
          '❌ Ops! ${_sintomas[sintomaIndex].name} não é esse remédio.';
      _dicaText = _getDica(sintomaIndex);
      _dicaTimer = 3.0;
    }

    _updateCardVisuals();

    // Verificar se completou
    if (_matchedPairs.length == _sintomas.length) {
      _gameComplete = true;
      _resultTimer = 3.0;
      _awardReward();
    }
  }

  String _getDica(int sintomaIndex) {
    switch (sintomaIndex) {
      case 0:
        return 'Dica da Dra. Cássia: Febre precisa de algo quente... vermelho!';
      case 1:
        return 'Dica da Dra. Cássia: Dor de cabeça? Pense no céu... azul!';
      case 2:
        return 'Dica da Dra. Cássia: Barriguinha? Natureza... verde!';
      default:
        return 'Tente outro remédio!';
    }
  }

  void _updateCardVisuals() {
    for (final child in children) {
      if (child is _SintomaCard) {
        child.setSelected(child.index == _selectedSintomaIndex);
        child.setMatched(_matchedPairs.contains(child.index));
      }
      if (child is _RemedioCard) {
        child.setMatched(_matchedPairs.contains(_correctMatch.keys.firstWhere(
              (k) => _correctMatch[k] == child.index,
              orElse: () => -1,
            )));
      }
    }
  }

  void _awardReward() {
    final wrongCount = _attemptedWrong.length;
    final coins = 10 - wrongCount * 2; // 10, 8, 6, 4
    final stars = wrongCount == 0 ? 2 : 1;
    final safeCoins = coins.clamp(4, 10);

    final save = SaveService();
    if (save.isInitialized) {
      final data = save.playerData;
      save.savePlayerData(
        data.copyWith(
          coins: data.coins + safeCoins,
          stars: data.stars + stars,
        ),
      );
    }

    _resultText.text =
        '🎉 Parabéns! +$safeCoins🪙 +$stars⭐\nAdesivo: Doutorzinho 👨‍⚕️';
    _instructionText.text = 'Você completou o desafio da Farmácia!';
  }

  void _onDraCassiaInteract() {
    if (_isDialogueOpen) return;

    _isDialogueOpen = true;
    _draCassia.estado = NpcState.interacting;

    _dialogueOverlay = NpcDialogueOverlay(
      npcName: _draCassia.nome,
      text: _draCassia.proximoDialogo,
      onClose: _closeDialogue,
      size: size,
      avatarColor: const Color(0xFFFFFFFF),
    );

    add(_dialogueOverlay!);
    _dialogueOverlay!.show();
  }

  void _closeDialogue() {
    if (_dialogueOverlay == null) return;

    _dialogueOverlay!.removeFromParent();
    _dialogueOverlay = null;
    _isDialogueOpen = false;
    _draCassia.estado = NpcState.idle;
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

    // Timer de dica
    if (_dicaTimer > 0) {
      _dicaTimer -= dt;
      if (_dicaTimer <= 0) {
        _dicaTimer = 0;
        _dicaText = null;
        _dicaTextComponent.text = '';
      } else {
        _dicaTextComponent.text = _dicaText ?? '';
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
    canvas.restore();
  }
}

// ─── Componentes visuais ───

/// Prateleira com caixas de remédios.
class _Prateleira extends PositionComponent {
  _Prateleira({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topLeft);

  @override
  void render(Canvas canvas) {
    // Fundo da prateleira
    final shelfPaint = Paint()..color = const Color(0xFFCFD8DC);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), shelfPaint);

    // Borda
    final borderPaint = Paint()
      ..color = const Color(0xFF90A4AE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), borderPaint);

    // Prateleiras horizontais
    final linePaint = Paint()
      ..color = const Color(0xFF78909C)
      ..strokeWidth = 3;
    for (int i = 1; i < 3; i++) {
      final y = size.y * i / 3;
      canvas.drawLine(Offset(4, y), Offset(size.x - 4, y), linePaint);
    }

    // Caixas de remédios decorativas
    final rng = Random(hashCode);
    final colors = [
      const Color(0xFFEF5350),
      const Color(0xFF42A5F5),
      const Color(0xFF66BB6A),
      const Color(0xFFFFCA28),
      const Color(0xFFAB47BC),
      const Color(0xFFFF7043),
    ];

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 4; col++) {
        final boxW = 20.0;
        final boxH = 18.0;
        final boxX = 8 + col * 26.0;
        final boxY = 4 + row * (size.y / 3) + 4;
        final color = colors[(row * 4 + col + rng.nextInt(6)) % colors.length];

        final boxPaint = Paint()..color = color;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(boxX, boxY, boxW, boxH),
            const Radius.circular(2),
          ),
          boxPaint,
        );

        // Detalhe branco
        final detailPaint = Paint()..color = Colors.white.withValues(alpha: 0.3);
        canvas.drawRect(
          Rect.fromLTWH(boxX + 3, boxY + 5, boxW - 6, 3),
          detailPaint,
        );
      }
    }
  }
}

/// Balança no balcão.
class _Balanca extends PositionComponent {
  _Balanca({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.topLeft);

  @override
  void render(Canvas canvas) {
    // Base
    final basePaint = Paint()..color = const Color(0xFF78909C);
    canvas.drawRect(Rect.fromLTWH(5, size.y - 8, size.x - 10, 8), basePaint);

    // Coluna
    final colPaint = Paint()..color = const Color(0xFF607D8B);
    canvas.drawRect(Rect.fromLTWH(size.x / 2 - 3, 8, 6, size.y - 16), colPaint);

    // Prato superior
    final platePaint = Paint()..color = const Color(0xFF90A4AE);
    canvas.drawRect(Rect.fromLTWH(2, 4, size.x - 4, 6), platePaint);

    // Display digital
    final displayPaint = Paint()..color = const Color(0xFF263238);
    canvas.drawRect(Rect.fromLTWH(size.x - 14, 10, 12, 10), displayPaint);
    final numPaint = Paint()..color = const Color(0xFF00E676);
    canvas.drawRect(Rect.fromLTWH(size.x - 12, 12, 8, 6), numPaint);
  }
}

/// Card de sintoma (clicável).
class _SintomaCard extends PositionComponent with TapCallbacks {
  final _Sintoma sintoma;
  final int index;
  final VoidCallback onTap;
  bool _selected = false;
  bool _matched = false;
  double _feedbackTimer = 0;
  bool _showWrong = false;

  _SintomaCard({
    required Vector2 position,
    required Vector2 size,
    required this.sintoma,
    required this.index,
    required this.onTap,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.center,
        );

  void setSelected(bool value) => _selected = value;
  void setMatched(bool value) {
    if (value && !_matched) {
      _matched = true;
      _feedbackTimer = 1.0;
    }
  }

  void showWrong() {
    _showWrong = true;
    _feedbackTimer = 0.8;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_feedbackTimer > 0) {
      _feedbackTimer -= dt;
      if (_feedbackTimer <= 0) {
        _showWrong = false;
        _feedbackTimer = 0;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // Fundo
    Color bgColor;
    if (_matched) {
      bgColor = const Color(0xFFC8E6C9); // verde claro
    } else if (_showWrong) {
      bgColor = const Color(0xFFFFCDD2); // vermelho claro
    } else if (_selected) {
      bgColor = const Color(0xFFFFF9C4); // amarelo claro
    } else {
      bgColor = const Color(0xFFFFFFFF);
    }

    final bgPaint = Paint()..color = bgColor;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(12),
    );
    canvas.drawRRect(rrect, bgPaint);

    // Borda
    final borderColor = _selected
        ? const Color(0xFFFFCA28)
        : (_matched ? const Color(0xFF4CAF50) : const Color(0xFFCFD8DC));
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _selected || _matched ? 3 : 2;
    canvas.drawRRect(rrect, borderPaint);

    // Emoji do sintoma
    final emojiPainter = TextPainter(
      text: TextSpan(
        text: sintoma.emoji,
        style: const TextStyle(fontSize: 32),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    emojiPainter.layout();
    emojiPainter.paint(
      canvas,
      Offset(
        (size.x - emojiPainter.width) / 2,
        8,
      ),
    );

    // Nome do sintoma
    final namePainter = TextPainter(
      text: TextSpan(
        text: sintoma.name,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    namePainter.layout(maxWidth: size.x - 8);
    namePainter.paint(
      canvas,
      Offset(
        (size.x - namePainter.width) / 2,
        size.y - namePainter.height - 8,
      ),
    );

    // Checkmark se acertado
    if (_matched) {
      final checkPainter = TextPainter(
        text: const TextSpan(
          text: '✅',
          style: TextStyle(fontSize: 20),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      checkPainter.layout();
      checkPainter.paint(
        canvas,
        Offset(size.x - 22, 4),
      );
    }

    // X se errou
    if (_showWrong) {
      final wrongPainter = TextPainter(
        text: const TextSpan(
          text: '❌',
          style: TextStyle(fontSize: 20),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      wrongPainter.layout();
      wrongPainter.paint(
        canvas,
        Offset(size.x - 22, 4),
      );
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!_matched) {
      onTap();
    }
  }
}

/// Card de remédio (clicável).
class _RemedioCard extends PositionComponent with TapCallbacks {
  final _Remedio remedio;
  final int index;
  final VoidCallback onTap;
  bool _matched = false;

  _RemedioCard({
    required Vector2 position,
    required Vector2 size,
    required this.remedio,
    required this.index,
    required this.onTap,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.center,
        );

  void setMatched(bool value) => _matched = value;

  @override
  void render(Canvas canvas) {
    // Fundo
    final bgPaint = Paint()
      ..color = _matched
          ? const Color(0xFFC8E6C9)
          : const Color(0xFFFFFFFF);
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(12),
    );
    canvas.drawRRect(rrect, bgPaint);

    // Borda
    final borderPaint = Paint()
      ..color = _matched ? const Color(0xFF4CAF50) : const Color(0xFFCFD8DC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _matched ? 3 : 2;
    canvas.drawRRect(rrect, borderPaint);

    // Comprimido (oval colorido)
    final pillPaint = Paint()..color = remedio.color;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.x / 2, size.y / 2 - 6),
          width: size.x * 0.5,
          height: size.y * 0.35,
        ),
        const Radius.circular(8),
      ),
      pillPaint,
    );

    // Linha do meio do comprimido
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(size.x / 2 - 8, size.y / 2 - 6),
      Offset(size.x / 2 + 8, size.y / 2 - 6),
      linePaint,
    );

    // Nome do remédio
    final namePainter = TextPainter(
      text: TextSpan(
        text: remedio.name,
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
        size.y - namePainter.height - 6,
      ),
    );

    // Checkmark se acertado
    if (_matched) {
      final checkPainter = TextPainter(
        text: const TextSpan(
          text: '✅',
          style: TextStyle(fontSize: 18),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      checkPainter.layout();
      checkPainter.paint(
        canvas,
        Offset(size.x - 20, 2),
      );
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!_matched) {
      onTap();
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
