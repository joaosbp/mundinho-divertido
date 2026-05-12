# Mundinho Divertido — Arquitetura Multiagente

> **Versão:** 1.0  
> **Data:** 2026-05-12  
> **Orquestrador:** Jaime (assistente principal)  
> **CEO Founder:** JV

---

## 🏛️ Visão Geral

O desenvolvimento do Mundinho Divertido segue uma **arquitetura multiagente orientada a missões**. Cada agente é um subagente isolado do OpenClaw com contexto próprio, responsabilidade única e entregáveis verificáveis.

**Princípios:**
- Contexto isolado — cada agente vê apenas o que precisa
- Comunicação objetiva — entregáveis, não conversas
- Roteamento inteligente de LLM — modelo adequado à tarefa
- Memória de tarefa — decisões e bloqueios registrados
- Execução paralela quando possível

---

## 🤖 Agentes

### 1. Product Manager Agent (PM)

| Atributo | Valor |
|----------|-------|
| **ID** | `agent:pm` |
| **LLM padrão** | Kimi |
| **Responsabilidades** | Entender objetivos, definir roadmap, quebrar funcionalidades, priorizar backlog, criar missões executáveis |
| **Entregáveis** | Missões formatadas, backlog priorizado, critérios de aceitação |
| **Arquivos** | `docs/MISSOES_*.md`, `docs/BACKLOG.md` |

**Quando atuar:**
- Nova feature solicitada pelo JV
- Replanejamento de sprint
- Priorização de débito técnico
- Definição de escopo

---

### 2. Architect Agent (ARC)

| Atributo | Valor |
|----------|-------|
| **ID** | `agent:arch` |
| **LLM padrão** | ChatGPT 5.5 (para decisões críticas) / Kimi (para rotina) |
| **Responsabilidades** | Definir arquitetura, stack, padrões, modularização, contratos, estratégias de escalabilidade |
| **Entregáveis** | ADRs (Architecture Decision Records), contratos de API, diagramas, refatorações aprovadas |
| **Arquivos** | `docs/ARQUITETURA.md`, `docs/ADRs/*.md`, `docs/CONTRATOS.md` |

**Quando atuar:**
- Antes de qualquer feature que toque em >3 módulos
- Quando há dúvida sobre padrão a seguir
- Revisão de PR complexo
- Refatoração estrutural

---

### 3. Android Specialist Agent (DROID)

| Atributo | Valor |
|----------|-------|
| **ID** | `agent:droid` |
| **LLM padrão** | Gemini 3.1 Pro |
| **Responsabilidades** | Kotlin, Compose, Gradle, performance mobile, integrações Android, permissões, ciclo de vida, otimização |
| **Entregáveis** | Código Android nativo, configurações Gradle, otimizações de build, análise de performance |
| **Arquivos** | `android/`, configurações de build, análises de performance |

**Quando atuar:**
- Qualquer mudança em `android/`
- Problemas de build/release
- Otimização de APK
- Integração com SDKs Android

---

### 4. Backend Agent (BEND)

| Atributo | Valor |
|----------|-------|
| **ID** | `agent:bend` |
| **LLM padrão** | Kimi |
| **Responsabilidades** | APIs, banco de dados, autenticação, filas, cache, infraestrutura backend |
| **Entregáveis** | Endpoints, schemas, migrations, configs de infra |
| **Arquivos** | `backend/`, `functions/`, configs Firebase |

**Quando atuar:**
- Sync em nuvem (futuro)
- Backend para multiplayer (futuro)
- APIs de analytics

**Nota:** No MVP o projeto é offline-first. Este agente fica em standby.

---

### 5. Frontend/UI Agent (FE)

| Atributo | Valor |
|----------|-------|
| **ID** | `agent:fe` |
| **LLM padrão** | Kimi |
| **Responsabilidades** | Interfaces, UX, design system, componentes, acessibilidade, responsividade |
| **Entregáveis** | Widgets Flutter, telas, animações, assets UI |
| **Arquivos** | `lib/ui/`, `lib/screens/`, `assets/images/ui/` |

**Quando atuar:**
- Nova tela ou componente
- Melhoria de UX
- Sistema de design
- Animações e transições

---

### 6. QA/Testing Agent (QA)

| Atributo | Valor |
|----------|-------|
| **ID** | `agent:qa` |
| **LLM padrão** | Kimi |
| **Responsabilidades** | Testes, validações, edge cases, regressões, testes automatizados, smoke tests |
| **Entregáveis** | Testes unitários, testes de widget, testes de integração, relatórios de QA |
| **Arquivos** | `test/`, `integration_test/` |

**Quando atuar:**
- Após conclusão de cada missão de código
- Antes de merge na main
- Quando bug é reportado
- Regressão detectada

---

### 7. DevOps Agent (OPS)

| Atributo | Valor |
|----------|-------|
| **ID** | `agent:ops` |
| **LLM padrão** | Kimi |
| **Responsabilidades** | CI/CD, containers, deploy, observabilidade, monitoramento, automação operacional |
| **Entregáveis** | Pipelines, scripts, configs de deploy, dashboards de monitoramento |
| **Arquivos** | `.github/workflows/`, `Dockerfile`, scripts de deploy |

**Quando atuar:**
- Setup de CI/CD
- Build de release
- Deploy na Play Store
- Monitoramento de crashes

---

## 🧠 Roteamento de LLM

| Tipo de Tarefa | LLM Recomendado | Motivo |
|----------------|-----------------|--------|
| Execução cotidiana, código Flutter, refatorações | **Kimi** | Velocidade, baixo custo, bom para Dart/Flutter |
| Android nativo, Kotlin, Gradle, performance mobile | **Gemini 3.1 Pro** | Especialista Android, long context |
| Arquitetura crítica, decisões sistêmicas, debugging difícil, segurança | **ChatGPT 5.5** | Principal engineer, reasoning avançado |
| Análise de grandes codebases, documentação massiva | **Gemini 3.1 Pro** | Long context, análise profunda |
| Planejamento multiagente, revisão técnica final | **ChatGPT 5.5** | Visão sistêmica, trade-offs |

---

## 📋 Formato de Missão

```markdown
MISSÃO: [nome curto e claro]

Objetivo: [descrição em 1-2 frases do que deve ser alcançado]

Responsável: [agente_id]
LLM recomendado: [Kimi | Gemini 3.1 Pro | ChatGPT 5.5]

Entradas:
- [arquivos/contexto necessários]

Saídas esperadas:
- [arquivos/entregáveis concretos]

Critérios de conclusão:
- [ ] critério 1 (mensurável)
- [ ] critério 2 (mensurável)

Dependências:
- [missão_id] — [descrição do que precisa estar pronto]

Riscos:
- [risco 1] → [mitigação]

Prioridade: [P0 | P1 | P2 | P3]
Estimativa: [X horas/dias]
```

---

## 🔄 Fluxo Operacional

```
1. JV solicita feature / Jaime identifica necessidade
         ↓
2. PM Agent define escopo e quebra em missões
         ↓
3. Architect Agent revisa abordagem técnica (se necessário)
         ↓
4. Missões são criadas no formato padrão
         ↓
5. Orquestrador (Jaime) delega tarefas aos agentes
         ↓
6. Cada agente executa isoladamente (subagente)
         ↓
7. QA Agent valida entregáveis
         ↓
8. Architect revisa integração (se necessário)
         ↓
9. ChatGPT 5.5 faz revisão crítica final (missões complexas)
         ↓
10. Merge na main + documentação atualizada
```

---

## 📁 Arquivos de Estado

| Arquivo | Propósito |
|---------|-----------|
| `docs/MISSOES_MVP.md` | Missões ativas e pendentes do MVP |
| `docs/MISSOES_CONCLUIDAS.md` | Missões finalizadas com lições aprendidas |
| `docs/ADRS/` | Architecture Decision Records |
| `docs/BLOQUEIOS.md` | Bloqueios ativos e resoluções |
| `memory/agent-state.json` | Estado atual do orquestrador |

---

## 🚀 Execução Atual

**Fase:** MVP — Bairro Centro (Semanas 3-6)  
**Status:** Missão 1 em andamento  
**Próxima revisão:** Após conclusão da Missão 3

*Arquivo atualizado pelo Orquestrador (Jaime) a cada heartbeat.*
