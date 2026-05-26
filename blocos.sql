-- =============================================================
-- CARBONTRACE - Sistema de Monitoramento de Desmatamento
-- BLOCOS ANÔNIMOS, CURSORES, ESTRUTURAS DE REPETIÇÃO E CONDICIONAIS
-- Banco de Dados: Oracle
-- =============================================================

SET SERVEROUTPUT ON;

-- =============================================================
-- BLOCO 1
-- Exibe informações de todas as regiões e classifica
-- o nível de risco com base na área em km²
-- Contém: variáveis, SELECT INTO, IF/ELSIF/ELSE, exceção
-- =============================================================
DECLARE
    v_id_regiao     TB_REGIAO.id_regiao%TYPE;
    v_nome_regiao   TB_REGIAO.nome%TYPE;
    v_area          TB_REGIAO.area_km2%TYPE;
    v_classificacao VARCHAR2(20);

    CURSOR cur_regioes IS
        SELECT id_regiao, nome, area_km2
        FROM TB_REGIAO
        ORDER BY area_km2 DESC;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== CLASSIFICAÇÃO DE REGIÕES POR ÁREA ===');

    FOR reg IN cur_regioes LOOP
        v_id_regiao   := reg.id_regiao;
        v_nome_regiao := reg.nome;
        v_area        := reg.area_km2;

        -- Estrutura condicional 1
        IF v_area > 12000 THEN
            v_classificacao := 'GRANDE';
        ELSIF v_area > 8000 THEN
            v_classificacao := 'MEDIA';
        ELSIF v_area > 5000 THEN
            v_classificacao := 'PEQUENA';
        ELSE
            v_classificacao := 'MUITO PEQUENA';
        END IF;

        DBMS_OUTPUT.PUT_LINE(
            'Região: ' || v_nome_regiao ||
            ' | Área: ' || v_area || ' km²' ||
            ' | Classificação: ' || v_classificacao
        );
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado no Bloco 1: ' || SQLERRM);
END;
/


-- =============================================================
-- BLOCO 2
-- Percorre todas as análises e exibe o status de alerta
-- utilizando estrutura de repetição FOR LOOP
-- Contém: variáveis, FOR LOOP, IF/ELSIF/ELSE, exceção
-- =============================================================
DECLARE
    v_total_normal      NUMBER := 0;
    v_total_atencao     NUMBER := 0;
    v_total_critico     NUMBER := 0;
    v_total_emergencia  NUMBER := 0;

    CURSOR cur_analises IS
        SELECT id_analise, status_alerta, area_desmatada_km2
        FROM TB_ANALISE
        ORDER BY id_analise;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== CONTAGEM DE ANÁLISES POR STATUS ===');

    FOR reg IN cur_analises LOOP
        -- Estrutura condicional 2
        IF reg.status_alerta = 'NORMAL' THEN
            v_total_normal := v_total_normal + 1;
        ELSIF reg.status_alerta = 'ATENCAO' THEN
            v_total_atencao := v_total_atencao + 1;
        ELSIF reg.status_alerta = 'CRITICO' THEN
            v_total_critico := v_total_critico + 1;
        ELSE
            v_total_emergencia := v_total_emergencia + 1;
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Normal: '     || v_total_normal);
    DBMS_OUTPUT.PUT_LINE('Atenção: '    || v_total_atencao);
    DBMS_OUTPUT.PUT_LINE('Crítico: '    || v_total_critico);
    DBMS_OUTPUT.PUT_LINE('Emergência: ' || v_total_emergencia);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado no Bloco 2: ' || SQLERRM);
END;
/


-- =============================================================
-- BLOCO 3
-- Busca os dados de um usuário pelo ID e exibe suas informações
-- utilizando SELECT INTO e tratamento de exceção NO_DATA_FOUND
-- Contém: variáveis, SELECT INTO, IF/ELSIF/ELSE, exceção
-- =============================================================
DECLARE
    v_id_usuario    TB_USUARIO.id_usuario%TYPE := 2;
    v_nome          TB_USUARIO.nome%TYPE;
    v_email         TB_USUARIO.email%TYPE;
    v_tipo          TB_USUARIO.tipo_usuario%TYPE;
    v_perfil        VARCHAR2(50);
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== INFORMAÇÕES DO USUÁRIO ===');

    SELECT nome, email, tipo_usuario
    INTO v_nome, v_email, v_tipo
    FROM TB_USUARIO
    WHERE id_usuario = v_id_usuario;

    -- Estrutura condicional 3
    IF v_tipo = 'ADMIN' THEN
        v_perfil := 'Administrador do sistema com acesso total.';
    ELSIF v_tipo = 'ANALISTA' THEN
        v_perfil := 'Analista responsável por análises satelitais.';
    ELSE
        v_perfil := 'Fiscal responsável por ocorrências em campo.';
    END IF;

    DBMS_OUTPUT.PUT_LINE('Nome: '   || v_nome);
    DBMS_OUTPUT.PUT_LINE('Email: '  || v_email);
    DBMS_OUTPUT.PUT_LINE('Tipo: '   || v_tipo);
    DBMS_OUTPUT.PUT_LINE('Perfil: ' || v_perfil);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Usuário com ID ' || v_id_usuario || ' não encontrado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado no Bloco 3: ' || SQLERRM);
END;
/


-- =============================================================
-- BLOCO 4
-- Percorre os alertas emitidos e exibe o nível de criticidade
-- utilizando WHILE LOOP
-- Contém: variáveis, WHILE LOOP, SELECT INTO, exceção
-- =============================================================
DECLARE
    v_contador      NUMBER := 1;
    v_total_alertas NUMBER;
    v_id_alerta     TB_ALERTA.id_alerta%TYPE;
    v_nivel         TB_ALERTA.nivel_criticidade%TYPE;
    v_descricao     TB_ALERTA.descricao%TYPE;

    CURSOR cur_alertas IS
        SELECT id_alerta, nivel_criticidade, descricao
        FROM TB_ALERTA
        ORDER BY data_emissao;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== LISTAGEM DE ALERTAS EMITIDOS ===');

    SELECT COUNT(*)
    INTO v_total_alertas
    FROM TB_ALERTA;

    OPEN cur_alertas;

    -- Estrutura de repetição 1: WHILE LOOP
    WHILE v_contador <= v_total_alertas LOOP
        FETCH cur_alertas INTO v_id_alerta, v_nivel, v_descricao;
        EXIT WHEN cur_alertas%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'Alerta #' || v_id_alerta ||
            ' | Nível: ' || v_nivel ||
            ' | ' || SUBSTR(v_descricao, 1, 60) || '...'
        );

        v_contador := v_contador + 1;
    END LOOP;

    CLOSE cur_alertas;

EXCEPTION
    WHEN OTHERS THEN
        IF cur_alertas%ISOPEN THEN
            CLOSE cur_alertas;
        END IF;
        DBMS_OUTPUT.PUT_LINE('Erro inesperado no Bloco 4: ' || SQLERRM);
END;
/


-- =============================================================
-- BLOCO 5
-- Lista os órgãos ambientais e a quantidade de alertas
-- recebidos por cada um utilizando cursor explícito
-- Contém: cursor explícito, LOOP EXIT WHEN, SELECT INTO, exceção
-- =============================================================
DECLARE
    v_id_orgao      TB_ORGAO_AMBIENTAL.id_orgao%TYPE;
    v_nome_orgao    TB_ORGAO_AMBIENTAL.nome%TYPE;
    v_tipo_orgao    TB_ORGAO_AMBIENTAL.tipo%TYPE;
    v_total_alertas NUMBER;

    CURSOR cur_orgaos IS
        SELECT id_orgao, nome, tipo
        FROM TB_ORGAO_AMBIENTAL
        ORDER BY nome;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== ALERTAS RECEBIDOS POR ÓRGÃO ===');

    OPEN cur_orgaos;

    -- Estrutura de repetição 2: LOOP EXIT WHEN
    LOOP
        FETCH cur_orgaos INTO v_id_orgao, v_nome_orgao, v_tipo_orgao;
        EXIT WHEN cur_orgaos%NOTFOUND;

        SELECT COUNT(*)
        INTO v_total_alertas
        FROM TB_ALERTA_ORGAO
        WHERE id_orgao = v_id_orgao;

        DBMS_OUTPUT.PUT_LINE(
            'Órgão: ' || v_nome_orgao ||
            ' | Tipo: ' || v_tipo_orgao ||
            ' | Alertas recebidos: ' || v_total_alertas
        );
    END LOOP;

    CLOSE cur_orgaos;

EXCEPTION
    WHEN OTHERS THEN
        IF cur_orgaos%ISOPEN THEN
            CLOSE cur_orgaos;
        END IF;
        DBMS_OUTPUT.PUT_LINE('Erro inesperado no Bloco 5: ' || SQLERRM);
END;
/


-- =============================================================
-- BLOCO 6
-- Percorre os estados e exibe quantas regiões monitoradas
-- cada um possui utilizando FOR LOOP numérico
-- Contém: variáveis, FOR LOOP numérico, SELECT INTO,
-- IF/ELSIF/ELSE, exceção
-- =============================================================
DECLARE
    v_total_estados NUMBER;
    v_id_estado     TB_ESTADO.id_estado%TYPE;
    v_nome_estado   TB_ESTADO.nome%TYPE;
    v_sigla         TB_ESTADO.sigla%TYPE;
    v_total_regioes NUMBER;
    v_situacao      VARCHAR2(30);

    CURSOR cur_estados_com_regioes IS
        SELECT e.id_estado, e.nome, e.sigla
        FROM TB_ESTADO e
        WHERE EXISTS (
            SELECT 1 FROM TB_REGIAO r WHERE r.id_estado = e.id_estado
        )
        ORDER BY e.nome;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== ESTADOS COM REGIÕES MONITORADAS ===');

    SELECT COUNT(*)
    INTO v_total_estados
    FROM TB_ESTADO e
    WHERE EXISTS (
        SELECT 1 FROM TB_REGIAO r WHERE r.id_estado = e.id_estado
    );

    DBMS_OUTPUT.PUT_LINE('Total de estados monitorados: ' || v_total_estados);
    DBMS_OUTPUT.PUT_LINE('---');

    -- Estrutura de repetição 3: FOR com cursor
    FOR reg IN cur_estados_com_regioes LOOP
        v_id_estado   := reg.id_estado;
        v_nome_estado := reg.nome;
        v_sigla       := reg.sigla;

        SELECT COUNT(*)
        INTO v_total_regioes
        FROM TB_REGIAO
        WHERE id_estado = v_id_estado;

        -- Estrutura condicional 4
        IF v_total_regioes >= 3 THEN
            v_situacao := 'ALTO MONITORAMENTO';
        ELSIF v_total_regioes = 2 THEN
            v_situacao := 'MONITORAMENTO MÉDIO';
        ELSE
            v_situacao := 'MONITORAMENTO BÁSICO';
        END IF;

        DBMS_OUTPUT.PUT_LINE(
            'Estado: ' || v_nome_estado ||
            ' (' || v_sigla || ')' ||
            ' | Regiões: ' || v_total_regioes ||
            ' | Situação: ' || v_situacao
        );
    END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Nenhum estado encontrado com regiões monitoradas.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado no Bloco 6: ' || SQLERRM);
END;
/


-- =============================================================
-- CURSOR EXPLÍCITO ADICIONAL 3
-- Exibe as imagens satelitais por satélite com contador
-- utilizando FOR LOOP numérico
-- =============================================================
DECLARE
    v_total_imagens NUMBER := 0;
    v_contador      NUMBER := 0;

    CURSOR cur_imagens_satelite IS
        SELECT s.nome AS satelite, COUNT(i.id_imagem) AS total
        FROM TB_SATELITE s
        LEFT JOIN TB_IMAGEM_SATELITAL i ON s.id_satelite = i.id_satelite
        GROUP BY s.nome
        ORDER BY total DESC;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== IMAGENS CAPTURADAS POR SATÉLITE ===');

    -- Estrutura de repetição 4: FOR LOOP numérico
    FOR reg IN cur_imagens_satelite LOOP
        v_contador      := v_contador + 1;
        v_total_imagens := v_total_imagens + reg.total;

        DBMS_OUTPUT.PUT_LINE(
            v_contador || '. ' || reg.satelite ||
            ' | Imagens capturadas: ' || reg.total
        );
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('---');
    DBMS_OUTPUT.PUT_LINE('Total geral de imagens: ' || v_total_imagens);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado no Cursor 3: ' || SQLERRM);
END;
/


-- =============================================================
-- CURSOR EXPLÍCITO ADICIONAL 4
-- Exibe ocorrências reportadas por fiscal com área estimada
-- utilizando cursor explícito com parâmetro
-- =============================================================
DECLARE
    v_id_usuario    TB_USUARIO.id_usuario%TYPE;
    v_nome_usuario  TB_USUARIO.nome%TYPE;
    v_data          TB_OCORRENCIA.data_ocorrencia%TYPE;
    v_area          TB_OCORRENCIA.area_estimada_km2%TYPE;
    v_descricao     TB_OCORRENCIA.descricao%TYPE;

    CURSOR cur_ocorrencias (p_tipo VARCHAR2) IS
        SELECT u.nome, o.data_ocorrencia, o.area_estimada_km2, o.descricao
        FROM TB_OCORRENCIA o
        JOIN TB_USUARIO u ON o.id_usuario = u.id_usuario
        WHERE u.tipo_usuario = p_tipo
        ORDER BY o.data_ocorrencia DESC;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== OCORRÊNCIAS REPORTADAS POR FISCAIS ===');

    OPEN cur_ocorrencias('FISCAL');

    LOOP
        FETCH cur_ocorrencias INTO v_nome_usuario, v_data, v_area, v_descricao;
        EXIT WHEN cur_ocorrencias%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'Fiscal: ' || v_nome_usuario ||
            ' | Data: ' || TO_CHAR(v_data, 'DD/MM/YYYY') ||
            ' | Área: ' || v_area || ' km²'
        );
        DBMS_OUTPUT.PUT_LINE('  Descrição: ' || SUBSTR(v_descricao, 1, 80));
    END LOOP;

    CLOSE cur_ocorrencias;

EXCEPTION
    WHEN OTHERS THEN
        IF cur_ocorrencias%ISOPEN THEN
            CLOSE cur_ocorrencias;
        END IF;
        DBMS_OUTPUT.PUT_LINE('Erro inesperado no Cursor 4: ' || SQLERRM);
END;
/
