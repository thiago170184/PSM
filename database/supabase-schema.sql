-- ============================================================
-- PESQUISA DE ESTRUTURA DE PDVs — Schema Supabase
-- Atualizado com breakdown de terminais por categoria
-- ============================================================

-- Drop tables if exist (para reset)
DROP TABLE IF EXISTS pesquisa_pdvs CASCADE;
DROP TABLE IF EXISTS pesquisas CASCADE;

-- ============================================================
-- Tabela principal: pesquisas
-- ============================================================
CREATE TABLE pesquisas (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  
  -- Dados Pessoais
  nome TEXT NOT NULL,
  filial TEXT NOT NULL,
  
  -- Dados do Evento
  evento TEXT NOT NULL,
  cliente TEXT NOT NULL,
  dias INTEGER NOT NULL DEFAULT 1,
  local_evento TEXT NOT NULL,
  cidade TEXT NOT NULL,
  
  -- Dados Operacionais
  faturamento NUMERIC(15,2) NOT NULL DEFAULT 0,
  publico INTEGER NOT NULL DEFAULT 0,
  modalidade TEXT NOT NULL CHECK (modalidade IN ('Ficha', 'Cashless', 'Híbrido')),
  setores INTEGER NOT NULL DEFAULT 1,
  porte TEXT NOT NULL CHECK (porte IN ('PP', 'P', 'M', 'G', 'MEGA')),
  
  -- Totais calculados
  total_pdvs INTEGER NOT NULL DEFAULT 0,
  total_terminais INTEGER NOT NULL DEFAULT 0,
  
  -- Terminais por categoria (para índices da dashboard)
  terminais_caixa INTEGER NOT NULL DEFAULT 0,
  terminais_bebida INTEGER NOT NULL DEFAULT 0,
  terminais_misto INTEGER NOT NULL DEFAULT 0,
  terminais_alimentacao INTEGER NOT NULL DEFAULT 0,
  terminais_servicos INTEGER NOT NULL DEFAULT 0,
  terminais_loja INTEGER NOT NULL DEFAULT 0,
  
  -- Metadata
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- Tabela de itens: pesquisa_pdvs (detalhe por tipo de PDV)
-- ============================================================
CREATE TABLE pesquisa_pdvs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  pesquisa_id UUID NOT NULL REFERENCES pesquisas(id) ON DELETE CASCADE,
  
  categoria TEXT NOT NULL,
  nome TEXT NOT NULL,
  codigo TEXT NOT NULL,
  pontos INTEGER NOT NULL DEFAULT 0,
  terminais INTEGER NOT NULL DEFAULT 0,
  
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- Índices para performance
-- ============================================================
CREATE INDEX idx_pesquisas_filial ON pesquisas(filial);
CREATE INDEX idx_pesquisas_cliente ON pesquisas(cliente);
CREATE INDEX idx_pesquisas_cidade ON pesquisas(cidade);
CREATE INDEX idx_pesquisas_modalidade ON pesquisas(modalidade);
CREATE INDEX idx_pesquisas_porte ON pesquisas(porte);
CREATE INDEX idx_pesquisas_created ON pesquisas(created_at DESC);
CREATE INDEX idx_pesquisa_pdvs_pesquisa ON pesquisa_pdvs(pesquisa_id);

-- ============================================================
-- RLS (Row Level Security) — políticas públicas
-- ============================================================
ALTER TABLE pesquisas ENABLE ROW LEVEL SECURITY;
ALTER TABLE pesquisa_pdvs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Permitir insert público" ON pesquisas
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Permitir select público" ON pesquisas
  FOR SELECT USING (true);

CREATE POLICY "Permitir insert público" ON pesquisa_pdvs
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Permitir select público" ON pesquisa_pdvs
  FOR SELECT USING (true);

-- ============================================================
-- View para dashboard
-- ============================================================
CREATE OR REPLACE VIEW v_dashboard_pesquisas AS
SELECT
  id, nome, filial, evento, cliente, dias, local_evento, cidade,
  faturamento, publico, modalidade, setores, porte,
  total_pdvs, total_terminais,
  terminais_caixa, terminais_bebida, terminais_misto,
  terminais_alimentacao, terminais_servicos, terminais_loja,
  created_at,
  CASE WHEN terminais_caixa > 0 THEN ROUND(faturamento / terminais_caixa, 2) ELSE 0 END AS itc,
  CASE WHEN terminais_bebida > 0 THEN ROUND(faturamento / terminais_bebida, 2) ELSE 0 END AS itb,
  CASE WHEN terminais_misto > 0 THEN ROUND(faturamento / terminais_misto, 2) ELSE 0 END AS itm,
  CASE WHEN terminais_alimentacao > 0 THEN ROUND(faturamento / terminais_alimentacao, 2) ELSE 0 END AS ita,
  CASE WHEN terminais_servicos > 0 THEN ROUND(faturamento / terminais_servicos, 2) ELSE 0 END AS its,
  CASE WHEN terminais_loja > 0 THEN ROUND(faturamento / terminais_loja, 2) ELSE 0 END AS itl
FROM pesquisas
ORDER BY created_at DESC;
