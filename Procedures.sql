-- =============================================================
-- CARBONTRACE - Sistema de Monitoramento de Desmatamento
-- PROCEDURES E FUNCTIONS
-- Banco de Dados: Oracle
-- =============================================================

SET SERVEROUTPUT ON;

-- =============================================================
-- PROCEDURES
-- =============================================================


-- =============================================================
-- 1. SP_CADASTRAR_OCORRENCIA
-- Cadastra uma nova ocorrência de desmatamento reportada
-- por um fiscal em campo.
-- =============================================================
CREATE OR REPLACE PROCEDURE SP_CADASTRAR_OCORRENCIA (
    p_data_ocorrencia   IN DATE,
    p_descricao         IN VARCHAR2,
    p_area_estimada     IN NUMBER,
    p_id_regiao         IN NUMBER,
    p_id_usuario        IN NUMBER
) AS
    v_tipo_usuario  TB_USUARIO.tipo_usuario%TYPE;
    v_count_regiao  NUMBER;
BEGIN
    -- Verifica se o usuário existe e é FISCAL ou ADMIN
    SELECT tipo_usuario
    INTO v_tipo_usuario
    FROM TB_USUARIO
    WHERE id_usuario = p_id_usuario;

    IF v_tipo_usuario NOT IN ('FISCAL', 'ADMIN') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Apenas FISCAL ou ADMIN podem cadastrar ocorrências.');
    END IF;

    -- Verifica se a região existe
    SELECT COUNT(*)
    INTO v_count_regiao
    FROM TB_REGIAO
    WHERE id_regiao = p_id_regiao;

    IF v_count_regiao = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Região informada não encontrada.');
    END IF;

    -- Verifica se a área é válida
    IF p_area_estimada <= 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Área estimada deve ser maior que zero.');
    END IF;

    -- Insere a ocorrência
    INSERT INTO TB_OCORRENCIA (
        data_ocorrencia,
        descricao,
        area_estimada_km2,
        id_regiao,
        id_usuario
    ) VALUES (
        p_data_ocorrencia,
        p_descricao,
        p_area_estimada,
        p_id_regiao,
        p_id_usuario
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Ocorrência cadastrada com sucesso!');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro: Usuário não encontrado.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
END SP_CADASTRAR_OCORRENCIA;
/


-- =============================================================
-- 2. SP_EMITIR_ALERTA
-- Gera um alerta a partir de uma análise com status
-- CRITICO ou EMERGENCIA.
-- =============================================================
CREATE OR REPLACE PROCEDURE SP_EMITIR_ALERTA (
    p_id_analise        IN NUMBER,
    p_descricao         IN VARCHAR2
) AS
    v_status_alerta     TB_ANALISE.status_alerta%TYPE;
    v_nivel_criticidade TB_ALERTA.nivel_criticidade%TYPE;
    v_count_alerta      NUMBER;
BEGIN
    -- Verifica se a análise existe
    SELECT status_alerta
    INTO v_status_alerta
    FROM TB_ANALISE
    WHERE id_analise = p_id_analise;

    -- Verifica se já existe alerta para essa análise
    SELECT COUNT(*)
    INTO v_count_alerta
    FROM TB_ALERTA
    WHERE id_analise = p_id_analise;

    IF v_count_alerta > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Já existe um alerta cadastrado para esta análise.');
    END IF;

    -- Define o nível de criticidade com base no status da análise
    IF v_status_alerta = 'ATENCAO' THEN
        v_nivel_criticidade := 'MEDIO';
    ELSIF v_status_alerta = 'CRITICO' THEN
        v_nivel_criticidade := 'ALTO';
    ELSIF v_status_alerta = 'EMERGENCIA' THEN
        v_nivel_criticidade := 'CRITICO';
    ELSE
        RAISE_APPLICATION_ERROR(-20005, 'Análise com status NORMAL não gera alerta.');
    END IF;

    -- Insere o alerta
    INSERT INTO TB_ALERTA (
        data_emissao,
        nivel_criticidade,
        descricao,
        id_analise
    ) VALUES (
        SYSDATE,
        v_nivel_criticidade,
        p_descricao,
        p_id_analise
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Alerta emitido com sucesso! Nível: ' || v_nivel_criticidade);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro: Análise não encontrada.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
END SP_EMITIR_ALERTA;
/


-- =============================================================
-- 3. SP_NOTIFICAR_ORGAOS
-- Notifica todos os órgãos ambientais de um estado
-- quando um alerta é emitido.
-- =============================================================
CREATE OR REPLACE PROCEDURE SP_NOTIFICAR_ORGAOS (
    p_id_alerta IN NUMBER
) AS
    v_id_estado     TB_ESTADO.id_estado%TYPE;
    v_count_alerta  NUMBER;
    v_count_orgaos  NUMBER;

    CURSOR cur_orgaos (p_estado NUMBER) IS
        SELECT id_orgao
        FROM TB_ORGAO_AMBIENTAL
        WHERE id_estado = p_estado;
BEGIN
    -- Verifica se o alerta existe
    SELECT COUNT(*)
    INTO v_count_alerta
    FROM TB_ALERTA
    WHERE id_alerta = p_id_alerta;

    IF v_count_alerta = 0 THEN
        RAISE_APPLICATION_ERROR(-20006, 'Alerta não encontrado.');
    END IF;

    -- Busca o estado da região vinculada ao alerta
    SELECT r.id_estado
    INTO v_id_estado
    FROM TB_ALERTA a
    JOIN TB_ANALISE an ON a.id_analise = an.id_analise
    JOIN TB_IMAGEM_SATELITAL i ON an.id_imagem = i.id_imagem
    JOIN TB_REGIAO r ON i.id_regiao = r.id_regiao
    WHERE a.id_alerta = p_id_alerta;

    -- Verifica se existem órgãos no estado
    SELECT COUNT(*)
    INTO v_count_orgaos
    FROM TB_ORGAO_AMBIENTAL
    WHERE id_estado = v_id_estado;

    IF v_count_orgaos = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum órgão encontrado para o estado.');
        RETURN;
    END IF;

    -- Notifica cada órgão do estado
    FOR reg IN cur_orgaos(v_id_estado) LOOP
        -- Evita duplicidade
        DECLARE
            v_exists NUMBER;
        BEGIN
            SELECT COUNT(*)
            INTO v_exists
            FROM TB_ALERTA_ORGAO
            WHERE id_alerta = p_id_alerta
            AND id_orgao = reg.id_orgao;

            IF v_exists = 0 THEN
                INSERT INTO TB_ALERTA_ORGAO (
                    id_alerta,
                    id_orgao,
                    data_notificacao,
                    status_notificacao
                ) VALUES (
                    p_id_alerta,
                    reg.id_orgao,
                    SYSDATE,
                    'PENDENTE'
                );
                DBMS_OUTPUT.PUT_LINE('Órgão ' || reg.id_orgao || ' notificado com sucesso.');
            ELSE
                DBMS_OUTPUT.PUT_LINE('Órgão ' || reg.id_orgao || ' já foi notificado.');
            END IF;
        END;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Notificação concluída para o estado ' || v_id_estado || '.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro: Dados não encontrados para o alerta informado.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
END SP_NOTIFICAR_ORGAOS;
/


-- =============================================================
-- 4. SP_ATUALIZAR_STATUS_NOTIFICACAO
-- Atualiza o status de notificação em TB_ALERTA_ORGAO
-- após confirmação do órgão.
-- =============================================================
CREATE OR REPLACE PROCEDURE SP_ATUALIZAR_STATUS_NOTIFICACAO (
    p_id_alerta             IN NUMBER,
    p_id_orgao              IN NUMBER,
    p_status_notificacao    IN VARCHAR2
) AS
    v_count NUMBER;
BEGIN
    -- Verifica se o registro existe
    SELECT COUNT(*)
    INTO v_count
    FROM TB_ALERTA_ORGAO
    WHERE id_alerta = p_id_alerta
    AND id_orgao = p_id_orgao;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20007, 'Notificação não encontrada para o alerta e órgão informados.');
    END IF;

    -- Valida o status informado
    IF p_status_notificacao NOT IN ('PENDENTE', 'ENVIADO', 'CONFIRMADO', 'FALHA') THEN
        RAISE_APPLICATION_ERROR(-20008, 'Status inválido. Use: PENDENTE, ENVIADO, CONFIRMADO ou FALHA.');
    END IF;

    -- Atualiza o status
    UPDATE TB_ALERTA_ORGAO
    SET status_notificacao = p_status_notificacao
    WHERE id_alerta = p_id_alerta
    AND id_orgao = p_id_orgao;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Status atualizado para ' || p_status_notificacao || ' com sucesso!');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
END SP_ATUALIZAR_STATUS_NOTIFICACAO;
/


-- =============================================================
-- 5. SP_CADASTRAR_ANALISE
-- Cadastra uma nova análise a partir de uma imagem satelital,
-- calculando o percentual de variação em relação à análise
-- anterior da mesma região.
-- =============================================================
CREATE OR REPLACE PROCEDURE SP_CADASTRAR_ANALISE (
    p_id_imagem         IN NUMBER,
    p_area_desmatada    IN NUMBER
) AS
    v_id_regiao             TB_REGIAO.id_regiao%TYPE;
    v_area_anterior         TB_ANALISE.area_desmatada_km2%TYPE := 0;
    v_percentual_variacao   NUMBER;
    v_status_alerta         VARCHAR2(20);
    v_count_imagem          NUMBER;
BEGIN
    -- Verifica se a imagem existe
    SELECT COUNT(*)
    INTO v_count_imagem
    FROM TB_IMAGEM_SATELITAL
    WHERE id_imagem = p_id_imagem;

    IF v_count_imagem = 0 THEN
        RAISE_APPLICATION_ERROR(-20009, 'Imagem satelital não encontrada.');
    END IF;

    IF p_area_desmatada < 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Área desmatada não pode ser negativa.');
    END IF;

    -- Busca a região da imagem
    SELECT id_regiao
    INTO v_id_regiao
    FROM TB_IMAGEM_SATELITAL
    WHERE id_imagem = p_id_imagem;

    -- Busca a área desmatada da análise anterior da mesma região
    BEGIN
        SELECT a.area_desmatada_km2
        INTO v_area_anterior
        FROM TB_ANALISE a
        JOIN TB_IMAGEM_SATELITAL i ON a.id_imagem = i.id_imagem
        WHERE i.id_regiao = v_id_regiao
        AND a.data_analise = (
            SELECT MAX(a2.data_analise)
            FROM TB_ANALISE a2
            JOIN TB_IMAGEM_SATELITAL i2 ON a2.id_imagem = i2.id_imagem
            WHERE i2.id_regiao = v_id_regiao
        );
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_area_anterior := 0;
    END;

    -- Calcula o percentual de variação
    IF v_area_anterior = 0 THEN
        v_percentual_variacao := 0;
    ELSE
        v_percentual_variacao := ROUND(((p_area_desmatada - v_area_anterior) / v_area_anterior) * 100, 2);
    END IF;

    -- Define o status do alerta com base no percentual
    IF v_percentual_variacao < 5 THEN
        v_status_alerta := 'NORMAL';
    ELSIF v_percentual_variacao < 10 THEN
        v_status_alerta := 'ATENCAO';
    ELSIF v_percentual_variacao < 20 THEN
        v_status_alerta := 'CRITICO';
    ELSE
        v_status_alerta := 'EMERGENCIA';
    END IF;

    -- Insere a análise
    INSERT INTO TB_ANALISE (
        data_analise,
        area_desmatada_km2,
        percentual_variacao,
        status_alerta,
        id_imagem
    ) VALUES (
        SYSDATE,
        p_area_desmatada,
        v_percentual_variacao,
        v_status_alerta,
        p_id_imagem
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Análise cadastrada com sucesso!');
    DBMS_OUTPUT.PUT_LINE('Área desmatada: ' || p_area_desmatada || ' km²');
    DBMS_OUTPUT.PUT_LINE('Variação: ' || v_percentual_variacao || '%');
    DBMS_OUTPUT.PUT_LINE('Status: ' || v_status_alerta);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
END SP_CADASTRAR_ANALISE;
/


-- =============================================================
-- FUNCTIONS
-- =============================================================


-- =============================================================
-- 1. FN_TOTAL_DESMATADO_REGIAO
-- Retorna o total de área desmatada em km² de uma região
-- em um período informado.
-- =============================================================
CREATE OR REPLACE FUNCTION FN_TOTAL_DESMATADO_REGIAO (
    p_id_regiao     IN NUMBER,
    p_data_inicio   IN DATE,
    p_data_fim      IN DATE
) RETURN NUMBER AS
    v_total NUMBER := 0;
BEGIN
    SELECT NVL(SUM(a.area_desmatada_km2), 0)
    INTO v_total
    FROM TB_ANALISE a
    JOIN TB_IMAGEM_SATELITAL i ON a.id_imagem = i.id_imagem
    WHERE i.id_regiao = p_id_regiao
    AND a.data_analise BETWEEN p_data_inicio AND p_data_fim;

    RETURN v_total;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
        RETURN -1;
END FN_TOTAL_DESMATADO_REGIAO;
/


-- =============================================================
-- 2. FN_NIVEL_CRITICIDADE
-- Recebe o percentual de variação e retorna automaticamente
-- o nível de criticidade correspondente.
-- =============================================================
CREATE OR REPLACE FUNCTION FN_NIVEL_CRITICIDADE (
    p_percentual_variacao IN NUMBER
) RETURN VARCHAR2 AS
    v_nivel VARCHAR2(20);
BEGIN
    IF p_percentual_variacao IS NULL THEN
        RAISE_APPLICATION_ERROR(-20011, 'Percentual de variação não pode ser nulo.');
    END IF;

    IF p_percentual_variacao < 5 THEN
        v_nivel := 'BAIXO';
    ELSIF p_percentual_variacao < 10 THEN
        v_nivel := 'MEDIO';
    ELSIF p_percentual_variacao < 20 THEN
        v_nivel := 'ALTO';
    ELSE
        v_nivel := 'CRITICO';
    END IF;

    RETURN v_nivel;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
        RETURN NULL;
END FN_NIVEL_CRITICIDADE;
/


-- =============================================================
-- 3. FN_CONTAR_ALERTAS_ESTADO
-- Retorna a quantidade de alertas emitidos em um estado
-- em um período informado.
-- =============================================================
CREATE OR REPLACE FUNCTION FN_CONTAR_ALERTAS_ESTADO (
    p_id_estado     IN NUMBER,
    p_data_inicio   IN DATE,
    p_data_fim      IN DATE
) RETURN NUMBER AS
    v_total NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO v_total
    FROM TB_ALERTA al
    JOIN TB_ANALISE an ON al.id_analise = an.id_analise
    JOIN TB_IMAGEM_SATELITAL i ON an.id_imagem = i.id_imagem
    JOIN TB_REGIAO r ON i.id_regiao = r.id_regiao
    WHERE r.id_estado = p_id_estado
    AND al.data_emissao BETWEEN p_data_inicio AND p_data_fim;

    RETURN v_total;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
        RETURN -1;
END FN_CONTAR_ALERTAS_ESTADO;
/


-- =============================================================
-- 4. FN_MEDIA_DESMATAMENTO_ESTADO
-- Recebe o ID de um estado e retorna a média de área
-- desmatada por região naquele estado.
-- =============================================================
CREATE OR REPLACE FUNCTION FN_MEDIA_DESMATAMENTO_ESTADO (
    p_id_estado IN NUMBER
) RETURN NUMBER AS
    v_media         NUMBER := 0;
    v_count_estado  NUMBER;
BEGIN
    -- Verifica se o estado existe
    SELECT COUNT(*)
    INTO v_count_estado
    FROM TB_ESTADO
    WHERE id_estado = p_id_estado;

    IF v_count_estado = 0 THEN
        RAISE_APPLICATION_ERROR(-20012, 'Estado não encontrado.');
    END IF;

    SELECT NVL(AVG(a.area_desmatada_km2), 0)
    INTO v_media
    FROM TB_ANALISE a
    JOIN TB_IMAGEM_SATELITAL i ON a.id_imagem = i.id_imagem
    JOIN TB_REGIAO r ON i.id_regiao = r.id_regiao
    WHERE r.id_estado = p_id_estado;

    RETURN ROUND(v_media, 2);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
        RETURN -1;
END FN_MEDIA_DESMATAMENTO_ESTADO;
/


-- =============================================================
-- 5. FN_VERIFICAR_REGIAO_CRITICA
-- Verifica se uma região possui alertas CRITICO ou EMERGENCIA
-- ativos nos últimos 30 dias. Retorna 1 para TRUE e 0 para FALSE.
-- =============================================================
CREATE OR REPLACE FUNCTION FN_VERIFICAR_REGIAO_CRITICA (
    p_id_regiao IN NUMBER
) RETURN NUMBER AS
    v_count         NUMBER := 0;
    v_count_regiao  NUMBER;
BEGIN
    -- Verifica se a região existe
    SELECT COUNT(*)
    INTO v_count_regiao
    FROM TB_REGIAO
    WHERE id_regiao = p_id_regiao;

    IF v_count_regiao = 0 THEN
        RAISE_APPLICATION_ERROR(-20013, 'Região não encontrada.');
    END IF;

    SELECT COUNT(*)
    INTO v_count
    FROM TB_ALERTA al
    JOIN TB_ANALISE an ON al.id_analise = an.id_analise
    JOIN TB_IMAGEM_SATELITAL i ON an.id_imagem = i.id_imagem
    WHERE i.id_regiao = p_id_regiao
    AND al.nivel_criticidade IN ('ALTO', 'CRITICO')
    AND al.data_emissao >= SYSDATE - 30;

    IF v_count > 0 THEN
        RETURN 1; -- TRUE - região crítica
    ELSE
        RETURN 0; -- FALSE - região normal
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
        RETURN -1;
END FN_VERIFICAR_REGIAO_CRITICA;
/


-- =============================================================
-- CARBONTRACE - TESTES DAS PROCEDURES E FUNCTIONS (CORRIGIDO)
-- Correção: valores decimais declarados em variáveis intermediárias
-- =============================================================

-- Teste SP_CADASTRAR_OCORRENCIA
DECLARE
    v_area NUMBER := 50.75;
BEGIN
    SP_CADASTRAR_OCORRENCIA(
        p_data_ocorrencia => DATE '2024-06-01',
        p_descricao       => 'Teste de ocorrência via procedure.',
        p_area_estimada   => v_area,
        p_id_regiao       => 1,
        p_id_usuario      => 3
    );
END;
/

-- Teste SP_EMITIR_ALERTA
BEGIN
    SP_EMITIR_ALERTA(
        p_id_analise => 2,
        p_descricao  => 'Alerta gerado via procedure de teste.'
    );
END;
/

-- Teste SP_NOTIFICAR_ORGAOS
BEGIN
    SP_NOTIFICAR_ORGAOS(p_id_alerta => 2);
END;
/

-- Teste SP_ATUALIZAR_STATUS_NOTIFICACAO
BEGIN
    SP_ATUALIZAR_STATUS_NOTIFICACAO(
        p_id_alerta             => 2,
        p_id_orgao              => 1,
        p_status_notificacao    => 'CONFIRMADO'
    );
END;
/

-- Teste SP_CADASTRAR_ANALISE
DECLARE
    v_area NUMBER := 200.50;
BEGIN
    SP_CADASTRAR_ANALISE(
        p_id_imagem      => 2,
        p_area_desmatada => v_area
    );
END;
/

-- Teste FN_TOTAL_DESMATADO_REGIAO
DECLARE
    v_total NUMBER;
BEGIN
    v_total := FN_TOTAL_DESMATADO_REGIAO(1, DATE '2024-01-01', DATE '2024-12-31');
    DBMS_OUTPUT.PUT_LINE('Total desmatado na região 1: ' || v_total || ' km²');
END;
/

-- Teste FN_NIVEL_CRITICIDADE
DECLARE
    v_nivel      VARCHAR2(20);
    v_percentual NUMBER := 15.5;
BEGIN
    v_nivel := FN_NIVEL_CRITICIDADE(v_percentual);
    DBMS_OUTPUT.PUT_LINE('Nível de criticidade para 15.5%: ' || v_nivel);
END;
/

-- Teste FN_CONTAR_ALERTAS_ESTADO
DECLARE
    v_total NUMBER;
BEGIN
    v_total := FN_CONTAR_ALERTAS_ESTADO(4, DATE '2024-01-01', DATE '2024-12-31');
    DBMS_OUTPUT.PUT_LINE('Total de alertas no Amazonas: ' || v_total);
END;
/

-- Teste FN_MEDIA_DESMATAMENTO_ESTADO
DECLARE
    v_media NUMBER;
BEGIN
    v_media := FN_MEDIA_DESMATAMENTO_ESTADO(4);
    DBMS_OUTPUT.PUT_LINE('Média de desmatamento no Amazonas: ' || v_media || ' km²');
END;
/

-- Teste FN_VERIFICAR_REGIAO_CRITICA
DECLARE
    v_critica NUMBER;
BEGIN
    v_critica := FN_VERIFICAR_REGIAO_CRITICA(1);
    IF v_critica = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Região 1 está em situação CRÍTICA!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Região 1 está em situação NORMAL.');
    END IF;
END;
/
