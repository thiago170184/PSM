# Prompt para Lovable — Pesquisa de Estrutura de PDVs

## Visão Geral do Projeto

Aplicação web para pesquisa e análise de estrutura de Pontos de Venda (PDVs) de eventos. O sistema tem duas interfaces principais:

1. **Formulário de Pesquisa** (`/pesquisa`) — página pública onde pesquisadores de campo preenchem dados sobre a estrutura de PDVs de eventos
2. **Dashboard Analítica** (`/dashboard`) — página administrativa com filtros, KPIs, índices de terminais, gráficos matriciais e listagem de eventos

## Stack Técnica

- React + TypeScript
- Tailwind CSS
- Recharts (gráficos)
- Supabase (banco de dados PostgreSQL + autenticação futura)
- Font: Titillium Web (Google Fonts, pesos: 300, 400, 600, 700)

## Banco de Dados (Supabase)

### Tabela `pesquisas`
```
id: UUID (PK, auto-generated)
nome: TEXT NOT NULL — nome do pesquisador
filial: TEXT NOT NULL — filial de origem
evento: TEXT NOT NULL — nome do evento
cliente: TEXT NOT NULL — nome do cliente
dias: INTEGER NOT NULL — quantidade de dias
local_evento: TEXT NOT NULL — local do evento
cidade: TEXT NOT NULL — cidade/UF
faturamento: NUMERIC(15,2) NOT NULL — faturamento estimado
publico: INTEGER NOT NULL — público por dia
modalidade: TEXT NOT NULL — enum: 'Ficha', 'Cashless', 'Híbrido'
setores: INTEGER NOT NULL — número de setores
porte: TEXT NOT NULL — calculado: 'PP', 'P', 'M', 'G', 'MEGA'
total_pdvs: INTEGER NOT NULL — soma dos PDVs
total_terminais: INTEGER NOT NULL — soma dos terminais
terminais_caixa: INTEGER NOT NULL DEFAULT 0
terminais_bebida: INTEGER NOT NULL DEFAULT 0
terminais_misto: INTEGER NOT NULL DEFAULT 0
terminais_alimentacao: INTEGER NOT NULL DEFAULT 0
terminais_servicos: INTEGER NOT NULL DEFAULT 0
terminais_loja: INTEGER NOT NULL DEFAULT 0
created_at: TIMESTAMPTZ DEFAULT NOW()
```

### Tabela `pesquisa_pdvs`
```
id: UUID (PK, auto-generated)
pesquisa_id: UUID (FK → pesquisas.id, CASCADE)
categoria: TEXT NOT NULL
nome: TEXT NOT NULL
codigo: TEXT NOT NULL
pontos: INTEGER NOT NULL DEFAULT 0
terminais: INTEGER NOT NULL DEFAULT 0
created_at: TIMESTAMPTZ DEFAULT NOW()
```

### RLS
- Ambas tabelas com insert e select público (formulário sem autenticação)

## Página 1: Formulário de Pesquisa (`/pesquisa`)

### Header
- Ícone azul com monitor + texto "Pesquisa de Estrutura de PDVs" + subtexto "Operações BR — Zig"
- SEM link para dashboard (pesquisadores não devem acessar)

### Seção 1 — Dados Pessoais (todos obrigatórios)
- Nome Completo (text input)
- Filial (select): BRASÍLIA/DF, GOIÂNIA/GO, SALVADOR/BA, FORTALEZA/CE, RECIFE/PE, BELÉM/PA, VITÓRIA/ES, BELO HORIZONTE/MG, RIO DE JANEIRO/RJ, SÃO PAULO/SP, CURITIBA/PR, PORTO ALEGRE/RS, FLORIANÓPOLIS/SC

### Seção 2 — Dados Gerais do Evento (todos obrigatórios)
- Evento (text, full width)
- Cliente (text)
- Quantidade de Dias (number)
- Local (text)
- Cidade / UF (text)

### Seção 3 — Dados Operacionais (todos obrigatórios)
- Faturamento Estimado (currency input com máscara R$ 15.000.000,00)
- Público por Dia (number input com máscara de milhar: 65.000)
- Modalidade (select): Ficha, Cashless, Híbrido
- Setores (number)
- Exibir badge do Porte calculado automaticamente:
  - PP: até R$ 74.999,99
  - P: R$ 75.000 a R$ 149.999,99
  - M: R$ 150.000 a R$ 499.999,99
  - G: R$ 500.000 a R$ 1.499.999,99
  - MEGA: R$ 1.500.000+

### Seção 4 — Estrutura de Pontos de Venda
Tabela com categorias colapsáveis. Colunas: Categoria | Nome | Cód. | Contexto/Descrição | Nº PDVs | Terminais

**Categorias e itens:**

💳 **Caixas** (obrigatório pelo menos 1 item)
- Caixa Fixo (CF) — Caixa que fica alocado em local fixo
- Caixa Móvel (CM) — Caixa que usa mochila pirulito e fica móvel
- Caixa Produção (CP) — Terminal de produção para geração de bônus/cortesias

🍺 **Bebidas**
- Bar (BB) — Bar geral onde normalmente se vende bebidas em geral
- Bar Drink (BD) — Bar focado em vendas de destilados/combos
- Bar Ativação (BT) — Bar patrocinado por alguma marca com venda exclusiva
- Bar Micro/Mini (BV) — Bar com estrutura menor, normalmente em locais de difícil acesso
- Caixa Ambulante Bebidas (CB) — Caixas exclusivos da operação de ambulantes de bebida
- Ambulante de Bebidas (BY) — Ambulantes de bebidas

🔄 **Operação Mista**
- Misto (MM) — Bares que também vendem comida. Operações mistas
- Garçom (MG) — Atendimento presencial onde o profissional leva o produto ao cliente

🍔 **Alimentação**
- Alimentação Fixa (AA) — Ponto de alimentação fixa, tendas ou estruturas de octanorm
- Food Truck (AF) — Alimentação feita por carros food truck
- Caixa Ambulante Alimentação (CA) — Caixas exclusivos da operação de ambulantes de alimentação
- Ambulante Alimentação (AX) — Ambulantes de alimentação

🎡 **Serviços**
- Serviços (SS) — Pontos de vendas de serviços diversos. Exemplo: brinquedos
- Locker/Guarda Volumes (SL) — Guarda volumes e/ou lockers

🛍️ **Merchandising**
- Loja (LO) — Loja de souvenir e/ou merchandising do evento, incluindo ambulantes

### Validações do Formulário
1. Todos os campos das seções 1, 2 e 3 são obrigatórios (indicar com asterisco vermelho)
2. Pelo menos 1 item da categoria Caixas deve ter valor > 0
3. Se preencheu Nº PDVs numa linha, Terminais é obrigatório (e vice-versa)
4. Demais categorias são opcionais

### Comportamento ao enviar
1. Calcular porte baseado no faturamento
2. Calcular total_pdvs e total_terminais
3. Calcular terminais por categoria (terminais_caixa, terminais_bebida, etc.)
4. Inserir na tabela `pesquisas`
5. Para cada item com pontos > 0 ou terminais > 0, inserir na tabela `pesquisa_pdvs`
6. Exibir tela de sucesso com totais e botão "Nova Pesquisa" (reseta o formulário)

## Página 2: Dashboard (`/dashboard`)

### Header
- Logo azul + "PDV Analytics" + aba Dashboard + botão "+ Nova Pesquisa" (navega para /pesquisa)

### Filtros (7 filtros em linha)
- Filial (select, valores dinâmicos do banco)
- Cliente (select, valores dinâmicos)
- Local do evento (select, valores dinâmicos)
- Cidade/UF (select, valores dinâmicos)
- Modalidade (select: Ficha, Cashless, Híbrido)
- Porte (select: PP, P, M, G, MEGA)
- Nome pesquisador (text input)
- Contador de filtros ativos + botão "Limpar filtros"
- Todos os dados da dashboard reagem aos filtros

### Cards KPIs (5 cards em linha)
- 🎪 Eventos — contagem de pesquisas
- 📟 Média terminais / evento
- 💰 Média faturamento / evento (formato R$)
- 🖥️ Média PDVs / evento
- 👥 Média público / evento

### Índices de Terminais (6 cards)
Média de terminais por categoria por evento (Total terminais da categoria ÷ Nº de eventos):
- ITC — Índice Terminais por Caixa 💳
- ITB — Índice Terminais por Bar 🍺
- ITM — Índice Terminais por Misto 🔄
- ITA — Índice Terminais por Alimentação 🍔
- ITS — Índice Terminais por Serviço 🎡
- ITL — Índice Terminais por Loja 🛍️

### Gráficos (lado a lado)

**Matriz de Terminais** (gráfico de barras horizontais)
- Média de terminais por categoria
- Cores por categoria (Caixas=azul, Bebidas=amarelo, Mistos=roxo, Alimentação=verde, Serviços=ciano, Lojas=vermelho)
- Exibir valor numérico dentro da barra (branco, bold)

**Matriz por Filial** (tabela)
- Colunas: Filial | Eventos | 💳Caixas | 🍺Bebidas | 🔄Mistos | 🍔Alimentação | 🎡Serviços | 🛍️Lojas | Média Geral
- Cada filial com média de terminais por categoria
- Última linha "Geral" com média global destacada em azul
- Última coluna "Média Geral" = média total de terminais por evento por filial

### Listagem de Eventos (tabela)
- Colunas: Evento | Cliente | Filial | Cidade | Porte (badge colorido) | Público/dia | PDVs | Terminais | Faturamento | Pesquisador | Data
- Badges de porte com cores: PP=cinza, P=ciano, M=amarelo, G=roxo, MEGA=azul

## Design System

### Cores
- Background: #F0F2F5
- Cards: #FFFFFF com borda #E8EBF0
- Azul primário: #4B6BFB (botões, destaques)
- Azul light: #EEF1FF
- Verde: #22C55E
- Laranja: #F59E0B
- Roxo: #8B5CF6
- Vermelho: #EF4444
- Ciano: #06B6D4
- Texto: #1A1D26
- Secundário: #6B7280
- Muted: #9CA3AF
- Inputs: background #F7F8FA, borda #E5E7EB, border-radius 10px
- Cards: border-radius 16-18px, shadow sutil

### Tipografia
- Font: Titillium Web
- Hierarquia: títulos 700-800, labels 600, body 400-500

### Componentes
- Cards com cantos arredondados (16px), sombra sutil
- Inputs com focus state azul (box-shadow)
- Tabelas com linhas alternadas (#fff / #FBFBFC)
- Categorias de PDV colapsáveis com ícones emoji
- Badges de porte com cores específicas
- Máscaras de input para moeda (R$) e números (milhar)

## Rotas
- `/pesquisa` — Formulário público (link compartilhável com pesquisadores)
- `/dashboard` — Dashboard administrativa
- `/` — Redireciona para `/dashboard`

## Integração Supabase
- Usar @supabase/supabase-js
- Variáveis de ambiente: VITE_SUPABASE_URL e VITE_SUPABASE_ANON_KEY
- Insert no formulário (pesquisas + pesquisa_pdvs)
- Select na dashboard com filtros dinâmicos
- Dados reais substituem os mocks
