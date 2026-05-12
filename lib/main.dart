import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/services/analytics_service.dart';
import 'registry.dart';
import 'ui/screens/loading_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuração de tela cheia imersiva
  // Esconde barras de navegação e status no Android
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersive,
    overlays: [],
  );
  // Listener para re-esconder barras quando usuário deslizar
  SystemChrome.setSystemUIChangeCallback((systemUiOverlaysAreVisible) async {
    if (systemUiOverlaysAreVisible) {
      await Future.delayed(const Duration(seconds: 3));
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersive,
        overlays: [],
      );
    }
  });
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Firebase
  await Firebase.initializeApp();

  // Crashlytics — apenas em release, nunca em debug
  if (kReleaseMode) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  // Analytics desabilitado por padrão (opt-in LGPD/COPPA)
  AnalyticsService().setEnabled(false);

  // Registrar conteúdo do jogo
  registerAllContent();

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
      home: const LoadingScreen(),
    );
  }
}
