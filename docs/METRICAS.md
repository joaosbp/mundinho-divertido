# Mundinho Divertido — Métricas, Analytics e KPIs

> **Versão:** 2.0  
> **Data:** 2026-05-12  
> **Status:** Documento normativo — métricas aqui definidas são obrigatórias desde o MVP  
> **CEO Founder:** JV  
> **Assistente:** Jaime

---

## 📌 Por que este documento existe

> *"Você não pode melhorar o que não mede."*

O Product Owner identificou **"falta de métricas/analytics"** como gap crítico. Este documento corrige isso definitivamente. **Nenhuma feature será considerada "pronta" sem instrumentação de métricas.**

---

## 🎯 Framework de Métricas

Usamos o framework **"HEART + Funnel de Monetização"**, adaptado para produto infantil:

| Categoria | Métrica | O que mede | Alvo MVP |
|-----------|---------|-----------|----------|
| **Happiness** | NPS / CSAT / Review Score | A criança (e o pai) está feliz? | 4.5+ estrelas |
| **Engagement** | DAU, MAU, sessões/dia, tempo médio | O jogador volta? | DAU/MAU > 20%, 2+ sessões/dia |
| **Adoption** | Taxa de download→abertura, trial start | O jogador experimenta? | 80%+ abrem no D0 |
| **Retention** | D1, D7, D30 | O jogador permanece? | D1 > 50%, D7 > 20%, D30 > 10% |
| **Task Success** | Taxa de conclusão de missão, mini-jogo | O jogador consegue fazer? | Missões > 80%, Mini-jogos > 70% |
| **Monetização** | Trial conversion, MRR, LTV, CAC | O modelo funciona? | 15%+ trial-to-paid |

---

## 📊 KPIs por Fase

### FASE 0 — Fundação (Semanas 1-2)

| KPI | Alvo | Como medir |
|-----|------|-----------|
| Build success rate | 100% | CI/CD passando em toda commit |
| Tempo de build | < 5 min | CI/CD logs |
| Crash rate (dev) | 0% | Testes automatizados |
| Cobertura de testes | > 50% | `flutter test --coverage` |

### FASE 1 — MVP (Semanas 3-6)

| KPI | Alvo | Como medir |
|-----|------|-----------|
| Instalações | 100+ (interno) | Firebase / Play Console |
| Sessão média | > 5 min | Firebase Analytics |
| Retenção D1 | > 50% | Firebase Analytics |
| Taxa de crash | < 1% | Firebase Crashlytics |
| Missões completadas | > 60% das iniciadas | Evento customizado |
| Mini-jogos jogados | > 70% das sessões | Evento customizado |
| Score de playtest | > 4.0/5 | Questionário com crianças |

### FASE 2 — Alpha (Semanas 7-10)

| KPI | Alvo | Como medir |
|-----|------|-----------|
| DAU | 50+ | Firebase |
| D7 retenção | > 20% | Firebase |
| Tempo médio por sessão | > 8 min | Firebase |
| Sessões por usuário/dia | > 2 | Firebase |
| Taxa de crash | < 0.5% | Crashlytics |
| NPS (pais) | > 50 | Pesquisa manual |

### FASE 3 — Beta (Semanas 11-16)

| KPI | Alvo | Como medir |
|-----|------|-----------|
| DAU | 200+ | Firebase |
| D30 retenção | > 10% | Firebase |
| Taxa de conclusão de missão | > 80% | Evento customizado |
| Taxa de abandono em tutorial | < 10% | Evento `tutorial_step_X` |
| Review médio | > 4.3 | Play Console |

### FASE 4 — Monetização (Semanas 17-20)

| KPI | Alvo | Como medir |
|-----|------|-----------|
| Trial start rate | > 70% dos downloads | Evento `trial_started` |
| Trial-to-paid conversion | > 15% | Play Console + evento `subscription_purchased` |
| MRR | > R$ 2.000 | Play Console |
| Churn mensal | < 8% | Play Console |
| Chargeback rate | < 1% | Play Console |

---

## 🔧 Eventos de Analytics (Obrigatórios)

### Eventos de Jornada do Jogador

| Evento | Quando disparar | Parâmetros |
|--------|-----------------|------------|
| `app_open` | App aberto | `source` (push, icon, deeplink) |
| `first_open` | Primeira abertura | `referrer`, `campaign` |
| `session_start` | Início de sessão | `level`, `location` |
| `session_end` | Fim de sessão | `duration_seconds`, `session_count` |
| `tutorial_start` | Tutorial iniciado | `tutorial_id` |
| `tutorial_step_complete` | Passo do tutorial concluído | `tutorial_id`, `step_number` |
| `tutorial_complete` | Tutorial finalizado | `tutorial_id`, `duration_seconds` |
| `tutorial_abandon` | Tutorial abandonado | `tutorial_id`, `step_number` |

### Eventos de Gameplay

| Evento | Quando disparar | Parâmetros |
|--------|-----------------|------------|
| `location_enter` | Jogador entra em local | `location_id`, `district_id` |
| `location_exit` | Jogador sai de local | `location_id`, `duration_seconds` |
| `npc_interact` | Interação com NPC | `npc_id`, `interaction_type` |
| `mission_start` | Missão iniciada | `mission_id`, `mission_type`, `arc_id` |
| `mission_step_complete` | Passo de missão concluído | `mission_id`, `step_number` |
| `mission_complete` | Missão finalizada | `mission_id`, `duration_seconds`, `stars_earned` |
| `mission_abandon` | Missão abandonada | `mission_id`, `step_number` |
| `minigame_start` | Mini-jogo iniciado | `minigame_id`, `difficulty` |
| `minigame_complete` | Mini-jogo finalizado | `minigame_id`, `score`, `stars` |
| `minigame_abandon` | Mini-jogo abandonado | `minigame_id`, `time_played` |
| `item_collect` | Item coletado | `item_id`, `item_type`, `location_id` |
| `sticker_collect` | Figurinha coletada | `sticker_id`, `album_progress` |
| `avatar_customize` | Avatar customizado | `part_changed`, `new_item_id` |

### Eventos de Progressão

| Evento | Quando disparar | Parâmetros |
|--------|-----------------|------------|
| `level_up` | Progressão de nível (se aplicável) | `new_level` |
| `district_unlock` | Bairro desbloqueado | `district_id`, `mission_that_unlocked` |
| `location_unlock` | Local desbloqueado | `location_id` |
| `collection_complete` | Coleção finalizada | `collection_type`, `total_items` |
| `achievement_unlock` | Conquista desbloqueada | `achievement_id` |
| `daily_mission_complete` | Missão diária concluída | `day_of_week`, `mission_id` |

### Eventos de Monetização

| Evento | Quando disparar | Parâmetros |
|--------|-----------------|------------|
| `trial_started` | Período trial iniciado | `source`, `days_since_install` |
| `subscription_viewed` | Tela de subscription visualizada | `plan_type`, `source_screen` |
| `subscription_purchased` | Assinatura comprada | `plan_type`, `price`, `currency`, `trial_days_remaining` |
| `subscription_cancelled` | Assinatura cancelada | `plan_type`, `days_since_purchase`, `reason` (se disponível) |
| `subscription_renewed` | Assinatura renovada | `plan_type`, `renewal_count` |
| `subscription_expired` | Assinatura expirada | `plan_type`, `days_since_cancel` |

### Eventos de Engajamento

| Evento | Quando disparar | Parâmetros |
|--------|-----------------|------------|
| `push_notification_received` | Push recebido | `campaign_id`, `notification_type` |
| `push_notification_opened` | Push aberto | `campaign_id`, `notification_type` |
| `share` | Conteúdo compartilhado | `content_type`, `destination` |
| `rate_app_prompt_shown` | Prompt de avaliação exibido | `sessions_count` |
| `rate_app_prompt_accepted` | Usário aceitou avaliar | `rating` (se aplicável) |
| `rate_app_prompt_dismissed` | Usuário dispensou | `dismiss_reason` |

### Eventos do Painel dos Pais

| Evento | Quando disparar | Parâmetros |
|--------|-----------------|------------|
| `parent_dashboard_open` | Painel aberto | `auth_method` |
| `time_limit_set` | Limite de tempo configurado | `limit_minutes` |
| `bedtime_block_set` | Bloqueio noturno configurado | `block_time` |
| `progress_exported` | Progresso exportado | `format` |
| `progress_reset` | Progresso resetado | `reason` |

---

## 📱 Dashboards

### Dashboard de Produto (Diário)

Métricas que JV deve olhar todo dia:

```
┌─────────────────────────────────────────────────┐
│  MUNDINHO DIVERTIDO — Dashboard Diário          │
├─────────────────────────────────────────────────┤
│                                                 │
│  👥 Usuários                                    │
│     DAU:        ___     Meta: ___               │
│     Novos:      ___     Meta: ___               │
│                                                 │
│  ⏱️ Engajamento                                 │
│     Sessões/dia: ___    Meta: 2+                │
│     Tempo médio: ___    Meta: >5min             │
│                                                 │
│  🔄 Retenção                                    │
│     D1: ___%            Meta: >50%              │
│     D7: ___%            Meta: >20%              │
│     D30: ___%           Meta: >10%              │
│                                                 │
│  🎮 Gameplay                                    │
│     Missões completadas: ___                    │
│     Mini-jogos jogados: ___                     │
│     Locais mais visitados: ___                  │
│                                                 │
│  🐛 Saúde Técnica                               │
│     Crashes: ___        Meta: 0                 │
│     ANR: ___            Meta: 0                 │
│     Rating: ___         Meta: 4.5+              │
│                                                 │
└─────────────────────────────────────────────────┘
```

### Dashboard de Monetização (Semanal)

```
┌─────────────────────────────────────────────────┐
│  MUNDINHO DIVERTIDO — Dashboard Semanal         │
├─────────────────────────────────────────────────┤
│                                                 │
│  💰 Receita                                     │
│     MRR: R$ ___         Meta: R$ 2.000+         │
│     Receita semana: R$ ___                      │
│                                                 │
│  📈 Conversão                                   │
│     Trial starts: ___                           │
│     Trial-to-paid: ___% Meta: >15%              │
│     Churn: ___%         Meta: <8%               │
│                                                 │
│  🛒 Planos                                      │
│     Mensal: ___%        Anual: ___%             │
│     Early adopter: ___%                         │
│                                                 │
│  💎 LTV                                         │
│     LTV estimado: R$ ___  Meta: >R$ 35          │
│     CAC estimado: R$ ___  Meta: <R$ 15          │
│                                                 │
└─────────────────────────────────────────────────┘
```

### Dashboard de Playtest (Pós-teste)

```
┌─────────────────────────────────────────────────┐
│  MUNDINHO DIVERTIDO — Playtest Report           │
├─────────────────────────────────────────────────┤
│                                                 │
│  👶 Participantes                               │
│     Quantidade: ___     Idades: ___             │
│     Duração média: ___  Observador: ___         │
│                                                 │
│  😊 Emocional                                   │
│     Sorriu em 30s? ___%   Meta: >80%            │
│     Jogou 10min solo? ___% Meta: >70%           │
│     Quis jogar de novo? ___%                    │
│                                                 │
│  ❓ Dificuldades                                │
│     Pediu ajuda para: ___                       │
│     Ficou frustrado em: ___                     │
│     Não entendeu: ___                           │
│                                                 │
│  💬 Feedback verbal                             │
│     Coisas que gostou: ___                      │
│     Coisas que não gostou: ___                  │
│     Sugestões espontâneas: ___                  │
│                                                 │
│  📝 Ações                                       │
│     [ ] Item crítico para corrigir              │
│     [ ] Item importante para melhorar           │
│     [ ] Ideia para nova feature                 │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## 🔒 Privacidade nos Analytics

> **Regra de ouro:** Coletamos o mínimo necessário para tomar decisões de produto. Nada mais.

### O que NUNCA coletamos

- Nome real da criança
- Endereço, email, telefone
- Fotos ou gravações
- Localização precisa (GPS)
- Identificadores persistentes de advertising (IDFA/GAID)

### O que coletamos (anônimo)

- Estatísticas de gameplay (tempo, missões, mini-jogos)
- Modelo do dispositivo e versão do OS (para otimização)
- Crash logs e stack traces
- Eventos de uso de funcionalidades (para priorizar desenvolvimento)

### Consentimento

- Analytics **desabilitado por padrão** no primeiro launch
- Painel dos pais permite habilitar/desabilitar a qualquer momento
- Quando habilitado, dados são anonimizados antes de envio
- Sem analytics = jogo funciona 100%, sem limitações

---

## 🧪 Instrumentação de Código

### Exemplo: Evento de Missão

```dart
// lib/core/services/analytics_service.dart

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static bool _enabled = false;

  static void setEnabled(bool enabled) {
    _enabled = enabled;
    _analytics.setAnalyticsCollectionEnabled(enabled);
  }

  static Future<void> logMissionComplete({
    required String missionId,
    required int durationSeconds,
    required int starsEarned,
  }) async {
    if (!_enabled) return;

    await _analytics.logEvent(
      name: 'mission_complete',
      parameters: {
        'mission_id': missionId,
        'duration_seconds': durationSeconds,
        'stars_earned': starsEarned,
      },
    );
  }

  // ... outros métodos
}
```

### Exemplo: Uso no código de missão

```dart
// Dentro do MissionManager quando missão é completada
AnalyticsService.logMissionComplete(
  missionId: mission.id,
  durationSeconds: mission.duration.inSeconds,
  starsEarned: result.stars,
);
```

---

## 📋 Checklist de Instrumentação

Toda feature nova deve:

- [ ] Definir quais eventos ela precisa rastrear (antes de codar)
- [ ] Implementar disparo dos eventos no código
- [ ] Testar se eventos aparecem no DebugView do Firebase
- [ ] Documentar eventos neste arquivo (se for evento novo)
- [ ] Verificar se evento não envia PII (Personally Identifiable Information)

---

## 🎯 Metas de Curto Prazo (Próximos 30 dias)

| # | Meta | Responsável | Deadline |
|---|------|-------------|----------|
| 1 | Configurar Firebase Analytics + Crashlytics | JV | Semana 1 |
| 2 | Implementar `AnalyticsService` base | JV | Semana 1 |
| 3 | Instrumentar todos os eventos de tutorial | JV | Semana 2 |
| 4 | Instrumentar todos os eventos de missão | JV | Semana 2 |
| 5 | Criar dashboard manual (planilha) | Jaime | Semana 2 |
| 6 | Primeiro playtest com 3+ crianças | JV | Semana 3 |
| 7 | Preencher primeiro Dashboard de Playtest | JV | Semana 3 |
| 8 | Revisar métricas e ajustar eventos | JV | Semana 4 |

---

*Métricas não são luxo. São oxigênio para decisões inteligentes.*
