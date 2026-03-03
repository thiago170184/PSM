# Prompt 1 — Alterações no Formulário (/pesquisa)

Faça as seguintes alterações no formulário de pesquisa:

## 1. Campos com autocomplete (Seção "Dados Gerais do Evento")

Os campos **Cliente**, **Local** e **Cidade / UF** devem virar campos de texto com autocomplete:
- Ao carregar o formulário, buscar valores distintos (SELECT DISTINCT) já cadastrados na tabela `pesquisas` para cada campo (`cliente`, `local_evento`, `cidade`)
- Conforme o usuário digita, filtrar e exibir as sugestões em um dropdown abaixo do campo
- O usuário pode selecionar uma sugestão OU digitar um valor novo (campo livre com sugestões)

## 2. Novo campo: Categoria do Evento (Seção "Dados Gerais do Evento")

Adicionar um campo select **obrigatório** chamado "Categoria do Evento" na seção "Dados Gerais do Evento", após o campo Cidade/UF. Opções:
- Feira
- Eventos esportivos
- Shows
- Rodeios
- Festivais
- Gastronômicos
- Eventos 24h
- Reveillon
- Carnaval
- Festa Junina

Este campo deve ser salvo na nova coluna `categoria_evento` da tabela `pesquisas`.

## 3. Modalidades de evento atualizadas (Seção "Dados Operacionais")

O campo **Modalidade** deve ter as seguintes opções (substituir as atuais):
- Ficha
- Cashless
- Híbrido
- Tickets
- 360

## 4. Novas categorias de PDV (Seção "Estrutura de Pontos de Venda")

Adicionar os seguintes itens nas categorias existentes:

**No grupo 💳 Caixas**, adicionar:
- Caixa Auto atendimento (CA) — Caixa de auto atendimento

**No grupo 🍺 Bebidas**, adicionar:
- Queima de Ficha (BQ) — Ponto de queima de ficha

**No grupo 🔄 Operação Mista**, adicionar:
- Impressora de pedidos (MI) — Impressora de pedidos para operação mista

## 5. Novo grupo de categorias: Tickets

Adicionar um novo grupo colapsável **🎫 Tickets** (após Merchandising) com os itens:
- Tickets Pré-venda (TP) — Terminais de pré-venda de tickets/ingressos
- Tickets Bilheteria (TB) — Terminais de bilheteria para venda no local
- Tickets Validador (TV) — Terminais de validação de tickets/ingressos

Os terminais deste grupo devem ser somados na nova coluna `terminais_tickets` da tabela `pesquisas`.

## 6. Suporte a edição de pesquisas

O formulário deve aceitar um parâmetro `id` na URL (ex: `/pesquisa?id=abc-123`).
- Se o parâmetro `id` estiver presente: carregar todos os dados da pesquisa (incluindo os PDVs da tabela `pesquisa_pdvs`) e preencher o formulário para edição
- Ao salvar com `id`: fazer UPDATE na tabela `pesquisas` e deletar + re-inserir os registros em `pesquisa_pdvs`
- Se NÃO tiver `id`: comportamento normal de INSERT (como já funciona hoje)
