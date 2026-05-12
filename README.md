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
├── main.dart              # Entry point
├── game/
│   └── mundinho_game.dart # FlameGame principal
└── screens/
    └── menu_screen.dart   # Menu principal

docs/                      # Documentação do produto
assets/
├── images/                # Sprites, backgrounds, UI
└── audio/                 # Músicas e SFX
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

---

## 👤 Autor

**JV** — CEO Founder  
Assistente: **Jaime** 🤖

---

*Mundinho Divertido © 2026 — Feito com ❤️ no Brasil*
