-- =============================================================
-- CARBONTRACE - Sistema de Monitoramento de Desmatamento
-- DDL - Data Definition Language
-- CRIANDO TABELAS
-- Banco de Dados: Oracle
-- =============================================================

-- =============================================================
-- 1. TB_ESTADO
-- =============================================================
CREATE TABLE TB_ESTADO (
    id_estado   NUMBER(2)       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome        VARCHAR2(100)   NOT NULL,
    sigla       CHAR(2)         NOT NULL UNIQUE,
    CONSTRAINT chk_sigla_estado CHECK (sigla = UPPER(sigla))
);

-- =============================================================
-- 2. TB_SATELITE
-- =============================================================
CREATE TABLE TB_SATELITE (
    id_satelite     NUMBER(5)       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome            VARCHAR2(100)   NOT NULL,
    agencia         VARCHAR2(100)   NOT NULL,
    altitude_km     NUMBER(7,2)     NOT NULL,
    ano_lancamento  NUMBER(4)       NOT NULL,
    CONSTRAINT chk_altitude CHECK (altitude_km > 0),
    CONSTRAINT chk_ano_satelite CHECK (ano_lancamento BETWEEN 1950 AND 2100)
);

-- =============================================================
-- 3. TB_USUARIO
-- =============================================================
CREATE TABLE TB_USUARIO (
    id_usuario      NUMBER(10)      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome            VARCHAR2(150)   NOT NULL,
    email           VARCHAR2(200)   NOT NULL UNIQUE,
    senha           VARCHAR2(255)   NOT NULL,
    tipo_usuario    VARCHAR2(20)    NOT NULL,
    data_cadastro   DATE            DEFAULT SYSDATE NOT NULL,
    CONSTRAINT chk_tipo_usuario CHECK (tipo_usuario IN ('ADMIN', 'ANALISTA', 'FISCAL'))
);

-- =============================================================
-- 4. TB_REGIAO
-- =============================================================
CREATE TABLE TB_REGIAO (
    id_regiao   NUMBER(10)      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome        VARCHAR2(150)   NOT NULL,
    latitude    NUMBER(9,6)     NOT NULL,
    longitude   NUMBER(9,6)     NOT NULL,
    area_km2    NUMBER(12,2)    NOT NULL,
    id_estado   NUMBER(2)       NOT NULL,
    CONSTRAINT fk_regiao_estado FOREIGN KEY (id_estado) REFERENCES TB_ESTADO(id_estado),
    CONSTRAINT chk_area_regiao CHECK (area_km2 > 0),
    CONSTRAINT chk_latitude CHECK (latitude BETWEEN -90 AND 90),
    CONSTRAINT chk_longitude CHECK (longitude BETWEEN -180 AND 180)
);

-- =============================================================
-- 5. TB_ORGAO_AMBIENTAL
-- =============================================================
CREATE TABLE TB_ORGAO_AMBIENTAL (
    id_orgao        NUMBER(10)      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome            VARCHAR2(200)   NOT NULL,
    tipo            VARCHAR2(50)    NOT NULL,
    email_contato   VARCHAR2(200)   NOT NULL,
    id_estado       NUMBER(2)       NOT NULL,
    CONSTRAINT fk_orgao_estado FOREIGN KEY (id_estado) REFERENCES TB_ESTADO(id_estado),
    CONSTRAINT chk_tipo_orgao CHECK (tipo IN ('FEDERAL', 'ESTADUAL', 'MUNICIPAL', 'ONG'))
);

-- =============================================================
-- 6. TB_IMAGEM_SATELITAL
-- =============================================================
CREATE TABLE TB_IMAGEM_SATELITAL (
    id_imagem           NUMBER(10)      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    data_captura        DATE            NOT NULL,
    resolucao_metros    NUMBER(6,2)     NOT NULL,
    url_imagem          VARCHAR2(500)   NOT NULL,
    id_regiao           NUMBER(10)      NOT NULL,
    id_satelite         NUMBER(5)       NOT NULL,
    CONSTRAINT fk_imagem_regiao     FOREIGN KEY (id_regiao)   REFERENCES TB_REGIAO(id_regiao),
    CONSTRAINT fk_imagem_satelite   FOREIGN KEY (id_satelite) REFERENCES TB_SATELITE(id_satelite),
    CONSTRAINT chk_resolucao CHECK (resolucao_metros > 0)
);

-- =============================================================
-- 7. TB_ANALISE
-- =============================================================
CREATE TABLE TB_ANALISE (
    id_analise              NUMBER(10)      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    data_analise            DATE            DEFAULT SYSDATE NOT NULL,
    area_desmatada_km2      NUMBER(12,4)    NOT NULL,
    percentual_variacao     NUMBER(6,2)     NOT NULL,
    status_alerta           VARCHAR2(20)    NOT NULL,
    id_imagem               NUMBER(10)      NOT NULL,
    CONSTRAINT fk_analise_imagem FOREIGN KEY (id_imagem) REFERENCES TB_IMAGEM_SATELITAL(id_imagem),
    CONSTRAINT chk_area_desmatada CHECK (area_desmatada_km2 >= 0),
    CONSTRAINT chk_status_alerta CHECK (status_alerta IN ('NORMAL', 'ATENCAO', 'CRITICO', 'EMERGENCIA'))
);

-- =============================================================
-- 8. TB_ALERTA
-- =============================================================
CREATE TABLE TB_ALERTA (
    id_alerta           NUMBER(10)      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    data_emissao        DATE            DEFAULT SYSDATE NOT NULL,
    nivel_criticidade   VARCHAR2(20)    NOT NULL,
    descricao           VARCHAR2(500)   NOT NULL,
    id_analise          NUMBER(10)      NOT NULL,
    CONSTRAINT fk_alerta_analise FOREIGN KEY (id_analise) REFERENCES TB_ANALISE(id_analise),
    CONSTRAINT chk_nivel_criticidade CHECK (nivel_criticidade IN ('BAIXO', 'MEDIO', 'ALTO', 'CRITICO'))
);

-- =============================================================
-- 9. TB_OCORRENCIA
-- =============================================================
CREATE TABLE TB_OCORRENCIA (
    id_ocorrencia       NUMBER(10)      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    data_ocorrencia     DATE            NOT NULL,
    descricao           VARCHAR2(500)   NOT NULL,
    area_estimada_km2   NUMBER(12,4)    NOT NULL,
    id_regiao           NUMBER(10)      NOT NULL,
    id_usuario          NUMBER(10)      NOT NULL,
    CONSTRAINT fk_ocorrencia_regiao   FOREIGN KEY (id_regiao)   REFERENCES TB_REGIAO(id_regiao),
    CONSTRAINT fk_ocorrencia_usuario  FOREIGN KEY (id_usuario)  REFERENCES TB_USUARIO(id_usuario),
    CONSTRAINT chk_area_ocorrencia CHECK (area_estimada_km2 > 0)
);

-- =============================================================
-- 10. TB_RELATORIO
-- =============================================================
CREATE TABLE TB_RELATORIO (
    id_relatorio    NUMBER(10)      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    data_geracao    DATE            DEFAULT SYSDATE NOT NULL,
    titulo          VARCHAR2(300)   NOT NULL,
    periodo_inicio  DATE            NOT NULL,
    periodo_fim     DATE            NOT NULL,
    id_usuario      NUMBER(10)      NOT NULL,
    CONSTRAINT fk_relatorio_usuario FOREIGN KEY (id_usuario) REFERENCES TB_USUARIO(id_usuario),
    CONSTRAINT chk_periodo CHECK (periodo_fim >= periodo_inicio)
);

-- =============================================================
-- 11. TB_ALERTA_ORGAO (N:N entre alerta e orgao)
-- =============================================================
CREATE TABLE TB_ALERTA_ORGAO (
    id_alerta           NUMBER(10)      NOT NULL,
    id_orgao            NUMBER(10)      NOT NULL,
    data_notificacao    DATE            DEFAULT SYSDATE NOT NULL,
    status_notificacao  VARCHAR2(20)    NOT NULL,
    CONSTRAINT pk_alerta_orgao PRIMARY KEY (id_alerta, id_orgao),
    CONSTRAINT fk_ao_alerta FOREIGN KEY (id_alerta) REFERENCES TB_ALERTA(id_alerta),
    CONSTRAINT fk_ao_orgao  FOREIGN KEY (id_orgao)  REFERENCES TB_ORGAO_AMBIENTAL(id_orgao),
    CONSTRAINT chk_status_notificacao CHECK (status_notificacao IN ('PENDENTE', 'ENVIADO', 'CONFIRMADO', 'FALHA'))
);
