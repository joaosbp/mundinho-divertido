# Mundinho Divertido

> **O maior jogo de mundo aberto infantojuvenil do Brasil.** 🎮🇧🇷

Uma cidade viva, expansível e interativa onde crianças e adolescentes exploram, aprendem, criam e se divertem em um universo 100% brasileiro.

---

## 🎯 Sobre

**Mundinho Divertido** é um jogo de mundo aberto inspirado em *The Sims* e *GTA* (sem violência), ensinando cidadania, saúde, educação, meio ambiente e convivência social de forma lúdica.

- **Plataforma:** Android (inicialmente), iOS (futuro)
- **Stack:** Flutter + Flame Engine
- **Modelo:** Grátis por 30 dias, depois R$ 6,90/mês. Zero anúncios. Zero microtransações.
- **Público de referência:** 6-15 anos (ver [PREMISSAS.md](docs/PREMISSAS.md))

---

## 📚 Documentação

A documentação completa do produto está em [`docs/`](docs/):

| Documento | Descrição |
|-----------|-----------|
| [PREMISSAS.md](docs/PREMISSAS.md) | **Constituição do projeto** — premissas, princípios, diretrizes e objetivos |
| [GDD.md](docs/GDD.md) | Game Design Document |
| [CIDADE.md](docs/CIDADE.md) | Catálogo de 60+ locais da cidade |
| [MISSOES.md](docs/MISSOES.md) | Sistema de missões e atividades educativas |
| [ARQUITETURA.md](docs/ARQUITETURA.md) | Arquitetura técnica Flutter+Flame |
| [UX_UI.md](docs/UX_UI.md) | Diretrizes de UX/UI progressivas |
| [MONETIZACAO.md](docs/MONETIZACAO.md) | Estratégia de monetização |
| [ROADMAP.md](docs/ROADMAP.md) | Roadmap de desenvolvimento |
| [VISAO.md](docs/VISAO.md) | Visão de longo prazo (36 meses) |
| [METRICAS.md](docs/METRICAS.md) | **KPIs, analytics e eventos** |
| [LGPD.md](docs/LGPD.md) | **Conformidade LGPD, COPPA e privacidade** |

---

## 🚀 Rodando Localmente

### Requisitos

- Flutter SDK ^3.11.5
- Android SDK (min API 26 / Android 8.0)
- Dart ^3.11.5
- Node.js (para Firebase CLI)
- Conta Google com acesso ao projeto Firebase

### Setup Firebase (Obrigatório)

O app usa Firebase para Analytics e Crashlytics. O arquivo `google-services.json` **não está versionado** por segurança.

#### Primeira vez (setup completo)

```bash
# 1. Instalar Firebase CLI (se ainda não tiver)
npm install -g firebase-tools
firebase login

# 2. Gerar o google-services.json
firebase apps:sdkconfig ANDROID \
  --project mundinho-divertido \
  > android/app/google-services.json

# 3. Verificar se o arquivo foi criado
ls android/app/google-services.json
```

#### Alternativa: se já tem acesso ao projeto

Peça para um membro do time enviar o arquivo `android/app/google-services.json` ou recupere do Firebase Console:
https://console.firebase.google.com/project/mundinho-divertido/settings/general/android

### Comandos

```bash
# Clonar
git clone https://github.com/joaosbp/mundinho-divertido.git
cd mundinho-divertido

# Instalar dependências
flutter pub get

# Rodar no emulador/dispositivo
flutter run

# Rodar testes
flutter test

# Build de release (Android)
flutter build apk --release
```

---

## 🏗️ Estrutura do Projeto

```
lib/
├── main.dart                    # Entry point — init Firebase, serviços, registry
├── registry.dart                # Registro centralizado de locais, minigames, missões
├── core/
│   ├── constants/               # Cores, dimensões, timings
│   ├── services/                # Save, Analytics, Audio
│   └── utils/                   # Helpers
├── models/                      # PlayerData, SettingsData, LocationData
├── engine/
│   ├── mundinho_game.dart       # FlameGame principal
│   ├── camera_controller.dart
│   └── world_map.dart
├── entities/
│   └── player/
│       └── player.dart          # Componente jogável
├── locations/
│   ├── location_base.dart       # Classe base para locais
│   ├── location_manager.dart    # Registro e acesso
│   └── buildings/centro/        # Implementações por bairro
├── minigames/
│   ├── minigame_base.dart
│   ├── minigame_manager.dart
│   └── games/                   # Implementações de minigames
├── missions/
│   ├── mission_base.dart
│   ├── mission_manager.dart
│   └── definitions/             # Missões por arco
├── ui/
│   └── hud/
│       └── main_hud.dart        # Overlay do jogo
└── screens/
    └── menu_screen.dart         # Menu principal

docs/                            # Documentação completa do produto
assets/
├── images/                      # Sprites, backgrounds, UI
└── audio/                       # Músicas e SFX
```

A estrutura completa planejada está em [ARQUITETURA.md](docs/ARQUITETURA.md).

---

## 🧪 Testes

```bash
flutter test
```

---

## 📄 Licença e Privacidade

- **Privacidade:** Ver [LGPD.md](docs/LGPD.md)
- **Dados:** Zero coleta de dados pessoais de crianças. Analytics opt-in, desabilitado por padrão.
- **Anúncios:** Zero anúncios de terceiros.
- **Segurança:** O arquivo `google-services.json` não está versionado. Nunca commite credenciais Firebase.

---

## 👤 Autor

**JV** — CEO Founder  
Assistente: **Jaime** 🤖

---

*Mundinho Divertido © 2026 — Feito com ❤️ no Brasil*
