# Mundinho Divertido — Roadmap de Desenvolvimento

> **Versão:** 2.0
> **Última atualização:** 2026-05-12
> **Paradigma:** Single-dev acelerado por IA (LLMs, coding agents, asset generation)
> **CEO Founder:** JV

---

## 🧠 A Nova Realidade: Desenvolvimento 2026 com IA

> *"Em 2026, 1 desenvolvedor com IA equivale a 3-5 desenvolvedores de 2020. Não pela substituição humana, mas pela aceleração de iteração, geração de código, debugging e prototipagem."*

### Ferramentas de IA no Workflow

| Ferramenta | Função | Ganho de Produtividade |
|------------|--------|----------------------|
| **LLM (Kimi/GPT/Claude)** | Geração de código, arquitetura, refactoring, debugging | 3-5x em tarefas de código |
| **Coding Agents (Codex, Kimi CLI)** | Implementação de features inteiras, testes, documentação | 2-4x em velocidade de entrega |
| **AI Image Generation** | Concept art, placeholders, texturas, ícones | 10x mais rápido que arte manual para protótipos |
| **AI Music/SFX** | Geração de música ambiente, efeitos sonoros placeholders | 5x mais rápido |
| **Copilot / Code Completion** | Autocomplete inteligente, sugestões de padrões | 1.5x no dia a dia |

### Metodologia: AI-Augmented Development

```
┌─────────────────────────────────────────────────────────────┐
│  CICLO DE DESENVOLVIMENTO ACELERADO (1 semana = 2-3 semanas) │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Segunda-feira:                                             │
│  ├─ JV define o que construir esta semana (1-2 features)    │
│  └─ Jaime (IA) gera scaffolding e arquitetura inicial       │
│                                                             │
│  Terça-Quarta:                                              │
│  ├─ Coding agent implementa 70% do código                   │
│  └─ JV revisa, ajusta e completa os 30% restantes          │
│                                                             │
│  Quinta:                                                    │
│  ├─ Testes automáticos + testes manuais no celular         │
│  └─ Jaime gera relatório de bugs e sugestões de fix        │
│                                                             │
│  Sexta:                                                     │
│  ├─ Polimento e merge                                      │
│  └─ Playtest com crianças (se possível)                    │
│                                                             │
│  Fim de semana:                                             │
│  ├─ Jaime documenta o que foi feito                        │
│  └─ JV descansa ou explora ideias para próxima semana      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Por Que Isso Muda Tudo?

| Aspecto | Era Pré-IA (2020) | Era IA (2026) |
|---------|------------------|---------------|
| Prototipar menu principal | 3-5 dias | 4-8 horas |
| Implementar mini-jogo | 1-2 semanas | 2-4 dias |
| Gerar assets placeholder | 1 semana (artista) | 2-4 horas (IA) |
| Debugar crash | 1-2 dias | 2-6 horas (IA analisa logs) |
| Documentar feature | 1 dia | 30 min (IA gera draft) |
| Refatorar código legado | 1 semana | 1-2 dias |
| **1 dev produz equivalente a** | **1 dev** | **3-5 devs** |

---

## 🗓️ Roadmap Detalhado

### FASE 0: Fundação AI-Nativa (Semanas 1-2)

> *"Antes de código, construir a máquina de desenvolvimento."*

| Semana | Tarefas | Entregável |
|--------|---------|------------|
| **S1** | Setup Flutter + Flame + CI/CD. Configurar coding agents. Criar templates de código (LocationBase, MiniGameBase, MissionBase). Pipeline de build automatizado. | Ambiente de dev pronto, 1 comando para build |
| **S2** | Implementar arquitetura base: GameLoop, Camera, Player controller, Save system (Hive). Criar sistema de plugin para locais. Testar em 3 dispositivos Android. | APK base rodando, personagem anda em tela vazia |

**Meta:** Foundation sólida que permite adicionar locais em horas, não dias.

---

### FASE 1: MVP — O Primeiro Bairro (Semanas 3-6)

> *"Um bairro perfeito vale mais que oito bairros medianos."*

**Escopo do MVP:**
- 1 bairro: **Centro**
- 8 locais: Prefeitura, Mercado, Padaria, Farmácia, Correios, Escola, Parque, Casa do Jogador
- 5 NPCs: Prefeito Tico, Dona Rosa, Tia Júlia, Dr. Pipo, Seu João
- 5 mini-jogos: Caça ao tesouro, Padeiro, Lista de compras, Escovação, Plantar
- 5 missões principais (3-5 passos cada)
- 3 missões diárias (rotativas)
- Avatar customizável (10 roupas, 5 acessórios)
- Save/load, som básico, menu, HUD

| Semana | Tarefas |
|--------|---------|
| **S3** | Implementar 4 locais (Casa, Parque, Mercado, Padaria) + NPCs + mini-jogos |
| **S4** | Implementar 4 locais (Prefeitura, Escola, Farmácia, Correios) + missões |
| **S5** | Integração: missões, recompensas, progressão, UI polida |
| **S6** | Testes, otimização, build de release interno, playtest com 3+ crianças |

**Entregável:**
```
📦 mundinho-divertido-v0.5-mvp.apk
├── 1 bairro completo e polido
├── 8 locais interativos
├── 5 missões principais
├── 5 mini-jogos
├── 5 NPCs com rotinas
├── Avatar customizável
├── Menu, HUD, settings
├── Zero bugs críticos
└── APK < 50MB
```

**Meta de Qualidade:** Criança de 6 anos sorri em 30 segundos e joga por 10 minutos sem pedir ajuda.

---

### FASE 2: Alpha — Expansão Inicial (Semanas 7-10)

> *"Adicionar conteúdo usando a arquitetura já validada."*

**Escopo:**
- +2 bairros: Mercadão, Parque da Cidade (formalizando o que já existe)
- +10 locais (total: 18)
- +5 NPCs (total: 10)
- +5 mini-jogos (total: 10)
- +5 missões principais (total: 10)
- Ciclo dia/noite básico
- Clima básico (sol/chuva)
- Sistema de coleções (figurinhas, adesivos)

| Semana | Tarefas |
|--------|---------|
| **S7** | Implementar dia/noite + clima. Adicionar 3 locais novos. |
| **S8** | Adicionar 7 locais novos. Implementar sistema de coleções. |
| **S9** | Missões novas, NPCs novos, mini-jogos novos. Integração. |
| **S10** | Testes, otimização, feedback de playtesters. |

**Entregável:** Alpha testável com 18 locais, 10 missões.

---

### FASE 3: Beta — Conteúdo Rico (Semanas 11-16)

> *"O jogo já é divertido. Agora é torná-lo irresistível."*

**Escopo:**
- +3 bairros: Vila Saúde, Bairro Escola, Bombeiros & Cia
- +15 locais (total: 33)
- +10 NPCs (total: 20)
- +10 mini-jogos (total: 20)
- +10 missões principais (total: 20)
- Eventos sazonais (Natal, Páscoa)
- Música por bairro
- SFX completos
- UI/UX polida

| Semana | Tarefas |
|--------|---------|
| **S11-S12** | 3 bairros novos + locais + NPCs |
| **S13-S14** | Mini-jogos, missões, eventos sazonais |
| **S15** | Áudio final, polimento UX, acessibilidade |
| **S16** | Beta fechado com 20+ usuários, coleta de feedback |

**Entregável:** Beta completo, pronto para soft launch.

---

### FASE 4: Monetização e Soft Launch (Semanas 17-20)

> *"Construir a máquina de receita enquanto ainda é pequeno."*
> **📊 Métricas:** Ver [`METRICAS.md`](METRICAS.md) — KPIs e eventos de monetização.
> **🔒 Conformidade:** Ver [`LGPD.md`](LGPD.md) — tela de consentimento, privacidade e COPPA.

**Escopo:**
- Implementar subscription (Google Play Billing)
- 30 dias grátis
- Painel dos pais completo
- Analytics (Firebase, **opt-in, desabilitado por padrão**)
- Crash reporting (**opt-in**)
- ASO (App Store Optimization)
- Tela de consentimento parental (LGPD/COPPA)
- Soft launch em mercado secundário (Portugal ou pequena cidade BR)

| Semana | Tarefas |
|--------|---------|
| **S17** | Billing, subscription, trial flow |
| **S18** | Analytics, crash reporting, painel dos pais |
| **S19** | ASO, screenshots, descrição, vídeo de trailer |
| **S20** | Soft launch + métricas + ajustes |

---

### FASE 5: Launch Nacional (Semanas 21-24)

> *"O grande dia."*

**Escopo:**
- Lançamento na Google Play Store Brasil
- Campanha de lançamento (redes sociais, influencers pequenos)
- Suporte ativo (responder reviews, corrigir bugs urgentes)
- Primeiro evento sazonal (Dia das Crianças ou Natal)

| Semana | Tarefas |
|--------|---------|
| **S21** | Final build, assinatura, upload na Play Store |
| **S22** | Lançamento! Monitoramento 24/7 |
| **S23** | Primeira atualização (hotfixes + ajustes) |
| **S24** | Primeiro evento sazonal + análise de métricas |

---

### FASE 6+: Pós-Launch e Expansões (Mês 7+)

| Período | Meta |
|---------|------|
| **Mês 7-9** | Manutenção, bug fixes, 2 novos bairros, primeiro evento sazonal grande |
| **Mês 10-12** | 2 novos bairros, multiplayer local (beta), plano Família |
| **Ano 2** | iOS, 4 novos bairros (Praia, Serra, Tecnologia, Artes), UGC leve |
| **Ano 3** | Realidade Aumentada (AR), merchandising, série animada |

---

## 📊 Timeline Visual

```
2026
MAI    JUN    JUL    AGO    SET    OUT    NOV    DEZ
│      │      │      │      │      │      │      │
├──────┤      │      │      │      │      │      │
│ F0   │      │      │      │      │      │      │  Foundation
├──────┼──────┤      │      │      │      │      │
│      │ F1   │      │      │      │      │      │  MVP
│      ├──────┼──────┤      │      │      │      │
│      │      │ F2   │      │      │      │      │  Alpha
│      │      ├──────┼──────┤      │      │      │
│      │      │      │ F3   │      │      │      │  Beta
│      │      │      ├──────┼──────┼──────┤      │
│      │      │      │      │ F4   │      │      │  Monetização
│      │      │      │      ├──────┼──────┤      │
│      │      │      │      │      │ F5   │      │  Launch!
│      │      │      │      │      ├──────┼──────┤
│      │      │      │      │      │      │ F6+  │  Expansões

Legendas:
  F0 = Foundation (2 semanas)
  F1 = MVP (4 semanas)
  F2 = Alpha (4 semanas)
  F3 = Beta (6 semanas)
  F4 = Monetização (4 semanas)
  F5 = Launch (4 semanas)
  F6+ = Pós-launch contínuo
```

---

## 👥 Recursos e Ferramentas

### Equipe (Single-Dev + IA)

| Papel | Quem | Ferramentas |
|-------|------|-------------|
| **CEO / Product Owner** | JV | Documentação, decisões, playtests |
| **Desenvolvedor Principal** | JV + Coding Agents (Kimi, Codex) | Flutter, Flame, VS Code, Git |
| **Arquiteto de Software** | Jaime (IA) | Design patterns, refactoring, reviews |
| **Artista 2D** | JV + AI Image Gen (Midjourney/Stable Diffusion/DALL-E) | Concept art, placeholders, texturas |
| **Compositor** | AI Music Gen + Freelancer (final) | Música ambiente, SFX |
| **QA / Tester** | JV + Crianças reais | Testes manuais, playtests |
| **Copywriter / Tradutor** | Jaime (IA) | Textos, diálogos, descrições |

### Stack Tecnológico de IA

```
Desenvolvimento:
├── Coding: Kimi Code, Claude Code, GitHub Copilot
├── Arquitetura: GPT-5 / Kimi K2.5 (análise de design)
├── Debug: AI log analyzer, stack trace interpreter
└── Test: AI-generated test cases

Arte:
├── Concept: Midjourney v7, DALL-E 4, Stable Diffusion 3
├── Sprite sheets: AI sprite generators + manual cleanup
├── UI/UX: Figma AI, Galileo AI
└── Animation: AI-assisted tweening, procedural animation

Áudio:
├── Music: Suno v4, Udio, AIVA
├── SFX: ElevenLabs SoundFX, AI SFX generators
└── Voice: ElevenLabs TTS (narração opcional)

Marketing:
├── ASO: AI keyword optimizer
├── Copy: GPT-5 (descrições, posts)
├── Trailer: AI video editing (Runway, Pika)
└── Analytics: AI insights (Firebase + custom)
```

---

## 📊 Metas de Qualidade por Fase

| Fase | FPS | APK | RAM | Tempo Sessão | Bugs Críticos |
|------|-----|-----|-----|--------------|---------------|
| Foundation | 60 | < 20MB | < 100MB | — | 0 |
| MVP | 60 | < 50MB | < 150MB | > 5 min | 0 |
| Alpha | 60 | < 70MB | < 180MB | > 8 min | 0 |
| Beta | 60 | < 100MB | < 200MB | > 10 min | 0 |
| Launch | 60 | < 100MB | < 200MB | > 12 min | 0 |

---

## 🎯 Ritmo de Desenvolvimento

> *"Consistência vence intensidade. 1 feature por semana bem feita > 5 features mal feitas."*

### Ritmo Semanal Ideal

| Dia | Foco |
|-----|------|
| **Segunda** | Planejamento + scaffolding (IA gera base) |
| **Terça** | Implementação core (JV + coding agent) |
| **Quarta** | Implementação + integração |
| **Quinta** | Testes + polimento + bug fixes |
| **Sexta** | Playtest + documentação + deploy interno |
| **Sábado** | Exploração criativa (ideias, protótipos) |
| **Domingo** | Descanso |

### Velocity Esperada (com IA)

| Entregável | Tempo Pré-IA | Tempo com IA |
|------------|-------------|--------------|
| 1 novo local | 3-5 dias | 1-2 dias |
| 1 novo NPC | 2-3 dias | 4-8 horas |
| 1 novo mini-jogo | 5-7 dias | 2-3 dias |
| 1 nova missão | 2-3 dias | 6-12 horas |
| 1 novo bairro (8 locais) | 1-2 meses | 2-3 semanas |
| Build de release | 1 dia | 2-4 horas |

---

## 📝 Notas Finais

1. **Este roadmap assume 20-30h/semana de desenvolvimento focado.**
2. **Ferramentas de IA são multiplicadores, não substitutos.** JV decide, ajusta e dá o toque humano.
3. **Playtests são sagrados.** A cada 2 semanas, 2-3 crianças testam o jogo por 15 minutos.
4. **Documentação viva.** Atualizar este roadmap mensalmente com progresso real.
5. **Escopo é o inimigo.** Cortar sem piedade. Adicionar só quando o core estiver impecável.

---

*"Em 2026, não compete quem tem mais devs. Compete quem usa IA com mais inteligência."*
