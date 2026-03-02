# PSM — Pesquisa de Estrutura de PDVs

Sistema de pesquisa e análise de estrutura de Pontos de Venda (PDVs) para eventos.

## Estrutura do Projeto

```
PSM/
├── src/
│   └── components/
│       └── PesquisaPDVs.jsx    # Componente principal (Dashboard + Formulário)
├── database/
│   └── supabase-schema.sql     # Schema completo do banco de dados
├── docs/
│   └── LOVABLE-PROMPT.md       # Prompt para importação no Lovable
└── README.md
```

## Páginas

### 📋 Formulário de Pesquisa (`/pesquisa`)
Página pública para pesquisadores de campo preencherem dados sobre PDVs de eventos.
- Dados pessoais, evento, operacionais
- 18 tipos de PDV em 6 categorias
- Validações completas
- Máscaras de input (moeda, números)

### 📊 Dashboard (`/dashboard`)
Painel administrativo com análises dos dados coletados.
- 7 filtros dinâmicos
- 5 KPIs (médias por evento)
- 6 índices de terminais por categoria (ITC, ITB, ITM, ITA, ITS, ITL)
- Matriz de terminais (gráfico de barras)
- Matriz por filial (tabela com médias)
- Listagem completa de eventos

## Stack

- React + TypeScript
- Tailwind CSS
- Recharts
- Supabase (PostgreSQL)
- Font: Titillium Web

## Banco de Dados

Executar o arquivo `database/supabase-schema.sql` no SQL Editor do Supabase.

Tabelas:
- `pesquisas` — dados principais + terminais por categoria
- `pesquisa_pdvs` — detalhe por tipo de PDV (1:N)
- `v_dashboard_pesquisas` — view com índices pré-calculados

## Deploy via Lovable

1. Criar projeto no Lovable
2. Colar o conteúdo de `docs/LOVABLE-PROMPT.md` como prompt inicial
3. Conectar ao GitHub (este repositório)
4. Conectar ao Supabase (executar SQL antes)
5. Configurar variáveis: `VITE_SUPABASE_URL` e `VITE_SUPABASE_ANON_KEY`

## Modalidades

- **Ficha** — eventos com sistema de fichas
- **Cashless** — eventos com sistema cashless
- **Híbrido** — eventos com ambos os sistemas

## Classificação de Porte

| Porte | Faturamento |
|-------|-------------|
| PP    | até R$ 74.999 |
| P     | R$ 75.000 — R$ 149.999 |
| M     | R$ 150.000 — R$ 499.999 |
| G     | R$ 500.000 — R$ 1.499.999 |
| MEGA  | R$ 1.500.000+ |
