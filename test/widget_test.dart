import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mundinho_divertido/main.dart';
import 'package:mundinho_divertido/screens/menu_screen.dart';
import 'package:mundinho_divertido/ui/screens/loading_screen.dart';

void main() {
  group('MenuScreen', () {
    testWidgets('renderiza título e botões', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MenuScreen(),
        ),
      );

      expect(find.text('Mundinho'), findsOneWidget);
      expect(find.text('Divertido'), findsOneWidget);
      expect(find.text('▶  JOGAR'), findsOneWidget);
      expect(find.text('⚙  CONFIGURAÇÕES'), findsOneWidget);
      expect(find.text('❤  SOBRE'), findsOneWidget);
    });

    testWidgets('botão Jogar existe e é clicável', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MenuScreen(),
        ),
      );

      final jogarBtn = find.text('▶  JOGAR');
      expect(jogarBtn, findsOneWidget);

      // Verifica que o botão está habilitado (onPressed não é null)
      final button = tester.widget<ElevatedButton>(
        find.ancestor(of: jogarBtn, matching: find.byType(ElevatedButton)),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('botão Sobre abre diálogo', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MenuScreen(),
        ),
      );

      await tester.tap(find.text('❤  SOBRE'));
      await tester.pumpAndSettle();

      expect(find.text('Mundinho Divertido'), findsOneWidget);
      expect(find.text('Um jogo infantil cheio de diversão! 🎮'), findsOneWidget);
    });
  });

  group('LoadingScreen', () {
    testWidgets('renderiza elementos visuais iniciais', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingScreen(),
        ),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);
      expect(find.text('Mundinho'), findsOneWidget);
      expect(find.text('Divertido'), findsOneWidget);
    });
  });

  group('MundinhoDivertidoApp', () {
    testWidgets('inicia com LoadingScreen', (WidgetTester tester) async {
      await tester.pumpWidget(const MundinhoDivertidoApp());
      expect(find.byType(LoadingScreen), findsOneWidget);
    });
  });
}
