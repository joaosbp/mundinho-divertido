import 'locations/buildings/centro/casa_jogador.dart';
import 'locations/buildings/centro/escola.dart';
import 'locations/buildings/centro/mercadao.dart';
import 'locations/buildings/centro/parque_central.dart';
import 'locations/buildings/centro/padaria.dart';
import 'locations/buildings/centro/prefeitura.dart';
import 'locations/location_manager.dart';
import 'minigames/games/creative/pintura_livre.dart';
import 'minigames/games/math/matematica_lousa.dart';
import 'minigames/games/memory/lista_compras.dart';
import 'minigames/games/puzzle/alfabeto_colorido.dart';
import 'minigames/games/puzzle/organizar_cidade.dart';
import 'minigames/games/sequence/padeiro_mirim.dart';
import 'minigames/minigame_manager.dart';
import 'missions/definitions/arc1/m1_bolo_vovo_maria.dart';
import 'missions/definitions/arc1/t1_bem_vindo.dart';
import 'missions/mission_manager.dart';

/// Registra todos os locais, mini-jogos e missões no startup.
///
/// Chamado uma única vez em [main.dart] após inicialização dos serviços.
void registerAllContent() {
  // ─── Locais ───
  LocationManager()
    ..register(CasaJogador())
    ..register(ParqueCentral())
    ..register(Prefeitura())
    ..register(Padaria())
    ..register(Mercadao())
    ..register(Escola());

  // ─── Mini-jogos ───
  MiniGameManager()
    ..register(
      'organizar_cidade',
      () => OrganizarCidadeMiniGame(),
    )
    ..register(
      'lista_compras',
      () => ListaComprasMiniGame(),
    )
    ..register(
      'padeiro_mirim',
      () => PadeiroMirimMiniGame(),
    )
    ..register(
      'matematica_lousa',
      () => MatematicaLousaMiniGame(),
    )
    ..register(
      'alfabeto_colorido',
      () => AlfabetoColoridoMiniGame(),
    )
    ..register(
      'pintura_livre',
      () => PinturaLivreMiniGame(),
    );

  // ─── Missões ───
  MissionManager()
    ..register(TBemVindo())
    ..register(MBoloVovoMaria());
}
