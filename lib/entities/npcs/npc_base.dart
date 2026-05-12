import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

/// Estados possíveis de um NPC.
enum NpcState { idle, walking, interacting }

/// Classe base abstrata para todos os NPCs do jogo.
abstract class NpcBase extends SpriteComponent with TapCallbacks, HasGameReference {
  final String nome;
  final List<String> dialogos;
  NpcState estado = NpcState.idle;

  // Movimento aleatório
  final Random _random = Random();
  Vector2? _walkTarget;
  double _walkTimer = 0;
  double _nextWalkDelay = 0;
  static const double _walkSpeed = 40.0;

  // Área de patrulha (bounds)
  final Rect? patrolBounds;

  /// Caminho do sprite no assets/images/ (ex: 'characters/npcs/prefeito_tico.png')
  final String spritePath;

  NpcBase({
    required this.nome,
    required this.dialogos,
    required Vector2 position,
    required this.spritePath,
    Vector2? size,
    this.patrolBounds,
  }) : super(
          position: position,
          size: size ?? Vector2.all(64),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite(spritePath);
  }

  /// Chamado quando o jogador interage com o NPC.
  void onInteract();

  @override
  void update(double dt) {
    super.update(dt);

    if (estado == NpcState.interacting) return;

    _walkTimer += dt;

    if (_walkTarget == null && _walkTimer >= _nextWalkDelay) {
      _chooseNewWalkTarget();
    }

    if (_walkTarget != null) {
      estado = NpcState.walking;
      final direction = _walkTarget! - position;
      final distance = direction.length;

      if (distance < 3) {
        _walkTarget = null;
        _walkTimer = 0;
        _nextWalkDelay = 2 + _random.nextDouble() * 2; // 2-4s parado
        estado = NpcState.idle;
      } else {
        direction.normalize();
        final nextPos = position + direction * _walkSpeed * dt;

        // Respeitar bounds se definidos
        final bounds = patrolBounds;
        if (bounds != null) {
          position = Vector2(
            nextPos.x.clamp(bounds.left, bounds.right),
            nextPos.y.clamp(bounds.top, bounds.bottom),
          );
        } else {
          position = nextPos;
        }
      }
    }
  }

  void _chooseNewWalkTarget() {
    final bounds = patrolBounds;
    if (bounds == null) return;
    _walkTarget = Vector2(
      bounds.left + _random.nextDouble() * bounds.width,
      bounds.top + _random.nextDouble() * bounds.height,
    );
    _walkTimer = 0;
  }

  @override
  void onTapDown(TapDownEvent event) {
    event.handled = true;
    onInteract();
  }
}
