-- ============================================================
-- MIGRAÇÃO v3 — Padronização de Dados
-- Rodar no Supabase SQL Editor
-- ============================================================
-- IMPORTANTE: Rode este script no SQL Editor do Supabase
-- (Dashboard > SQL Editor > New query > Cole e execute)
-- ============================================================

-- ============================================================
-- 1. Função auxiliar para padronizar cidade mantendo UF maiúscula
--    "SAO PAULO / SP" → "São Paulo / SP"
--    "sao paulo/ sp"  → "São Paulo / SP"
-- ============================================================
CREATE OR REPLACE FUNCTION padronizar_cidade(input TEXT)
RETURNS TEXT AS $$
DECLARE
  separador_pos INTEGER;
  cidade_parte TEXT;
  uf_parte TEXT;
BEGIN
  input := TRIM(input);
  IF input = '' OR input IS NULL THEN RETURN input; END IF;

  separador_pos := POSITION('/' IN input);
  IF separador_pos > 0 THEN
    cidade_parte := TRIM(SUBSTRING(input FROM 1 FOR separador_pos - 1));
    uf_parte := TRIM(SUBSTRING(input FROM separador_pos + 1));
    RETURN INITCAP(cidade_parte) || ' / ' || UPPER(uf_parte);
  ELSE
    RETURN INITCAP(input);
  END IF;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 2. Padronização geral: TRIM + Title Case em todos os campos
-- ============================================================

-- Nome do pesquisador
UPDATE pesquisas SET nome = INITCAP(TRIM(nome))
WHERE nome IS DISTINCT FROM INITCAP(TRIM(nome));

-- Evento
UPDATE pesquisas SET evento = INITCAP(TRIM(evento))
WHERE evento IS DISTINCT FROM INITCAP(TRIM(evento));

-- Cliente (Title Case + trim)
UPDATE pesquisas SET cliente = INITCAP(TRIM(cliente))
WHERE cliente IS DISTINCT FROM INITCAP(TRIM(cliente));

-- Local do evento (Title Case + trim)
UPDATE pesquisas SET local_evento = INITCAP(TRIM(local_evento))
WHERE local_evento IS DISTINCT FROM INITCAP(TRIM(local_evento));

-- Cidade (função especial que mantém UF maiúscula)
UPDATE pesquisas SET cidade = padronizar_cidade(cidade)
WHERE cidade IS DISTINCT FROM padronizar_cidade(cidade);

-- ============================================================
-- 3. Unificação de CLIENTES duplicados
-- ============================================================

-- GL Anhembi, GL Spexpo → Gl Events (mesmo grupo)
UPDATE pesquisas SET cliente = 'Gl Events'
WHERE LOWER(TRIM(cliente)) IN ('gl anhembi', 'gl spexpo', 'gl events');

-- Gruponda → Grupo Onda
UPDATE pesquisas SET cliente = 'Grupo Onda'
WHERE LOWER(TRIM(cliente)) IN ('gruponda');

-- ============================================================
-- 4. Unificação de LOCAIS duplicados
-- ============================================================

-- Rio Centro → Riocentro
UPDATE pesquisas SET local_evento = 'Riocentro'
WHERE LOWER(TRIM(local_evento)) IN ('rio centro', 'riocentro');

-- Estadio Comercial RP → Estadio Do Comercial RP
UPDATE pesquisas SET local_evento = 'Estadio Do Comercial Rp'
WHERE LOWER(TRIM(local_evento)) IN ('estadio comercial rp', 'estadio do comercial rp');

-- ============================================================
-- 5. Unificação de CIDADES duplicadas
-- ============================================================

-- Todas as variações de São Paulo → São Paulo / SP
UPDATE pesquisas SET cidade = 'São Paulo / SP'
WHERE LOWER(TRIM(REPLACE(cidade, ' ', ''))) LIKE '%saopaulo%'
   OR LOWER(TRIM(REPLACE(cidade, ' ', ''))) LIKE '%sãopaulo%'
   OR TRIM(cidade) = 'SP'
   OR TRIM(cidade) = 'Sp'
   OR TRIM(cidade) = '';

-- ============================================================
-- 6. Trigger para padronizar automaticamente novas inserções
--    e edições futuras
-- ============================================================
CREATE OR REPLACE FUNCTION trg_padronizar_texto()
RETURNS TRIGGER AS $$
BEGIN
  NEW.nome := INITCAP(TRIM(NEW.nome));
  NEW.evento := INITCAP(TRIM(NEW.evento));
  NEW.cliente := INITCAP(TRIM(NEW.cliente));
  NEW.local_evento := INITCAP(TRIM(NEW.local_evento));
  NEW.cidade := padronizar_cidade(NEW.cidade);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Dropar trigger se já existir
DROP TRIGGER IF EXISTS trg_padronizar_pesquisas ON pesquisas;

-- Criar trigger
CREATE TRIGGER trg_padronizar_pesquisas
  BEFORE INSERT OR UPDATE ON pesquisas
  FOR EACH ROW
  EXECUTE FUNCTION trg_padronizar_texto();

-- ============================================================
-- 7. Verificação — rode para conferir o resultado
-- ============================================================
-- SELECT DISTINCT cliente FROM pesquisas ORDER BY cliente;
-- SELECT DISTINCT local_evento FROM pesquisas ORDER BY local_evento;
-- SELECT DISTINCT cidade FROM pesquisas ORDER BY cidade;

-- ============================================================
-- FIM DA MIGRAÇÃO v3
-- Após rodar, todos os campos estarão padronizados e
-- novos registros serão padronizados automaticamente pelo trigger.
-- ============================================================
