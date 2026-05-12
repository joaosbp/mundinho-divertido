import 'package:flame/components.dart';

import '../models/location_data.dart';

/// Classe base para todos os locais da cidade.
///
/// Cada novo local estende esta classe e registra-se no [LocationManager].
/// Regra de ouro: nunca modificar código existente para adicionar novo local.
abstract class LocationBase {
  final LocationData data;

  LocationBase({required this.data});

  /// Chamado quando o jogador entra no local.
  void onPlayerEnter() {
    // Override em subclasses
  }

  /// Chamado quando o jogador sai do local.
  void onPlayerExit() {
    // Override em subclasses
  }

  /// Chamado a cada update do game loop.
  void update(double dt) {
    // Override em subclasses
  }

  /// Verifica se o local está aberto no horário atual do jogo.
  bool isOpenAt(int gameHour) {
    if (data.operatingHours == null || data.operatingHours == '24h') {
      return true;
    }
    final parts = data.operatingHours!.split('-');
    if (parts.length != 2) return true;
    final open = int.tryParse(parts[0]) ?? 0;
    final close = int.tryParse(parts[1]) ?? 24;
    return gameHour >= open && gameHour < close;
  }
}
