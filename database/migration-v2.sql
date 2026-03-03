-- ============================================================
-- MIGRAÇÃO v2 — Rodar no Supabase SQL Editor
-- Adiciona: categoria_evento, terminais_tickets, novas modalidades,
--           políticas de UPDATE/DELETE, e atualiza a view
-- ============================================================
-- IMPORTANTE: Rode este script no SQL Editor do Supabase
-- (Dashboard > SQL Editor > New query > Cole e execute)
-- ============================================================

-- 1. Nova coluna: categoria_evento
ALTER TABLE pesquisas
ADD COLUMN IF NOT EXISTS categoria_evento TEXT NOT NULL DEFAULT 'Feira';

-- Adicionar CHECK constraint para categoria_evento
ALTER TABLE pesquisas
ADD CONSTRAINT chk_categoria_evento
CHECK (categoria_evento IN (
  'Feira', 'Eventos esportivos', 'Shows', 'Rodeios',
  'Festivais', 'Gastronômicos', 'Eventos 24h',
  'Reveillon', 'Carnaval', 'Festa Junina'
));

-- 2. Nova coluna: terminais_tickets
ALTER TABLE pesquisas
ADD COLUMN IF NOT EXISTS terminais_tickets INTEGER NOT NULL DEFAULT 0;

-- 3. Atualizar CHECK de modalidade (remover antigo, criar novo)
ALTER TABLE pesquisas DROP CONSTRAINT IF EXISTS pesquisas_modalidade_check;
ALTER TABLE pesquisas
ADD CONSTRAINT pesquisas_modalidade_check
CHECK (modalidade IN ('Ficha', 'Cashless', 'Híbrido', 'Tickets', '360'));

-- 4. Índice para categoria_evento
CREATE INDEX IF NOT EXISTS idx_pesquisas_categoria_evento ON pesquisas(categoria_evento);

-- 5. Políticas de UPDATE e DELETE para edição de pesquisas
DO $$
BEGIN
  -- UPDATE em pesquisas
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'pesquisas' AND policyname = 'Permitir update público'
  ) THEN
    CREATE POLICY "Permitir update público" ON pesquisas
      FOR UPDATE USING (true) WITH CHECK (true);
  END IF;

  -- DELETE em pesquisa_pdvs (para re-inserir ao editar)
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'pesquisa_pdvs' AND policyname = 'Permitir delete público'
  ) THEN
    CREATE POLICY "Permitir delete público" ON pesquisa_pdvs
      FOR DELETE USING (true);
  END IF;

  -- UPDATE em pesquisa_pdvs
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'pesquisa_pdvs' AND policyname = 'Permitir update público'
  ) THEN
    CREATE POLICY "Permitir update público" ON pesquisa_pdvs
      FOR UPDATE USING (true) WITH CHECK (true);
  END IF;
END $$;

-- 6. Recriar a view com os novos campos e CEIL
CREATE OR REPLACE VIEW v_dashboard_pesquisas AS
SELECT
  id, nome, filial, evento, cliente, dias, local_evento, cidade,
  faturamento, publico, modalidade, setores, porte, categoria_evento,
  total_pdvs, total_terminais,
  terminais_caixa, terminais_bebida, terminais_misto,
  terminais_alimentacao, terminais_servicos, terminais_loja, terminais_tickets,
  created_at,
  CASE WHEN terminais_caixa > 0 THEN CEIL(faturamento / terminais_caixa) ELSE 0 END AS itc,
  CASE WHEN terminais_bebida > 0 THEN CEIL(faturamento / terminais_bebida) ELSE 0 END AS itb,
  CASE WHEN terminais_misto > 0 THEN CEIL(faturamento / terminais_misto) ELSE 0 END AS itm,
  CASE WHEN terminais_alimentacao > 0 THEN CEIL(faturamento / terminais_alimentacao) ELSE 0 END AS ita,
  CASE WHEN terminais_servicos > 0 THEN CEIL(faturamento / terminais_servicos) ELSE 0 END AS its,
  CASE WHEN terminais_loja > 0 THEN CEIL(faturamento / terminais_loja) ELSE 0 END AS itl,
  CASE WHEN terminais_tickets > 0 THEN CEIL(faturamento / terminais_tickets) ELSE 0 END AS itt
FROM pesquisas
ORDER BY created_at DESC;

-- ============================================================
-- FIM DA MIGRAÇÃO
-- Registros existentes terão categoria_evento = 'Feira' (default)
-- e terminais_tickets = 0 (default). Ajuste manualmente se necessário.
-- ============================================================
