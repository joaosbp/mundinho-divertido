import 'package:flutter/material.dart';

/// HUD principal do jogo (overlay sobre o FlameGame).
class MainHud extends StatelessWidget {
  final int stars;
  final int coins;
  final VoidCallback? onPausePressed;
  final VoidCallback? onInventoryPressed;
  final VoidCallback? onMapPressed;

  const MainHud({
    super.key,
    this.stars = 0,
    this.coins = 0,
    this.onPausePressed,
    this.onInventoryPressed,
    this.onMapPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Topo: recursos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _ResourceBadge(icon: '⭐', value: stars),
                    const SizedBox(width: 12),
                    _ResourceBadge(icon: '🪙', value: coins),
                  ],
                ),
                IconButton(
                  onPressed: onPausePressed,
                  icon: const Icon(Icons.pause_circle_filled, size: 40),
                  color: Colors.white,
                ),
              ],
            ),
            const Spacer(),
            // Base: ações rápidas
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _HudButton(
                  icon: Icons.backpack,
                  onPressed: onInventoryPressed,
                ),
                const SizedBox(width: 16),
                _HudButton(
                  icon: Icons.map,
                  onPressed: onMapPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ResourceBadge extends StatelessWidget {
  final String icon;
  final int value;

  const _ResourceBadge({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$icon $value',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _HudButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _HudButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white70,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(icon, size: 32, color: Colors.black87),
        ),
      ),
    );
  }
}
