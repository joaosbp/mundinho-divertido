# Mundinho Divertido — Game Design Document (GDD)

> **Versão:** 2.0  
> **Última atualização:** 2026-05-12  
> **CEO Founder:** JV  
> **Assistente:** Jaime

---

## 🎮 Visão Geral

**Mundinho Divertido** é um jogo de mundo aberto infantil onde crianças exploram uma cidade interativa, completam missões educativas e brincam livremente com personagens e ambientes. O jogo combina:

- **Exploração livre** ao estilo sandbox (The Sims)
- **Missões narrativas** com objetivos claros (GTA, sem violência)
- **Mini-jogos educativos** em cada local da cidade
- **Progressão por descoberta**, não por competição

### Público-alvo
- **Idade:** 6 a 15 anos
- **Localização:** Brasil (português nativo, cultura brasileira)
- **Dispositivo:** Celulares Android (Android 8+, 2GB RAM) e iOS (futuro)
- **Contexto:** Jogos casuais a imersivos, sessões de 5-40 minutos
- **Habilidades:** Leitura básica (6-7 anos) a fluente (12-15 anos). Interface híbrida: ícones + texto progressivo
- **Tom:** Infantil para 6-8 anos, tween para 9-12, teen leve para 13-15. O jogo escala a complexidade conforme a idade do jogador.

---

## 🎯 Core Game Loop

```
EXPLORAR → INTERAGIR → COMPLETAR → RECOMPENSAR → DESBLOQUEAR → REPETIR
```

### Fluxo detalhado:

1. **Explorar** a cidade livremente (andar, correr, andar de bike, ônibus)
2. **Interagir** com locais, NPCs e objetos (tocar para abrir portas, falar com personagens)
3. **Completar** mini-jogos ou missões (ajudar o padeiro, levar carta no correio, cuidar do zoológico)
4. **Receber recompensas** (estrelas, adesivos, novas roupas, moedas)
5. **Desbloquear** novos locais, personagens ou missões
6. **Repetir** — explorar mais, descobrir segredos, jogar mini-games avulsos

### Momentos de Jogabilidade:

| Momento | Descrição | Exemplo |
|---------|-----------|---------|
| **Descoberta** | Encontrar algo novo sozinho | "Tem um peixe colorido na lagoa!" |
| **Conquista** | Completar uma missão | "Ajudei o bombeiro a apagar o fogo!" |
| **Criatividade** | Personalizar o avatar/casa | "Coloquei um chapéu de palhaço no meu personagem!" |
| **Social** | Interagir com NPCs | "A vovó Maria me deu um biscoito!" |
| **Surpresa** | Eventos aleatórios | "Começou a chover! Os sapinhos saíram!" |

---

## 🗺️ Visão de Longo Prazo — Cidade do Mundinho

> **Esta seção descreve a visão completa do mundo.** O MVP inicial terá apenas 1 bairro com 8-10 locais. Veja o Roadmap para o plano de expansão gradual.

A cidade é dividida em **bairros temáticos**, cada um com identidade visual própria:

### Bairros Planejados (Visão Completa — 12-24 meses)

| Bairro | Tema | Locais principais |
|--------|------|-------------------|
| **Centro** | Urbano, comercial | Prefeitura, banco, correios, lojas |
| **Vila Saúde** | Saúde e bem-estar | Hospital, farmácia, clínicas, academia |
| **Bairro Escola** | Educação e cultura | Escola, biblioteca, museu, teatro |
| **Mercadão** | Comércio e alimentação | Mercado, padaria, açougue, hortifrúti |
| **Parque da Cidade** | Natureza e lazer | Parque, lagoa, playground, zoológico |
| **Bombeiros & Cia** | Segurança | Quartel bombeiros, delegacia, rodoviária |
| **Aeroporto** | Transporte | Aeroporto, heliporto, torre de controle |
| **Vila Religiosa** | Espiritualidade | Igreja, capela, centro comunitário |

### Bairros Futuros (Expansões — 24-36 meses)

| Bairro | Tema |
|--------|------|
| Praia do Mundinho | Litoral, praias, barcos |
| Serra Verde | Montanhas, camping, fazenda |
| Vila Tecnológica | Robótica, espaço, ciência |
| Bairro das Artes | Pintura, música, dança |
| Bairro Noturno | Entretenimento noturno, cinema, shows |
| Ilha Misteriosa | Exploração, tesouros, aventura |

---

## 👤 Personagens

### Personagem Jogável (Avatar)
- Criança de 6-7 anos (neutro em gênero por padrão, customizável)
- Customização: cabelo, roupa, calçado, acessórios, cor de pele
- Expressões faciais animadas (feliz, triste, surpreso, pensativo)
- Andar, correr, pular, sentar, dormir, dançar, acenar

### NPCs Principais (Cada local tem 1-3 personagens fixos)

| Personagem | Local | Função | Personalidade |
|------------|-------|--------|---------------|
| **Prefeito Tico** | Prefeitura | Dá missões de cidadania | Engraçado, gagueja quando nervoso |
| **Dona Rosa** | Padaria | Vende pães, ensina receitas | Mãezona, cheira a canela |
| **Dr. Pipo** | Hospital | Cura personagens, ensina saúde | Sempre com estetoscópio gigante |
| **Sargento Faísca** | Bombeiros | Missões de segurança | Corajoso, mas medo de aranhas |
| **Tia Júlia** | Escola | Professora, mini-jogos educativos | Paciente, usa óculos coloridos |
| **Seu João** | Mercado | Vende frutas, ensina cores/números | Conta piadas ruins |
| **Vovó Maria** | Igreja | Histórias, eventos comunitários | Sábia, distribui biscoitos |
| **Piloto Zeca** | Aeroporto | Viagens, ensina geografia | Sonhador, fala de nuvens |
| **Bióloga Bia** | Zoológico | Cuida animais, ensina natureza | Apaixonada por borboletas |
| **Detetive Lupa** | Delegacia | Missões de encontrar objetos | Curiosa, sempre investigando |

### NPCs Aleatórios
- Cidadãos com rotinas diárias (vão trabalhar, fazem compras, passeiam no parque)
- Animais de estimação (cachorros, gatos, pássaros)
- Animais selvagens (no parque e zoológico)
- Veículos com personagens (ônibus, carros, ambulância, caminhão de bombeiro)

---

## 🕹️ Mecânicas Principais

### 1. Movimentação
- **Toque para andar:** toca no chão, personagem caminha até lá
- **Toque duplo para correr:** mais rápido, gasta energia
- **Arrastar:** empurra objetos (caixas, carrinho de compras)
- **Veículos:** pode andar de bicicleta, patinete, ônibus (rotas fixas)

### 2. Interação
- **Toque em NPCs:** diálogo por ícones/balões (sem texto denso)
- **Toque em portas:** entra/sai de locais (transição suave)
- **Toque em objetos:** coleta, usa ou ativa
- **Pressionar e segurar:** ações especiais (abrir cofre, plantar semente)

### 3. Inventário
- Mochila visual com ícones grandes
- Itens: roupas, adesivos, comidas, ferramentas, coleções
- Máximo 12 itens visíveis (rolagem horizontal simples)

### 4. Energia e Bem-estar
- **Energia:** gasta ao correr, brincar muito. Recarrega dormindo ou comendo.
- **Fome:** precisa comer (padaria, mercado, casa).
- **Felicidade:** sobe ao brincar, completar missões, interagir com amigos.
- **Higiene:** toma banho em casa ou na praia (futuro).

### 5. Ciclo Dia/Noite
- Ciclo de 15 minutos reais = 1 dia no jogo
- Lojas fecham à noite (com sinalização visual: luzes apagadas, portas fechadas)
- Eventos noturnos: fogueira no parque, estrelas no céu, luzes da cidade
- NPCs vão para casa dormir

### 6. Clima e Eventos
- **Sol, chuva, nublado, vento** — afetam visuais e algumas atividades
- Chuva: usa guarda-chuva, sapinhos aparecem, poças d'água para pular
- Eventos aleatórios: desfile na rua principal, feira no parque, fogos no aeroporto

---

## 📱 Interface (Princípios)

- **Zero texto obrigatório:** tudo por ícones, cores e animações
- **Botões grandes:** mínimo 64x64dp (dedo de criança)
- **Feedback visual imediato:** toque = som + animação + vibração suave
- **Sem menus aninhados:** máximo 2 níveis de navegação
- **Tutorial integrado:** a personagem Tia Júlia guia o jogador nas primeiras 10 minutos

### HUD Simplificado

```
┌─────────────────────────────────────┐
│  ⭐ 12  🪙 45               ⚙️  👤  │  ← Topo: estrelas, moedas, config, avatar
│                                     │
│                                     │
│         [MUNDO ABERTO]              │  ← Área de jogo (90% da tela)
│                                     │
│                                     │
│         🎒  [JOystick virtual]      │  ← Baixo: inventário, movimento
└─────────────────────────────────────┘
```

---

## 🎨 Diretrizes Visuais

### Estilo Gráfico
- **2.5D isométrico** ou **top-down com profundidade** (estilo Animal Crossing / Stardew Valley)
- **Cores vibrantes** e saturadas (paletas primárias com tons pastel)
- **Formas arredondadas:** sem cantos agudos
- **Animações suaves:** tweening em todos os movimentos
- **Personagens "chibi":** cabeça grande, corpo pequeno, expressões exageradas

### Paleta de Cores por Bairro

| Bairro | Cor Principal | Cor Secundária |
|--------|--------------|----------------|
| Centro | 🟡 Amarelo | 🟠 Laranja |
| Saúde | 🔵 Azul claro | ⚪ Branco |
| Escola | 🟢 Verde | 🟡 Amarelo |
| Mercadão | 🔴 Vermelho | 🟢 Verde |
| Parque | 🟢 Verde grama | 🔵 Azul céu |
| Bombeiros | 🔴 Vermelho | ⚪ Branco |
| Aeroporto | 🔵 Azul | ⚪ Branco |
| Igreja | 🟣 Roxo | 🟡 Dourado |

### Performance
- Sprites em atlas (texture atlas) para reduzir draw calls
- Máximo 50 sprites animados simultâneos na tela
- Resolução base: 1080x1920 (escala para outros tamanhos)
- Tamanho do APK final: < 100MB

---

## 🔊 Áudio

### Música
- **Música ambiente por bairro:** estilo lo-fi, instrumental, leve
- **Música de mini-jogos:** mais ritmada e animada
- **Transições suaves:** crossfade entre faixas
- **Opção de desativar:** botão visível no menu

### Efeitos Sonoros (SFX)
- Todos os sons com pitch mais alto (mais "fofinho")
- Feedback sonoro em toda interação
- Vozes dos NPCs: "bla bla bla" estilizado (sem palavras reais, apenas entonação)
- Sons de ambiente: pássaros, carros distantes, vento, chuva

### Localização de Áudio
- Sons em português (SFX com nomes em PT-BR quando necessário)
- Considerar opção de narração por voz (futuro)

---

## 📊 Progressão e Sistema de Recompensas

### Moedas do Jogo
- **🪙 Moedinhas:** ganha em missões e mini-jogos. Usa para comprar roupas e itens.
- **⭐ Estrelas:** conquistas especiais. Desbloqueiam locais e personagens raros.
- **❤️ Corações:** relacionamento com NPCs. Mais corações = mais missões e presentes.

### Níveis de Jogador
- Não há "nível" tradicional. A progressão é por **descoberta** e **coleções**.
- **Álbum de Figurinhas:** coleciona figurinhas de cada local/personagem
- **Medalhas:** conquistas por tipo de atividade ("Amigo dos Animais", "Chefe da Cozinha")

### Sistema de "Dias Especiais"
- **Segunda:** Início de semana, missões de organização
- **Quarta:** Meio de semana, mini-jogos de raciocínio
- **Sexta:** Preparativos para o fim de semana
- **Sábado:** Evento especial no parque
- **Domingo:** Dia de descansar, missões relaxantes
- **Eventos sazonais:** Dia das Crianças, Natal, Páscoa, Festa Junina, Carnaval

---

## 🧪 Sistema de Missões (Visão Completa)

> **Missões escalam em complexidade conforme idade:**
> - **6-8 anos:** Ícones predominantes, texto curto, missões de 3 passos
> - **9-12 anos:** Texto + ícones, missões de 5-7 passos, escolhas simples
> - **13-15 anos:** Narração rica, missões de 8-12 passos, consequências, moralidade

### Tipos de Missões

| Tipo | Descrição | Duração | Idade |
|------|-----------|---------|-------|
| **Tutorial** | Primeiros passos com Tia Júlia | 5-10 min | 6+ |
| **História Principal** | Missões que desbloqueiam novos bairros | 10-25 min cada | 8+ |
| **Missões de Local** | Específicas de cada edifício | 3-15 min cada | 6+ |
| **Mini-jogos Avulsos** | Jogos rápidos em qualquer momento | 1-5 min cada | 6+ |
| **Missões Diárias** | 3 missões novas por dia | 2-8 min cada | 6+ |
| **Missões de Classe** | Desafios por faixa etária | 10-20 min | 9+ |
| **Eventos Especiais** | Temporadas, feriados | variável | 6+ |
| **Missões Secretas** | Descobertas explorando | 15-30 min | 10+ |

### Exemplo de Missão Principal (6-8 anos — Versão Simples)

**"O Grande Bolo da Vovó Maria"**
1. Vovó Maria pede ajuda para fazer um bolo
2. Jogador vai ao mercado comprar ingredientes (mini-jogo: encontrar itens na prateleira)
3. Vai à padaria pegar farinha especial (mini-jogo: peneirar farinha)
4. Vai à farmácia pegar essência de baunilha
5. Volta para a igreja (centro comunitário) e ajuda a misturar (mini-jogo: seguir receita)
6. Entrega o bolo na prefeitura para a festa da cidade
7. Recompensa: Estrela + receita no álbum + chapéu de cozinheiro

### Exemplo de Missão Principal (12-15 anos — Versão Ousada)

**"A Conspiração do Bolo Envenenado"**
1. Vovó Maria encomenda um bolo para a festa do prefeito
2. Na cozinha, alguém sabotou os ingredientes — o jogador encontra pistas
3. Missão investigativa: interrogar NPCs, encontrar provas, deduzir culpado
4. Escolha moral: expor o culpado publicamente ou dar uma lição privada
5. Consequências: diferentes finais afetam relações com NPCs e desbloqueiam missões futuras
6. Recompensa: Estrela + Badge "Detetive" + Nova missão secreta desbloqueada

---

## 🚫 O Que NÃO Terá no Jogo

| ❌ Restrição | Motivo |
|-------------|--------|
| Violência gráfica | Público infantil/juvenil |
| Microtransações diretas (loot boxes, gems) | Somente subscription e expansões |
| Temporizadores de energia que forçam pagamento | Anti-frustração |
| Chat online aberto com estranhos | Segurança infantil |
| Anúncios de terceiros | Experiência premium (sem anúncios) |
| Conteúdo assustador/terror | Idade 6-15 anos |
| Competição agressiva (PvP, ranking público) | Foco em exploração e criatividade |
| Compartilhamento de dados pessoais | LGPD / Privacidade |

---

## 🌟 Diferenciais Competitivos

1. **100% Brasileiro:** cultura, personagens, locais, festas, comidas, expressões
2. **Mundo realista e educativo:** crianças aprendem sobre cidade, profissões, cidadania
3. **Jogabilidade simples:** um toque para tudo, sem tutoriais chatos
4. **Expansível:** novos bairros, missões e personagens adicionados regularmente
5. **Offline-first:** funciona sem internet (sincroniza quando conecta)
6. **Modo "Mãe/Pai":** painel para acompanhar tempo de jogo e atividades do filho

---

## 📝 Notas para Futuras Versões

- **Multiplayer local:** 2 crianças no mesmo WiFi explorando juntas
- **Editor de casa:** decorar a casa do personagem com móveis
- **Pets:** adotar e cuidar de animais de estimação
- **Bairros novos:** praia, serra, espaço, fundo do mar
- **Modo foto:** tirar screenshots com filtros e adesivos

---

*Documento vivo — atualizar conforme o jogo evolui.*
