# Mundinho Divertido — Arquitetura Técnica

> **Versão:** 1.0
> **Stack:** Flutter + Flame Engine
> **Plataforma:** Android (mínimo SDK 26 / Android 8.0)

---

## 🏗️ Visão Arquitetural

O jogo segue uma arquitetura **modular e orientada a componentes**, permitindo:
- Adicionar novos bairros sem tocar no código existente
- Substituir mini-jogos individualmente
- Testar componentes isoladamente
- Performance otimizada para celulares medianos

### Princípios

1. **Separação de concerns:** UI, lógica de jogo, dados e áudio são independentes
2. **Componentização:** cada local, NPC e mini-jogo é um componente autocontido
3. **State management simples:** sem over-engineering, adequado para escopo do jogo
4. **Asset management eficiente:** lazy loading, atlases de textura, áudio comprimido
5. **Offline-first:** tudo funciona sem internet, sync é opcional

---

## 📦 Estrutura de Pastas

```
lib/
├── main.dart                    # Entry point, inicialização
├── app.dart                     # MaterialApp, tema, rotas
│
├── core/                        # Código compartilhado
│   ├── constants/               # Cores, dimensões, tempos
│   │   ├── colors.dart
│   │   ├── dimensions.dart
│   │   └── timings.dart
│   ├── utils/                   # Helpers, extensões
│   │   ├── audio_utils.dart
│   │   ├── math_utils.dart
│   │   └── save_utils.dart
│   └── services/                # Serviços singleton
│       ├── audio_service.dart   # Música e SFX
│       ├── save_service.dart    # Persistência local (SharedPreferences + Hive)
│       ├── analytics_service.dart # Firebase (opt-in)
│       └── ad_service.dart      # Monetização (AdMob)
│
├── engine/                      # Camada sobre Flame
│   ├── mundinho_game.dart       # FlameGame principal
│   ├── camera_controller.dart   # Controle de câmera isométrica/top-down
│   ├── world_map.dart           # Mapa da cidade (grid + objetos)
│   ├── day_night_cycle.dart     # Ciclo dia/noite
│   └── weather_system.dart      # Sistema de clima
│
├── entities/                    # Entidades do jogo
│   ├── player/                  # Personagem jogável
│   │   ├── player.dart
│   │   ├── player_controller.dart
│   │   └── player_customization.dart
│   ├── npcs/                    # NPCs
│   │   ├── npc_base.dart        # Classe base com IA simples
│   │   ├── npc_dialogue.dart    # Sistema de diálogo por ícones
│   │   └── npc_scheduler.dart   # Rotinas diárias
│   └── vehicles/                # Veículos
│       ├── vehicle_base.dart
│       ├── bus.dart
│       └── bicycle.dart
│
├── locations/                   # Locais da cidade (60+)
│   ├── location_base.dart       # Classe base para todos os locais
│   ├── location_manager.dart    # Registro e acesso a locais
│   ├── location_transitions.dart # Entrar/sair de locais
│   ├── interior_scenes/         # Cenas internas
│   │   ├── prefab_store.dart    # Loja genérica
│   │   ├── prefab_office.dart   # Escritório genérico
│   │   └── prefab_outdoor.dart  # Área externa genérica
│   └── buildings/               # Implementações específicas
│       ├── centro/
│       │   ├── prefeitura.dart
│       │   ├── banco.dart
│       │   └── ...
│       ├── vila_saude/
│       ├── mercadao/
│       └── ...
│
├── minigames/                   # Mini-jogos (30+)
│   ├── minigame_base.dart       # Interface/classe base
│   ├── minigame_manager.dart    # Registro e launcher
│   ├── minigame_ui.dart         # UI compartilhada (timer, pontuação)
│   └── games/                   # Implementações
│       ├── puzzle/
│       ├── memory/
│       ├── rhythm/
│       ├── sorting/
│       └── reaction/
│
├── missions/                    # Sistema de missões
│   ├── mission_base.dart
│   ├── mission_manager.dart
│   ├── mission_tracker.dart     # Progresso do jogador
│   ├── mission_ui.dart          # Indicadores no HUD
│   └── definitions/             # Definições de missões
│       ├── arc1_city_awakens.dart
│       ├── arc2_flavor_tradition.dart
│       └── ...
│
├── ui/                          # Interface do usuário
│   ├── hud/
│   │   ├── main_hud.dart        # HUD principal
│   │   ├── minimap.dart
│   │   ├── inventory_bar.dart
│   │   └── energy_bar.dart
│   ├── menus/
│   │   ├── main_menu.dart
│   │   ├── pause_menu.dart
│   │   ├── settings_menu.dart
│   │   └── parent_dashboard.dart
│   ├── dialogs/
│   │   ├── npc_dialogue.dart
│   │   ├── reward_dialog.dart
│   │   └── confirm_dialog.dart
│   └── overlays/
│       ├── loading_overlay.dart
│       ├── tutorial_overlay.dart
│       └── transition_overlay.dart
│
├── customization/               # Personalização
│   ├── avatar/
│   │   ├── avatar_parts.dart    # Partes do corpo
│   │   ├── avatar_renderer.dart
│   │   └── wardrobe.dart        # Roupas desbloqueadas
│   └── house/                   # (FUTURO) Decoração da casa
│
├── collections/                 # Sistema de coleções
│   ├── sticker_album.dart
│   ├── sticker_definitions.dart # 60 figurinhas
│   ├── recipe_book.dart
│   └── achievements.dart
│
├── models/                      # Modelos de dados
│   ├── player_data.dart         # Dados salvos do jogador
│   ├── location_data.dart
│   ├── npc_data.dart
│   └── settings_data.dart
│
└── assets/                      # Referências a assets (não os arquivos)
    ├── asset_paths.dart
    └── asset_preloader.dart

assets/
├── images/
│   ├── ui/                      # Botões, ícones, HUD
│   ├── characters/              # Sprites de personagens
│   │   ├── player/
│   │   └── npcs/
│   ├── buildings/               # Prédios (exterior)
│   ├── interiors/               # Cenas internas
│   ├── props/                   # Objetos interativos
│   ├── effects/                 # Partículas, brilhos
│   └── backgrounds/             # Céu, fundos
├── audio/
│   ├── music/                   # Músicas por bairro
│   ├── sfx/                     # Efeitos sonoros
│   └── ambience/                # Sons de ambiente
├── fonts/
└── data/
    ├── locations.json           # Definições de locais
    ├── npcs.json                # Definições de NPCs
    ├── missions.json            # Definições de missões
    └── dialogues.json           # Diálogos por ícones
```

---

## 🔧 Stack Tecnológico

| Camada | Tecnologia | Versão | Motivo |
|--------|-----------|--------|--------|
| **Framework** | Flutter | 3.41.9+ | UI nativa, hot reload, performance |
| **Game Engine** | Flame | ^1.28.0 | 2D games em Flutter, componentes, física leve |
| **Áudio** | Flame Audio | ^2.11.0 | Gerenciamento de música e SFX |
| **Persistência** | Hive + SharedPreferences | latest | Local, rápido, sem SQL |
| **Fontes** | Google Fonts | ^6.2.1 | Fredoka (infantil) e outras |
| **Anúncios** | google_mobile_ads | latest | AdMob para monetização |
| **Analytics** | firebase_analytics | latest | Métricas de uso (opt-in) |
| **State** | ValueNotifier / Riverpod | - | Simples, sem overhead |

---

## 🎮 Padrões de Código

### Componente de Local (Exemplo)

```dart
// lib/locations/buildings/centro/prefeitura.dart

class Prefeitura extends LocationBase {
  Prefeitura() : super(
    id: 'prefeitura',
    name: 'Prefeitura',
    district: District.centro,
    exteriorSprite: 'buildings/prefeitura.png',
    interiorScene: 'interiors/prefeitura_interior.png',
    operatingHours: TimeRange(8, 18),
    npcIds: ['prefeito_tico', 'secretaria_ana'],
    miniGames: ['organizar_cidade'],
  );

  @override
  void onPlayerEnter(Player player) {
    super.onPlayerEnter(player);
    AudioService.playAmbience('prefeitura_ambience');
  }

  @override
  void onPlayerExit(Player player) {
    AudioService.stopAmbience();
    super.onPlayerExit(player);
  }
}
```

### Mini-Jogo (Exemplo)

```dart
// lib/minigames/games/puzzle/organizar_cidade.dart

class OrganizarCidadeMiniGame extends MiniGameBase {
  OrganizarCidadeMiniGame() : super(
    id: 'organizar_cidade',
    name: 'Organizar a Cidade',
    duration: Duration(minutes: 3),
    targetAge: AgeRange(4, 8),
    skills: [Skill.categorization, Skill.spatialReasoning],
  );

  @override
  void onStart() {
    // Spawn elementos arrastáveis
    // Configurar zonas de drop
  }

  @override
  MiniGameResult onComplete() {
    final score = calculateScore();
    return MiniGameResult(
      stars: score.toStars(),
      coins: score.toCoins(),
      message: 'Parabéns! A cidade está organizada!',
    );
  }
}
```

### Missão (Exemplo)

```dart
// lib/missions/definitions/arc1/m1_bolo_vovo_maria.dart

class MBoloVovoMaria extends MissionBase {
  MBoloVovoMaria() : super(
    id: 'M1',
    title: 'O Bolo da Vovó Maria',
    arc: Arc.cityAwakens,
    steps: [
      MissionStep(
        id: 'M1_S1',
        description: 'Ir ao Mercadão',
        targetLocation: 'mercadao',
        miniGame: 'lista_compras',
      ),
      MissionStep(
        id: 'M1_S2',
        description: 'Ir à Padaria',
        targetLocation: 'padaria',
        miniGame: 'padeiro_mirim',
      ),
      // ...
    ],
    rewards: [
      Reward.stars(1),
      Reward.coins(15),
      Reward.item('chapeu_chef'),
    ],
  );
}
```

---

## 💾 Persistência de Dados

### Estratégia: Offline-First

```
┌─────────────────┐
│   Memória RAM   │ ← Durante gameplay (estado ativo)
└────────┬────────┘
         │
┌────────▼────────┐
│  Hive (local)   │ ← Save principal (rápido, binário)
│  • player_data  │
│  • progress     │
│  • settings     │
└────────┬────────┘
         │
┌────────▼────────┐
│  SharedPrefs    │ ← Configurações simples
│  • first_run    │
│  • sound_on     │
│  • language     │
└─────────────────┘
         │
┌────────▼────────┐     ┌─────────────────┐
│  Firebase (cloud)│────→│  Backup remoto  │ ← Quando online
│  (opt-in)       │     │  (se habilitado)│
└─────────────────┘     └─────────────────┘
```

### Modelo de Dados Salvos

```dart
@HiveType(typeId: 0)
class PlayerData extends HiveObject {
  @HiveField(0)
  String playerName;

  @HiveField(1)
  AvatarData avatar;

  @HiveField(2)
  int coins;

  @HiveField(3)
  int stars;

  @HiveField(4)
  List<String> unlockedLocations;

  @HiveField(5)
  List<String> completedMissions;

  @HiveField(6)
  List<String> collectedStickers;

  @HiveField(7)
  Map<String, int> miniGameHighScores;

  @HiveField(8)
  DateTime lastPlayed;

  @HiveField(9)
  int totalPlayTimeMinutes;

  @HiveField(10)
  Map<String, int> npcFriendship;
}
```

---

## 🎯 Performance: Otimizações para Celulares Medianos

### Metas de Performance

| Métrica | Meta | Mínimo Aceitável |
|---------|------|-----------------|
| FPS | 60 | 30 |
| Tempo de inicialização | < 3s | < 5s |
| Uso de RAM | < 200MB | < 300MB |
| Tamanho do APK | < 100MB | < 150MB |
| Bateria | Não aquecer | - |

### Otimizações Implementadas

1. **Texture Atlases**
   - Sprites agrupados em atlases (máx 2048x2048)
   - Reduz draw calls de 200+ para ~20

2. **Lazy Loading**
   - Bairros carregados sob demanda
   - Assets descarregados quando não visíveis

3. **Object Pooling**
   - Partículas, NPCs, objetos reutilizados
   - Evita garbage collection frequente

4. **Áudio Streaming**
   - Músicas em streaming (não carregadas inteiras)
   - SFX pré-carregados (pequenos)

5. **Resolução Adaptativa**
   - Sprites em múltiplas resoluções (1x, 1.5x, 2x)
   - Escolha automática baseada no dispositivo

6. **Culling**
   - Não renderizar objetos fora da tela
   - NPCs "dormem" quando longe do jogador

7. **Compilação AOT**
   - Flutter AOT para performance nativa
   - Sem JIT em release

---

## 🔌 Extensibilidade: Como Adicionar Conteúdo

### Adicionar um Novo Local

```dart
// 1. Criar classe
class NovaLoja extends LocationBase { ... }

// 2. Registrar no LocationManager
LocationManager.register(NovaLoja());

// 3. Adicionar assets
// images/buildings/nova_loja.png
// images/interiors/nova_loja_interior.png

// 4. Adicionar ao mapa
// data/locations.json → adicionar entrada

// 5. Pronto! Aparece no jogo automaticamente
```

### Adicionar um Mini-Jogo

```dart
// 1. Criar classe extendendo MiniGameBase
class MeuMiniJogo extends MiniGameBase { ... }

// 2. Registrar no MiniGameManager
MiniGameManager.register('meu_minijogo', () => MeuMiniJogo());

// 3. Associar a um local ou missão
```

### Adicionar uma Missão

```dart
// 1. Criar classe extendendo MissionBase
class M21NovaMissao extends MissionBase { ... }

// 2. Registrar no MissionManager
MissionManager.register(M21NovaMissao());

// 3. Definir gatilho de desbloqueio
```

---

## 🔒 Segurança e Privacidade

> **📋 Documento completo:** [`LGPD.md`](LGPD.md) — conformidade LGPD, COPPA, privacidade e segurança infantil.
> **📊 Documento complementar:** [`METRICAS.md`](METRICAS.md) — analytics opt-in e eventos de privacidade.

### Regras para Jogos Infantis (COPPA / LGPD)

1. **Não coletar:**
   - Nome real da criança
   - Endereço, email, telefone
   - Fotos da criança
   - Localização precisa
   - ID de advertising (GAID/IDFA)

2. **Coleta permitida (anônima, opt-in):**
   - Estatísticas de gameplay (tempo, missões completadas)
   - Crash reports
   - Modelo do dispositivo (para otimização)
   - **Analytics desabilitado por padrão** — exige consentimento verificável dos pais

3. **Consentimento dos pais:**
   - Painel "Para Mães e Pais" requer senha
   - Tela de consentimento no primeiro launch
   - Analytics e crash reporting desabilitados por padrão
   - Revogação possível a qualquer momento no painel

4. **Armazenamento:**
   - Tudo local no dispositivo (padrão)
   - Sem conta obrigatória
   - Sem servidor de backend para gameplay
   - Sync em nuvem apenas se habilitado pelo responsável (futuro)

---

## 🧪 Testes

### Estratégia de Testes

| Tipo | Ferramenta | Cobertura |
|------|-----------|-----------|
| Unit tests | flutter_test | Models, utils, lógica pura |
| Widget tests | flutter_test | UI components, menus |
| Integration | flutter_driver | Fluxos completos de missão |
| Performance | flutter_devtools | FPS, memória, startup |
| Manual | - | UX com crianças reais |

### Cenários de Teste Críticos

- [ ] Inicialização limpa (first run)
- [ ] Continuar jogo salvo
- [ ] Completar missão do início ao fim
- [ ] Jogar 5 mini-jogos seguidos sem crash
- [ ] Alternar entre 10 locais rapidamente
- [ ] Jogar por 30 minutos (teste de memória)
- [ ] Receber ligação durante o jogo (pausar/resumir)
- [ ] Dispositivo com pouca bateria (modo economia)

---

## 📱 Configuração de Build

### Android (app/build.gradle)

```gradle
android {
    compileSdkVersion 36
    
    defaultConfig {
        applicationId "com.joaosbp.mundinho_divertido"
        minSdkVersion 26  // Android 8.0
        targetSdkVersion 36
        versionCode 1
        versionName "1.0.0"
    }
    
    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt')
        }
    }
}
```

---

*Arquitetura viva — evoluir conforme o jogo cresce.*
