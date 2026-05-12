import 'package:flutter_test/flutter_test.dart';
import 'package:mundinho_divertido/core/services/save_service.dart';
import 'package:mundinho_divertido/models/player_data.dart';
import 'package:mundinho_divertido/models/settings_data.dart';

void main() {
  late SaveService service;

  setUp(() {
    service = SaveService();
  });

  group('SaveService - hasSaveData', () {
    test('sem dados retorna false', () {
      expect(service.hasSaveData(), false);
    });
  });

  group('SaveService - playerData / loadPlayerData', () {
    test('sem save retorna defaultData', () {
      final data = service.playerData;
      expect(data.playerName, 'Jogador');
      expect(data.coins, 0);
      expect(data.stars, 0);
    });

    test('loadPlayerData sem save retorna defaultData', () {
      final data = service.loadPlayerData();
      expect(data.playerName, 'Jogador');
      expect(data.inventory, isEmpty);
    });
  });

  group('SaveService - settingsData / loadSettings', () {
    test('sem save retorna defaultData', () {
      final data = service.settingsData;
      expect(data.soundOn, true);
      expect(data.musicOn, true);
      expect(data.language, 'pt');
    });

    test('loadSettings sem save retorna defaultData', () {
      final data = service.loadSettings();
      expect(data.vibrationOn, true);
      expect(data.narrationOn, true);
    });
  });

  group('PlayerData JSON round-trip', () {
    test('save e load via toJson/fromJson', () {
      final original = PlayerData.defaultData().copyWith(
        playerName: 'Maria',
        coins: 100,
        stars: 10,
        inventory: ['maca', 'banana'],
        completedMissions: ['m1'],
      );

      final json = original.toJson();
      final restored = PlayerData.fromJson(json);

      expect(restored.playerName, 'Maria');
      expect(restored.coins, 100);
      expect(restored.stars, 10);
      expect(restored.inventory, ['maca', 'banana']);
      expect(restored.completedMissions, ['m1']);
    });
  });

  group('SettingsData JSON round-trip', () {
    test('save e load via toJson/fromJson', () {
      final original = SettingsData.defaultData().copyWith(
        soundOn: false,
        musicOn: false,
        language: 'en',
        textSizeScale: 1.5,
      );

      final json = original.toJson();
      final restored = SettingsData.fromJson(json);

      expect(restored.soundOn, false);
      expect(restored.musicOn, false);
      expect(restored.language, 'en');
      expect(restored.textSizeScale, 1.5);
    });
  });

  group('deleteSave', () {
    test('não quebra sem inicialização', () async {
      await service.deleteSave();
      expect(service.hasSaveData(), false);
    });
  });

  group('SaveService - auto-save timer', () {
    test('startAutoSave e stopAutoSave não lançam exceção', () {
      final data = PlayerData.defaultData();
      service.startAutoSave(() => data);
      service.stopAutoSave();
    });
  });
}
