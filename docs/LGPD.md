# Mundinho Divertido — Conformidade LGPD, COPPA e Privacidade

> **Versão:** 2.0  
> **Data:** 2026-05-12  
> **Status:** Documento normativo — requisitos legais são não-negociáveis  
> **CEO Founder:** JV  
> **Assistente:** Jaime  
> **Jurisdições:** Brasil (LGPD) + Estados Unidos (COPPA) + União Europeia (GDPR-ready)

---

## 📌 Por que este documento existe

> *"Jogo para menores = requisito legal não-negociável."*

O Product Owner identificou **"falta de conformidade LGPD/COPPA"** como gap crítico. Este documento corrige isso definitivamente. **Nenhuma feature, coleta de dados ou integração de terceiros será aprovada sem revisão deste documento.**

---

## ⚖️ Base Legal e Regulamentações

### LGPD (Lei Geral de Proteção de Dados — Brasil)

| Aspecto | Aplicação ao Mundinho Divertido |
|---------|--------------------------------|
| **Lei** | Lei nº 13.709/2018 |
| **Aplicável?** | Sim — coletamos dados de crianças e adolescentes |
| **Base legal** | Consentimento do responsável legal (Art. 14) |
| **DPO necessário?** | Sim — quando operação envolve dados de crianças |
| **Registro de operações** | Obrigatório (Art. 38) |

### COPPA (Children's Online Privacy Protection Act — EUA)

| Aspecto | Aplicação ao Mundinho Divertido |
|---------|--------------------------------|
| **Lei** | 15 U.S.C. § 6501–6506 |
| **Aplicável?** | Sim — app direcionado a crianças menores de 13 anos |
| **Requisito chave** | Consentimento verificável dos pais antes de coletar qualquer dado |
| **FTC** | Federal Trade Commission aplica penalidades |
| **Multa** | Até US$ 51.744 por violação (atualizado 2024) |

### GDPR (General Data Protection Regulation — UE)

| Aspecto | Aplicação ao Mundinho Divertido |
|---------|--------------------------------|
| **Regulamento** | Regulation (EU) 2016/679 |
| **Aplicável?** | Indiretamente — se houver usuários na UE |
| **Base legal para menores** | Consentimento do titular da responsabilidade parental |
| **Idade mínima** | 16 anos (ou 13 com consentimento parental, conforme legislação local) |

---

## 🛡️ Princípios de Privacidade por Design

### 1. Minimização de Dados
> *"Coletamos apenas o que é estritamente necessário para o funcionamento do jogo."*

| Dado | Coletamos? | Por quê? | Onde fica? |
|------|-----------|----------|------------|
| Nome real | ❌ NÃO | Não necessário | — |
| Email | ❌ NÃO | Não necessário | — |
| Telefone | ❌ NÃO | Não necessário | — |
| Endereço | ❌ NÃO | Não necessário | — |
| Fotos | ❌ NÃO | Não necessário | — |
| Localização GPS | ❌ NÃO | Não necessário | — |
| ID de advertising (GAID/IDFA) | ❌ NÃO | Proibido por COPPA | — |
| Nome do personagem no jogo | ✅ SIM | Save local | Apenas no dispositivo |
| Progresso do jogo | ✅ SIM | Save local | Apenas no dispositivo |
| Configurações | ✅ SIM | Save local | Apenas no dispositivo |
| Modelo do dispositivo | ✅ SIM (anônimo) | Otimização de performance | Analytics (opt-in) |
| Versão do OS | ✅ SIM (anônimo) | Otimização de performance | Analytics (opt-in) |
| Estatísticas de gameplay | ✅ SIM (anônimo) | Melhorar o jogo | Analytics (opt-in) |
| Crash logs | ✅ SIM (anônimo) | Corrigir bugs | Crashlytics (opt-in) |

### 2. Consentimento Verificável dos Pais

**Fluxo obrigatório no primeiro launch:**

```
┌─────────────────────────────────────────┐
│  👨‍👩‍👧  Olá, pais e responsáveis!        │
├─────────────────────────────────────────┤
│                                         │
│  Antes de começar, precisamos da sua    │
│  autorização.                           │
│                                         │
│  O Mundinho Divertido:                  │
│  ✅ Não coleta dados pessoais           │
│  ✅ Não tem anúncios de terceiros       │
│  ✅ Não tem chat aberto                 │
│  ✅ Funciona sem internet               │
│                                         │
│  Opcionalmente, com sua permissão:      │
│  📊 Enviar estatísticas anônimas de uso │
│     (para melhorar o jogo)              │
│  🐛 Enviar relatórios de erro           │
│     (para corrigir bugs)                │
│                                         │
│  [✅ PERMITIR E COMEÇAR]                │
│  [▶️ COMEÇAR SEM PERMISSÕES]            │
│                                         │
│  📖 Ver Política de Privacidade completa│
│                                         │
└─────────────────────────────────────────┘
```

**Requisitos do consentimento:**
- [ ] Tela clara e separada para pais (não confundir com tutorial da criança)
- [ ] Explicação em linguagem simples (nível de jornal, não contrato jurídico)
- [ ] Checkbox separado para analytics e para crash reporting
- [ ] Nenhum dado é enviado antes do consentimento
- [ ] Consentimento pode ser revogado a qualquer momento no Painel dos Pais

### 3. Armazenamento Local como Padrão

```
┌─────────────────────────────────────────┐
│  ARQUITETURA DE DADOS                   │
├─────────────────────────────────────────┤
│                                         │
│  📱 Dispositivo (padrão)                │
│  ├── Hive: save do jogador              │
│  ├── SharedPrefs: configurações         │
│  └── Cache de assets                    │
│                                         │
│  ☁️ Nuvem (opcional, com consentimento) │
│  ├── Firebase Analytics (anônimo)       │
│  ├── Firebase Crashlytics (anônimo)     │
│  └── Future: backup de save (opt-in)    │
│                                         │
│  🚫 NUNCA na nuvem sem consentimento:   │
│  ├── Dados pessoais                     │
│  ├── Identificadores persistentes       │
│  └── Histórico de comportamento         │
│                                         │
└─────────────────────────────────────────┘
```

### 4. Transparência Total

**O que o jogador (e o pai) tem direito de saber:**

| Informação | Onde disponível |
|------------|----------------|
| Quais dados coletamos | Tela de consentimento + Política de Privacidade |
| Por que coletamos | Tela de consentimento + Política de Privacidade |
| Com quem compartilhamos | Política de Privacidade (resposta: ninguém) |
| Como excluir dados | Painel dos Pais + email para contato |
| Quanto tempo guardamos | Política de Privacidade |
| Quem é o DPO | Política de Privacidade + email |

---

## 📋 Política de Privacidade (Resumo Executivo)

> **Versão completa deve ser publicada no site e linkada na Play Store.**

### Resumo para Pais (1 minuto de leitura)

```
MUNDINHO DIVERTIDO — RESUMO DA PRIVACIDADE

🔒 O que NÃO fazemos:
   • Não pedimos nome, email, telefone ou endereço
   • Não tiramos fotos ou acessamos câmera
   • Não usamos sua localização
   • Não mostramos anúncios de terceiros
   • Não vendemos dados para ninguém

📱 O que fazemos (no seu dispositivo apenas):
   • Salvamos o progresso do jogo (personagem, missões, figurinhas)
   • Salvamos suas preferências (som, vibração, idioma)

📊 O que fazemos (somente com sua permissão):
   • Enviamos estatísticas anônimas de como o jogo é usado
   • Enviamos relatórios quando o jogo trava (para corrigirmos)

👨‍👩‍👧 Você está no controle:
   • Pode mudar permissões a qualquer momento no Painel dos Pais
   • Pode pedir para apagar todos os dados enviando email
   • Pode jogar 100% offline sem nenhuma permissão

📧 Dúvidas? Fale conosco: privacidade@mundinhodivertido.com.br
```

### Política Completa (Estrutura)

1. **Identificação do Controlador**
   - Nome: [Nome do desenvolvedor / JV]
   - CNPJ: [se houver]
   - Endereço: [se houver]
   - Email: privacidade@mundinhodivertido.com.br

2. **Dados Coletados**
   - Lista completa de dados coletados (conforme tabela acima)
   - Dados coletados automaticamente vs. fornecidos pelo usuário

3. **Finalidade**
   - Para que cada dado é usado
   - Base legal para cada finalidade

4. **Compartilhamento**
   - Não compartilhamos com terceiros (exceto prestadores de serviço essenciais: Firebase)
   - Firebase terms: https://firebase.google.com/terms

5. **Retenção**
   - Dados locais: até o app ser desinstalado
   - Dados de analytics: 14 meses (padrão Firebase)
   - Crash logs: 90 dias

6. **Direitos do Titular**
   - Acesso, correção, exclusão, portabilidade
   - Como exercer: Painel dos Pais ou email

7. **Segurança**
   - Medidas técnicas e administrativas
   - Criptografia em repouso (Hive criptografa save se habilitado)

8. **Crianças e Adolescentes**
   - Processo de consentimento parental
   - Como verificar idade (auto-declaração no perfil)
   - O que acontece se descobrimos que coletamos dados sem consentimento

9. **Cookies e Tecnologias Similares**
   - Não aplicável (app nativo, não web)

10. **Alterações**
    - Notificação no app e por email (se opt-in)

11. **Contato**
    - DPO: [nome/email]
    - ANPD: https://www.gov.br/anpd/pt-br

---

## 🔐 Medidas de Segurança

### Técnicas

| Medida | Implementação | Status |
|--------|--------------|--------|
| Criptografia de save local | Hive com criptografia AES | Planejado |
| Sem conta obrigatória | Não há login/senha | ✅ Implementado |
| Sem servidor de gameplay | Tudo é local | ✅ Implementado |
| Identificador anônimo no analytics | Firebase gera ID anônimo | ✅ Implementado |
| Não uso de IDFA/GAID | Desabilitado por padrão | ✅ Implementado |
| SSL em todas as comunicações | Firebase SDK já faz | ✅ Implementado |
| Validação de input | Sanitizar nomes de personagem | Planejado |
| Rate limiting | Limitar chamadas de analytics | Planejado |

### Administrativas

| Medida | Responsável | Status |
|--------|-------------|--------|
| Registro de operações na ANPD | JV | Pendente (após launch) |
| Nomeação de DPO | JV | Pendente |
| Treinamento de privacidade | JV + Jaime | Contínuo |
| Revisão de código para PII | JV | A cada PR |
| Incident response plan | JV | A criar |

---

## 🏛️ Registro de Operações (LGPD Art. 38)

### Operação 1: Salvamento de Progresso Local

| Campo | Valor |
|-------|-------|
| **Nome** | Salvamento de Progresso do Jogo |
| **Finalidade** | Permitir que o jogador continue de onde parou |
| **Base legal** | Execução de contrato (uso do app) |
| **Dados** | Nome do personagem, progresso, inventário, configurações |
| **Tempo de retenção** | Até desinstalação do app |
| **Compartilhamento** | Nenhum |
| **Medidas de segurança** | Armazenamento local criptografado |

### Operação 2: Analytics Anônimo

| Campo | Valor |
|-------|-------|
| **Nome** | Estatísticas de Uso Anônimas |
| **Finalidade** | Melhorar o jogo com base em comportamento agregado |
| **Base legal** | Consentimento do responsável |
| **Dados** | Eventos de gameplay (anônimos), modelo do dispositivo, versão do OS |
| **Tempo de retenção** | 14 meses |
| **Compartilhamento** | Google (Firebase Analytics) |
| **Medidas de segurança** | Dados anonimizados, sem PII |

### Operação 3: Crash Reporting

| Campo | Valor |
|-------|-------|
| **Nome** | Relatórios de Erro |
| **Finalidade** | Identificar e corrigir bugs |
| **Base legal** | Consentimento do responsável |
| **Dados** | Stack trace, modelo do dispositivo, versão do OS |
| **Tempo de retenção** | 90 dias |
| **Compartilhamento** | Google (Firebase Crashlytics) |
| **Medidas de segurança** | Sem dados de usuário, apenas técnico |

---

## ⚠️ Plano de Resposta a Incidentes

### Se descobrirmos que coletamos dados sem consentimento:

1. **Imediato (0-24h):**
   - Parar toda coleta involuntária
   - Identificar escopo do incidente (quais dados, quantos usuários)

2. **Curto prazo (24-72h):**
   - Notificar ANPD (se aplicável)
   - Notificar usuários afetados (se possível identificar)
   - Documentar o incidente

3. **Médio prazo (1-2 semanas):**
   - Excluir dados coletados indevidamente
   - Implementar correção técnica
   - Revisar processos para evitar reincidência

4. **Documentação:**
   - Registrar em `docs/INCIDENTES.md`
   - Incluir: data, descrição, impacto, ações tomadas, lições aprendidas

---

## ✅ Checklist de Conformidade Pré-Launch

- [ ] Política de Privacidade completa publicada (site ou in-app)
- [ ] Tela de consentimento parental implementada
- [ ] Analytics desabilitado por padrão
- [ ] Crash reporting desabilitado por padrão
- [ ] Painel dos Pais permite revogar consentimento
- [ ] Nenhum ID de advertising é coletado
- [ ] Nenhum dado pessoal identificável é coletado
- [ ] Registro de operações preparado para ANPD
- [ ] DPO designado (mesmo que seja o próprio JV)
- [ ] Email de contato para privacidade funciona
- [ ] Termos de Uso publicados
- [ ] App classificado como "Designed for Families" na Play Store
- [ ] Classificação etária correta na Play Store (Livre / Everyone)
- [ ] Sem anúncios de terceiros (verificado em build de release)
- [ ] Sem links para redes sociais não moderadas
- [ ] Sem chat aberto ou comunicação entre usuários

---

## 📚 Referências e Recursos

| Recurso | Link |
|---------|------|
| LGPD Completa | https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm |
| ANPD | https://www.gov.br/anpd/pt-br |
| COPPA FTC | https://www.ftc.gov/business-guidance/resources/complying-coppa-frequently-asked-questions |
| Google Play Families Policy | https://support.google.com/googleplay/android-developer/answer/9893335 |
| Firebase Data Processing | https://firebase.google.com/terms/data-processing-terms |
| GDPR | https://gdpr.eu/ |

---

*Privacidade não é feature. É fundamento.*
