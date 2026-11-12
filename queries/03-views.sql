CREATE OR REPLACE VIEW FraudesGB.vw_fraude_pais AS

SELECT
pais,
COUNT(*) transacoes,
SUM(fraude) fraudes,
ROUND(100*AVG(fraude),2) taxa_fraude
FROM FraudesGB.vw_abt_fraude
GROUP BY pais;

CREATE OR REPLACE VIEW FraudesGB.vw_fraude_categoria AS

SELECT
departamento,
COUNT(*) transacoes,
SUM(fraude) fraudes,
ROUND(100*AVG(fraude),2) taxa_fraude
FROM FraudesGB.vw_abt_fraude
GROUP BY departamento;


CREATE OR REPLACE VIEW FraudesGB.vw_fraude_canal AS

SELECT
canal_venda,
COUNT(*) transacoes,
SUM(fraude) fraudes,
ROUND(100*AVG(fraude),2) taxa_fraude
FROM FraudesGB.vw_abt_fraude
GROUP BY canal_venda;


CREATE OR REPLACE VIEW FraudesGB.vw_fraude_tempo AS

SELECT

dt_compra,

COUNT(*) transacoes,

SUM(fraude) fraudes,

ROUND(
100*AVG(CAST(fraude AS FLOAT64)),
2
) taxa_fraude,

ROUND(
AVG(valor_compra),
2
) ticket_medio

FROM FraudesGB.vw_abt_fraude

GROUP BY dt_compra

ORDER BY dt_compra;



CREATE OR REPLACE VIEW FraudesGB.vw_ticket_medio_pais AS

SELECT

pais,

COUNT(*) transacoes,

ROUND(
AVG(valor_compra),
2
) ticket_medio,

SUM(fraude) fraudes,

ROUND(
100*AVG(CAST(fraude AS FLOAT64)),
2
) taxa_fraude

FROM FraudesGB.vw_abt_fraude

GROUP BY pais;


