# Mundinho Divertido — Roadmap de Desenvolvimento

> **Versão:** 1.0
> **Última atualização:** 2026-05-11
> **Estimativa total:** 8-12 meses para MVP completo

---

## 🗓️ Visão Geral

```
FASE 1 ──────► FASE 2 ──────► FASE 3 ──────► FASE 4 ──────► FASE 5
  (Mês 1-2)     (Mês 3-4)      (Mês 5-6)      (Mês 7-9)      (Mês 10-12)
  
PROTÓTIPO    CORE GAME      CONTEÚDO      POLIMENTO      LANÇAMENTO
  │            │             │              │               │
  ▼            ▼             ▼              ▼               ▼
Menu +        Mundo         60 locais      Anúncios        Google Play
1 mini-jogo   aberto        Missões        Monetização     Marketing
Placeholder   + 3 bairros   20 missões     Testes beta     Expansões
              + movimento   + NPCs         Otimização      Pós-launch
```

---

## 🚧 FASE 1: Protótipo e Fundação (Semanas 1-4)

### Objetivo
Ter um executável rodando no celular com:
- Menu funcional
- Personagem andando em um ambiente
- 1 mini-jogo jogável
- Placeholder de assets (formas geométricas + cores)

### Tarefas

| # | Tarefa | Responsável | Status |
|---|--------|-------------|--------|
| 1.1 | Setup completo do projeto Flutter + Flame | Dev | ✅ |
| 1.2 | Implementar menu principal | Dev | ⬜ |
| 1.3 | Implementar tela de jogo base (mundo vazio) | Dev | ⬜ |
| 1.4 | Personagem andando (toque no chão) | Dev | ⬜ |
| 1.5 | Câmera seguindo personagem | Dev | ⬜ |
| 1.6 | 1 mini-jogo funcional (ex: caça ao tesouro) | Dev | ⬜ |
| 1.7 | Sistema de save/load básico | Dev | ⬜ |
| 1.8 | Testar em celular Android real | Dev | ⬜ |

### Entregável
```
📦 mundinho-divertido-prototype-v0.1.apk
├── Menu funcional
├── Personagem andando em grid
├── 1 mini-jogo (3 minutos)
└── Save/Load funcionando
```

---

## 🎨 FASE 2: Core Game e Arte Base (Semanas 5-8)

### Objetivo
Implementar a "espinha dorsal" do jogo:
- Mundo aberto com 3 bairros
- Sistema de locais (entrar/sair)
- 5 NPCs básicos
- Sistema de missões (estrutura)
- Placeholder de arte melhorado (provisório mas colorido)

### Tarefas

| # | Tarefa | Semana |
|---|--------|--------|
| 2.1 | Implementar sistema de locais (LocationBase) | 5 |
| 2.2 | Implementar 3 bairros (Centro, Mercadão, Parque) | 5-6 |
| 2.3 | Implementar 10 locais interativos | 6 |
| 2.4 | Implementar sistema de NPCs (IA simples, rotinas) | 6-7 |
| 2.5 | Criar 5 NPCs com diálogos por ícones | 7 |
| 2.6 | Implementar sistema de missões (estrutura + tracking) | 7-8 |
| 2.7 | Implementar 3 missões de tutorial | 8 |
| 2.8 | Implementar HUD (moedas, estrelas, energia) | 8 |
| 2.9 | Arte placeholder colorida (formas → sprites simples) | 5-8 |
| 2.10 | Música e SFX placeholder | 8 |

### Entregável
```
📦 mundinho-divertido-alpha-v0.3.apk
├── 3 bairros exploráveis
├── 10 locais interativos
├── 5 NPCs com rotinas
├── 3 missões de tutorial
├── HUD completo
└── Save/Load robusto
```

---

## 🏗️ FASE 3: Conteúdo Completo (Semanas 9-16)

### Objetivo
Preencher o jogo com todo o conteúdo planejado:
- 8 bairros, 60 locais
- 20 missões principais
- 30 mini-jogos
- 20 NPCs
- Arte final (sprites, backgrounds, UI)
- Áudio final (músicas, SFX, vozes)

### Tarefas

| # | Tarefa | Semana |
|---|--------|--------|
| 3.1 | Implementar todos os 8 bairros | 9-10 |
| 3.2 | Implementar todos os 60 locais | 10-12 |
| 3.3 | Criar todos os 20 NPCs | 11-13 |
| 3.4 | Implementar sistema de mini-jogos (framework) | 9 |
| 3.5 | Implementar 30 mini-jogos | 12-14 |
| 3.6 | Implementar 20 missões principais | 13-15 |
| 3.7 | Implementar missões diárias | 15 |
| 3.8 | Implementar eventos sazonais (estrutura) | 15 |
| 3.9 | Arte final: personagens | 9-13 |
| 3.10 | Arte final: prédios e cenários | 11-14 |
| 3.11 | Arte final: UI e ícones | 13-14 |
| 3.12 | Música final (1 por bairro) | 12-14 |
| 3.13 | SFX completos | 14-15 |
| 3.14 | Sistema de coleções (figurinhas, adesivos) | 15 |
| 3.15 | Customização de avatar | 15-16 |

### Entregável
```
📦 mundinho-divertido-beta-v0.8.apk
├── 8 bairros, 60 locais
├── 20 NPCs com rotinas e diálogos
├── 20 missões principais
├── 30 mini-jogos
├── 3 missões diárias
├── Sistema de coleções
├── Customização de avatar
├── Arte e áudio finais
└── Eventos sazonais (estrutura)
```

---

## 🔧 FASE 4: Polimento e Monetização (Semanas 17-24)

### Objetivo
Transformar o beta em produto final:
- Monetização (anúncios + remove ads)
- Otimização de performance
- Testes extensivos
- Painel dos pais
- Acessibilidade
- Bug fixes

### Tarefas

| # | Tarefa | Semana |
|---|--------|--------|
| 4.1 | Integrar AdMob (banner + interstitial) | 17 |
| 4.2 | Implementar compra "Remove Ads" (Google Play Billing) | 17-18 |
| 4.3 | Implementar painel "Para Mães e Pais" | 18 |
| 4.4 | Otimização de performance (FPS, memória, bateria) | 18-19 |
| 4.5 | Testes em múltiplos dispositivos Android | 19-20 |
| 4.6 | Testes com crianças reais (playtest) | 20 |
| 4.7 | Acessibilidade (cores, tamanho, velocidade) | 20-21 |
| 4.8 | Tutorial integrado (Tia Júlia) | 21 |
| 4.9 | Tradução e revisão de textos | 21 |
| 4.10 | Preparação de assets para loja (screenshots, ícone, descrição) | 22 |
| 4.11 | Polimento de UX (animações, transições, feedback) | 22-23 |
| 4.12 | Últimos bug fixes | 23-24 |
| 4.13 | Build de release + assinatura | 24 |

### Entregável
```
📦 mundinho-divertido-release-v1.0.apk
├── Jogo completo e polido
├── Monetização implementada
├── Performance otimizada
├── Testado em 5+ dispositivos
├── Assets de loja prontos
└── Pronto para publicação
```

---

## 🚀 FASE 5: Lançamento e Pós-Launch (Semanas 25+)

### Semana 25: Lançamento
- [ ] Publicar na Google Play Store
- [ ] ASO (App Store Optimization)
- [ ] Anúncio nas redes sociais
- [ ] Enviar para blogueiros/YouTubers de apps infantis
- [ ] Monitorar reviews e crash reports

### Mês 4-6: Manutenção
- [ ] Corrigir bugs reportados
- [ ] Responder reviews
- [ ] Ajustar dificuldade baseado em analytics
- [ ] Primeiro evento sazonal (Dia das Crianças / Natal)

### Mês 7-9: Primeira Expansão
- [ ] Desenvolver "Praia do Mundinho"
- [ ] 5-10 novos locais
- [ ] 5 novas missões
- [ ] Lançar como DLC (R$ 3,00)

### Mês 10-12: Crescimento
- [ ] Segunda expansão ("Serra Verde")
- [ ] Sistema de multiplayer local (2 jogadores)
- [ ] Modo foto com filtros
- [ ] Considerar iOS (se houver demanda)

---

## 📊 Cronograma Visual

```
2026
MAI    JUN    JUL    AGO    SET    OUT    NOV    DEZ    2027
│      │      │      │      │      │      │      │      JAN
▼      ▼      ▼      ▼      ▼      ▼      ▼      ▼      ▼
├──────┤      │      │      │      │      │      │      │
│ FASE │      │      │      │      │      │      │      │
│  1   │      │      │      │      │      │      │      │
├──────┼──────┤      │      │      │      │      │      │
│      │ FASE │      │      │      │      │      │      │
│      │  2   │      │      │      │      │      │      │
│      ├──────┼──────┼──────┤      │      │      │      │
│      │      │ FASE │      │      │      │      │      │
│      │      │  3   │      │      │      │      │      │
│      │      ├──────┼──────┼──────┼──────┤      │      │
│      │      │      │      │ FASE │      │      │      │
│      │      │      │      │  4   │      │      │      │
│      │      │      │      ├──────┼──────┼──────┼──────┤
│      │      │      │      │      │      │ FASE │      │
│      │      │      │      │      │      │  5   │      │
│      │      │      │      │      │      ├──────┼──────┼──────►
│      │      │      │      │      │      │ 🚀   │ 🏖️   │ ⛰️
│      │      │      │      │      │      │LANÇ. │PRAIA │SERRA

Legendas:
  🚀 = Lançamento v1.0
  🏖️ = Expansão Praia
  ⛰️ = Expansão Serra
```

---

## 👥 Recursos Necessários

### Equipe Mínima (Projeto Solo / Equipe Pequena)

| Papel | Tempo | Custo Estimado |
|-------|-------|----------------|
| **Desenvolvedor Flutter** | Full-time (8 meses) | R$ 0 (JV) |
| **Artista 2D** | Part-time (4 meses) | R$ 3.000-8.000 (freela) |
| **Compositor/Musico** | Part-time (2 meses) | R$ 1.000-3.000 (freela) |
| **SFX Designer** | Part-time (1 mês) | R$ 500-1.500 (freela) |
| **Testador (playtest crianças)** | Esporádico | R$ 0 (família/amigos) |

**Custo total estimado (artistas freelancers):** R$ 4.500 - 12.500

### Alternativas de Arte

| Opção | Custo | Qualidade | Velocidade |
|-------|-------|-----------|------------|
| Freelancer BR | Médio-Alto | Alta | Média |
| Asset Store (Unity/Itch.io) | Baixo | Média | Rápida |
| IA Generativa (com revisão) | Baixo | Média | Rápida |
| Estilo simples (JV mesmo) | Grátis | Baixa-Média | Lenta |

**Recomendação:** Misto — assets comprados para prototipagem, freelancer para arte final dos personagens principais.

---

## 🎯 Marcos (Milestones)

| Marco | Data Alvo | Critério de Sucesso |
|-------|-----------|---------------------|
| **M1: Protótipo Jogável** | Jun/2026 | APK rodando no celular, personagem anda, 1 mini-jogo |
| **M2: Alpha** | Jul/2026 | 3 bairros, 10 locais, 5 NPCs, 3 missões |
| **M3: Beta** | Set/2026 | 8 bairros, 60 locais, jogo completo de conteúdo |
| **M4: Release Candidate** | Nov/2026 | Performance otimizada, sem bugs críticos, monetização OK |
| **M5: Lançamento** | Dez/2026 | Na Google Play, 100+ downloads na primeira semana |
| **M6: Primeira Expansão** | Mar/2027 | Praia do Mundinho lançada, 50+ vendas |

---

## 📝 Notas

- **Datas são estimativas** — ajustar conforme progresso real
- **Foco em qualidade, não velocidade** — melhor atrasar que lançar quebrado
- **Playtests frequentes** — testar com crianças a cada 2 semanas
- **Documentação viva** — atualizar este roadmap mensalmente

---

*"O jogo perfeito é aquele que as crianças amam e os pais confiam."*
