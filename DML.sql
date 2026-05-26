-- =============================================================
-- CARBONTRACE - Sistema de Monitoramento de Desmatamento
-- DML - Data Manipulation Language
-- Popular o Banco
-- Banco de Dados: Oracle
-- =============================================================

-- =============================================================
-- 1. TB_ESTADO (27 estados brasileiros)
-- =============================================================
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Acre', 'AC');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Alagoas', 'AL');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Amapá', 'AP');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Amazonas', 'AM');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Bahia', 'BA');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Ceará', 'CE');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Distrito Federal', 'DF');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Espírito Santo', 'ES');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Goiás', 'GO');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Maranhão', 'MA');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Mato Grosso', 'MT');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Mato Grosso do Sul', 'MS');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Minas Gerais', 'MG');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Pará', 'PA');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Paraíba', 'PB');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Paraná', 'PR');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Pernambuco', 'PE');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Piauí', 'PI');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Rio de Janeiro', 'RJ');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Rio Grande do Norte', 'RN');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Rio Grande do Sul', 'RS');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Rondônia', 'RO');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Roraima', 'RR');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Santa Catarina', 'SC');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('São Paulo', 'SP');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Sergipe', 'SE');
INSERT INTO TB_ESTADO (nome, sigla) VALUES ('Tocantins', 'TO');

-- =============================================================
-- 2. TB_SATELITE (5 satélites)
-- =============================================================
INSERT INTO TB_SATELITE (nome, agencia, altitude_km, ano_lancamento) VALUES ('Landsat 8', 'NASA', 705.00, 2013);
INSERT INTO TB_SATELITE (nome, agencia, altitude_km, ano_lancamento) VALUES ('Sentinel-2A', 'ESA', 786.00, 2015);
INSERT INTO TB_SATELITE (nome, agencia, altitude_km, ano_lancamento) VALUES ('CBERS-4A', 'INPE', 628.00, 2019);
INSERT INTO TB_SATELITE (nome, agencia, altitude_km, ano_lancamento) VALUES ('Landsat 9', 'NASA', 705.00, 2021);
INSERT INTO TB_SATELITE (nome, agencia, altitude_km, ano_lancamento) VALUES ('Sentinel-2B', 'ESA', 786.00, 2017);

-- =============================================================
-- 3. TB_USUARIO (10 usuários)
-- =============================================================
INSERT INTO TB_USUARIO (nome, email, senha, tipo_usuario, data_cadastro) VALUES ('Carlos Silva', 'carlos.silva@carbontrace.com', 'hash_senha_001', 'ADMIN', DATE '2024-01-10');
INSERT INTO TB_USUARIO (nome, email, senha, tipo_usuario, data_cadastro) VALUES ('Ana Oliveira', 'ana.oliveira@carbontrace.com', 'hash_senha_002', 'ANALISTA', DATE '2024-01-15');
INSERT INTO TB_USUARIO (nome, email, senha, tipo_usuario, data_cadastro) VALUES ('Pedro Santos', 'pedro.santos@carbontrace.com', 'hash_senha_003', 'FISCAL', DATE '2024-02-01');
INSERT INTO TB_USUARIO (nome, email, senha, tipo_usuario, data_cadastro) VALUES ('Mariana Costa', 'mariana.costa@carbontrace.com', 'hash_senha_004', 'ANALISTA', DATE '2024-02-10');
INSERT INTO TB_USUARIO (nome, email, senha, tipo_usuario, data_cadastro) VALUES ('João Ferreira', 'joao.ferreira@carbontrace.com', 'hash_senha_005', 'FISCAL', DATE '2024-03-05');
INSERT INTO TB_USUARIO (nome, email, senha, tipo_usuario, data_cadastro) VALUES ('Luciana Rocha', 'luciana.rocha@carbontrace.com', 'hash_senha_006', 'FISCAL', DATE '2024-03-15');
INSERT INTO TB_USUARIO (nome, email, senha, tipo_usuario, data_cadastro) VALUES ('Roberto Lima', 'roberto.lima@carbontrace.com', 'hash_senha_007', 'ANALISTA', DATE '2024-04-01');
INSERT INTO TB_USUARIO (nome, email, senha, tipo_usuario, data_cadastro) VALUES ('Fernanda Alves', 'fernanda.alves@carbontrace.com', 'hash_senha_008', 'ADMIN', DATE '2024-04-20');
INSERT INTO TB_USUARIO (nome, email, senha, tipo_usuario, data_cadastro) VALUES ('Thiago Mendes', 'thiago.mendes@carbontrace.com', 'hash_senha_009', 'FISCAL', DATE '2024-05-10');
INSERT INTO TB_USUARIO (nome, email, senha, tipo_usuario, data_cadastro) VALUES ('Camila Souza', 'camila.souza@carbontrace.com', 'hash_senha_010', 'ANALISTA', DATE '2024-05-20');

-- =============================================================
-- 4. TB_REGIAO (15 regiões)
-- =============================================================
INSERT INTO TB_REGIAO (nome, latitude, longitude, area_km2, id_estado) VALUES ('Amazônia Central', -3.465305, -62.215881, 15420.50, 4);
INSERT INTO TB_REGIAO (nome, latitude, longitude, area_km2, id_estado) VALUES ('Nordeste do Pará', -2.431908, -48.450000, 8750.00, 14);
INSERT INTO TB_REGIAO (nome, latitude, longitude, area_km2, id_estado) VALUES ('Sul do Amazonas', -7.123456, -64.876543, 12300.75, 4);
INSERT INTO TB_REGIAO (nome, latitude, longitude, area_km2, id_estado) VALUES ('Norte de Mato Grosso', -10.234567, -55.678901, 9800.25, 11);
INSERT INTO TB_REGIAO (nome, latitude, longitude, area_km2, id_estado) VALUES ('Leste do Acre', -9.012345, -68.345678, 6500.00, 1);
INSERT INTO TB_REGIAO (nome, latitude, longitude, area_km2, id_estado) VALUES ('Centro de Roraima', -2.567890, -61.234567, 11200.50, 23);
INSERT INTO TB_REGIAO (nome, latitude, longitude, area_km2, id_estado) VALUES ('Norte do Tocantins', -7.890123, -48.123456, 5400.75, 27);
INSERT INTO TB_REGIAO (nome, latitude, longitude, area_km2, id_estado) VALUES ('Oeste da Bahia', -12.345678, -44.567890, 7800.00, 5);
INSERT INTO TB_REGIAO (nome, latitude, longitude, area_km2, id_estado) VALUES ('Sul do Maranhão', -6.789012, -44.901234, 6200.25, 10);
INSERT INTO TB_REGIAO (nome, latitude, longitude, area_km2, id_estado) VALUES ('Norte de Rondônia', -9.456789, -63.789012, 8900.50, 22);
INSERT INTO TB_REGIAO (nome, latitude, longitude, area_km2, id_estado) VALUES ('Leste do Amapá', -1.234567, -51.012345, 4300.00, 3);
INSERT INTO TB_REGIAO (nome, latitude, longitude, area_km2, id_estado) VALUES ('Centro de Goiás', -16.012345, -49.456789, 5600.75, 9);
INSERT INTO TB_REGIAO (nome, latitude, longitude, area_km2, id_estado) VALUES ('Norte de Minas Gerais', -15.678901, -43.234567, 7100.25, 13);
INSERT INTO TB_REGIAO (nome, latitude, longitude, area_km2, id_estado) VALUES ('Oeste do Pará', -4.567890, -54.678901, 13500.00, 14);
INSERT INTO TB_REGIAO (nome, latitude, longitude, area_km2, id_estado) VALUES ('Sul de Mato Grosso do Sul', -21.345678, -54.901234, 9200.50, 12);

-- =============================================================
-- 5. TB_ORGAO_AMBIENTAL (8 órgãos)
-- =============================================================
INSERT INTO TB_ORGAO_AMBIENTAL (nome, tipo, email_contato, id_estado) VALUES ('IBAMA Regional Amazonas', 'FEDERAL', 'ibama.am@ibama.gov.br', 4);
INSERT INTO TB_ORGAO_AMBIENTAL (nome, tipo, email_contato, id_estado) VALUES ('SEMA Mato Grosso', 'ESTADUAL', 'sema@mt.gov.br', 11);
INSERT INTO TB_ORGAO_AMBIENTAL (nome, tipo, email_contato, id_estado) VALUES ('IBAMA Regional Pará', 'FEDERAL', 'ibama.pa@ibama.gov.br', 14);
INSERT INTO TB_ORGAO_AMBIENTAL (nome, tipo, email_contato, id_estado) VALUES ('SEMAT Acre', 'ESTADUAL', 'semat@ac.gov.br', 1);
INSERT INTO TB_ORGAO_AMBIENTAL (nome, tipo, email_contato, id_estado) VALUES ('FEMA Roraima', 'ESTADUAL', 'fema@rr.gov.br', 23);
INSERT INTO TB_ORGAO_AMBIENTAL (nome, tipo, email_contato, id_estado) VALUES ('SOS Amazônia', 'ONG', 'contato@sosamaz.org.br', 4);
INSERT INTO TB_ORGAO_AMBIENTAL (nome, tipo, email_contato, id_estado) VALUES ('INEMA Bahia', 'ESTADUAL', 'inema@ba.gov.br', 5);
INSERT INTO TB_ORGAO_AMBIENTAL (nome, tipo, email_contato, id_estado) VALUES ('IBAMA Regional Rondônia', 'FEDERAL', 'ibama.ro@ibama.gov.br', 22);

-- =============================================================
-- 6. TB_IMAGEM_SATELITAL (15 imagens)
-- =============================================================
INSERT INTO TB_IMAGEM_SATELITAL (data_captura, resolucao_metros, url_imagem, id_regiao, id_satelite) VALUES (DATE '2024-01-05', 30.00, 'https://satelite.carbontrace.com/img/2024/01/regiao1_landsat8.tif', 1, 1);
INSERT INTO TB_IMAGEM_SATELITAL (data_captura, resolucao_metros, url_imagem, id_regiao, id_satelite) VALUES (DATE '2024-01-10', 10.00, 'https://satelite.carbontrace.com/img/2024/01/regiao2_sentinel2a.tif', 2, 2);
INSERT INTO TB_IMAGEM_SATELITAL (data_captura, resolucao_metros, url_imagem, id_regiao, id_satelite) VALUES (DATE '2024-01-15', 20.00, 'https://satelite.carbontrace.com/img/2024/01/regiao3_cbers4a.tif', 3, 3);
INSERT INTO TB_IMAGEM_SATELITAL (data_captura, resolucao_metros, url_imagem, id_regiao, id_satelite) VALUES (DATE '2024-02-01', 30.00, 'https://satelite.carbontrace.com/img/2024/02/regiao4_landsat9.tif', 4, 4);
INSERT INTO TB_IMAGEM_SATELITAL (data_captura, resolucao_metros, url_imagem, id_regiao, id_satelite) VALUES (DATE '2024-02-10', 10.00, 'https://satelite.carbontrace.com/img/2024/02/regiao5_sentinel2b.tif', 5, 5);
INSERT INTO TB_IMAGEM_SATELITAL (data_captura, resolucao_metros, url_imagem, id_regiao, id_satelite) VALUES (DATE '2024-02-20', 30.00, 'https://satelite.carbontrace.com/img/2024/02/regiao6_landsat8.tif', 6, 1);
INSERT INTO TB_IMAGEM_SATELITAL (data_captura, resolucao_metros, url_imagem, id_regiao, id_satelite) VALUES (DATE '2024-03-05', 10.00, 'https://satelite.carbontrace.com/img/2024/03/regiao7_sentinel2a.tif', 7, 2);
INSERT INTO TB_IMAGEM_SATELITAL (data_captura, resolucao_metros, url_imagem, id_regiao, id_satelite) VALUES (DATE '2024-03-15', 20.00, 'https://satelite.carbontrace.com/img/2024/03/regiao8_cbers4a.tif', 8, 3);
INSERT INTO TB_IMAGEM_SATELITAL (data_captura, resolucao_metros, url_imagem, id_regiao, id_satelite) VALUES (DATE '2024-03-25', 30.00, 'https://satelite.carbontrace.com/img/2024/03/regiao9_landsat9.tif', 9, 4);
INSERT INTO TB_IMAGEM_SATELITAL (data_captura, resolucao_metros, url_imagem, id_regiao, id_satelite) VALUES (DATE '2024-04-05', 10.00, 'https://satelite.carbontrace.com/img/2024/04/regiao10_sentinel2b.tif', 10, 5);
INSERT INTO TB_IMAGEM_SATELITAL (data_captura, resolucao_metros, url_imagem, id_regiao, id_satelite) VALUES (DATE '2024-04-15', 30.00, 'https://satelite.carbontrace.com/img/2024/04/regiao11_landsat8.tif', 11, 1);
INSERT INTO TB_IMAGEM_SATELITAL (data_captura, resolucao_metros, url_imagem, id_regiao, id_satelite) VALUES (DATE '2024-04-25', 10.00, 'https://satelite.carbontrace.com/img/2024/04/regiao12_sentinel2a.tif', 12, 2);
INSERT INTO TB_IMAGEM_SATELITAL (data_captura, resolucao_metros, url_imagem, id_regiao, id_satelite) VALUES (DATE '2024-05-05', 20.00, 'https://satelite.carbontrace.com/img/2024/05/regiao13_cbers4a.tif', 13, 3);
INSERT INTO TB_IMAGEM_SATELITAL (data_captura, resolucao_metros, url_imagem, id_regiao, id_satelite) VALUES (DATE '2024-05-15', 30.00, 'https://satelite.carbontrace.com/img/2024/05/regiao14_landsat9.tif', 14, 4);
INSERT INTO TB_IMAGEM_SATELITAL (data_captura, resolucao_metros, url_imagem, id_regiao, id_satelite) VALUES (DATE '2024-05-25', 10.00, 'https://satelite.carbontrace.com/img/2024/05/regiao15_sentinel2b.tif', 15, 5);

-- =============================================================
-- 7. TB_ANALISE (15 análises)
-- =============================================================
INSERT INTO TB_ANALISE (data_analise, area_desmatada_km2, percentual_variacao, status_alerta, id_imagem) VALUES (DATE '2024-01-06', 125.50, 2.30, 'NORMAL', 1);
INSERT INTO TB_ANALISE (data_analise, area_desmatada_km2, percentual_variacao, status_alerta, id_imagem) VALUES (DATE '2024-01-11', 340.75, 8.50, 'ATENCAO', 2);
INSERT INTO TB_ANALISE (data_analise, area_desmatada_km2, percentual_variacao, status_alerta, id_imagem) VALUES (DATE '2024-01-16', 890.25, 18.70, 'CRITICO', 3);
INSERT INTO TB_ANALISE (data_analise, area_desmatada_km2, percentual_variacao, status_alerta, id_imagem) VALUES (DATE '2024-02-02', 45.00, 1.20, 'NORMAL', 4);
INSERT INTO TB_ANALISE (data_analise, area_desmatada_km2, percentual_variacao, status_alerta, id_imagem) VALUES (DATE '2024-02-11', 1250.80, 25.40, 'EMERGENCIA', 5);
INSERT INTO TB_ANALISE (data_analise, area_desmatada_km2, percentual_variacao, status_alerta, id_imagem) VALUES (DATE '2024-02-21', 210.30, 5.60, 'ATENCAO', 6);
INSERT INTO TB_ANALISE (data_analise, area_desmatada_km2, percentual_variacao, status_alerta, id_imagem) VALUES (DATE '2024-03-06', 78.90, 3.10, 'NORMAL', 7);
INSERT INTO TB_ANALISE (data_analise, area_desmatada_km2, percentual_variacao, status_alerta, id_imagem) VALUES (DATE '2024-03-16', 560.40, 12.80, 'CRITICO', 8);
INSERT INTO TB_ANALISE (data_analise, area_desmatada_km2, percentual_variacao, status_alerta, id_imagem) VALUES (DATE '2024-03-26', 180.60, 4.90, 'ATENCAO', 9);
INSERT INTO TB_ANALISE (data_analise, area_desmatada_km2, percentual_variacao, status_alerta, id_imagem) VALUES (DATE '2024-04-06', 920.15, 19.30, 'CRITICO', 10);
INSERT INTO TB_ANALISE (data_analise, area_desmatada_km2, percentual_variacao, status_alerta, id_imagem) VALUES (DATE '2024-04-16', 35.20, 0.90, 'NORMAL', 11);
INSERT INTO TB_ANALISE (data_analise, area_desmatada_km2, percentual_variacao, status_alerta, id_imagem) VALUES (DATE '2024-04-26', 1580.70, 32.60, 'EMERGENCIA', 12);
INSERT INTO TB_ANALISE (data_analise, area_desmatada_km2, percentual_variacao, status_alerta, id_imagem) VALUES (DATE '2024-05-06', 290.45, 7.40, 'ATENCAO', 13);
INSERT INTO TB_ANALISE (data_analise, area_desmatada_km2, percentual_variacao, status_alerta, id_imagem) VALUES (DATE '2024-05-16', 670.80, 14.20, 'CRITICO', 14);
INSERT INTO TB_ANALISE (data_analise, area_desmatada_km2, percentual_variacao, status_alerta, id_imagem) VALUES (DATE '2024-05-26', 95.30, 3.80, 'NORMAL', 15);

-- =============================================================
-- 8. TB_ALERTA (10 alertas - apenas análises ATENCAO/CRITICO/EMERGENCIA)
-- =============================================================
INSERT INTO TB_ALERTA (data_emissao, nivel_criticidade, descricao, id_analise) VALUES (DATE '2024-01-11', 'MEDIO', 'Aumento significativo de desmatamento detectado na região nordeste do Pará.', 2);
INSERT INTO TB_ALERTA (data_emissao, nivel_criticidade, descricao, id_analise) VALUES (DATE '2024-01-16', 'ALTO', 'Área crítica de desmatamento identificada no sul do Amazonas. Ação imediata necessária.', 3);
INSERT INTO TB_ALERTA (data_emissao, nivel_criticidade, descricao, id_analise) VALUES (DATE '2024-02-11', 'CRITICO', 'Emergência ambiental declarada no leste do Acre. Desmatamento em escala alarmante.', 5);
INSERT INTO TB_ALERTA (data_emissao, nivel_criticidade, descricao, id_analise) VALUES (DATE '2024-02-21', 'MEDIO', 'Variação de desmatamento acima do limite aceitável no centro de Roraima.', 6);
INSERT INTO TB_ALERTA (data_emissao, nivel_criticidade, descricao, id_analise) VALUES (DATE '2024-03-16', 'ALTO', 'Desmatamento crítico detectado no oeste da Bahia. Fiscalização urgente requerida.', 8);
INSERT INTO TB_ALERTA (data_emissao, nivel_criticidade, descricao, id_analise) VALUES (DATE '2024-03-26', 'MEDIO', 'Aumento moderado de desmatamento no sul do Maranhão.', 9);
INSERT INTO TB_ALERTA (data_emissao, nivel_criticidade, descricao, id_analise) VALUES (DATE '2024-04-06', 'ALTO', 'Situação crítica no norte de Rondônia. Área desmatada ultrapassa limites legais.', 10);
INSERT INTO TB_ALERTA (data_emissao, nivel_criticidade, descricao, id_analise) VALUES (DATE '2024-04-26', 'CRITICO', 'Emergência ambiental no centro de Goiás. Maior índice de desmatamento registrado no período.', 12);
INSERT INTO TB_ALERTA (data_emissao, nivel_criticidade, descricao, id_analise) VALUES (DATE '2024-05-06', 'MEDIO', 'Desmatamento em crescimento no norte de Minas Gerais. Monitoramento reforçado.', 13);
INSERT INTO TB_ALERTA (data_emissao, nivel_criticidade, descricao, id_analise) VALUES (DATE '2024-05-16', 'ALTO', 'Área de desmatamento crítica identificada no oeste do Pará.', 14);

-- =============================================================
-- 9. TB_OCORRENCIA (10 ocorrências)
-- =============================================================
INSERT INTO TB_OCORRENCIA (data_ocorrencia, descricao, area_estimada_km2, id_regiao, id_usuario) VALUES (DATE '2024-01-20', 'Queimada identificada próxima à reserva indígena na Amazônia Central.', 45.80, 1, 3);
INSERT INTO TB_OCORRENCIA (data_ocorrencia, descricao, area_estimada_km2, id_regiao, id_usuario) VALUES (DATE '2024-01-25', 'Desmatamento ilegal para expansão de pastagem no nordeste do Pará.', 120.30, 2, 5);
INSERT INTO TB_OCORRENCIA (data_ocorrencia, descricao, area_estimada_km2, id_regiao, id_usuario) VALUES (DATE '2024-02-05', 'Corte raso de vegetação nativa no sul do Amazonas.', 89.50, 3, 6);
INSERT INTO TB_OCORRENCIA (data_ocorrencia, descricao, area_estimada_km2, id_regiao, id_usuario) VALUES (DATE '2024-02-15', 'Abertura de estrada clandestina causando desmatamento no norte de MT.', 35.20, 4, 3);
INSERT INTO TB_OCORRENCIA (data_ocorrencia, descricao, area_estimada_km2, id_regiao, id_usuario) VALUES (DATE '2024-03-01', 'Área de proteção ambiental invadida no leste do Acre.', 67.40, 5, 5);
INSERT INTO TB_OCORRENCIA (data_ocorrencia, descricao, area_estimada_km2, id_regiao, id_usuario) VALUES (DATE '2024-03-20', 'Desmatamento para agricultura no centro de Roraima.', 98.70, 6, 9);
INSERT INTO TB_OCORRENCIA (data_ocorrencia, descricao, area_estimada_km2, id_regiao, id_usuario) VALUES (DATE '2024-04-10', 'Extração ilegal de madeira no norte de Rondônia.', 150.60, 10, 6);
INSERT INTO TB_OCORRENCIA (data_ocorrencia, descricao, area_estimada_km2, id_regiao, id_usuario) VALUES (DATE '2024-04-30', 'Grande área de cerrado desmatada no centro de Goiás.', 210.90, 12, 3);
INSERT INTO TB_OCORRENCIA (data_ocorrencia, descricao, area_estimada_km2, id_regiao, id_usuario) VALUES (DATE '2024-05-10', 'Queimada criminosa no norte de Minas Gerais.', 78.30, 13, 9);
INSERT INTO TB_OCORRENCIA (data_ocorrencia, descricao, area_estimada_km2, id_regiao, id_usuario) VALUES (DATE '2024-05-20', 'Desmatamento de floresta ripária no oeste do Pará.', 55.40, 14, 5);

-- =============================================================
-- 10. TB_RELATORIO (5 relatórios)
-- =============================================================
INSERT INTO TB_RELATORIO (data_geracao, titulo, periodo_inicio, periodo_fim, id_usuario) VALUES (DATE '2024-02-01', 'Relatório de Desmatamento - Janeiro 2024', DATE '2024-01-01', DATE '2024-01-31', 2);
INSERT INTO TB_RELATORIO (data_geracao, titulo, periodo_inicio, periodo_fim, id_usuario) VALUES (DATE '2024-03-01', 'Relatório de Desmatamento - Fevereiro 2024', DATE '2024-02-01', DATE '2024-02-29', 4);
INSERT INTO TB_RELATORIO (data_geracao, titulo, periodo_inicio, periodo_fim, id_usuario) VALUES (DATE '2024-04-01', 'Relatório de Desmatamento - Março 2024', DATE '2024-03-01', DATE '2024-03-31', 2);
INSERT INTO TB_RELATORIO (data_geracao, titulo, periodo_inicio, periodo_fim, id_usuario) VALUES (DATE '2024-05-01', 'Relatório de Desmatamento - Abril 2024', DATE '2024-04-01', DATE '2024-04-30', 7);
INSERT INTO TB_RELATORIO (data_geracao, titulo, periodo_inicio, periodo_fim, id_usuario) VALUES (DATE '2024-06-01', 'Relatório de Desmatamento - Maio 2024', DATE '2024-05-01', DATE '2024-05-31', 10);

-- =============================================================
-- 11. TB_ALERTA_ORGAO (15 notificações)
-- =============================================================
INSERT INTO TB_ALERTA_ORGAO (id_alerta, id_orgao, data_notificacao, status_notificacao) VALUES (1, 3, DATE '2024-01-11', 'CONFIRMADO');
INSERT INTO TB_ALERTA_ORGAO (id_alerta, id_orgao, data_notificacao, status_notificacao) VALUES (2, 1, DATE '2024-01-16', 'CONFIRMADO');
INSERT INTO TB_ALERTA_ORGAO (id_alerta, id_orgao, data_notificacao, status_notificacao) VALUES (2, 6, DATE '2024-01-16', 'ENVIADO');
INSERT INTO TB_ALERTA_ORGAO (id_alerta, id_orgao, data_notificacao, status_notificacao) VALUES (3, 4, DATE '2024-02-11', 'CONFIRMADO');
INSERT INTO TB_ALERTA_ORGAO (id_alerta, id_orgao, data_notificacao, status_notificacao) VALUES (3, 6, DATE '2024-02-11', 'CONFIRMADO');
INSERT INTO TB_ALERTA_ORGAO (id_alerta, id_orgao, data_notificacao, status_notificacao) VALUES (4, 5, DATE '2024-02-21', 'ENVIADO');
INSERT INTO TB_ALERTA_ORGAO (id_alerta, id_orgao, data_notificacao, status_notificacao) VALUES (5, 2, DATE '2024-03-16', 'CONFIRMADO');
INSERT INTO TB_ALERTA_ORGAO (id_alerta, id_orgao, data_notificacao, status_notificacao) VALUES (5, 7, DATE '2024-03-16', 'PENDENTE');
INSERT INTO TB_ALERTA_ORGAO (id_alerta, id_orgao, data_notificacao, status_notificacao) VALUES (6, 7, DATE '2024-03-26', 'ENVIADO');
INSERT INTO TB_ALERTA_ORGAO (id_alerta, id_orgao, data_notificacao, status_notificacao) VALUES (7, 8, DATE '2024-04-06', 'CONFIRMADO');
INSERT INTO TB_ALERTA_ORGAO (id_alerta, id_orgao, data_notificacao, status_notificacao) VALUES (7, 1, DATE '2024-04-06', 'ENVIADO');
INSERT INTO TB_ALERTA_ORGAO (id_alerta, id_orgao, data_notificacao, status_notificacao) VALUES (8, 2, DATE '2024-04-26', 'CONFIRMADO');
INSERT INTO TB_ALERTA_ORGAO (id_alerta, id_orgao, data_notificacao, status_notificacao) VALUES (8, 6, DATE '2024-04-26', 'FALHA');
INSERT INTO TB_ALERTA_ORGAO (id_alerta, id_orgao, data_notificacao, status_notificacao) VALUES (9, 7, DATE '2024-05-06', 'PENDENTE');
INSERT INTO TB_ALERTA_ORGAO (id_alerta, id_orgao, data_notificacao, status_notificacao) VALUES (10, 3, DATE '2024-05-16', 'ENVIADO');

COMMIT;

-- =============================================================
-- CONTAGEM DE REGISTROS
-- =============================================================
SELECT 'TB_ESTADO'           AS tabela, COUNT(*) AS total FROM TB_ESTADO           UNION ALL
SELECT 'TB_SATELITE'         AS tabela, COUNT(*) AS total FROM TB_SATELITE          UNION ALL
SELECT 'TB_USUARIO'          AS tabela, COUNT(*) AS total FROM TB_USUARIO           UNION ALL
SELECT 'TB_REGIAO'           AS tabela, COUNT(*) AS total FROM TB_REGIAO            UNION ALL
SELECT 'TB_ORGAO_AMBIENTAL'  AS tabela, COUNT(*) AS total FROM TB_ORGAO_AMBIENTAL   UNION ALL
SELECT 'TB_IMAGEM_SATELITAL' AS tabela, COUNT(*) AS total FROM TB_IMAGEM_SATELITAL  UNION ALL
SELECT 'TB_ANALISE'          AS tabela, COUNT(*) AS total FROM TB_ANALISE           UNION ALL
SELECT 'TB_ALERTA'           AS tabela, COUNT(*) AS total FROM TB_ALERTA            UNION ALL
SELECT 'TB_OCORRENCIA'       AS tabela, COUNT(*) AS total FROM TB_OCORRENCIA        UNION ALL
SELECT 'TB_RELATORIO'        AS tabela, COUNT(*) AS total FROM TB_RELATORIO         UNION ALL
SELECT 'TB_ALERTA_ORGAO'     AS tabela, COUNT(*) AS total FROM TB_ALERTA_ORGAO;
