import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'npc_base.dart';

/// Dra. Cássia — médica da Farmácia.
class DraCassia extends NpcBase {
  final VoidCallback onInteractCallback;

  DraCassia({
    required super.position,
    required this.onInteractCallback,
  }) : super(
          nome: 'Dra. Cássia',
          dialogos: const [
            'Olá! Qual o seu sintoma? Vou te ajudar a encontrar o remédio certo!',
            'Lembre-se: febre precisa de comprimido vermelho!',
            'Dor de cabeça? O azul é o remédio certo!',
            'Barriguinha chata? O verde vai te ajudar!',
            'Você está ficando um expert em remédios!',
          ],
          spritePath: 'characters/npcs/dra_cassia.png',
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
    // Estática
  }

  @override
  void onInteract() {
    onInteractCallback();
  }
}
