import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

/// Tipos de itens do inventário.
enum InventoryItemType { recipe, sticker, collectible, empty }

/// Item do inventário.
class InventoryItem {
  final String id;
  final String name;
  final InventoryItemType type;
  final String? description;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.type,
    this.description,
  });
}

/// Overlay de inventário — grid 4x3 de slots.
class InventoryOverlayComponent extends PositionComponent with TapCallbacks {
  final List<InventoryItem> items;
  final VoidCallback onClose;

  double _opacity = 0;
  double _targetOpacity = 1.0;
  String? _selectedId;

  InventoryOverlayComponent({
    required this.items,
    required this.onClose,
  }) : super(
          position: Vector2.zero(),
          anchor: Anchor.topLeft,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _opacity = 0;
    _targetOpacity = 1.0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if ((_targetOpacity - _opacity).abs() > 0.01) {
      final step = dt / 0.2;
      if (_opacity < _targetOpacity) {
        _opacity = (_opacity + step).clamp(0.0, _targetOpacity);
      } else {
        _opacity = (_opacity - step).clamp(_targetOpacity, 1.0);
      }
    } else {
      _opacity = _targetOpacity;
    }
  }

  @override
  void renderTree(Canvas canvas) {
    if (_opacity <= 0.01) return;
    canvas.saveLayer(
      null,
      Paint()..color = Colors.white.withOpacity(_opacity),
    );
    super.renderTree(canvas);
    canvas.restore();
  }

  @override
  void render(Canvas canvas) {
    // Fundo escuro
    final bgPaint = Paint()..color = const Color(0x99000000);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), bgPaint);

    final panelW = 380.0;
    final panelH = 420.0;
    final panelX = (size.x - panelW) / 2;
    final panelY = (size.y - panelH) / 2;

    // Painel
    final panelPaint = Paint()..color = AppColors.greyLight;
    final panelRrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(panelX, panelY, panelW, panelH),
      const Radius.circular(24),
    );
    canvas.drawRRect(panelRrect, panelPaint);

    // Título
    final titlePainter = TextPainter(
      text: const TextSpan(
        text: '🎒 Inventário',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    titlePainter.layout();
    titlePainter.paint(
      canvas,
      Offset(panelX + 20, panelY + 16),
    );

    // Botão fechar (X)
    final closeRect = Rect.fromLTWH(panelX + panelW - 44, panelY + 12, 32, 32);
    final closePaint = Paint()..color = Colors.transparent;
    canvas.drawRect(closeRect, closePaint);

    final xPainter = TextPainter(
      text: const TextSpan(
        text: '✕',
        style: TextStyle(fontSize: 22, color: AppColors.greyDark),
      ),
      textDirection: TextDirection.ltr,
    );
    xPainter.layout();
    xPainter.paint(
      canvas,
      Offset(closeRect.left + (closeRect.width - xPainter.width) / 2,
          closeRect.top + (closeRect.height - xPainter.height) / 2),
    );

    // Grid 4x3
    final cols = 4;
    final rows = 3;
    final slotSize = 72.0;
    final gap = 10.0;
    final gridW = cols * slotSize + (cols - 1) * gap;
    final gridX = panelX + (panelW - gridW) / 2;
    final gridY = panelY + 60;

    final slots = List<InventoryItem>.generate(
      12,
      (i) => i < items.length ? items[i] : _emptyItem(),
    );

    for (int i = 0; i < slots.length; i++) {
      final col = i % cols;
      final row = i ~/ cols;
      final x = gridX + col * (slotSize + gap);
      final y = gridY + row * (slotSize + gap);
      final item = slots[i];
      final isSelected = _selectedId == item.id && item.type != InventoryItemType.empty;

      final slotRect = Rect.fromLTWH(x, y, slotSize, slotSize);
      final slotRrect = RRect.fromRectAndRadius(
        slotRect,
        const Radius.circular(12),
      );

      final bgColor = _colorForType(item.type);
      final slotPaint = Paint()..color = bgColor;
      canvas.drawRRect(slotRrect, slotPaint);

      final borderPaint = Paint()
        ..color = isSelected ? AppColors.primary : Colors.black12
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 3 : 1;
      canvas.drawRRect(slotRrect, borderPaint);

      if (item.type != InventoryItemType.empty) {
        final iconPainter = TextPainter(
          text: TextSpan(
            text: _iconForType(item.type),
            style: const TextStyle(fontSize: 28),
          ),
          textDirection: TextDirection.ltr,
        );
        iconPainter.layout();
        iconPainter.paint(
          canvas,
          Offset(
            x + (slotSize - iconPainter.width) / 2,
            y + (slotSize - iconPainter.height) / 2,
          ),
        );
      } else {
        final emptyPainter = TextPainter(
          text: const TextSpan(
            text: '📦',
            style: TextStyle(fontSize: 20, color: Colors.black26),
          ),
          textDirection: TextDirection.ltr,
        );
        emptyPainter.layout();
        emptyPainter.paint(
          canvas,
          Offset(
            x + (slotSize - emptyPainter.width) / 2,
            y + (slotSize - emptyPainter.height) / 2,
          ),
        );
      }
    }

    // Tooltip do item selecionado
    if (_selectedId != null) {
      final selected = items.firstWhere(
        (i) => i.id == _selectedId,
        orElse: () => _emptyItem(),
      );
      if (selected.type != InventoryItemType.empty) {
        final tooltipY = gridY + rows * (slotSize + gap) + 10;
        final tooltipRect = Rect.fromLTWH(
          panelX + 20,
          tooltipY,
          panelW - 40,
          60,
        );
        final tooltipRrect = RRect.fromRectAndRadius(
          tooltipRect,
          const Radius.circular(12),
        );
        final tooltipPaint = Paint()..color = Colors.white;
        canvas.drawRRect(tooltipRrect, tooltipPaint);

        final tooltipBorder = Paint()
          ..color = AppColors.primary.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawRRect(tooltipRrect, tooltipBorder);

        final namePainter = TextPainter(
          text: TextSpan(
            text: '${_iconForType(selected.type)} ${selected.name}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        namePainter.layout();
        namePainter.paint(
          canvas,
          Offset(tooltipRect.left + 12, tooltipRect.top + 8),
        );

        if (selected.description != null) {
          final descPainter = TextPainter(
            text: TextSpan(
              text: selected.description,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
            textDirection: TextDirection.ltr,
          );
          descPainter.layout(maxWidth: tooltipRect.width - 24);
          descPainter.paint(
            canvas,
            Offset(tooltipRect.left + 12, tooltipRect.top + 30),
          );
        }
      }
    }

    // Botão Fechar
    final btnY = panelY + panelH - 56;
    _drawButton(canvas, panelX + 24, btnY, panelW - 48, 44, '✅ Fechar',
        AppColors.success, onClose);
  }

  void _drawButton(Canvas canvas, double x, double y, double w, double h,
      String text, Color color, VoidCallback onTap) {
    final rect = Rect.fromLTWH(x, y, w, h);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
    final paint = Paint()..color = color;
    canvas.drawRRect(rrect, paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(x + (w - textPainter.width) / 2, y + (h - textPainter.height) / 2),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    event.handled = true;
    final local = event.localPosition;

    final panelW = 380.0;
    final panelH = 420.0;
    final panelX = (size.x - panelW) / 2;
    final panelY = (size.y - panelH) / 2;

    // Fechar (X)
    final closeRect = Rect.fromLTWH(panelX + panelW - 44, panelY + 12, 32, 32);
    if (closeRect.contains(Offset(local.x, local.y))) {
      onClose();
      return;
    }

    // Botão Fechar
    final btnY = panelY + panelH - 56;
    final btnRect = Rect.fromLTWH(panelX + 24, btnY, panelW - 48, 44);
    if (btnRect.contains(Offset(local.x, local.y))) {
      onClose();
      return;
    }

    // Grid
    final cols = 4;
    final slotSize = 72.0;
    final gap = 10.0;
    final gridW = cols * slotSize + (cols - 1) * gap;
    final gridX = panelX + (panelW - gridW) / 2;
    final gridY = panelY + 60;

    for (int i = 0; i < 12; i++) {
      final col = i % cols;
      final row = i ~/ cols;
      final x = gridX + col * (slotSize + gap);
      final y = gridY + row * (slotSize + gap);
      final slotRect = Rect.fromLTWH(x, y, slotSize, slotSize);
      if (slotRect.contains(Offset(local.x, local.y))) {
        final item = i < items.length ? items[i] : _emptyItem();
        if (item.type != InventoryItemType.empty) {
          _selectedId = item.id;
        } else {
          _selectedId = null;
        }
        return;
      }
    }

    _selectedId = null;
  }

  String _iconForType(InventoryItemType type) {
    switch (type) {
      case InventoryItemType.recipe:
        return '📄';
      case InventoryItemType.sticker:
        return '⭐';
      case InventoryItemType.collectible:
        return '🎁';
      case InventoryItemType.empty:
        return '';
    }
  }

  Color _colorForType(InventoryItemType type) {
    switch (type) {
      case InventoryItemType.recipe:
        return const Color(0xFFFFF3E0);
      case InventoryItemType.sticker:
        return const Color(0xFFFFFDE7);
      case InventoryItemType.collectible:
        return const Color(0xFFE8F5E9);
      case InventoryItemType.empty:
        return Colors.white24;
    }
  }

  InventoryItem _emptyItem() => const InventoryItem(
        id: 'empty',
        name: 'Vazio',
        type: InventoryItemType.empty,
      );
}
