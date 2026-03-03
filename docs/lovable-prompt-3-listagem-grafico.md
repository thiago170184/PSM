# Prompt 3 — Alterações na Listagem de Eventos e Gráfico Matriz (Dashboard)

Faça as seguintes alterações na dashboard:

## 1. Listagem de Eventos — Botão Editar

Na tabela "Listagem de Eventos":
- **Remover** a coluna "Data"
- **Adicionar** uma coluna "Ações" no lugar, com um botão/ícone de **editar** (ícone de lápis)
- Ao clicar no botão editar, navegar para `/pesquisa?id={pesquisa_id}` — isso abrirá o formulário com os dados preenchidos para edição (o suporte a edição já foi implementado no formulário)

Colunas atualizadas: Evento | Cliente | Filial | Cidade | Porte | Público/dia | PDVs | Terminais | Faturamento | Pesquisador | **Ações**

## 2. Gráfico "Matriz por Filial" → "Matriz por Categoria de Eventos"

Alterar a tabela/gráfico "Matriz por Filial":
- **Renomear** para "Matriz por Categoria de Eventos"
- A primeira coluna deixa de ser "Filial" e passa a ser **"Categoria do Evento"** (usando a nova coluna `categoria_evento`: Feira, Shows, Rodeios, Festivais, etc.)
- Cada linha mostra uma categoria de evento com a média de terminais por categoria de PDV
- Adicionar a coluna **🎫 Tickets** (usando `terminais_tickets`)

Colunas atualizadas: **Categoria do Evento** | Eventos | 💳Caixas | 🍺Bebidas | 🔄Mistos | 🍔Alimentação | 🎡Serviços | 🛍️Lojas | **🎫Tickets** | Média Geral

- Última linha "Geral" com média global destacada em azul (mantém comportamento atual, só muda o agrupamento)

## 3. Gráfico de Barras "Matriz de Terminais"

Adicionar a categoria **Tickets** (cor: laranja) no gráfico de barras horizontais de média de terminais por categoria.

Cores atualizadas: Caixas=azul, Bebidas=amarelo, Mistos=roxo, Alimentação=verde, Serviços=ciano, Lojas=vermelho, **Tickets=laranja**
