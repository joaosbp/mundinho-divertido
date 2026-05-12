import 'locations/buildings/centro/padaria.dart';
import 'locations/buildings/centro/prefeitura.dart';
import 'locations/location_manager.dart';
import 'minigames/games/puzzle/organizar_cidade.dart';
import 'minigames/minigame_manager.dart';
import 'missions/definitions/arc1/m1_bolo_vovo_maria.dart';
import 'missions/mission_manager.dart';

/// Registra todos os locais, mini-jogos e missões no startup.
///
/// Chamado uma única vez em [main.dart] após inicialização dos serviços.
void registerAllContent() {
  // ─── Locais ───
  LocationManager()
    ..register(Prefeitura())
    ..register(Padaria());

  // ─── Mini-jogos ───
  MiniGameManager()
    ..register(
      'organizar_cidade',
      () => OrganizarCidadeMiniGame(),
    );

  // ─── Missões ───
  MissionManager()
    ..register(MBoloVovoMaria());
}
