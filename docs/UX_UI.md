# Mundinho Divertido — Diretrizes de UX/UI para Crianças 4-8 anos

> **Versão:** 1.0
> **Princípio:** *"Se uma criança de 4 anos não entender em 3 segundos, precisa ser redesenhado."*

---

## 🧒 Entendendo o Público

### Desenvolvimento Cognitivo por Idade

| Idade | Capacidades | Limitações | Implicações de Design |
|-------|-------------|------------|----------------------|
| **4 anos** | Reconhece ícones, toca com um dedo, segue instruções simples | Não lê textos, atenção curta (3-5 min), coordenação em desenvolvimento | TUDO visual, feedback imediato, sessões curtas |
| **5-6 anos** | Lê algumas palavras, entende sequências, melhor coordenação | Leitura lenta, frustração fácil, precisa de reforço positivo | Mínimo texto, muita celebração, tentativas ilimitadas |
| **7-8 anos** | Lê bem, entende regras, gosta de desafios | Ainda prefere imagens, pode desistir se muito difícil | Texto opcional, progressão de dificuldade, recompensas |

### Tipos de Toque (Touch)

- **4 anos:** Toque com palma, arrasto impreciso, toque duplo acidental
- **5-6 anos:** Toque com dedo indicador, arrasto razoável
- **7-8 anos:** Toque preciso, gestos múltiplos

**Solução:** Botões grandes o suficiente para toque com palma (mínimo 64x64dp).

---

## 🎨 Princípios de Design

### 1. Zero Texto Obrigatório
- Toda informação deve ser comunicável por **ícones, cores, animações e sons**
- Texto existe como **complemento** (para quem já lê)
- Balões de fala usam **emoji + pictogramas**, não frases

**Exemplo de diálogo:**
```
❌ "Vovó Maria precisa de farinha para fazer o bolo"
✅  [🧓] → [🥣] + [🌾] → [?]
```

### 2. Feedback Imediato e Multi-Sensorial
Todo toque DEVE ter:
- **Visual:** Animação de pressão (escala 0.95), brilho, partículas
- **Sonoro:** Som característico (não genérico)
- **Tátil:** Vibração suave (HapticFeedback.lightImpact)

**Exemplo:** Toque em NPC
1. NPC "pula" levemente (animação)
2. Som de "oi!" amigável
3. Balão de fala aparece com animação de "pop"
4. Vibração de 10ms

### 3. Sem Frustração
- **Não há game over** — apenas "tentar de novo"
- **Não há temporizadores pressionantes** — exceto mini-jogos opcionais
- **Não há escolhas erradas permanentes** — sempre dá para desfazer
- **Dicas automáticas** — se a criança ficar parada por 10 segundos, algo pisca

### 4. Navegação Plana
- **Máximo 2 níveis** de menus
- **Sem sub-sub-menus**
- **Sem modais sobre modais**
- **Voltar sempre funciona** — botão físico ou gesto de swipe

### 5. Cores e Contraste
- **Cores vibrantes** e saturadas (crianças preferem)
- **Contraste alto** para legibilidade
- **Cores com significado consistente:**
  - 🟢 Verde = OK, avançar, positivo
  - 🔴 Vermelho = parar, perigo (suave), negativo
  - 🟡 Amarelo = atenção, dica
  - 🔵 Azul = informação, água
  - 🟣 Roxo = especial, mágico

### 6. Animações
- **Todas as transições são animadas** — crianças entendem melhor com movimento
- **Duração:** 200-400ms (rápido o suficiente para não entediar)
- **Easing:** bounce, elastic (diversão implícita)
- **Nunca transições em branco** — sempre mostrar algo acontecendo

---

## 📱 Layout e Componentes

### Botões

```
┌─────────────────────────────┐
│  ┌─────────────────────┐    │
│  │    [ÍCONE GRANDE]   │    │  ← 80x80dp mínimo
│  │                     │    │
│  │   Texto curto       │    │  ← Opcional, máx 2 palavras
│  └─────────────────────┘    │
│       borderRadius: 24      │
│       elevation: 4-8        │
└─────────────────────────────┘
```

**Especificações:**
- Tamanho mínimo: **64x64dp** (ideal: 80x80dp)
- Cantos arredondados: **16-24dp**
- Sombra: sempre presente (dá profundidade)
- Estado pressed: escala 0.95 + sombra reduzida
- Estado disabled: opacidade 0.4 (não esconder)

### Ícones
- **Estilo:** preenchido (filled), não outline
- **Tamanho:** 32-48dp na interface, 64dp+ em botões
- **Consistência:** mesmo estilo em todo o jogo
- **Reconhecibilidade:** usar padrões conhecidos (casa = 🏠, loja = 🛒)

### Balões de Diálogo (NPC)

```
    ┌──────────────────┐
    │ [🧓 Vovó Maria]  │  ← Avatar + nome (se lê)
    ├──────────────────┤
    │  [🥣] + [🌾] = ? │  ← Ícones grandes
    │                  │
    │  [✅]  [❌]      │  ← Botões de resposta
    └──────────────────┘
```

**Regras:**
- Balão nunca cobre mais que 40% da tela
- Ícones mínimo 48dp
- Respostas em botões grandes
- Toque fora do balão = repete a mensagem

### HUD (Heads-Up Display)

```
┌─────────────────────────────────────┐
│  ⭐ 12   🪙 45              ⚙️  👤  │  ← Topo: 56dp de altura
│                                     │
│                                     │
│         [ÁREA DE JOGO]              │  ← 80% da tela
│                                     │
│                                     │
│  🎒  [🕹️]           [📍]            │  ← Base: 64dp
└─────────────────────────────────────┘
```

**Elementos:**
- **Estrelas e moedas:** sempre visíveis, animam ao ganhar
- **Inventário:** botão mochila → abre barra horizontal de itens
- **Mapa:** botão pequeno no canto → minimapa ou mapa completo
- **Config:** acessível, mas não destacado (evita toques acidentais)

### Telas de Loading

❌ **NUNCA:** Tela preta com "Carregando..."
✅ **SEMPRE:** Animação divertida + barra de progresso colorida

**Exemplo:**
- Personagem correndo por uma rua colorida
- Carros passando
- Barra de progresso como "caminho" sob os pés do personagem
- Texto (opcional): "Preparando a diversão!"

---

## 🎭 Telas Principais

### Tela de Menu (Já implementada)

**Elementos:**
- Logo grande e animado (pulsar suave)
- Botão JOGAR: maior, cor diferente, animação de "chamar atenção"
- Botões secundários: menores, cores diferentes
- Fundo: animado (nuvens passando, pássaros voando)

### Tela de Seleção de Missão

```
┌─────────────────────────────────────┐
│  ← Voltar     Missões               │
├─────────────────────────────────────┤
│                                     │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐       │
│  │ M1 │ │ M2 │ │ M3 │ │ M4 │       │  ← Cards quadrados
│  │ ✅ │ │ ✅ │ │ ▶️ │ │ 🔒 │       │    com ícone de status
│  └────┘ └────┘ └────┘ └────┘       │
│                                     │
│  ┌─────────────────────────────┐    │
│  │ Descrição com ícones        │    │
│  │ [🥣] + [🌾] → [🎂]          │    │
│  └─────────────────────────────┘    │
│                                     │
│        [▶ JOGAR MISSÃO]            │
│                                     │
└─────────────────────────────────────┘
```

**Status visuais:**
- ✅ Completa (verde, opacidade reduzida)
- ▶️ Disponível (amarelo, pisca suavemente)
- 🔒 Bloqueada (cinza, cadeado)

### Tela de Recompensa

**O momento mais importante do jogo.**

```
┌─────────────────────────────────────┐
│                                     │
│         🎉 🎊 🎉                    │
│                                     │
│     PARABÉNS! (grande, animado)     │
│                                     │
│        ⭐  Estrela +1               │
│        (animação de estrela         │
│         girando e brilhando)        │
│                                     │
│     🪙  +15 moedinhas               │
│     (animação de moedas caindo)     │
│                                     │
│   ┌─────────────────────────┐       │
│   │   [🧑‍🍳 Chapéu de Chef]   │       │
│   │   (novo item!)          │       │
│   └─────────────────────────┘       │
│                                     │
│      [CONTINUAR]  [COMPARTILHAR]    │
│                                     │
└─────────────────────────────────────┘
```

**Regras:**
- Animação de confete (partículas coloridas)
- Som de celebração (aplausos + fanfarra curta)
- Personagem faz dança de vitória
- Duração mínima: 5 segundos (não dá para pular imediatamente)
- Depois de 5s, botão "Continuar" aparece

### Tela de Pausa

```
┌─────────────────────────────────────┐
│                                     │
│         ⏸  PAUSA                   │
│                                     │
│      [▶ Continuar]                 │
│      [🔊 Som: ON]                  │
│      [🎵 Música: ON]               │
│      [❓ Ajuda]                    │
│      [🏠 Menu Principal]           │
│                                     │
└─────────────────────────────────────┘
```

**Regras:**
- Pausa automaticamente música e SFX
- Jogo continua visível (escurecido) no fundo
- Toque fora do menu = continuar

---

## 🎮 Controles

### Mapeamento de Gestos

| Ação | Gesto | Onde |
|------|-------|------|
| Andar | Toque no chão | Mundo aberto |
| Correr | Toque duplo no chão | Mundo aberto |
| Interagir | Toque no objeto/NPC | Qualquer lugar |
| Arrastar | Pressionar e mover | Objetos empurráveis |
| Zoom in/out | Pinch (2 dedos) | Mapa |
| Pular cena | Toque na tela | Cutscenes (depois de 3s) |
| Voltar | Swipe da esquerda | Menus |
| Abrir inventário | Toque em 🎒 | HUD |
| Pausar | Toque em ⏸ ou botão físico | Durante jogo |

### Áreas de Toque "Generosas"

- Hitbox dos NPCs: 20% maior que o sprite visível
- Botões: área de toque ≥ área visual
- Objetos interativos: glow/brilho quando perto do jogador

---

## 🔊 Áudio como Guia

### Áudio como Substituto de Texto

Crianças de 4 anos **ouvem melhor que leem**. Use áudio para:

- **Instruções:** "Vamos lá!" (som de voz entusiasmada)
- **Confirmação:** "Muito bem!" (quando acerta)
- **Encorajamento:** "Quase lá!" (quando erra)
- **Alerta:** "Olha só!" (quando algo novo aparece)

**Implementação:**
- Sons curtos (1-2 segundos)
- Vozes de crianças ou adultos calorosos
- Sem sotaque estrangeiro (100% PT-BR)
- Opção de desligar (para pais)

### Feedback Sonoro por Ação

| Ação | Som |
|------|-----|
| Toque em botão | "Pop" curto e alto |
| Missão completa | Fanfarra + aplausos |
| Erro (mini-jogo) | "Oops" amigável + som de desapontamento suave |
| Moeda ganha | Som de moeda (tipo Mario) |
| Porta abrindo | Som de porta de madeira |
| NPC falando | "Bla bla bla" estilizado (entonação) |

---

## 🌙 Acessibilidade

### Opções de Acessibilidade (Menu de Configurações)

| Opção | Padrão | Descrição |
|-------|--------|-----------|
| **Som** | ON | Liga/desliga todos os efeitos sonoros |
| **Música** | ON | Liga/desliga música de fundo |
| **Vozes** | ON | Narração de instruções |
| **Vibração** | ON | Feedback tátil |
| **Tamanho dos botões** | Médio | Pequeno / Médio / Grande |
| **Modo Daltonismo** | OFF | Paleta alternativa de cores |
| **Velocidade do jogo** | Normal | Lento / Normal / Rápido |
| **Modo Alto Contraste** | OFF | Maior contraste para visibilidade |

### Considerações Especiais

- **Daltonismo:** não usar verde/vermelho como única forma de comunicar algo
- **TDAH:** sessões curtas, recompensas frequentes, movimento constante
- **Dislexia:** fonte Fredoka (sem serifa, formas simples)
- **Motor fino:** botões grandes, toques generosos

---

## 👨‍👩‍👧 Painel "Para Mães e Pais"

Acessível via botão escondido (toque 5x no logo) ou através das configurações com senha simples.

### Funcionalidades

```
┌─────────────────────────────────────┐
│  🔒  Painel dos Pais                │
├─────────────────────────────────────┤
│                                     │
│  ⏱️ Tempo de jogo hoje: 25 min      │
│  📊 Tempo esta semana: 2h 15min     │
│                                     │
│  🎯 Missões completadas: 12/20      │
│  ⭐ Estrelas ganhas: 45             │
│                                     │
│  ─── Limites ───                    │
│  [⏱️ Limite diário: 30 min]        │
│  [🌙 Bloquear após 20h]            │
│  [📴 Pausa a cada 15 min]          │
│                                     │
│  ─── Privacidade ───                │
│  [📊 Analytics: OFF]               │
│  [📺 Anúncios: OFF]                │
│                                     │
│  ─── Dados ───                      │
│  [💾 Exportar save]                │
│  [🗑️ Resetar progresso]            │
│                                     │
└─────────────────────────────────────┘
```

---

## 📐 Especificações Técnicas de UI

### Dimensões de Referência

| Elemento | dp (density-independent pixels) |
|----------|--------------------------------|
| Botão pequeno | 48x48 |
| Botão padrão | 64x64 |
| Botão grande | 80x80 |
| Botão hero | 96x96 |
| Ícone em botão | 32-40 |
| Ícone standalone | 48 |
| Espaçamento entre botões | 16-24 |
| Margem de tela | 16-24 |
| Balão de diálogo | max 70% da largura |
| Texto (se houver) | 16-24sp |
| Título | 28-36sp |

### Fonte

- **Primária:** Fredoka (Google Fonts)
- **Fallback:** Roboto
- **Peso:** Bold para títulos, Medium para texto
- **Tamanho mínimo:** 16sp (legível para crianças)

---

*Design que as crianças AMAM usar — sem ajuda dos pais.*
