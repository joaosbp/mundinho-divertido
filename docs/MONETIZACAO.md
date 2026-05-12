# Mundinho Divertido — Estratégia de Monetização

> **Versão:** 1.0
> **Modelo:** Freemium (Gratuito + Remove Ads)
> **Público:** Crianças 4-8 anos (pais pagam)
> **Região:** Brasil (foco inicial)

---

## 💰 Visão Geral

O jogo segue uma abordagem **ética e transparente** de monetização, priorizando:
1. Experiência da criança (sem frustração)
2. Confiança dos pais (sem surpresas)
3. Sustentabilidade do projeto (receita para manter e expandir)

### Modelo Escolhido

```
┌─────────────────────────────────────────┐
│           MUNDINHO DIVERTIDO            │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │      GRATUITO (100% do jogo)    │    │
│  │                                 │    │
│  │  ✅ Todo o mundo aberto         │    │
│  │  ✅ Todas as missões principais │    │
│  │  ✅ Todos os mini-jogos         │    │
│  │  ✅ Todos os eventos sazonais   │    │
│  │                                 │    │
│  │  📺 Anúncios entre sessões      │    │
│  │     (não durante gameplay)      │    │
│  └─────────────────────────────────┘    │
│                  │                      │
│                  ▼                      │
│  ┌─────────────────────────────────┐    │
│  │   REMOVE ADS — R$ 5,00          │    │
│  │   (compra única, para sempre)   │    │
│  │                                 │    │
│  │  ✅ Sem anúncios                │    │
│  │  ✅ Sem interrupções            │    │
│  │  ✅ Apoia o desenvolvimento     │    │
│  └─────────────────────────────────┘    │
│                  │                      │
│                  ▼                      │
│  ┌─────────────────────────────────┐    │
│  │   EXPANSÕES FUTURAS (opcional)  │    │
│  │                                 │    │
│  │  🏖️ Bairro Praia — R$ 3,00      │    │
│  │  ⛰️ Bairro Serra — R$ 3,00      │    │
│  │  🚀 Bairro Espaço — R$ 3,00     │    │
│  │                                 │    │
│  │  💎 Pacote Completo — R$ 8,00   │    │
│  └─────────────────────────────────┘    │
└─────────────────────────────────────────┘
```

---

## 📺 Anúncios (Versão Gratuita)

### Regras Éticas para Anúncios em Jogos Infantis

| ✅ Fazemos | ❌ Não fazemos |
|-----------|---------------|
| Anúncios entre sessões | Anúncios durante gameplay |
| Anúncios de 15-30s | Anúncios de mais de 30s |
| Anúncios de apps infantis/educativos | Anúncios de jogos de azar, violência, adultos |
| Botão "Pular" após 5s | Anúncios sem opção de pular |
| Anúncios após completar missão | Anúncios ao morrer/fracassar |
| Anúncios no menu (banner pequeno) | Banners sobre área de jogo |
| Limite de 3 anúncios por hora | Anúncios ilimitados |

### Posicionamento dos Anúncios

```
┌─────────────────────────────────────┐
│  [Banner pequeno]        ⭐  🪮  ⚙️  │  ← Banner no topo do menu
│                                     │     (nunca durante jogo)
├─────────────────────────────────────┤
│                                     │
│         MENU PRINCIPAL              │
│                                     │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│                                     │
│     🎉 MISSÃO COMPLETA! 🎉          │
│                                     │
├─────────────────────────────────────┤
│  [Anúncio de 15s]                   │  ← Interstitial após missão
│  [Pular em 5... 4... 3...]          │     (máx 1 a cada 10 min)
├─────────────────────────────────────┤
│      [CONTINUAR]                    │
└─────────────────────────────────────┘
```

### Tipos de Anúncios

1. **Banner (Menu apenas)**
   - Tamanho: 320x50dp (padrão)
   - Localização: topo do menu principal
   - Frequência: sempre visível no menu

2. **Interstitial (Entre sessões)**
   - Gatilho: após completar missão OU ao voltar ao menu
   - Frequência máxima: 1 a cada 10 minutos de gameplay
   - Duração: 15-30 segundos
   - Pular: disponível após 5 segundos

3. **Rewarded Video (Opcional, com bônus)**
   - Gatilho: botão "Ganhar moedas extras" no menu
   - Recompensa: 20 moedinhas
   - Frequência: 3 por dia
   - **Nunca obrigatório** — sempre há outra forma de ganhar

### Filtro de Anúncios

```dart
// Configuração do AdMob para jogos infantis
AdRequest(
  keywords: ['educational', 'kids', 'family', 'toys'],
  contentUrl: 'https://mundinhodivertido.com/family-friendly',
  // Bloquear categorias inapropriadas
  neigbouringContentUrl: null,
)
```

**Categorias bloqueadas:**
- Jogos de azar / apostas
- Violência / armas
- Conteúdo adulto / dating
- Alimentos não saudáveis (doces excessivos)
- Aplicativos com microtransações agressivas

---

## 💎 Remove Ads — R$ 5,00

### Proposta de Valor

> *"Pague uma vez, divirta-se para sempre. Sem anúncios, sem interrupções, sem surpresas."*

### O que inclui:

| Benefício | Descrição |
|-----------|-----------|
| ✅ Sem anúncios banner | Menu limpo |
| ✅ Sem anúncios interstitial | Transições suaves |
| ✅ Sem anúncios rewarded | Não há tentação de ver anúncio |
| ✅ Experiência fluida | Zero interrupções |
| ✅ Apoia desenvolvedor | Permite criar mais conteúdo |
| ✅ Transferível | Entre dispositivos (Google Play) |
| ✅ Para sempre | Compra única, vitalícia |

### O que NÃO inclui (ainda):
- Expansões futuras (Praia, Serra, etc.)
- Essas serão compras separadas ou pacote completo

### Fluxo de Compra

```
┌─────────────────────────────────────┐
│  Quer uma experiência sem anúncios? │
├─────────────────────────────────────┤
│                                     │
│    ┌─────────────────────────┐      │
│    │    ✨ REMOVE ADS ✨      │      │
│    │                         │      │
│    │    R$ 5,00              │      │
│    │    (pague uma vez)      │      │
│    │                         │      │
│    │  ✅ Sem interrupções    │      │
│    │  ✅ Para sempre         │      │
│    │  ✅ Apoie o jogo        │      │
│    └─────────────────────────┘      │
│                                     │
│    [💳 COMPRAR]  [❌ AGORA NÃO]    │
│                                     │
│  (compra protegida por senha do     │
│   Google Play — pais aprovam)       │
│                                     │
└─────────────────────────────────────┘
```

### Gatilhos de Oferta (Timing)

- **Sutil (sempre):** Botão "Remove Ads" visível no menu, discreto
- **Após 5 missões:** Diálogo educativo explicando a opção (1x só)
- **Após 10 anúncios:** "Quer parar de ver anúncios?"
- **Nunca:** durante gameplay, nunca interrompendo diversão

---

## 🏖️ Expansões Futuras (DLC)

### Modelo

Expansões são **novos bairros completos** com:
- 5-10 novos locais
- 5-10 novos NPCs
- 5-10 novas missões
- 2-3 novos mini-jogos
- Eventos sazonais exclusivos

### Previsão de Preços

| Expansão | Conteúdo | Preço |
|----------|----------|-------|
| **Praia do Mundinho** | Praia, barcos, mercado de peixe, surf | R$ 3,00 |
| **Serra Verde** | Fazenda, camping, cachoeira, cavalgada | R$ 3,00 |
| **Vila Tecnológica** | Centro espacial, robótica, laboratório | R$ 3,00 |
| **Bairro das Artes** | Teatro, estúdio de música, galeria | R$ 3,00 |
| **💎 Pacote Completo** | Todas as expansões | R$ 8,00 (economia de R$ 4,00) |

### Política de Expansões

- **Nunca conteúdo "pay-to-win"** — expansões são novas áreas, não vantagens
- **Base game permanece completo** — expansões são "mais do mesmo"
- **Eventos sazonais são gratuitos** — mesmo nas expansões
- **Preview gratuito:** cada expansão tem 1 missão de demonstração

---

## 📊 Projeções Financeiras (Conservadoras)

### Métricas de Referência (Jogos Infantis BR)

| Métrica | Valor |
|---------|-------|
| DAU (Daily Active Users) estimado (ano 1) | 5.000 - 15.000 |
| Taxa de conversão (remove ads) | 1-3% |
| Taxa de conversão (expansões) | 0.5-1% |
| ARPDAU (revenue por DAU) | R$ 0,01 - 0,05 |

### Projeção Ano 1 (Cenário Moderado)

| Mês | Downloads | DAU | Remove Ads (R$) | Ads Views (R$) | Total (R$) |
|-----|-----------|-----|-----------------|----------------|------------|
| 1 | 1.000 | 200 | 20 | 10 | 30 |
| 3 | 5.000 | 1.000 | 100 | 50 | 150 |
| 6 | 15.000 | 3.000 | 300 | 150 | 450 |
| 12 | 50.000 | 8.000 | 800 | 400 | 1.200 |

**Total Ano 1 (moderado):** R$ 6.000 - 10.000

### Usos da Receita

```
Receita:
├── 40% → Desenvolvimento (novo conteúdo, correções)
├── 25% → Arte e Áudio (novos assets)
├── 15% → Marketing (ASO, redes sociais)
├── 10% → Infraestrutura (servidores, licenças)
└── 10% → Reserva (fundo de emergência)
```

---

## 🛡️ Conformidade Legal

### Google Play — Política de Família

- ✅ App aprovado no programa "Designed for Families"
- ✅ Classificação etária: "Livre" (ESRB: E, PEGI: 3)
- ✅ Sem coleta de dados pessoais de crianças
- ✅ Anúncios filtrados para conteúdo infantil
- ✅ Compras protegidas por senha/autenticação

### LGPD (Lei Geral de Proteção de Dados)

- Dados armazenados localmente (não em servidor)
- Analytics anônimo e opt-in
- Sem compartilhamento de dados com terceiros
- Política de privacidade clara e acessível

---

## 📝 Mensagens para os Pais

### Tela Inicial (Primeira Execução)

```
┌─────────────────────────────────────┐
│  👋 Olá, pais e responsáveis!       │
├─────────────────────────────────────┤
│                                     │
│  Mundinho Divertido é 100% GRÁTIS   │
│  para jogar.                        │
│                                     │
│  📺 Opcional: Anúncios entre        │
│     sessões ajudam a manter o       │
│     jogo gratuito.                  │
│                                     │
│  💎 Opcional: R$ 5,00 remove        │
│     todos os anúncios para sempre.  │
│                                     │
│  🔒 Compras requerem senha.         │
│  🚫 Sem compras dentro do jogo.     │
│  👶 Sem coleta de dados pessoais.   │
│                                     │
│     [✅ ENTENDI]                    │
│                                     │
└─────────────────────────────────────┘
```

### Tela de Compra

```
┌─────────────────────────────────────┐
│  💎 Compra no App                   │
├─────────────────────────────────────┤
│                                     │
│  Remove Ads — R$ 5,00               │
│                                     │
│  ⚠️ Esta compra é cobrada na        │
│     sua conta Google Play.          │
│                                     │
│  👤 Conta: [email do pai]           │
│                                     │
│  [💳 CONFIRMAR COMPRA]              │
│  [❌ CANCELAR]                      │
│                                     │
└─────────────────────────────────────┘
```

---

## 🎯 Metas de Monetização

### Curto Prazo (3 meses)
- [ ] Implementar AdMob (banner + interstitial)
- [ ] Implementar compra "Remove Ads"
- [ ] 1.000+ downloads
- [ ] 50+ compras de Remove Ads

### Médio Prazo (6 meses)
- [ ] 10.000+ downloads
- [ ] 200+ compras de Remove Ads
- [ ] Implementar primeira expansão (Praia)
- [ ] Taxa de conversão ≥ 2%

### Longo Prazo (12 meses)
- [ ] 50.000+ downloads
- [ ] 1.000+ compras de Remove Ads
- [ ] 2-3 expansões lançadas
- [ ] Receita mensal recorrente ≥ R$ 1.000

---

*Monetização ética: a criança joga feliz, o pai paga tranquilo, o jogo cresce sustentável.*
