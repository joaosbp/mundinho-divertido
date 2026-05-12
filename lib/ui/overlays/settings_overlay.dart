import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';
import '../../core/services/save_service.dart';
import '../../models/settings_data.dart';

/// Overlay de configurações — som, música, vibração e idioma.
class SettingsOverlayComponent extends PositionComponent with TapCallbacks {
  final VoidCallback onBack;

  double _opacity = 0;
  double _targetOpacity = 1.0;

  late SettingsData _settings;
  bool _loaded = false;

  SettingsOverlayComponent({required this.onBack})
      : super(
          position: Vector2.zero(),
          anchor: Anchor.topLeft,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final save = SaveService();
    if (!save.isInitialized) {
      await save.initialize();
    }
    _settings = save.settingsData;
    _loaded = true;
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
    if (!_loaded) return;

    // Fundo escuro
    final bgPaint = Paint()..color = const Color(0xB3000000);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), bgPaint);

    final panelW = 340.0;
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
        text: '⚙️ Configurações',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    titlePainter.layout();
    titlePainter.paint(
      canvas,
      Offset(panelX + (panelW - titlePainter.width) / 2, panelY + 20),
    );

    // Opções
    double optY = panelY + 70;
    final optW = panelW - 48;
    final optH = 52.0;

    _drawToggle(canvas, panelX + 24, optY, optW, optH, '🎵 Música',
        _settings.musicOn, (v) => _setMusic(v));
    optY += optH + 10;

    _drawToggle(canvas, panelX + 24, optY, optW, optH, '🔊 Efeitos sonoros',
        _settings.soundOn, (v) => _setSound(v));
    optY += optH + 10;

    _drawToggle(canvas, panelX + 24, optY, optW, optH, '📳 Vibração',
        _settings.vibrationOn, (v) => _setVibration(v));
    optY += optH + 16;

    // Idioma
    _drawLanguageRow(canvas, panelX + 24, optY, optW, optH);
    optY += optH + 24;

    // Botão Voltar
    _drawButton(canvas, panelX + 24, optY, optW, 48, '⬅️ Voltar',
        AppColors.primary, onBack);
  }

  void _drawToggle(Canvas canvas, double x, double y, double w, double h,
      String label, bool value, ValueChanged<bool> onChanged) {
    final rect = Rect.fromLTWH(x, y, w, h);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
    final paint = Paint()..color = Colors.white;
    canvas.drawRRect(rrect, paint);

    final borderPaint = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(rrect, borderPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x + 12, y + (h - textPainter.height) / 2));

    // Toggle
    final toggleX = x + w - 52;
    final toggleY = y + (h - 28) / 2;
    final togglePaint = Paint()
      ..color = value ? AppColors.success : Colors.grey;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(toggleX, toggleY, 44, 28),
        const Radius.circular(14),
      ),
      togglePaint,
    );

    final knobX = value ? toggleX + 44 - 24 : toggleX + 4;
    final knobPaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(knobX + 10, toggleY + 14),
      10,
      knobPaint,
    );

    // Valor texto
    final valPainter = TextPainter(
      text: TextSpan(
        text: value ? 'ON' : 'OFF',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: value ? AppColors.success : Colors.grey,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    valPainter.layout();
    valPainter.paint(
      canvas,
      Offset(x + w - 58 - valPainter.width, y + (h - valPainter.height) / 2),
    );
  }

  void _drawLanguageRow(Canvas canvas, double x, double y, double w, double h) {
    final rect = Rect.fromLTWH(x, y, w, h);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
    final paint = Paint()..color = Colors.white;
    canvas.drawRRect(rrect, paint);

    final borderPaint = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(rrect, borderPaint);

    final textPainter = TextPainter(
      text: const TextSpan(
        text: '🌐 Idioma',
        style: TextStyle(fontSize: 16, color: Colors.black87),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x + 12, y + (h - textPainter.height) / 2));

    final lang = _settings.language == 'pt_BR' ? '🇧🇷 PT' : '🇺🇸 EN';
    final langPainter = TextPainter(
      text: TextSpan(
        text: lang,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.info,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    langPainter.layout();
    langPainter.paint(
      canvas,
      Offset(x + w - 12 - langPainter.width, y + (h - langPainter.height) / 2),
    );
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

    final panelW = 340.0;
    final panelH = 420.0;
    final panelX = (size.x - panelW) / 2;
    final panelY = (size.y - panelH) / 2;

    double optY = panelY + 70;
    final optW = panelW - 48;
    final optH = 52.0;

    if (_hitRow(local, panelX + 24, optY, optW, optH)) {
      _setMusic(!_settings.musicOn);
      return;
    }
    optY += optH + 10;

    if (_hitRow(local, panelX + 24, optY, optW, optH)) {
      _setSound(!_settings.soundOn);
      return;
    }
    optY += optH + 10;

    if (_hitRow(local, panelX + 24, optY, optW, optH)) {
      _setVibration(!_settings.vibrationOn);
      return;
    }
    optY += optH + 16;

    if (_hitRow(local, panelX + 24, optY, optW, optH)) {
      _toggleLanguage();
      return;
    }
    optY += optH + 24;

    if (_hitRow(local, panelX + 24, optY, optW, 48)) {
      onBack();
    }
  }

  bool _hitRow(Vector2 pos, double x, double y, double w, double h) {
    return pos.x >= x && pos.x <= x + w && pos.y >= y && pos.y <= y + h;
  }

  void _setMusic(bool v) {
    _settings = _settings.copyWith(musicOn: v);
    SaveService().saveSettings(_settings);
  }

  void _setSound(bool v) {
    _settings = _settings.copyWith(soundOn: v);
    SaveService().saveSettings(_settings);
  }

  void _setVibration(bool v) {
    _settings = _settings.copyWith(vibrationOn: v);
    SaveService().saveSettings(_settings);
  }

  void _toggleLanguage() {
    final lang = _settings.language == 'pt_BR' ? 'en_US' : 'pt_BR';
    _settings = _settings.copyWith(language: lang);
    SaveService().saveSettings(_settings);
  }
}
