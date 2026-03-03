# Prompt 2 — Alterações nos Filtros e Cards de Índices (Dashboard)

Faça as seguintes alterações na dashboard:

## 1. Filtros — Nome visível e multi-seleção

Alterar todos os filtros da dashboard:

- Cada filtro deve exibir um **label/nome acima** do campo (ex: "Filial", "Cliente", etc.)
- Todos os filtros do tipo select devem suportar **multi-seleção**: o usuário pode selecionar múltiplos valores ao mesmo tempo
- Usar componente de multi-select com chips/tags mostrando os valores selecionados
- Os dados da dashboard devem filtrar por TODOS os valores selecionados (lógica OR dentro do mesmo filtro)

Filtros atualizados (8 no total):
1. **Filial** (multi-select, valores dinâmicos do banco)
2. **Cliente** (multi-select, valores dinâmicos do banco)
3. **Local do evento** (multi-select, valores dinâmicos do banco)
4. **Cidade/UF** (multi-select, valores dinâmicos do banco)
5. **Modalidade** (multi-select, opções fixas: Ficha, Cashless, Híbrido, Tickets, 360)
6. **Porte** (multi-select, opções fixas: PP, P, M, G, MEGA)
7. **Categoria** (multi-select, opções fixas: Feira, Eventos esportivos, Shows, Rodeios, Festivais, Gastronômicos, Eventos 24h, Reveillon, Carnaval, Festa Junina) — este é um filtro NOVO baseado na nova coluna `categoria_evento`
8. **Pesquisador** (text input, mantém como está)

Manter o contador de filtros ativos e o botão "Limpar filtros".

## 2. Cards de Índices de Terminais — Layout e arredondamento

Alterar os 6 cards de índices existentes e adicionar 1 novo (total: 7 cards):

**Mudanças no layout de cada card:**
- O **título** do índice (ex: "ITC — Índice Terminais por Caixa") deve ficar **acima**, com o emoji/ícone **ao lado do título na mesma linha**
- O valor do indicador deve ser **arredondado para cima** (Math.ceil), exibido **sem casas decimais** (ex: 103, não 102.7)
- **Abaixo** do indicador principal, adicionar uma **sub-métrica em tamanho menor**: calcular (Média de público por evento ÷ valor do indicador) e exibir o resultado arredondado para cima. Exemplo: se ITC = 103 e a média de público dos eventos filtrados = 24.191, mostrar "235" abaixo (24.191 ÷ 103 = 235)

**Cards (7 no total):**
- 💳 ITC — Índice Terminais por Caixa
- 🍺 ITB — Índice Terminais por Bar
- 🔄 ITM — Índice Terminais por Misto
- 🍔 ITA — Índice Terminais por Alimentação
- 🎡 ITS — Índice Terminais por Serviço
- 🛍️ ITL — Índice Terminais por Loja
- 🎫 **ITT — Índice Terminais por Tickets** (NOVO — usa a nova coluna `terminais_tickets`)
