



select count(*) from  `unipds-511721.FraudesGB.abt_fraude`
Linha	f0_
1	150000

select * from  `unipds-511721.FraudesGB.abt_fraude` limit 10

Linha	data_compra	entrega_doc_1	entrega_doc_2	entrega_doc_3	produto	pais	valor_compra	categoria_produto	score_8	score_fraude_modelo	fraude	score_1	score_2	score_4	score_5	score_7	score_3	score_6	score_9	score_10
1	2020-03-22 12:38:55 UTC	1	true	false	Pneu Cooper Classic Tour 185/65 R14 86t	BR	174.3	cat_feb8e6e	0.209967246585136	76	1	1	0.8619	null	0.0599985463707723	0	3295867.67	0	183	null
2	2020-03-10 15:03:04 UTC	1	null	false	Termo Stanley 1lts Pico Cebador	AR	80.31	cat_8d395f1	0.318013058835219	20	0	4	null	null	0.0	0	null	2	2844	null
3	2020-04-12 20:18:29 UTC	1	false	false	Xiaomi Mi A1 Dual Sim 64 Gb Dourado 4 Gb Ram	BR	165.86	cat_43b9c10	0.210129816340014	69	0	4	0.8289	null	0.0	0	216336.88	8	1384	null
4	2020-03-18 08:46:30 UTC	1	null	false	Barbijo Con Valvula Delta Plus N95 X 10 Unidades	US	62.31	cat_08113a2	0.424281675326948	84	0	4	0.6983	null	0.0	0	21239.15	17	4731	null
5	2020-03-27 08:48:25 UTC	1	true	false	Delphi 10.3.3 64 Bits + Fast 6.2.1 + Unidac 7.4.11	BR	15.55	cat_f9a78b7	0.0464058744872595	1	0	2	0.8113	null	0.0	0	350.98	12	1797	null
6	2020-04-07 15:39:39 UTC	1	false	false	Máscara Facial Para Proteção De Todo Rosto Não Descartável	BR	4.24	cat_d3e283d	0.268786122188217	72	0	4	0.8474	null	0.406392694063926	0	16103.91	8	5385	null
7	2020-03-16 13:35:58 UTC	1	null	false	Justin Bieber, Changes, Cd, Nuevo	AR	10.4	cat_12a8b9b	0.170782638629358	84	0	2	0.6499	null	0.0	0	3027.08	3	3807	null
8	2020-04-04 16:19:35 UTC	0	null	false	10 Unidades De Barbijo Mascarilla Respirador Descartable N95	ES	6.52	cat_08113a2	0.00238308906623529	13	0	2	0.5802	null	0.0	0	101306.13	0	0	null
9	2020-04-02 15:32:45 UTC	1	null	false	Kit 25 Unid. Mascara Descartável Proteção Vírus Aproveit	BR	7.29	cat_604df77	0.193764768513471	93	1	2	1.0	null	0.0	0	14.59	3	3434	null
10	2020-03-26 11:09:18 UTC	0	false	false	Alcool Gel 5 Litros	BR	23.48	cat_8226450	0.840806626256487	83	0	4	0.941	null	0.190849237436453	0	9042.63	0	0	null

--1-entender qual o tamanho do problema

select 
  count(*)                                                          as total,
  sum(fraude)                                                       as fraudes,
  round(100.0*avg(fraude), 3)                                       as taxa_fraude_pct,
  round(sum(case when fraude = 1 then valor_compra else 0 end ), 2) as valor_exposto,
  round(avg(case when fraude = 1 then valor_compra end ), 2)        as ticket_medio_fraude,
  round(avg(valor_compra), 2)                                       as ticket_medio_geral
from   
  `unipds-511721.FraudesGB.abt_fraude`

  Linha	total	fraudes	taxa_fraude_pct	valor_exposto	ticket_medio_fraude	ticket_medio_geral
1	150000	7500	5.0	547271.12	72.97	43.52


--2-analisar a fraude por pais e a taxa 

select 
pais.nome_pais,
pais.regiao,
count(*)   as transacoes,
round(100.0*avg(fra.fraude), 2)   as taxas_fraudes_pct
from 
`unipds-511721.FraudesGB.abt_fraude` fra
inner join `unipds-511721.FraudesGB.dim_paises` pais on
fra.pais = pais.sigla_pais
group by pais.nome_pais,
         pais.regiao
having count(*) >= 1000
order by taxas_fraudes_pct desc;  

Linha	nome_pais	regiao	transacoes	taxas_fraudes_pct
1	Brasil	América do Sul	111628	5.52
2	Argentina	América do Sul	31964	3.69
3	Estados Unidos	América do Norte	2273	3.08
4	Uruguai	América do Sul	2967	0.98


--3-analisar os riscos x realidades
select 
ca.nivel_risco_categoria,
count(*)   as transacoes,
round(100.0*avg(fra.fraude), 2)   as taxas_fraudes_pct
from 
`unipds-511721.FraudesGB.abt_fraude` fra
inner join `unipds-511721.FraudesGB.dim_categorias` ca on
fra.categoria_produto  = ca.id_categoria
group by ca.nivel_risco_categoria
order by taxas_fraudes_pct desc;

Linha	nivel_risco_categoria	transacoes	taxas_fraudes_pct
1	médio	47079	5.21
2	alto	53379	5.06
3	baixo	49542	4.74


--4-analisar a taxa de fraudes por faixa de valor

select 
 case 
    when fra.valor_compra < 100 then '1) ate 100'
    when fra.valor_compra < 500 then '2) 100 - 500'
    ELSE                              '3)ACIMA DE 500'
  END   AS FAIXA_VALOR,    
count(*)   as transacoes,
round(100.0*avg(fra.fraude), 2)   as taxas_fraudes_pct
from 
`unipds-511721.FraudesGB.abt_fraude` fra
inner join `unipds-511721.FraudesGB.dim_categorias` ca on
fra.categoria_produto  = ca.id_categoria
group by faixa_valor
order by faixa_valor;

Linha	FAIXA_VALOR	transacoes	taxas_fraudes_pct
1	1) ate 100	137284	4.6
2	2) 100 - 500	11679	8.84
3	3)ACIMA DE 500	1037	14.95

--5-- ANALISAR ATRAVES DE UMA QUERY DINAMICA
WITH BASE AS(
  select 
 case 
    when fra.valor_compra < 100 then '1) ate 100'
    when fra.valor_compra < 500 then '2) 100 - 500'
    WHEN fra.valor_compra >= 500 then'3)ACIMA DE 500'
    ELSE                              '4) VALOR NULL'
  END   AS FAIXA_VALOR,    
FRA.FRAUDE,
FRA.VALOR_COMPRA
from 
`unipds-511721.FraudesGB.abt_fraude` fra
)
SELECT
  FAIXA_VALOR,
  COUNT(*) AS TRANSACOES,
  SUM(FRAUDE) AS FRAUDES,

  ROUND(100.0 * SUM(FRAUDE) / COUNT(*), 2) AS TAXAS_FRAUDES_PCT,

  ROUND(
    100.0 * SUM(FRAUDE)
    / SUM(SUM(FRAUDE)) OVER (),
    1
  ) AS PCT_DOS_CASOS,

  ROUND(
    SUM(CASE WHEN FRAUDE = 1 THEN VALOR_COMPRA ELSE 0 END),
    2
  ) AS VALOR_EXPOSTO,

  ROUND(
    100.0 * SUM(CASE WHEN FRAUDE = 1 THEN VALOR_COMPRA ELSE 0 END)
    / SUM(SUM(CASE WHEN FRAUDE = 1 THEN VALOR_COMPRA ELSE 0 END)) OVER (),
    1
  ) AS PCT_DO_VALOR,

  ROUND(
    SAFE_DIVIDE(
      SUM(CASE WHEN FRAUDE = 1 THEN VALOR_COMPRA ELSE 0 END),
      SUM(FRAUDE)
    ),
    2
  ) AS PERDA_MEDIA_POR_FRAUDE

FROM BASE
GROUP BY FAIXA_VALOR
ORDER BY FAIXA_VALOR;

Linha	FAIXA_VALOR	TRANSACOES	FRAUDES	TAXAS_FRAUDES_PCT	PCT_DOS_CASOS	VALOR_EXPOSTO	PCT_DO_VALOR	PERDA_MEDIA_POR_FRAUDE
1	1) ate 100	137284	6313	4.6	84.2	169628.21	31.0	26.87
2	2) 100 - 500	11679	1032	8.84	13.8	233386.93	42.6	226.15
3	3)ACIMA DE 500	1037	155

--6- ANALISA FRAUDE POR FAIXA

WITH FAIXAS AS (
    SELECT 
      FRAUDE,
      NTILE(10) OVER (ORDER BY SCORE_FRAUDE_MODELO) AS DECIL
    FROM `unipds-511721.FraudesGB.abt_fraude`
)
SELECT 
  DECIL,
  COUNT(*) AS TRANSACOES,
  ROUND(100.0*AVG(FRAUDE), 2) AS TAXA_FRAUDE_PCT
FROM FAIXAS
GROUP BY DECIL
ORDER BY DECIL

Linha	DECIL	TRANSACOES	TAXA_FRAUDE_PCT
1	1	15000	2.81
2	2	15000	4.59
3	3	15000	3.29
4	4	15000	0.31
5	5	15000	0.62
6	6	15000	1.26
7	7	15000	1.96
8	8	15000	5.24
9	9	15000	8.6
10	10	15000	21.32
