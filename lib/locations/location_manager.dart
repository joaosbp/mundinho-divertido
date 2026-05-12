import 'dart:developer' as developer;

import '../core/services/analytics_service.dart';
import 'location_base.dart';

/// Registro e acesso centralizado a todos os locais do jogo.
///
/// Padrão: singleton. Locais se auto-registram na inicialização.
class LocationManager {
  static final LocationManager _instance = LocationManager._internal();
  factory LocationManager() => _instance;
  LocationManager._internal();

  final Map<String, LocationBase> _locations = {};

  List<LocationBase> get allLocations => List.unmodifiable(_locations.values);
  List<LocationBase> get locationsByDistrict => List.unmodifiable(_locations.values);

  /// Registra um local. Substitui se já existir (hot-reload friendly).
  void register(LocationBase location) {
    _locations[location.data.id] = location;
    developer.log('Location registered: ${location.data.id}');
  }

  /// Busca um local pelo ID.
  LocationBase? get(String id) => _locations[id];

  /// Verifica se o local existe.
  bool has(String id) => _locations.containsKey(id);

  /// Retorna locais de um bairro específico.
  List<LocationBase> getByDistrict(String districtId) {
    return _locations.values
        .where((l) => l.data.districtId == districtId)
        .toList();
  }

  /// Retorna locais desbloqueados por padrão.
  List<LocationBase> get unlockedByDefault {
    return _locations.values.where((l) => l.data.isUnlockedByDefault).toList();
  }

  /// Entra em um local (dispara eventos e callbacks).
  void enter(String locationId) {
    final location = _locations[locationId];
    if (location == null) {
      developer.log('Location not found: $locationId');
      return;
    }
    location.onPlayerEnter();
    AnalyticsService().logLocationEnter(locationId, location.data.districtId);
  }

  /// Sai de um local.
  void exit(String locationId) {
    final location = _locations[locationId];
    location?.onPlayerExit();
  }
}
