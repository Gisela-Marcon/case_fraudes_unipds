
CREATE OR REPLACE VIEW FraudesGB.vw_transacoes_tratadas AS
SELECT
id_transacao,
data_compra,
ROUND(valor_compra,2) valor_compra,
COALESCE(pais,'ND') pais,
produto,
categoria_produto,
entrega_doc_1,
COALESCE(entrega_doc_2,FALSE) entrega_doc_2,
entrega_doc_3,
canal_venda,
versao_api,
COALESCE(is_teste,0) is_teste
FROM FraudesGB.transacoes
WHERE COALESCE(is_teste,0)=0;



CREATE OR REPLACE VIEW FraudesGB.vw_scores_tratados AS

WITH medianas AS (

SELECT

    APPROX_QUANTILES(score_2,100)[OFFSET(50)] med_score_2,
    APPROX_QUANTILES(score_3,100)[OFFSET(50)] med_score_3,
    APPROX_QUANTILES(score_4,100)[OFFSET(50)] med_score_4,
    APPROX_QUANTILES(score_6,100)[OFFSET(50)] med_score_6,
    APPROX_QUANTILES(score_9,100)[OFFSET(50)] med_score_9,
    APPROX_QUANTILES(score_10,100)[OFFSET(50)] med_score_10

FROM FraudesGB.scores_comportamentais sc

JOIN FraudesGB.scores_financeiros sf
USING(id_transacao)

)

SELECT

    sc.id_transacao,

    sc.score_1,

    COALESCE(sc.score_2,m.med_score_2) score_2,

    COALESCE(sc.score_4,m.med_score_4) score_4,

    sc.score_5,

    sc.score_7,

    COALESCE(sf.score_3,m.med_score_3) score_3,

    COALESCE(sf.score_6,m.med_score_6) score_6,

    COALESCE(sf.score_9,m.med_score_9) score_9,

    COALESCE(sf.score_10,m.med_score_10) score_10,

    sf.moeda_calculo,
    sf.recalculado,

    sc.dt_calculo_score,
    sc.versao_modelo_comportamental

FROM FraudesGB.scores_comportamentais sc

JOIN FraudesGB.scores_financeiros sf
USING(id_transacao)

CROSS JOIN medianas m;


CREATE OR REPLACE VIEW FraudesGB.vw_abt_fraude AS

WITH parametros AS (

    SELECT
        APPROX_QUANTILES(valor_compra, 100)[OFFSET(99)] AS p99_valor
    FROM FraudesGB.vw_transacoes_tratadas

)

SELECT

    -- CHAVE
    t.id_transacao,

    -- DATA
    DATE(t.data_compra) AS dt_compra,
    t.data_compra,

    -- TRANSAÇÃO
    ROUND(t.valor_compra,2) AS valor_compra,

    t.pais,
    p.nome_pais,
    p.regiao,
    p.moeda_local,

    t.produto,
    t.categoria_produto,

    c.departamento,
    c.nivel_risco_categoria,
    c.requer_doc_adicional,

    t.entrega_doc_1,
    t.entrega_doc_2,
    t.entrega_doc_3,

    t.canal_venda,
    t.versao_api,

    -- SCORES COMPORTAMENTAIS
    s.score_1,
    s.score_2,
    s.score_4,
    s.score_5,
    s.score_7,

    -- SCORES FINANCEIROS
    s.score_3,
    s.score_6,
    s.score_9,
    s.score_10,

    s.moeda_calculo,
    s.recalculado,

    s.dt_calculo_score,
    s.versao_modelo_comportamental,

    -- SCORE MODELO
    sm.score_8,

    -- IMPORTANTE:
    -- score bruto (não probabilidade)
    sm.score_fraude_modelo,

    sm.fraude,
    sm.experimento,
    sm.threshold_decisao,

    -- COMPONENTES DE DATA

    EXTRACT(YEAR FROM t.data_compra) AS ano,
    EXTRACT(MONTH FROM t.data_compra) AS mes,
    EXTRACT(DAY FROM t.data_compra) AS dia,
    EXTRACT(HOUR FROM t.data_compra) AS hora_compra,
    EXTRACT(DAYOFWEEK FROM t.data_compra) AS dia_semana,

    -- FAIXA DE VALOR

    CASE
        WHEN t.valor_compra < 20 THEN 'Baixo'
        WHEN t.valor_compra < 100 THEN 'Medio'
        WHEN t.valor_compra < 500 THEN 'Alto'
        ELSE 'Muito Alto'
    END AS faixa_valor,

    -- FEATURE ENGINEERING

    CASE
        WHEN s.score_1 >= 3 THEN 1
        ELSE 0
    END AS flag_risco_comportamental,

    CASE
        WHEN sm.score_8 >= 0.80 THEN 1
        ELSE 0
    END AS flag_alta_probabilidade,

    CASE
        WHEN t.valor_compra >
             AVG(t.valor_compra)
             OVER(PARTITION BY t.pais)
        THEN 1
        ELSE 0
    END AS acima_media_pais,

    -- OUTLIER P99

    CASE
        WHEN t.valor_compra > prm.p99_valor
        THEN 1
        ELSE 0
    END AS flag_outlier_valor,

    -- PAÍS RARO

    CASE
        WHEN COUNT(*) OVER(PARTITION BY t.pais) < 100
        THEN 1
        ELSE 0
    END AS flag_pais_raro,

    -- PAÍS NÃO INFORMADO

    CASE
        WHEN t.pais = 'ND'
        THEN 1
        ELSE 0
    END AS flag_pais_nao_informado,

    -- MÉTRICAS ANALÍTICAS

    RANK() OVER(
        PARTITION BY t.pais
        ORDER BY t.valor_compra DESC
    ) AS ranking_valor_pais,

    COUNT(*) OVER(
        PARTITION BY t.pais
    ) AS volume_transacoes_pais,

    ROUND(
        AVG(t.valor_compra)
        OVER(PARTITION BY t.pais),
        2
    ) AS ticket_medio_pais,

    ROUND(
        AVG(CAST(sm.fraude AS FLOAT64))
        OVER(PARTITION BY t.pais),
        4
    ) AS taxa_fraude_pais,

    ROUND(
        AVG(CAST(sm.fraude AS FLOAT64))
        OVER(PARTITION BY t.canal_venda),
        4
    ) AS taxa_fraude_canal,

    ROUND(
        AVG(CAST(sm.fraude AS FLOAT64))
        OVER(PARTITION BY c.departamento),
        4
    ) AS taxa_fraude_departamento

FROM FraudesGB.vw_transacoes_tratadas t

INNER JOIN FraudesGB.vw_scores_tratados s
    ON t.id_transacao = s.id_transacao

INNER JOIN FraudesGB.scores_modelo sm
    ON t.id_transacao = sm.id_transacao

LEFT JOIN FraudesGB.dim_paises p
    ON t.pais = p.sigla_pais

LEFT JOIN FraudesGB.dim_categorias c
    ON t.categoria_produto = c.id_categoria

CROSS JOIN parametros prm;

