import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'npc_base.dart';

/// Tia Júlia — professora da escola, estática perto da lousa.
class TiaJulia extends NpcBase {
  final VoidCallback? onInteractCallback;

  TiaJulia({
    required super.position,
    this.onInteractCallback,
  }) : super(
          nome: 'Tia Júlia',
          dialogos: const [
            'Bem-vindo à escola! Escolha um jogo para aprender!',
          ],
          spritePath: 'characters/npcs/tia_julia.png',
          size: Vector2.all(64),
          patrolBounds: null,
        );

  @override
  void onInteract() {
    onInteractCallback?.call();
  }

  @override
  void update(double dt) {
    estado = NpcState.idle;
  }
}
