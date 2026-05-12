import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import '../game/mundinho_game.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4ECDC4),
              Color(0xFF44A08D),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo / Título
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 80,
                        color: Colors.amber,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Mundinho',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 48,
                            ),
                      ),
                      Text(
                        'Divertido',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: const Color(0xFFFFF59D),
                              fontWeight: FontWeight.bold,
                              fontSize: 36,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                // Botão Jogar
                _MenuButton(
                  text: '▶  JOGAR',
                  color: const Color(0xFFFF6B6B),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => GameWidget(
                          game: MundinhoGame(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Botão Configurações
                _MenuButton(
                  text: '⚙  CONFIGURAÇÕES',
                  color: const Color(0xFF4ECDC4),
                  onPressed: () {
                    // TODO: Implementar configurações
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Em breve! 🚧'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Botão Sobre
                _MenuButton(
                  text: '❤  SOBRE',
                  color: const Color(0xFF9B59B6),
                  onPressed: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Mundinho Divertido',
                      applicationVersion: '1.0.0',
                      children: const [
                        Text('Um jogo infantil cheio de diversão! 🎮'),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 8,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
