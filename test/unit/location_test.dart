import 'package:flutter_test/flutter_test.dart';
import 'package:mundinho_divertido/locations/buildings/centro/casa_jogador.dart';
import 'package:mundinho_divertido/locations/buildings/centro/correios.dart';
import 'package:mundinho_divertido/locations/buildings/centro/escola.dart';
import 'package:mundinho_divertido/locations/buildings/centro/farmacia.dart';
import 'package:mundinho_divertido/locations/buildings/centro/mercadao.dart';
import 'package:mundinho_divertido/locations/buildings/centro/parque_central.dart';
import 'package:mundinho_divertido/locations/buildings/centro/padaria.dart';
import 'package:mundinho_divertido/locations/buildings/centro/prefeitura.dart';
import 'package:mundinho_divertido/locations/location_base.dart';
import 'package:mundinho_divertido/locations/location_manager.dart';
import 'package:mundinho_divertido/models/location_data.dart';

void main() {
  group('LocationData', () {
    test('copyWith cria cópia com valores alterados', () {
      const data = LocationData(
        id: 'test',
        name: 'Teste',
        districtId: 'centro',
        description: 'Descrição',
      );

      final updated = data.copyWith(name: 'Novo Nome');
      expect(updated.name, 'Novo Nome');
      expect(updated.id, 'test');
    });

    test('copyWith mantém listas imutáveis', () {
      const data = LocationData(
        id: 'test',
        name: 'Teste',
        districtId: 'centro',
        description: 'Descrição',
        npcIds: ['npc1'],
      );

      final updated = data.copyWith();
      expect(updated.npcIds, isNot(same(data.npcIds)));
    });
  });

  group('LocationBase - propriedades', () {
    final locations = <LocationBase>[
      CasaJogador(),
      ParqueCentral(),
      Prefeitura(),
      Padaria(),
      Mercadao(),
      Escola(),
      Farmacia(),
      Correios(),
    ];

    test('todos os locais têm id não vazio', () {
      for (final location in locations) {
        expect(location.data.id, isNotEmpty,
            reason: 'Location id não pode estar vazio');
      }
    });

    test('todos os locais têm nome não vazio', () {
      for (final location in locations) {
        expect(location.data.name, isNotEmpty,
            reason: 'Location name não pode estar vazio');
      }
    });

    test('todos os locais têm districtId correto', () {
      for (final location in locations) {
        expect(location.data.districtId, 'centro',
            reason: '${location.data.id} deve ter districtId centro');
      }
    });

    test('todos os locais têm descrição não vazia', () {
      for (final location in locations) {
        expect(location.data.description, isNotEmpty,
            reason: '${location.data.id} deve ter descrição');
      }
    });
  });

  group('LocationBase - isUnlockedByDefault', () {
    test('casa_jogador está desbloqueada por padrão', () {
      final location = CasaJogador();
      expect(location.data.isUnlockedByDefault, true);
    });

    test('parque_central está desbloqueada por padrão', () {
      final location = ParqueCentral();
      expect(location.data.isUnlockedByDefault, true);
    });

    test('mercadao está desbloqueada por padrão', () {
      final location = Mercadao();
      expect(location.data.isUnlockedByDefault, true);
    });

    test('padaria está desbloqueada por padrão', () {
      final location = Padaria();
      expect(location.data.isUnlockedByDefault, true);
    });

    test('prefeitura está desbloqueada por padrão', () {
      final location = Prefeitura();
      expect(location.data.isUnlockedByDefault, true);
    });

    test('escola está desbloqueada por padrão', () {
      final location = Escola();
      expect(location.data.isUnlockedByDefault, true);
    });

    test('farmacia está desbloqueada por padrão', () {
      final location = Farmacia();
      expect(location.data.isUnlockedByDefault, true);
    });

    test('correios está desbloqueada por padrão', () {
      final location = Correios();
      expect(location.data.isUnlockedByDefault, true);
    });
  });

  group('LocationBase - isOpenAt', () {
    test('local sem horário sempre aberto', () {
      final location = CasaJogador();
      expect(location.isOpenAt(0), true);
      expect(location.isOpenAt(12), true);
      expect(location.isOpenAt(23), true);
    });

    test('local 24h sempre aberto', () {
      const data = LocationData(
        id: 'test',
        name: 'Teste',
        districtId: 'centro',
        description: 'Teste',
        operatingHours: '24h',
      );
      final location = _TestLocation(data: data);
      expect(location.isOpenAt(3), true);
      expect(location.isOpenAt(15), true);
    });

    test('padaria abre 05h e fecha 20h', () {
      final location = Padaria();
      expect(location.isOpenAt(5), true);
      expect(location.isOpenAt(10), true);
      expect(location.isOpenAt(19), true);
      expect(location.isOpenAt(20), false);
      expect(location.isOpenAt(4), false);
    });

    test('prefeitura abre 08h e fecha 18h', () {
      final location = Prefeitura();
      expect(location.isOpenAt(8), true);
      expect(location.isOpenAt(17), true);
      expect(location.isOpenAt(18), false);
      expect(location.isOpenAt(7), false);
    });

    test('escola abre 07h e fecha 17h', () {
      final location = Escola();
      expect(location.isOpenAt(7), true);
      expect(location.isOpenAt(16), true);
      expect(location.isOpenAt(17), false);
      expect(location.isOpenAt(6), false);
    });
  });

  group('LocationManager', () {
    setUp(() {
      // Limpa registros anteriores (singleton)
      // Não há método clear público, então registramos todos
      final manager = LocationManager();
      manager.register(CasaJogador());
      manager.register(ParqueCentral());
      manager.register(Prefeitura());
      manager.register(Padaria());
      manager.register(Mercadao());
      manager.register(Escola());
      manager.register(Farmacia());
      manager.register(Correios());
    });

    test('registra e busca locais', () {
      final manager = LocationManager();
      expect(manager.get('casa_jogador'), isNotNull);
      expect(manager.get('parque_central'), isNotNull);
      expect(manager.get('inexistente'), isNull);
    });

    test('has verifica existência', () {
      final manager = LocationManager();
      expect(manager.has('casa_jogador'), true);
      expect(manager.has('inexistente'), false);
    });

    test('allLocations retorna 8 locais', () {
      final manager = LocationManager();
      expect(manager.allLocations.length, 8);
    });

    test('getByDistrict retorna locais do centro', () {
      final manager = LocationManager();
      final centro = manager.getByDistrict('centro');
      expect(centro.length, 8);
    });

    test('unlockedByDefault retorna todos os locais', () {
      final manager = LocationManager();
      final unlocked = manager.unlockedByDefault;
      expect(unlocked.length, 8);
    });
  });
}

/// Location de teste para validar isOpenAt.
class _TestLocation extends LocationBase {
  _TestLocation({required super.data});
}
