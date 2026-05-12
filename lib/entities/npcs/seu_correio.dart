import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'npc_base.dart';

/// Seu Correio — funcionário dos Correios.
class SeuCorreio extends NpcBase {
  final VoidCallback onInteractCallback;

  SeuCorreio({
    required super.position,
    required this.onInteractCallback,
  }) : super(
          nome: 'Seu Correio',
          dialogos: const [
            'Olá! Preciso entregar cartas para 3 locais. Você pode me ajudar?',
            'Memorize a rota e entregue as cartas na ordem certa!',
            'Bom trabalho! Você é um carteiro nato!',
          ],
          spritePath: 'characters/npcs/seu_correio.png',
          size: Vector2.all(64),
          patrolBounds: null,
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
    // Estático
  }

  @override
  void onInteract() {
    onInteractCallback();
  }
}
