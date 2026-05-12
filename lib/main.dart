import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'game/mundinho_game.dart';
import 'screens/menu_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MundinhoDivertidoApp());
}

class MundinhoDivertidoApp extends StatelessWidget {
  const MundinhoDivertidoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mundinho Divertido',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B6B),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.fredokaTextTheme(),
        useMaterial3: true,
      ),
      home: const MenuScreen(),
    );
  }
}
