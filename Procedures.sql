-- =============================================================
-- CARBONTRACE - Sistema de Monitoramento de Desmatamento
-- RELATÓRIOS SQL COM JOIN
-- Banco de Dados: Oracle
-- =============================================================


-- =============================================================
-- RELATÓRIO 1
-- Listagem completa de alertas com informações da região,
-- estado e satélite que capturou a imagem
-- =============================================================
SELECT
    al.id_alerta,
    al.data_emissao,
    al.nivel_criticidade,
    al.descricao,
    an.area_desmatada_km2,
    an.percentual_variacao,
    an.status_alerta,
    r.nome          AS nome_regiao,
    e.nome          AS nome_estado,
    e.sigla         AS sigla_estado,
    s.nome          AS nome_satelite,
    s.agencia       AS agencia_satelite
FROM TB_ALERTA al
JOIN TB_ANALISE an              ON al.id_analise     = an.id_analise
JOIN TB_IMAGEM_SATELITAL i      ON an.id_imagem      = i.id_imagem
JOIN TB_REGIAO r                ON i.id_regiao       = r.id_regiao
JOIN TB_ESTADO e                ON r.id_estado       = e.id_estado
JOIN TB_SATELITE s              ON i.id_satelite     = s.id_satelite
ORDER BY al.data_emissao DESC;


-- =============================================================
-- RELATÓRIO 2
-- Ocorrências reportadas por fiscais com informações
-- da região e estado onde ocorreram
-- =============================================================
SELECT
    o.id_ocorrencia,
    o.data_ocorrencia,
    o.area_estimada_km2,
    o.descricao,
    u.nome          AS nome_fiscal,
    u.tipo_usuario,
    r.nome          AS nome_regiao,
    r.area_km2      AS area_total_regiao,
    e.nome          AS nome_estado,
    e.sigla         AS sigla_estado
FROM TB_OCORRENCIA o
JOIN TB_USUARIO u       ON o.id_usuario  = u.id_usuario
JOIN TB_REGIAO r        ON o.id_regiao   = r.id_regiao
JOIN TB_ESTADO e        ON r.id_estado   = e.id_estado
ORDER BY o.data_ocorrencia DESC;


-- =============================================================
-- RELATÓRIO 3
-- Órgãos ambientais notificados por alerta com status
-- de notificação e informações do estado de atuação
-- =============================================================
SELECT
    ao.id_alerta,
    ao.data_notificacao,
    ao.status_notificacao,
    al.nivel_criticidade,
    al.data_emissao,
    og.nome         AS nome_orgao,
    og.tipo         AS tipo_orgao,
    og.email_contato,
    e.nome          AS nome_estado,
    e.sigla         AS sigla_estado
FROM TB_ALERTA_ORGAO ao
JOIN TB_ALERTA al               ON ao.id_alerta  = al.id_alerta
JOIN TB_ORGAO_AMBIENTAL og      ON ao.id_orgao   = og.id_orgao
JOIN TB_ESTADO e                ON og.id_estado  = e.id_estado
ORDER BY ao.data_notificacao DESC;


-- =============================================================
-- RELATÓRIO 4
-- Resumo de desmatamento por estado com total de regiões
-- monitoradas, total de análises e área total desmatada
-- =============================================================
SELECT
    e.nome                          AS nome_estado,
    e.sigla                         AS sigla_estado,
    COUNT(DISTINCT r.id_regiao)     AS total_regioes,
    COUNT(DISTINCT i.id_imagem)     AS total_imagens,
    COUNT(DISTINCT an.id_analise)   AS total_analises,
    NVL(SUM(an.area_desmatada_km2), 0)  AS area_total_desmatada_km2,
    NVL(AVG(an.area_desmatada_km2), 0)  AS media_desmatamento_km2,
    NVL(MAX(an.area_desmatada_km2), 0)  AS maior_desmatamento_km2
FROM TB_ESTADO e
JOIN TB_REGIAO r                ON e.id_estado   = r.id_estado
JOIN TB_IMAGEM_SATELITAL i      ON r.id_regiao   = i.id_regiao
JOIN TB_ANALISE an              ON i.id_imagem   = an.id_imagem
GROUP BY e.nome, e.sigla
ORDER BY area_total_desmatada_km2 DESC;


-- =============================================================
-- RELATÓRIO 5
-- Relatórios gerados com informações do usuário responsável
-- e quantidade de alertas no período do relatório
-- =============================================================
SELECT
    rl.id_relatorio,
    rl.titulo,
    rl.data_geracao,
    rl.periodo_inicio,
    rl.periodo_fim,
    u.nome              AS nome_usuario,
    u.tipo_usuario,
    COUNT(al.id_alerta) AS total_alertas_periodo
FROM TB_RELATORIO rl
JOIN TB_USUARIO u       ON rl.id_usuario    = u.id_usuario
LEFT JOIN TB_ALERTA al  ON al.data_emissao BETWEEN rl.periodo_inicio AND rl.periodo_fim
GROUP BY
    rl.id_relatorio,
    rl.titulo,
    rl.data_geracao,
    rl.periodo_inicio,
    rl.periodo_fim,
    u.nome,
    u.tipo_usuario
ORDER BY rl.data_geracao DESC;

-- =============================================================
-- FIM DOS RELATÓRIOS
-- =============================================================