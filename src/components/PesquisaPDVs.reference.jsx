import { useState, useCallback, useMemo } from "react";
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Legend, Cell, LabelList } from "recharts";

// ============================================================
// MOCK DATA — cada pesquisa com breakdown de terminais por categoria
// ============================================================
const MOCK_PESQUISAS = [
  { id: 1, nome: "Carlos Silva", filial: "SÃO PAULO/SP", evento: "Lollapalooza 2026", cliente: "T4F Entretenimento", dias: 3, local: "Autódromo de Interlagos", cidade: "São Paulo/SP", faturamento: 15000000, publico: 65000, modalidade: "Cashless", porte: "MEGA", total_pdvs: 142, total_terminais: 380, created_at: "2026-02-20",
    cat: { caixa: 42, bebida: 148, misto: 38, alimentacao: 95, servicos: 35, loja: 22 }},
  { id: 2, nome: "Ana Costa", filial: "RIO DE JANEIRO/RJ", evento: "Rock in Rio 2026", cliente: "Rock World", dias: 7, local: "Parque Olímpico", cidade: "Rio de Janeiro/RJ", faturamento: 22000000, publico: 80000, modalidade: "Cashless", porte: "MEGA", total_pdvs: 210, total_terminais: 520, created_at: "2026-02-18",
    cat: { caixa: 58, bebida: 210, misto: 52, alimentacao: 130, servicos: 42, loja: 28 }},
  { id: 3, nome: "Pedro Souza", filial: "SALVADOR/BA", evento: "Festival de Verão", cliente: "Rede Bahia", dias: 2, local: "Parque de Exposições", cidade: "Salvador/BA", faturamento: 3500000, publico: 35000, modalidade: "Cashless", porte: "MEGA", total_pdvs: 68, total_terminais: 145, created_at: "2026-02-15",
    cat: { caixa: 18, bebida: 58, misto: 15, alimentacao: 32, servicos: 14, loja: 8 }},
  { id: 4, nome: "Maria Lima", filial: "BELO HORIZONTE/MG", evento: "Arraial BH", cliente: "Belotur", dias: 4, local: "Expominas", cidade: "Belo Horizonte/MG", faturamento: 800000, publico: 15000, modalidade: "Híbrido", porte: "G", total_pdvs: 34, total_terminais: 72, created_at: "2026-02-12",
    cat: { caixa: 10, bebida: 24, misto: 8, alimentacao: 18, servicos: 8, loja: 4 }},
  { id: 5, nome: "João Mendes", filial: "CURITIBA/PR", evento: "Oktoberfest Curitiba", cliente: "Gastronomia PR", dias: 3, local: "Parque Barigui", cidade: "Curitiba/PR", faturamento: 450000, publico: 12000, modalidade: "Ficha", porte: "M", total_pdvs: 22, total_terminais: 48, created_at: "2026-02-10",
    cat: { caixa: 6, bebida: 18, misto: 5, alimentacao: 12, servicos: 4, loja: 3 }},
  { id: 6, nome: "Lucia Ferreira", filial: "FORTALEZA/CE", evento: "Carnatal", cliente: "Destaque Promo", dias: 4, local: "Arena Castelão", cidade: "Natal/RN", faturamento: 5200000, publico: 40000, modalidade: "Cashless", porte: "MEGA", total_pdvs: 88, total_terminais: 195, created_at: "2026-02-08",
    cat: { caixa: 24, bebida: 78, misto: 20, alimentacao: 45, servicos: 18, loja: 10 }},
  { id: 7, nome: "Roberto Dias", filial: "BRASÍLIA/DF", evento: "Festival Cerrado", cliente: "Gov DF", dias: 2, local: "Parque da Cidade", cidade: "Brasília/DF", faturamento: 120000, publico: 5000, modalidade: "Híbrido", porte: "P", total_pdvs: 12, total_terminais: 24, created_at: "2026-02-05",
    cat: { caixa: 4, bebida: 8, misto: 3, alimentacao: 5, servicos: 2, loja: 2 }},
  { id: 8, nome: "Camila Rocha", filial: "PORTO ALEGRE/RS", evento: "Acampamento Farroupilha", cliente: "Pref POA", dias: 10, local: "Parque Harmonia", cidade: "Porto Alegre/RS", faturamento: 1800000, publico: 20000, modalidade: "Ficha", porte: "MEGA", total_pdvs: 56, total_terminais: 110, created_at: "2026-02-01",
    cat: { caixa: 14, bebida: 42, misto: 12, alimentacao: 26, servicos: 10, loja: 6 }},
  { id: 9, nome: "Felipe Nunes", filial: "RECIFE/PE", evento: "Galo da Madrugada", cliente: "Pref Recife", dias: 1, local: "Centro do Recife", cidade: "Recife/PE", faturamento: 60000, publico: 8000, modalidade: "Ficha", porte: "PP", total_pdvs: 8, total_terminais: 16, created_at: "2026-01-28",
    cat: { caixa: 3, bebida: 6, misto: 2, alimentacao: 3, servicos: 1, loja: 1 }},
  { id: 10, nome: "Thiago Alves", filial: "GOIÂNIA/GO", evento: "Villa Mix", cliente: "Villa Mix Group", dias: 2, local: "Estádio Serra Dourada", cidade: "Goiânia/GO", faturamento: 2800000, publico: 30000, modalidade: "Cashless", porte: "MEGA", total_pdvs: 64, total_terminais: 138, created_at: "2026-01-25",
    cat: { caixa: 16, bebida: 52, misto: 14, alimentacao: 34, servicos: 14, loja: 8 }},
  { id: 11, nome: "Renata Pires", filial: "SÃO PAULO/SP", evento: "Primavera Sound SP", cliente: "Time For Fun", dias: 3, local: "Distrito Anhembi", cidade: "São Paulo/SP", faturamento: 9500000, publico: 45000, modalidade: "Cashless", porte: "MEGA", total_pdvs: 105, total_terminais: 270, created_at: "2026-01-20",
    cat: { caixa: 32, bebida: 108, misto: 28, alimentacao: 65, servicos: 22, loja: 15 }},
  { id: 12, nome: "Diego Santos", filial: "RIO DE JANEIRO/RJ", evento: "Réveillon Copacabana", cliente: "Riotur", dias: 1, local: "Praia de Copacabana", cidade: "Rio de Janeiro/RJ", faturamento: 6800000, publico: 100000, modalidade: "Cashless", porte: "MEGA", total_pdvs: 96, total_terminais: 240, created_at: "2026-01-15",
    cat: { caixa: 28, bebida: 98, misto: 24, alimentacao: 56, servicos: 20, loja: 14 }},
];

// Form data + helpers omitted for brevity — see full file in src/components/
// This is the reference component. The Lovable prompt (docs/LOVABLE-PROMPT.md) contains
// all specifications to rebuild this with Supabase integration.
// Full component available at: pesquisa_pdvs_dashboard.jsx