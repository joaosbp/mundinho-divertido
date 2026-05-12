import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/audio_service.dart';
import '../../core/services/save_service.dart';
import '../../screens/menu_screen.dart';

/// Tela de loading inicial.
///
/// - Fundo azul céu
/// - Logo "Mundinho Divertido" animado (bounce)
/// - Barra de progresso animada
/// - Texto "Carregando..." com animação de pontos
/// - Inicializa Hive, carrega dados, depois navega para [MenuScreen]
/// - Duração mínima: 2s (para não piscar)
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final AnimationController _progressController;
  late final AnimationController _dotsController;

  late final Animation<double> _bounceAnimation;

  double _progress = 0.0;
  String _dots = '';

  String? _error;

  static const _minDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: -20)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -20, end: 0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 70,
      ),
    ]).animate(_bounceController);

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _dotsController.addListener(() {
      final count = (math.sin(_dotsController.value * math.pi * 2) + 1) ~/ 1;
      setState(() {
        _dots = '.' * (count + 1).clamp(1, 3);
      });
    });

    _bounceController.repeat();
    _progressController.forward();

    _progressController.addListener(() {
      setState(() {
        _progress = _progressController.value;
      });
    });

    _initApp();
  }

  Future<void> _initApp() async {
    final stopwatch = Stopwatch()..start();

    try {
      // Passo 1: inicializar serviços
      await SaveService().initialize();
      setState(() => _progress = 0.3);

      // Passo 2: carregar dados
      SaveService().loadPlayerData();
      SaveService().loadSettings();
      setState(() => _progress = 0.6);

      // Passo 3: inicializar áudio
      await AudioService().initialize();
      setState(() => _progress = 0.8);

      // Passo 4: garantir duração mínima
      final elapsed = stopwatch.elapsed;
      if (elapsed < _minDuration) {
        await Future.delayed(_minDuration - elapsed);
      }
      setState(() => _progress = 1.0);

      // Navegar para o menu
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MenuScreen(),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar: $e';
        _progress = 0;
      });
    } finally {
      stopwatch.stop();
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _progressController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF87CEEB), // azul céu
              Color(0xFFB3E5FC),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo animado
                AnimatedBuilder(
                  animation: _bounceAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _bounceAnimation.value),
                      child: child,
                    );
                  },
                  child: Column(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 80,
                        color: Colors.amber,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Mundinho',
                        style: GoogleFonts.fredoka(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            const Shadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Divertido',
                        style: GoogleFonts.fredoka(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFF59D),
                          shadows: [
                            const Shadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 64),

                // Barra de progresso
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 64),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 12,
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF6B6B),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Texto carregando
                if (_error == null)
                  Text(
                    'Carregando$_dots',
                    style: GoogleFonts.fredoka(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        const Shadow(
                          color: Colors.black26,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    _error!,
                    style: GoogleFonts.fredoka(
                      fontSize: 16,
                      color: Colors.red.shade100,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
