# Mundinho Divertido — Diretrizes de UX/UI

> **Versão:** 2.0
> **Público-alvo:** 6 a 15 anos
> **Princípio:** *"Interface que escala com a idade: simples para 6 anos, rica para 15."*

---

## 🧒 Entendendo o Público

### Desenvolvimento por Faixa Etária

| Idade | Leitura | Coordenação | Atenção | Preferência de UI |
|---------|---------|-------------|---------|-------------------|
| **6-7 anos** | Básica (palavras simples) | Toque com dedo indicador | 5-10 min | Ícones grandes, texto curto, feedback visual |
| **8-9 anos** | Fluente (frases curtas) | Toque preciso, arrasto | 10-20 min | Ícones + texto, animações, recompensas frequentes |
| **10-12 anos** | Avançada (parágrafos) | Gestos múltiplos | 20-40 min | Interface rica, menus organizados, escolhas |
| **13-15 anos** | Adulta | Controle total | 30-60 min | UI completa, atalhos, customização, minimalismo opcional |

### Adaptação Dinâmica

O jogo detecta a idade informada no perfil e ajusta automaticamente:

| Elemento | 6-7 anos | 8-9 anos | 10-12 anos | 13-15 anos |
|----------|----------|----------|------------|------------|
| **Texto em diálogos** | Ícones + 1 palavra | Ícones + frase curta | Texto completo | Texto rico, opções de skip |
| **Tamanho botões** | 80x80dp | 72x72dp | 64x64dp | 56x56dp |
| **Tutorial** | Guiado passo a passo | Dicas contextuais | Tooltips | Opcional, pode desligar |
| **HUD** | Mínimo (3 elementos) | Padrão (5 elementos) | Completo (7 elementos) | Customizável |
| **Missões** | 3 passos visíveis | 5 passos | Lista completa | Mapa de missões, filtros |
| **Inventário** | 8 slots visíveis | 12 slots | 24 slots + categorias | 36 slots + busca |

---

## 🎨 Princípios de Design

### 1. Interface Progressiva
- **Base:** Todos veem ícones e cores (universal)
- **Texto:** Aparece conforme idade (6-7 anos vê pouco, 13-15 vê muito)
- **Complexidade:** Menus simples para crianças, organizados para tweens

### 2. Feedback Multi-Sensorial
Todo toque DEVE ter:
- **Visual:** Animação de pressão (escala 0.95), brilho, partículas
- **Sonoro:** Som característico
- **Tátil:** Vibração suave (configurável)

### 3. Zero Frustração
- **Não há game over** — apenas "tentar de novo"
- **Não há bloqueios por tempo** — subscription dá acesso total
- **Dicas automáticas** — se parado por 15 segundos, algo pisca
- **Skip opcional** — tween+ pode pular diálogos e cutscenes

### 4. Navegação Escalável
- **6-8 anos:** Máximo 2 níveis de menus, botões gigantes
- **9-12 anos:** Menus organizados por categorias, atalhos
- **13-15 anos:** UI minimalista opcional, atalhos de teclado (futuro), busca

### 5. Cores e Significado Consistente

| Cor | Significado | Uso |
|-----|-------------|-----|
| 🟢 Verde | OK, avançar, positivo | Botões de ação, confirmação |
| 🔴 Vermelho | Parar, cancelar, perigo | Fechar, sair, erro suave |
| 🟡 Amarelo | Atenção, dica, importante | Notificações, alertas |
| 🔵 Azul | Informação, água, céu | Info, mapa, água |
| 🟣 Roxo | Especial, mágico, raro | Itens raros, eventos |
| 🟠 Laranja | Energia, ação, urgência | Correr, ações rápidas |

---

## 📱 Layout e Componentes

### Botões

```
┌─────────────────────────────┐
│  ┌─────────────────────┐    │
│  │    [ÍCONE]          │    │
│  │    Texto            │    │
│  └─────────────────────┘    │
│       56-80dp               │
│       borderRadius: 16-24   │
│       elevation: 4-8        │
└─────────────────────────────┘
```

**Especificações por idade:**

| Idade | Tamanho mínimo | Fonte | Border Radius |
|-------|---------------|-------|---------------|
| 6-7 | 80x80dp | 20sp | 24dp |
| 8-9 | 72x72dp | 18sp | 20dp |
| 10-12 | 64x64dp | 16sp | 16dp |
| 13-15 | 56x56dp | 14sp | 12dp |

### Diálogos de NPC

**6-8 anos:**
```
┌──────────────────┐
│ [🧓 Avatar]      │
│ [🥣] + [🌾] = ?  │  ← Apenas ícones
│ [✅]  [❌]       │
└──────────────────┘
```

**9-12 anos:**
```
┌──────────────────────────┐
│ [🧓] Vovó Maria          │
│ "Preciso de farinha      │
│  para o bolo!"           │
│ [🌾] Pegar farinha       │
│ [🚶] Ir embora           │
└──────────────────────────┘
```

**13-15 anos:**
```
┌──────────────────────────────┐
│ [🧓] Vovó Maria              │
│                              │
│ "Meu neto, preciso de sua    │
│  ajuda. A festa do prefeito  │
│  é amanhã e meu bolo ainda   │
│  não está pronto. Você pode  │
│  ir ao mercado buscar os     │
│  ingredientes que faltam?"   │
│                              │
│ [🌾] "Claro, vovó!"          │
│ [❓] "Quais ingredientes?"   │
│ [🚶] "Depois eu volto"       │
└──────────────────────────────┘
```

### HUD (Heads-Up Display)

**HUD Progressivo:**

```
┌─────────────────────────────────────┐
│  ⭐ 12   🪙 45   ❤️ 8      ⚙️  👤  │  ← Topo (todas as idades)
│                                     │
│         [ÁREA DE JOGO]              │
│                                     │
│  🎒  [🕹️]  [📍]  [📋]  [💬]       │  ← Base (cresce com idade)
└─────────────────────────────────────┘
```

| Ícone | Função | Idade mínima |
|-------|--------|-------------|
| 🎒 | Inventário | 6+ |
| 🕹️ | Movimento | 6+ |
| 📍 | Mapa | 6+ |
| 📋 | Missões | 8+ |
| 💬 | Chat/NPCs | 10+ |
| 🔍 | Busca | 12+ |

---

## 🎭 Telas Principais

### Tela de Menu (Já implementada)

**Adaptações por idade:**
- **6-8:** Botões enormes, animação do personagem pulando, sons divertidos
- **9-12:** Botões padrão, preview de evento atual, notificações
- **13-15:** Layout compacto, atalhos para favoritos, stats de jogador

### Tela de Missões

**6-8 anos:**
- Cards grandes com imagem
- Checklist visual (caixinhas coloridas)
- Progresso: 2 de 5 ✅

**9-12 anos:**
- Lista com ícone + título + descrição curta
- Filtros: Ativas / Completas / Todas

**13-15 anos:**
- Mapa de missões (visual tipo board game)
- Filtros avançados, ordenação, busca
- Log de missões completas com data

### Tela de Recompensa

**Todas as idades:**
- Animação de confete (partículas)
- Som de celebração
- Personagem dança
- Duração mínima: 5 segundos

**+6 anos:** Texto "PARABÉNS!" aparece
**+9 anos:** Mostra estatísticas (tempo, precisão)
**+12 anos:** Botão "Compartilhar conquista"

---

## 🎮 Controles

### Mapeamento de Gestos

| Ação | Gesto | Onde | Idade |
|------|-------|------|-------|
| Andar | Toque no chão | Mundo aberto | 6+ |
| Correr | Toque duplo no chão | Mundo aberto | 6+ |
| Interagir | Toque no objeto/NPC | Qualquer lugar | 6+ |
| Arrastar | Pressionar e mover | Objetos empurráveis | 6+ |
| Zoom | Pinch (2 dedos) | Mapa / Mundo | 8+ |
| Pular cena | Toque na tela | Cutscenes | 8+ |
| Inventário | Toque em 🎒 | HUD | 6+ |
| Pausar | Toque em ⏸ | Durante jogo | 6+ |
| Mapa | Toque em 📍 | HUD | 6+ |
| Atalho rápido | Swipe de borda | HUD | 12+ |

---

## 🔊 Áudio como Guia

### Narração por Idade

| Idade | Tipo de Áudio |
|-------|--------------|
| 6-7 | Vozes amigáveis, instruções faladas para TUDO |
| 8-9 | Vozes para tutoriais, SFX para ações |
| 10-12 | SFX predominantes, vozes para eventos especiais |
| 13-15 | Música + SFX, opção de narração desligada |

**Configuração:** Pais podem ativar/desativar narração no painel.

---

## 🌙 Acessibilidade

### Opções de Acessibilidade

| Opção | Padrão | Descrição |
|-------|--------|-----------|
| **Som** | ON | Liga/desliga todos os efeitos sonoros |
| **Música** | ON | Liga/desliga música de fundo |
| **Narração** | ON (6-8) / OFF (9+) | Narração de instruções |
| **Vibração** | ON | Feedback tátil |
| **Tamanho do texto** | Auto | Pequeno / Médio / Grande |
| **Tamanho dos botões** | Auto | Ajusta conforme idade |
| **Modo Daltonismo** | OFF | Paleta alternativa |
| **Velocidade do texto** | Normal | Lento / Normal / Rápido |
| **Alto Contraste** | OFF | Maior contraste |
| **Modo Foco** | OFF | Remove distrações da tela |

---

## 👨‍👩‍👧 Painel "Para Mães e Pais"

Acessível via botão escondido (toque 5x no logo) ou configurações com senha.

### Funcionalidades

```
┌─────────────────────────────────────┐
│  🔒  Painel dos Pais                │
├─────────────────────────────────────┤
│                                     │
│  ⏱️ Tempo de jogo hoje: 25 min      │
│  📊 Tempo esta semana: 2h 15min     │
│  🎯 Missões completadas: 12/20      │
│  ⭐ Progresso geral: 45%            │
│                                     │
│  ─── Limites ───                    │
│  [⏱️ Limite diário: 60 min]        │
│  [🌙 Bloquear após 21h]            │
│  [📴 Pausa a cada 30 min]          │
│                                     │
│  ─── Assinatura ───                 │
│  [💎 Gerenciar assinatura]          │
│  [📅 Próxima cobrança: 15/06]      │
│                                     │
│  ─── Dados ───                      │
│  [💾 Exportar save]                 │
│  [🗑️ Resetar progresso]             │
│                                     │
└─────────────────────────────────────┘
```

---

## 📐 Especificações Técnicas

### Dimensões de Referência

| Elemento | dp mínimo | dp recomendado |
|----------|-----------|----------------|
| Botão (6-7 anos) | 64x64 | 80x80 |
| Botão (8-9 anos) | 56x56 | 72x72 |
| Botão (10-12 anos) | 48x48 | 64x64 |
| Botão (13-15 anos) | 44x44 | 56x56 |
| Ícone em botão | 28 | 32-40 |
| Ícone standalone | 40 | 48 |
| Espaçamento entre botões | 12 | 16-24 |
| Margem de tela | 12 | 16-24 |
| Balão de diálogo | max 75% largura | max 70% largura |
| Texto (6-7 anos) | 18sp | 22sp |
| Texto (8-9 anos) | 16sp | 18sp |
| Texto (10-12 anos) | 14sp | 16sp |
| Texto (13-15 anos) | 12sp | 14sp |
| Título | 24sp | 28-36sp |

### Fonte

- **Primária:** Fredoka (Google Fonts) — amigável, arredondada
- **Fallback:** Roboto
- **Peso:** Bold para títulos, Medium para texto, Regular para descrições

---

*Design que cresce com o jogador — da infância à adolescência.*
