import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'npc_base.dart';

/// Prefeito Tico — NPC estático atrás da mesa da Prefeitura.
class PrefeitoTico extends NpcBase {
  final VoidCallback onInteractCallback;

  PrefeitoTico({
    required super.position,
    required this.onInteractCallback,
  }) : super(
          nome: 'Prefeito Tico',
          dialogos: const [
            'Bem-vindo ao Mundinho! Sou o Prefeito Tico.',
            'Nossa cidade precisa de ajuda! Você pode explorar e ajudar?',
            'Volte aqui quando completar suas tarefas!',
          ],
          spritePath: 'characters/npcs/prefeito_tico.png',
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
    // Prefeito é estático — não chama movimento do pai
  }

  @override
  void onInteract() {
    onInteractCallback();
  }
}
