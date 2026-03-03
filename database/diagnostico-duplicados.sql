-- ============================================================
-- DIAGNÓSTICO DE DUPLICADOS — Rodar no Supabase SQL Editor
-- Cole no SQL Editor e execute. Copie o resultado e me envie.
-- ============================================================

-- 1. Clientes distintos (mostra como estão gravados)
SELECT '--- CLIENTES ---' AS campo;
SELECT DISTINCT cliente, COUNT(*) AS qtd
FROM pesquisas
GROUP BY cliente
ORDER BY LOWER(cliente), cliente;

-- 2. Locais de evento distintos
SELECT '--- LOCAIS DE EVENTO ---' AS campo;
SELECT DISTINCT local_evento, COUNT(*) AS qtd
FROM pesquisas
GROUP BY local_evento
ORDER BY LOWER(local_evento), local_evento;

-- 3. Cidades distintas
SELECT '--- CIDADES ---' AS campo;
SELECT DISTINCT cidade, COUNT(*) AS qtd
FROM pesquisas
GROUP BY cidade
ORDER BY LOWER(cidade), cidade;
