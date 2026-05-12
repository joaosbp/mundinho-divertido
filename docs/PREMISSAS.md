# Mundinho Divertido — Premissas, Princípios, Diretrizes e Objetivos

> **Versão:** 2.0  
> **Data:** 2026-05-12  
> **Status:** Documento normativo — todas as decisões de design, código e negócio devem se alinhar a este arquivo  
> **CEO Founder:** JV  
> **Assistente:** Jaime

---

## 📌 O que é este documento

Este arquivo é a **constituição do projeto**. Ele existe para que, quando houver dúvida sobre qual caminho seguir, a resposta não seja "o que o CEO quer" ou "o que a moda manda", mas sim **o que os princípios do projeto ditam**.

A faixa etária de 6-15 anos é uma **referência de mercado**, não uma regra de design. O jogo deve ser pautado pelos princípios abaixo, independentemente de quem esteja jogando.

---

## 🏛️ Premissas (assumimos como verdade)

| # | Premissa | Implicação |
|---|----------|------------|
| P1 | **Crianças merecem respeito** — não são usuários "menores", são jogadores com capacidades diferentes | Zero condescendência, zero simplificação forçada, zero "babá digital" |
| P2 | **Pais são gatekeepers financeiros** — quem paga não é quem joga | Toda comunicação de valor deve ser direcionada ao responsável; a criança não deve sentir pressão de compra |
| P3 | **Contexto brasileiro é diferente** — não é tradução de produto gringo | Cultura, idioma, referências, ritmo e sensibilidade 100% brasileiros |
| P4 | **Dispositivos são variados** — do básico ao premium | Performance é requisito, não luxo. O jogo deve rodar bem em hardware modesto |
| P5 | **Conectividade é instável** — Brasil tem gaps de internet | Offline-first não é feature, é requisito de acessibilidade |
| P6 | **Single-dev com IA é o modelo** — não há equipe de 20 pessoas | Escolher tecnologias e arquiteturas que permitam 1 pessoa manter e evoluir |
| P7 | **Conteúdo educativo funciona quando é divertido** — não o contrário | Educação é efeito colateral da diversão, nunca o objetivo explícito do jogador |

---

## 🎯 Princípios (regras de ouro)

### Princípio 1 — Jogador em primeiro lugar
> *"Toda decisão de design deve responder: isso melhora a experiência do jogador?"*

- Se uma feature beneficia o negócio mas prejudica o jogador, ela não entra.
- Se uma feature é legal tecnicamente mas o jogador não sente diferença, ela espera.
- Se há dúvida, testar com jogadores reais vale mais do que qualquer opinião de time.

### Princípio 2 — Transparência total
> *"Não há lugar para surpresas desagradáveis em produto infantil."*

- Preço claro desde o primeiro segundo
- O que é grátis e o que é pago deve ser óbvio
- Dados coletados são zero ou anônimos; nunca ocultos
- Política de privacidade em português, acessível e curta

### Princípio 3 — Crescimento sustentável
> *"Melhor um jogo pequeno e perfeito do que um jogo grande e quebrado."*

- Escopo é o inimigo número 1
- Cortar sem piedade é mais difícil e mais valioso do que adicionar
- Qualidade > Quantidade, sempre
- Um bairro perfeito vale mais que oito medianos

### Princípio 4 — Autonomia progressiva
> *"O jogador deve sentir que é ele quem conduz a experiência, não o jogo."*

- Tutorial integrado, não forçado
- Múltiplos caminhos para o mesmo objetivo
- Escolhas que parecem ter consequência (mesmo que mínimas)
- Zero bloqueios por tempo, zero timers de espera

### Princípio 5 — Segurança por design
> *"Não é "seguro até provar o contrário". É "inseguro até provar o contrário"."*

- Zero chat aberto com estranhos
- Zero coleta de dados pessoais identificáveis de menores
- Zero anúncios de terceiros (risco de conteúdo inadequado)
- Painel dos pais como requisito, não feature opcional

### Princípio 6 — Acessibilidade como padrão
> *"Acessibilidade não é modo especial. É o modo normal."*

- Texto legível, botões grandes, cores com contraste adequado
- Opções de narração, vibração, velocidade de texto
- Modo daltonismo, alto contraste
- Jogável com uma mão quando possível

### Princípio 7 — Brasilidade autêntica
> *"Não é "jogo traduzido para o Brasil". É "jogo que só poderia ter sido feito no Brasil"."*

- Personagens, locais, comidas, festas, expressões e ritmos brasileiros
- Referências que crianças brasileiras reconhecem (e estrangeiros não precisam entender)
- Humor, calor humano e caos organizado típico do Brasil

---

## 📐 Diretrizes (como aplicamos os princípios)

### Design de Gameplay

| Diretriz | Aplicação |
|----------|-----------|
| D-G1 — Zero frustração | Não existe "game over". Existe "tentar de novo". Recompensas mesmo em tentativas imperfeitas. |
| D-G2 — Feedback imediato | Todo toque gera resposta visual, sonora e tátil em <100ms. |
| D-G3 — Progressão por descoberta | Níveis tradicionais são secundários. O que importa é o que o jogador descobriu e colecionou. |
| D-G4 — Ritmo respeitoso | Sessões de 5-40 min. Nunca forçar maratonas. Pausas naturais a cada missão. |
| D-G5 — Consistência de controles | Um toque sempre interage. Toque duplo sempre acelera. Nunca mudar mapping sem motivo. |

### Design de Interface

| Diretriz | Aplicação |
|----------|-----------|
| D-UI1 — Ícones universais | Toda ação deve ser compreensível sem texto. Texto é complemento, não requisito. |
| D-UI2 — Escalabilidade progressiva | UI começa minimalista e revela complexidade conforme o jogador demonstra maturidade (não idade). |
| D-UI3 — Navegação de 2 toques | Nenhuma ação importante deve exigir mais de 2 toques para ser alcançada. |
| D-UI4 — Estado sempre visível | O jogador deve saber, sem abrir menus: quanto tem, para onde vai, o que falta. |

### Design de Narrativa

| Diretriz | Aplicação |
|----------|-----------|
| D-N1 — NPCs com alma | Cada personagem tem gosto, medo, sonho e rotina. Não são vending machines de missão. |
| D-N2 — Histórias locais antes de globais | O drama da padaria importa tanto quanto a trama do prefeito. |
| D-N3 — Consequência leve | Escolhas têm consequências visíveis, mas nunca punem permanentemente o jogador. |
| D-N4 — Humor para todas as idades | Piadas que crianças de 6 anos riem e adolescentes de 15 anos também (em níveis diferentes). |

### Design Técnico

| Diretriz | Aplicação |
|----------|-----------|
| D-T1 — Modularidade obrigatória | Novo bairro = nova pasta. Nunca tocar código existente para adicionar conteúdo. |
| D-T2 — Performance como feature | 60 FPS é meta. 30 FPS é mínimo aceitável. Abaixo disso é bug. |
| D-T3 — Offline-first | Tudo funciona sem internet. Sync é bônus, não requisito. |
| D-T4 — Testes de regressão | Cada novo local deve ser testável isoladamente. Nada quebre o que já funcionava. |
| D-T5 — Documentação viva | Cada feature nova atualiza a docs antes do código ser mergeado. |

### Design de Negócio

| Diretriz | Aplicação |
|----------|-----------|
| D-NG1 — Monetização ética | A criança nunca vê tela de pagamento. O pai nunca se sente enganado. |
| D-NG2 — Valor antes do preço | 30 dias grátis não é "trial", é "demonstração de valor real". |
| D-NG3 — Transparência de dados | Se coletamos algo, dizemos o quê, por quê e como excluir. |
| D-NG4 — Crescimento orgânico | Marketing começa com o produto sendo bom o suficiente para ser recomendado. |

---

## 🎯 Objetivos (o que queremos alcançar)

### Objetivo Estratégico (3 anos)
> Tornar o Mundinho Divertido o jogo de mundo aberto infantojuvenil mais amado do Brasil, reconhecido por qualidade, ética e Brasilidade.

### Objetivos Táticos (1 ano)

| # | Objetivo | Métrica de sucesso |
|---|----------|-------------------|
| O1 | Lançar MVP com 1 bairro polido | 1.000+ downloads nos primeiros 30 dias |
| O2 | Validar modelo de subscription | 15%+ taxa de conversão trial-to-paid |
| O3 | Provar retenção | D1 > 50%, D7 > 20%, D30 > 10% |
| O4 | Estabelecer marca | 80%+ dos reviews mencionam "divertido" ou "educativo" |
| O5 | Manter qualidade técnica | 0 bugs críticos, 4.5+ estrelas na Play Store |

### Objetivos do MVP (3 meses)

| # | Objetivo | Critério de pronto |
|---|----------|-------------------|
| OM1 | Jogador sorri em 30s | Playtest: 80%+ das crianças sorriem nos primeiros 30 segundos |
| OM2 | Jogador joga 10 min sem ajuda | Playtest: 70%+ jogam 10+ min sem pedir ajuda a adulto |
| OM3 | Pai entende o valor em 2 min | Playtest: 90%+ dos pais entendem o que o jogo ensina em 2 min de observação |
| OM4 | Build estável | 0 crashes em 100 sessões de teste |
| OM5 | Documentação pronta para execução | Todos os docs normativos aprovados e versionados |

---

## 🧒 Sobre a Faixa Etária de Referência

> **6-15 anos é uma referência de mercado, não uma cadeia.**

Esta faixa indica que o jogo será **acessível desde cedo e interessante até a adolescência**, mas não impõe:
- Que uma criança de 5 anos não possa jogar (se tiver interesse e leitura assistida)
- Que um adolescente de 16 anos será expulso (se ainda se identificar)
- Que o design deve fazer compromissos ruins para agradar simultaneamente um público muito amplo

### Como usar a faixa etária corretamente

| Uso correto | Uso incorreto |
|-------------|---------------|
| "Referência para calibrar complexidade de linguagem" | "Regra rígida que limita conteúdo" |
| "Guia para testes com usuários" | "Desculpa para over-engineering de 4 tiers de UI" |
| "Comunicação com pais e lojas de apps" | "Fragmentação do produto em 4 jogos em 1" |

**Regra de decisão:** Se uma feature só existe para atender uma faixa etária específica e não serve os princípios do projeto, ela não entra no MVP.

---

## ✅ Checklist de Alinhamento

Antes de aprovar qualquer nova feature, missão, tela ou mudança estratégica, verificar:

- [ ] Alinha com pelo menos 3 dos 7 princípios?
- [ ] Não contradiz nenhuma premissa?
- [ ] Respeita todas as diretrizes da área correspondente?
- [ ] Contribui para pelo menos 1 objetivo tático?
- [ ] Se remove algo, o que ganha justifica o que perde?
- [ ] Foi testado (ou será testado) com jogadores reais?

**Se a resposta for "não" para qualquer item acima, a feature não é aprovada.**

---

*Este documento pode ser atualizado por JV a qualquer momento. Versões anteriores ficam no histórico do Git.*
