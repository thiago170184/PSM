# Prompt 4 — Padronização de Texto e Ajustes na Listagem de Eventos

Faça as seguintes alterações no sistema:

## 1. Padronização de campos de texto — Primeira maiúscula

Todos os campos de texto que são exibidos no sistema (tanto no formulário quanto na dashboard) devem seguir o padrão **Primeira letra maiúscula e restante minúsculo** (capitalize), independente de como o usuário digitou.

**Campos afetados:**
- Nome do pesquisador
- Evento
- Cliente
- Local do evento
- Cidade/UF

**Regra:** A padronização é feita em duas camadas:
1. **Banco de dados (trigger):** Já existe um trigger `trg_padronizar_pesquisas` que aplica INITCAP + TRIM automaticamente em todo INSERT/UPDATE. Para o campo cidade, mantém a UF em maiúscula (ex: "São Paulo / SP").
2. **Frontend (exibição):** Implementar uma função utilitária `toTitleCase(text)` como fallback para exibir os dados já padronizados. Exemplo:
   - "LOLLAPALOOZA 2026" → "Lollapalooza 2026"
   - "são paulo / sp" → "São Paulo / SP"
   - "carlos silva" → "Carlos Silva"

Aplicar `toTitleCase` nos campos de texto livre ao exibir na dashboard e nas sugestões de autocomplete do formulário.

## 2. Fonte Titillium Web em todo o sistema

Garantir que a fonte **Titillium Web** (Google Fonts) esteja aplicada em **todo o sistema** — formulário, dashboard, tabelas, filtros, cards, gráficos, badges, inputs, botões, etc.

- Importar via Google Fonts: pesos 300, 400, 600, 700
- Aplicar como `font-family` global no `body` ou na raiz do app
- Garantir que nenhum componente use fonte padrão do sistema (sans-serif genérico)

## 3. Listagem de Eventos — Remover coluna Filial e simplificar Porte

Na tabela "Listagem de Eventos" da dashboard:
- **Remover** a coluna "Filial"
- Os badges de **Porte** devem exibir apenas as siglas: **PP**, **P**, **M**, **G**, **MEGA** (sem texto por extenso, apenas as letras com as cores já definidas)

Colunas atualizadas: Evento | Cliente | Cidade | Porte | Público/dia | PDVs | Terminais | Faturamento | Pesquisador | Ações
