import 'package:flutter_test/flutter_test.dart';
import 'package:mundinho_divertido/minigames/games/math/matematica_lousa.dart';
import 'package:mundinho_divertido/minigames/games/memory/lista_compras.dart';
import 'package:mundinho_divertido/minigames/games/sequence/padeiro_mirim.dart';

void main() {
  group('ListaComprasMiniGame', () {
    late ListaComprasMiniGame game;

    setUp(() {
      game = ListaComprasMiniGame();
    });

    test('propriedades corretas', () {
      expect(game.id, 'lista_compras');
      expect(game.name, 'Lista de Compras');
      expect(game.duration, const Duration(minutes: 2));
      expect(game.skills, contains('memoria'));
      expect(game.skills, contains('atencao'));
    });

    test('onComplete retorna recompensa', () {
      final result = game.onComplete();
      expect(result.stars, greaterThanOrEqualTo(1));
      expect(result.coins, greaterThanOrEqualTo(0));
      expect(result.message, isNotEmpty);
    });
  });

  group('PadeiroMirimMiniGame', () {
    late PadeiroMirimMiniGame game;

    setUp(() {
      game = PadeiroMirimMiniGame();
    });

    test('propriedades corretas', () {
      expect(game.id, 'padeiro_mirim');
      expect(game.name, 'Padeiro Mirim');
      expect(game.duration, const Duration(minutes: 3));
      expect(game.skills, contains('sequencia'));
      expect(game.skills, contains('coordenacao_motora'));
    });

    test('onComplete retorna recompensa', () {
      final result = game.onComplete();
      expect(result.stars, greaterThanOrEqualTo(1));
      expect(result.coins, greaterThanOrEqualTo(0));
      expect(result.message, contains('bolo'));
    });
  });

  group('MatematicaLousaMiniGame', () {
    late MatematicaLousaMiniGame game;

    setUp(() {
      game = MatematicaLousaMiniGame();
    });

    test('propriedades corretas', () {
      expect(game.id, 'matematica_lousa');
      expect(game.name, 'Matem\u00e1tica na Lousa');
      expect(game.duration, const Duration(minutes: 2));
      expect(game.skills, contains('contagem'));
      expect(game.skills, contains('reconhecimento_numerico'));
    });

    test('onComplete retorna recompensa', () {
      final result = game.onComplete();
      expect(result.stars, greaterThanOrEqualTo(1));
      expect(result.coins, greaterThanOrEqualTo(0));
      expect(result.message, contains('contou'));
    });
  });

  group('MiniGameBase comportamento base', () {
    test('onAbandon retorna 0 estrelas', () {
      final game = ListaComprasMiniGame();
      final result = game.onAbandon();
      expect(result.stars, 0);
      expect(result.coins, 0);
    });

    test('onStart n\u00e3o lan\u00e7a exce\u00e7\u00e3o', () {
      final game = ListaComprasMiniGame();
      expect(() => game.onStart(), returnsNormally);
    });
  });
}
