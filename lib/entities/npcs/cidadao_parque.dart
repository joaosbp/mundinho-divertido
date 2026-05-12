import 'package:flame/components.dart';

import 'npc_base.dart';

/// NPC cidadão que fica no Parque Central.
class CidadaoParque extends NpcBase {
  CidadaoParque({required super.position, super.patrolBounds})
      : super(
          nome: 'Cidadão',
          dialogos: const ['Olá! O parque é ótimo para brincar! 🌳'],
          spritePath: 'characters/npcs/cidadao.png',
          size: Vector2.all(64),
        );

  @override
  void onInteract() {
    // O diálogo é gerenciado pelo MundinhoGame via callback
  }
}
