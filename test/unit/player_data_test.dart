import 'package:flutter_test/flutter_test.dart';
import 'package:mundinho_divertido/models/player_data.dart';

void main() {
  group('PlayerData', () {
    test('defaultData cria valores corretos', () {
      final data = PlayerData.defaultData();

      expect(data.playerName, 'Jogador');
      expect(data.coins, 0);
      expect(data.stars, 0);
      expect(data.unlockedLocations, ['casa_jogador', 'praca_central']);
      expect(data.completedMissions, isEmpty);
      expect(data.collectedStickers, isEmpty);
      expect(data.miniGameHighScores, isEmpty);
      expect(data.totalPlayTimeMinutes, 0);
      expect(data.npcFriendship, isEmpty);
      expect(data.inventory, isEmpty);
      expect(data.visitedLocations, isEmpty);
      expect(data.completedMiniGames, isEmpty);
      expect(data.settings.language, 'pt');
    });

    test('copyWith altera valores específicos', () {
      final data = PlayerData.defaultData();
      final updated = data.copyWith(
        playerName: 'Ana',
        coins: 50,
        stars: 3,
      );

      expect(updated.playerName, 'Ana');
      expect(updated.coins, 50);
      expect(updated.stars, 3);
      expect(updated.unlockedLocations, data.unlockedLocations);
    });

    test('copyWith mantém listas imutáveis', () {
      final data = PlayerData.defaultData();
      final updated = data.copyWith();

      expect(updated.unlockedLocations, isNot(same(data.unlockedLocations)));
      expect(updated.completedMissions, isNot(same(data.completedMissions)));
    });

    test('toJson / fromJson serializam corretamente', () {
      final original = PlayerData.defaultData().copyWith(
        playerName: 'Lucas',
        coins: 25,
        stars: 5,
        inventory: ['bolo', 'remedio'],
        completedMissions: ['t1_bem_vindo'],
      );

      final json = original.toJson();
      final restored = PlayerData.fromJson(json);

      expect(restored.playerName, original.playerName);
      expect(restored.coins, original.coins);
      expect(restored.stars, original.stars);
      expect(restored.inventory, original.inventory);
      expect(restored.completedMissions, original.completedMissions);
      expect(restored.settings.language, original.settings.language);
    });

    test('fromJson usa defaults para campos nulos', () {
      final restored = PlayerData.fromJson({});

      expect(restored.playerName, 'Jogador');
      expect(restored.coins, 0);
      expect(restored.stars, 0);
      expect(restored.unlockedLocations, ['casa_jogador', 'praca_central']);
    });

    group('inventário', () {
      test('adicionar item via copyWith', () {
        final data = PlayerData.defaultData();
        final updated = data.copyWith(
          inventory: [...data.inventory, 'maca'],
        );

        expect(updated.inventory, contains('maca'));
        expect(updated.inventory.length, 1);
      });

      test('remover item via copyWith', () {
        final data = PlayerData.defaultData().copyWith(
          inventory: ['maca', 'banana', 'laranja'],
        );
        final updated = data.copyWith(
          inventory: data.inventory.where((i) => i != 'banana').toList(),
        );

        expect(updated.inventory, isNot(contains('banana')));
        expect(updated.inventory.length, 2);
      });
    });

    group('missões', () {
      test('completar missão via copyWith', () {
        final data = PlayerData.defaultData();
        final missionId = 't1_bem_vindo';
        final updated = data.copyWith(
          completedMissions: [...data.completedMissions, missionId],
        );

        expect(updated.completedMissions, contains(missionId));
        expect(updated.completedMissions.length, 1);
      });
    });
  });
}
