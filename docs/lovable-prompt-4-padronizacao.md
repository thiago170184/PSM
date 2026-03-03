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

**Regra:** Ao salvar no banco (INSERT ou UPDATE) e/ou ao exibir na tela, converter automaticamente para o formato Title Case (primeira letra de cada palavra maiúscula, restante minúscula). Exemplo:
- "LOLLAPALOOZA 2026" → "Lollapalooza 2026"
- "são paulo/sp" → "São Paulo/Sp"
- "carlos silva" → "Carlos Silva"
- "T4F ENTRETENIMENTO" → "T4f Entretenimento"

Implementar uma função utilitária `toTitleCase(text)` que converta qualquer texto para este padrão e aplicar em todos os campos de texto livre antes de salvar e ao exibir.

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
