# Mundinho Divertido — Missões do MVP (Fase 1)

> **Fase:** MVP — Bairro Centro (Semanas 3-6)
> **Total de locais:** 8
> **Total de missões principais:** 5
> **Total de mini-jogos:** 5
> **Orquestrador:** Jaime

---

## Épico 1: Fundação do Mundo

### MISSÃO: M1-CASA — Implementar Casa do Jogador

**Objetivo:** Criar a Casa do Jogador como primeiro local jogável, com exterior no mapa, interior interativo e sistema de transição entre cenas.

**Responsável:** agent:fe
**LLM recomendado:** Kimi

**Entradas:**
- `docs/ARQUITETURA.md` — estrutura de locais
- `docs/CIDADE.md` — descrição da Casa do Jogador
- `lib/locations/location_base.dart` — classe base
- `lib/locations/location_manager.dart` — registro
- `lib/engine/mundinho_game.dart` — engine atual

**Saídas esperadas:**
- `lib/locations/buildings/centro/casa_jogador.dart`
- `lib/locations/interior_scenes/casa_interior.dart`
- Assets placeholder (círculos/retângulos coloridos)
- Transição suave entre exterior e interior

**Critérios de conclusão:**
- [ ] Casa do Jogador aparece no mapa mundial
- [ ] Player pode tocar na casa e entrar
- [ ] Interior é renderizado com cômodos básicos (quarto, cozinha)
- [ ] Player pode sair da casa voltando pro mapa
- [ ] Transição tem fade de 300ms
- [ ] SaveService registra que o jogador visitou a casa

**Dependências:**
- Nenhuma (primeira missão)

**Riscos:**
- Transição de cenas no Flame pode ser complexa → usar `RouterComponent` ou overlay
- Performance com múltiplas cenas → lazy load do interior

**Prioridade:** P0
**Estimativa:** 2 dias

---

### MISSÃO: M1-PARQUE — Implementar Parque Central

**Objetivo:** Criar o Parque Central como área de mundo aberto com elementos interativos (bancos, escorregador, fonte) e 1 NPC básico.

**Responsável:** agent:fe
**LLM recomendado:** Kimi

**Entradas:**
- `docs/ARQUITETURA.md`
- `docs/CIDADE.md` — descrição do Parque
- `lib/locations/location_base.dart`
- `lib/entities/player/player.dart`

**Saídas esperadas:**
- `lib/locations/buildings/centro/parque_central.dart`
- `lib/entities/npcs/npc_base.dart` — classe base de NPC
- `lib/entities/npcs/cidadao.dart` — NPC genérico do parque
- Sistema de diálogo por balões (ícones + texto curto)

**Critérios de conclusão:**
- [ ] Parque é renderizado no mapa com grama, árvores (shapes) e caminhos
- [ ] Player pode interagir com bancos (sentar)
- [ ] Player pode interagir com escorregador (animação de descida)
- [ ] NPC genérico aparece no parque com rotina simples (idle + walk)
- [ ] Toque no NPC abre balão de diálogo com ícone + texto
- [ ] SaveService registra interações

**Dependências:**
- M1-CASA (sistema de locais estabelecido)

**Riscos:**
- Pathfinding de NPC pode ser complexo → usar movimento aleatório simples no MVP
- Animações de interação → usar scale/position tweens no MVP

**Prioridade:** P0
**Estimativa:** 2 dias

---

## Épico 2: Comércio e Serviços

### MISSÃO: M1-MERCADO — Implementar Mercadão + Mini-jogo "Lista de Compras"

**Objetivo:** Criar o Mercadão com interior interativo e mini-jogo de encontrar itens na prateleira.

**Responsável:** agent:fe
**LLM recomendado:** Kimi

**Entradas:**
- `lib/locations/location_base.dart`
- `lib/minigames/minigame_base.dart`
- `lib/minigames/minigame_manager.dart`
- `docs/CIDADE.md` — Mercadão

**Saídas esperadas:**
- `lib/locations/buildings/centro/mercadao.dart`
- `lib/minigames/games/memory/lista_compras.dart`
- NPC Seu João com diálogo

**Critérios de conclusão:**
- [ ] Mercadão renderizado no mapa
- [ ] Interior com prateleiras e itens (shapes coloridos)
- [ ] Mini-jogo: lista de 3-5 itens, jogador toca nos corretos
- [ ] Feedback visual imediato (✅/❌)
- [ ] Recompensa: moedas + figurinha

**Dependências:**
- M1-CASA
- M1-PARQUE (NPC base pronto)

**Prioridade:** P1
**Estimativa:** 2 dias

---

### MISSÃO: M1-PADARIA — Implementar Padaria + Mini-jogo "Padeiro Mirim"

**Objetivo:** Criar a Padaria com mini-jogo de seguir receita (misturar → sovar → assar → decorar).

**Responsável:** agent:fe
**LLM recomendado:** Kimi

**Saídas esperadas:**
- `lib/locations/buildings/centro/padaria.dart` (expandir stub existente)
- `lib/minigames/games/sequence/padeiro_mirim.dart`
- NPC Dona Rosa com diálogo

**Critérios de conclusão:**
- [ ] Padaria com forno animado (luz piscando)
- [ ] Mini-jogo em 4 passos sequenciais
- [ ] Cada passo tem animação (scale, rotate)
- [ ] Barra de progresso do forno
- [ ] Recompensa: moedas + receita no álbum

**Dependências:**
- M1-CASA
- M1-MERCADO (padrão de mini-jogo estabelecido)

**Prioridade:** P1
**Estimativa:** 2 dias

---

## Épico 3: Instituições

### MISSÃO: M1-PREFEITURA — Implementar Prefeitura + Missão Tutorial

**Objetivo:** Criar a Prefeitura como hub de missões e implementar a primeira missão do jogo ("Bem-vindo ao Mundinho!").

**Responsável:** agent:fe
**LLM recomendado:** Kimi

**Entradas:**
- `lib/missions/mission_base.dart`
- `lib/missions/mission_manager.dart`
- `lib/locations/buildings/centro/prefeitura.dart` (stub existente)
- `docs/MISSOES.md` — Missão tutorial

**Saídas esperadas:**
- `lib/locations/buildings/centro/prefeitura.dart` (completo)
- `lib/missions/definitions/arc1/t1_bem_vindo.dart`
- NPC Prefeito Tico com rotina

**Critérios de conclusão:**
- [ ] Prefeitura com bandeira animada
- [ ] NPC Prefeito Tico com rotina (idle, walk, acena)
- [ ] Missão tutorial com 3 passos: falar com Tico → visitar 2 locais → voltar
- [ ] Indicador de missão ativa no HUD
- [ ] Recompensa ao completar: estrela + moedas

**Dependências:**
- M1-CASA
- M1-PARQUE

**Riscos:**
- Sistema de missões pode ser complexo → usar state machine simples

**Prioridade:** P1
**Estimativa:** 2 dias

---

### MISSÃO: M1-ESCOLA — Implementar Escola + Mini-jogos Educativos

**Objetivo:** Criar a Escola com 3 mini-jogos educativos (Matemática, Alfabeto, Pintura).

**Responsável:** agent:fe
**LLM recomendado:** Kimi

**Saídas esperadas:**
- `lib/locations/buildings/centro/escola.dart`
- `lib/minigames/games/math/matematica_lousa.dart`
- `lib/minigames/games/puzzle/alfabeto_colorido.dart`
- `lib/minigames/games/creative/pintura_livre.dart`

**Critérios de conclusão:**
- [ ] 3 mini-jogos funcionais
- [ ] Matemática: contar objetos na tela
- [ ] Alfabeto: ordenar letras arrastando
- [ ] Pintura: tela com paleta de cores e brush
- [ ] NPC Tia Júlia guia o jogador

**Dependências:**
- M1-PADARIA (padrão de mini-jogo)

**Prioridade:** P1
**Estimativa:** 3 dias

---

## Épico 4: Saúde e Comunicação

### MISSÃO: M1-FARMACIA — Implementar Farmácia + Mini-jogo "Remédio Certo"

**Objetivo:** Criar a Farmácia com mini-jogo de combinar sintomas com remédios.

**Responsável:** agent:fe
**LLM recomendado:** Kimi

**Saídas esperadas:**
- `lib/locations/buildings/centro/farmacia.dart`
- `lib/minigames/games/memory/remedio_certo.dart`
- NPC Dr. Pipo

**Critérios de conclusão:**
- [ ] Farmácia com prateleiras de remédios coloridos
- [ ] Mini-jogo de memória/associação
- [ ] NPC Dr. Pipo dá dicas

**Dependências:**
- M1-ESCOLA (padrão de mini-jogo educativo)

**Prioridade:** P2
**Estimativa:** 1.5 dias

---

### MISSÃO: M1-CORREIOS — Implementar Correios + Mini-jogo "Carteiro Express"

**Objetivo:** Criar os Correios com mini-jogo de entregar cartas pelos locais.

**Responsável:** agent:fe
**LLM recomendado:** Kimi

**Saídas esperadas:**
- `lib/locations/buildings/centro/correios.dart`
- `lib/minigames/games/sequence/carteiro_express.dart`
- NPC Seu Correio

**Critérios de conclusão:**
- [ ] Correios com caixas amarelas
- [ ] Mini-jogo: memorizar rota e entregar cartas na ordem
- [ ] NPC Seu Correio

**Dependências:**
- M1-FARMACIA

**Prioridade:** P2
**Estimativa:** 1.5 dias

---

## Épico 5: Integração e Polimento

### MISSÃO: M1-UI — Implementar HUD Completo, Menu e Settings

**Objetivo:** Criar HUD funcional, tela de pause, settings e menu principal polido.

**Responsável:** agent:fe
**LLM recomendado:** Kimi

**Saídas esperadas:**
- `lib/ui/hud/main_hud.dart` (completo)
- `lib/ui/menus/pause_menu.dart`
- `lib/ui/menus/settings_menu.dart`
- `lib/ui/overlays/loading_overlay.dart`

**Critérios de conclusão:**
- [ ] HUD mostra: moedas, estrelas, missão ativa, botão de inventário
- [ ] Pause menu: continuar, settings, sair
- [ ] Settings: som, música, vibração, tamanho de texto
- [ ] Loading overlay entre transições
- [ ] Inventário visual (12 slots, ícones)

**Dependências:**
- Todas as missões de locais (para testar HUD)

**Prioridade:** P1
**Estimativa:** 2 dias

---

### MISSÃO: M1-SAVE — Sistema de Save/Load Completo

**Objetivo:** Implementar persistência completa do progresso com Hive.

**Responsável:** agent:arch
**LLM recomendado:** ChatGPT 5.5

**Saídas esperadas:**
- SaveService funcional com todos os dados
- Auto-save a cada 2 minutos
- Tela de "Continuar" no menu
- Export/import de save (painel dos pais)

**Critérios de conclusão:**
- [ ] Progresso salva automaticamente
- [ ] Player retoma de onde parou
- [ ] Dados de missões, locais, inventário persistem
- [ ] Testes unitários do SaveService

**Dependências:**
- Todas as missões de gameplay

**Prioridade:** P0
**Estimativa:** 1 dia

---

### MISSÃO: M1-QA — Testes e Validação do MVP

**Objetivo:** Validar que o MVP atinge critérios de qualidade definidos.

**Responsável:** agent:qa
**LLM recomendado:** Kimi

**Saídas esperadas:**
- Testes unitários de todos os managers
- Testes de widget das telas principais
- Playtest com crianças (3+)
- Relatório de QA

**Critérios de conclusão:**
- [ ] 80%+ cobertura de testes nos managers
- [ ] 0 bugs críticos
- [ ] Playtest: 80%+ das crianças sorriem em 30s
- [ ] Playtest: 70%+ jogam 10min sem ajuda
- [ ] APK < 50MB

**Dependências:**
- Todas as missões anteriores concluídas

**Prioridade:** P0
**Estimativa:** 2 dias

---

## 📊 Dashboard de Missões

| Missão | Agente | Status | Prioridade | Estimativa | Início | Término |
|--------|--------|--------|------------|------------|--------|---------|
| M1-CASA | FE | 🟡 Em andamento | P0 | 2d | Hoje | — |
| M1-PARQUE | FE | 🔴 Pendente | P0 | 2d | — | — |
| M1-MERCADO | FE | 🔴 Pendente | P1 | 2d | — | — |
| M1-PADARIA | FE | 🔴 Pendente | P1 | 2d | — | — |
| M1-PREFEITURA | FE | 🔴 Pendente | P1 | 2d | — | — |
| M1-ESCOLA | FE | 🔴 Pendente | P1 | 3d | — | — |
| M1-FARMACIA | FE | 🔴 Pendente | P2 | 1.5d | — | — |
| M1-CORREIOS | FE | 🔴 Pendente | P2 | 1.5d | — | — |
| M1-UI | FE | 🔴 Pendente | P1 | 2d | — | — |
| M1-SAVE | ARCH | 🔴 Pendente | P0 | 1d | — | — |
| M1-QA | QA | 🔴 Pendente | P0 | 2d | — | — |

**Legenda:**
- 🟢 Concluída
- 🟡 Em andamento
- 🔴 Pendente
- ⚪ Bloqueada

---

*Arquivo atualizado pelo Orquestrador após cada missão.*
