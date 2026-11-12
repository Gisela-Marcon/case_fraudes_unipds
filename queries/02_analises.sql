

--------------------------------------------------------------------------------
-- 
-- ETAPA 1 - registros das tabelasa
--------------------------------------------------------------------------------

-- Volume das tabelas
--identificar a quantidade de registro em cada tabela
SELECT 'transacoes' tabela, COUNT(*) registros
FROM `unipds-511721.FraudesGB.transacoes`
UNION ALL
SELECT 'scores_comportamentais', COUNT(*)
FROM `unipds-511721.FraudesGB.scores_comportamentais`
UNION ALL
SELECT 'scores_financeiros', COUNT(*)
FROM `unipds-511721.FraudesGB.scores_financeiros`
UNION ALL
SELECT 'scores_modelo', COUNT(*)
FROM `unipds-511721.FraudesGB.scores_modelo`
UNION ALL
SELECT 'dim_paises', COUNT(*)
FROM `unipds-511721.FraudesGB.dim_paises`
UNION ALL
SELECT 'dim_categorias', COUNT(*)
FROM `unipds-511721.FraudesGB.dim_categorias`;

/*
Quantidade de Registros por Tabela
Tabela	Registros
transacoes	150.200
scores_comportamentais	150.200
scores_financeiros	150.200
scores_modelo	150.200
dim_paises	57
dim_categorias	8.374
*/


--------------------------------------
-- ETTAPA 2
-- retornar tipos de colunas das tabelas

--------------------------------------
SELECT
table_name,
column_name,
data_type
FROM `unipds-511721.FraudesGB.INFORMATION_SCHEMA.COLUMNS`
ORDER BY table_name, ordinal_position;

/*Linha	table_name	column_name	data_type
1	dim_categorias	id_categoria	STRING
2	dim_categorias	departamento	STRING
3	dim_categorias	nivel_risco_categoria	STRING
4	dim_categorias	requer_doc_adicional	INT64
5	dim_categorias	ativo	INT64
6	dim_paises	sigla_pais	STRING
7	dim_paises	nome_pais	STRING
8	dim_paises	regiao	STRING
9	dim_paises	moeda_local	STRING
10	dim_paises	locale	STRING
11	dim_paises	ativo	INT64
12	scores_comportamentais	id_transacao	INT64
13	scores_comportamentais	score_1	INT64
14	scores_comportamentais	score_2	FLOAT64
15	scores_comportamentais	score_4	INT64
16	scores_comportamentais	score_5	FLOAT64
17	scores_comportamentais	score_7	INT64
18	scores_comportamentais	dt_calculo_score	DATE
19	scores_comportamentais	versao_modelo_comportamental	STRING
20	scores_financeiros	id_transacao	INT64
21	scores_financeiros	score_3	FLOAT64
22	scores_financeiros	score_6	INT64
23	scores_financeiros	score_9	INT64
24	scores_financeiros	score_10	INT64
25	scores_financeiros	moeda_calculo	STRING
26	scores_financeiros	recalculado	INT64
27	scores_modelo	id_transacao	INT64
28	scores_modelo	score_8	FLOAT64
29	scores_modelo	score_fraude_modelo	INT64
30	scores_modelo	fraude	INT64
31	scores_modelo	experimento	STRING
32	scores_modelo	threshold_decisao	FLOAT64
33	transacoes	id_transacao	INT64
34	transacoes	data_compra	TIMESTAMP
35	transacoes	valor_compra	FLOAT64
36	transacoes	pais	STRING
37	transacoes	produto	STRING
38	transacoes	categoria_produto	STRING
39	transacoes	entrega_doc_1	INT64
40	transacoes	entrega_doc_2	BOOL
41	transacoes	entrega_doc_3	BOOL
42	transacoes	canal_venda	STRING
43	transacoes	is_teste	INT64
44	transacoes	versao_api	STRING
*/



--------------------------------------------------------------------------------
-- ETAPA 3
-- CARDINALIDADE
--------------------------------------------------------------------------------
--transacoes
SELECT
  COUNT(DISTINCT id_transacao) qtd_transacoes,
  COUNT(DISTINCT pais) qtd_paises,
  COUNT(DISTINCT categoria_produto) qtd_categorias,
  COUNT(DISTINCT produto) qtd_produtos,
  COUNT(DISTINCT canal_venda) qtd_canais,
  COUNT(DISTINCT versao_api) qtd_apis
FROM `unipds-511721.FraudesGB.transacoes`;
/*
------------------
Linha	qtd_transacoes	qtd_paises	qtd_categorias	qtd_produtos	qtd_canais	qtd_apis
1	150200	51	8324	127305	5	4
---------------------
*/

--paises

SELECT
COUNT(*) registros,
COUNT(DISTINCT sigla_pais) paises,
COUNT(DISTINCT regiao) regioes,
COUNT(DISTINCT moeda_local) moedas
FROM `unipds-511721.FraudesGB.dim_paises`;
/*
Linha	registros	paises	regioes	moedas
1	57	57	7	46
*/

--categorias

SELECT
COUNT(*) registros,
COUNT(DISTINCT id_categoria) categorias,
COUNT(DISTINCT departamento) departamentos,
COUNT(DISTINCT nivel_risco_categoria) niveis_risco
FROM `unipds-511721.FraudesGB.dim_categorias`;

/*
Linha	registros	categorias	departamentos	niveis_risco
1	8374	8374	9	3
*/

-- scores_comportamentais


SELECT 
COUNT(*) registros,
COUNT(DISTINCT SCORE_1) SCORE1,
COUNT(DISTINCT SCORE_4) SCORE4,
COUNT(DISTINCT VERSAO_MODELO_COMPORTAMENTAL) VERSAO_MODELO_COMPORTAMENTAL
FROM `unipds-511721.FraudesGB.scores_comportamentais`

/*
Linha	registros	SCORE1	SCORE4	VERSAO_MODELO_COMPORTAMENTAL
1	150200	4	51	3
*/

--scores_financeiros

SELECT COUNT(*) registros,
COUNT(DISTINCT MOEDA_CALCULO) moeda_calculo
FROM `unipds-511721.FraudesGB.scores_financeiros`
/*
Linha	registros	moeda_calculo
1	150200	3
*/

--SCORE_MODELO

SELECT COUNT(*) registros,
COUNT(DISTINCT FRAUDE) FRAUDE,
COUNT(DISTINCT EXPERIMENTO) EXPERIMENTO,
COUNT(DISTINCT threshold_decisao) threshold_decisao
FROM `unipds-511721.FraudesGB.scores_modelo`

/*
Linha	registros	FRAUDE	EXPERIMENTO	threshold_decisao
1	150200	2	4	1
*/


--------------------------------------------------------------------------------
-- 4. UNICIDADE DAS CHAVES
-- CHAVES NÃO ÚNICAS - 
--------------------------------------------------------------------------------
--TRANSACOES

SELECT
id_transacao,
COUNT(*) qtd
FROM `unipds-511721.FraudesGB.transacoes`
GROUP BY id_transacao
HAVING COUNT(*) > 1;
--Não há dados para exibir.

--SCORES_COMPORTAMENTAIS

SELECT
id_transacao,
COUNT(*) qtd
FROM `unipds-511721.FraudesGB.scores_comportamentais`
GROUP BY id_transacao
HAVING COUNT(*) > 1;
--Não há dados para exibir.

--SCORE_FINANCEIROS
SELECT
id_transacao,
COUNT(*) qtd
FROM `unipds-511721.FraudesGB.scores_financeiros`
GROUP BY id_transacao
HAVING COUNT(*) > 1;
--Não há dados para exibir.

--SCORES_MODELO

SELECT
id_transacao,
COUNT(*) qtd
FROM `unipds-511721.FraudesGB.scores_modelo`
GROUP BY id_transacao
HAVING COUNT(*) > 1;

--------------------------------------------------------------------------------
-- 5. CONTAGEM DE NULOS - 
--------------------------------------------------------------------------------

--transacoes

SELECT
COUNTIF(id_transacao IS NULL) id_transacao_null,
COUNTIF(data_compra IS NULL) data_compra_null,
COUNTIF(valor_compra IS NULL) valor_compra_null,
COUNTIF(pais IS NULL) pais_null,
COUNTIF(produto IS NULL) produto_null,
COUNTIF(categoria_produto IS NULL) categoria_produto_null,
COUNTIF(entrega_doc_1 IS NULL) entrega_doc_1_null,
COUNTIF(entrega_doc_2 IS NULL) entrega_doc_2_null,
COUNTIF(entrega_doc_3 IS NULL) entrega_doc_3_null,
COUNTIF(canal_venda IS NULL) canal_venda_null,
COUNTIF(is_teste IS NULL) is_teste_null,
COUNTIF(versao_api IS NULL) versao_api_null
FROM `unipds-511721.FraudesGB.transacoes`;

/*
Linha	id_transacao_null	data_compra_null	valor_compra_null	pais_null	produto_null	categoria_produto_null	entrega_doc_1_null	entrega_doc_2_null	entrega_doc_3_null	canal_venda_null	is_teste_null	versao_api_null
1	0	0	0	194	0	0	0	108999	0	0	0	0

*/

--scores_comportamentais

SELECT
COUNTIF(score_1 IS NULL) score1_null,
COUNTIF(score_2 IS NULL) score2_null,
COUNTIF(score_4 IS NULL) score4_null,
COUNTIF(score_5 IS NULL) score5_null,
COUNTIF(score_7 IS NULL) score7_null
FROM `unipds-511721.FraudesGB.scores_comportamentais`;

/*
Linha	score1_null	score2_null	score4_null	score5_null	score7_null
1	0	12996	366	0	0	
*/

--scores_financeiros

SELECT
COUNTIF(score_3 IS NULL) score3_null,
COUNTIF(score_6 IS NULL) score6_null,
COUNTIF(score_9 IS NULL) score9_null,
COUNTIF(score_10 IS NULL) score10_null
FROM `unipds-511721.FraudesGB.scores_financeiros`;

/*
Linha	score3_null	score6_null	score9_null	score10_null
1	12996	11	11	366
*/


--08-11-2016
--BLOCO 6 - VALORES ÚNICOS
--------------------------------------------------------------------------------
-- 6. VALORES UNICOS
--------------------------------------------------------------------------------
--País

SELECT pais, COUNT(*) qtd
FROM `unipds-511721.FraudesGB.transacoes`
GROUP BY pais
ORDER BY qtd DESC;
/*

Linha	pais	qtd
1	BR	111767
2	AR	32013
3	UY	2972
4	US	2278
5	SE	359
6	MX	237
7	null	194
8	RU	73
9	ES	69
10	CO	64
11	GB	43
12	FR	18
13	IT	14
14	PT	13
15	CL	9
16	DE	9
17	PE	5
18	EC	4
19	PY	4
20	NZ	3
21	AU	3
22	PA	3
23	CH	3
24	UA	3
25	CA	3
26	CN	3
27	BE	3
28	NL	2
29	CR	2
30	LB	2
31	PR	2
32	AE	2
33	BO	2
34	PH	1
35	EG	1
36	HN	1
37	TR	1
38	KR	1
39	TW	1
40	GE	1
41	JP	1
42	GR	1
43	NI	1
44	IL	1
45	ZA	1
46	NO	1
47	AD	1
48	FI	1
49	IN	1
50	DO	1
51	GH	1
52	BS	1

*/

--Categoria

SELECT categoria_produto, COUNT(*) qtd
FROM `unipds-511721.FraudesGB.transacoes`
GROUP BY categoria_produto
ORDER BY qtd DESC
LIMIT 10;
/*

Linha	categoria_produto	qtd
1	cat_43b9c10	2334
2	cat_d69bed9	1801
3	cat_604df77	1787
4	cat_6c4cfdc	1449
5	cat_4249bd8	1192
6	cat_3203c7c	1094
7	cat_be0af8e	1043
8	cat_0820fab	939
9	cat_8ef7164	911
10	cat_d5975ae	882
*/

--Canal

SELECT canal_venda, COUNT(*) qtd
FROM `unipds-511721.FraudesGB.transacoes`
GROUP BY canal_venda
ORDER BY qtd DESC;
/*

Linha	canal_venda	qtd
1	api_parceiro	30323
2	app_ios	30228
3	web_mobile	30010
4	app_android	29951
5	web_desktop	29688
*/


--API
SELECT versao_api, COUNT(*) qtd
FROM `unipds-511721.FraudesGB.transacoes`
GROUP BY versao_api
ORDER BY qtd DESC;
/*
Linha	versao_api	qtd
1	v3	67655
2	v2.1	44900
3	v2	30062
4	v1	7583
*/


--------------------------------------------------------------------------------
-- 6. DADOS DUPLICADOS
--------------------------------------------------------------------------------
--analisar se tem dados duplicados
--pais
SELECT
sigla_pais,
COUNT(*) qtd
FROM `unipds-511721.FraudesGB.dim_paises`
GROUP BY sigla_pais
HAVING COUNT(*) > 1;

--Não há dados para exibir.

--categorias 
--Essa análise é muito importante porque valida a hipótese do relacionamento 1:1, e podemos notar que nao tem relação.

SELECT
departamento,
COUNT(*) categorias
FROM `unipds-511721.FraudesGB.dim_categorias`
GROUP BY departamento
ORDER BY categorias DESC;

/*
Linha	departamento	categorias
1	Casa & Jardim	1065
2	Moda	1064
3	Automotivo	1060
4	Esportes	1055
5	Alimentos	1038
6	Beleza & Saúde	1037
7	Brinquedos	1035
8	Eletrônicos	970
9	Desativado	50
*/




--Essa análise é muito importante porque valida a hipótese do relacionamento 1:1.
--e podemos avaliar que sim é relacionamento 1:1 

--scores_comportamentais

SELECT
COUNT(*) registros,
COUNT(DISTINCT id_transacao) transacoes
FROM `unipds-511721.FraudesGB.scores_comportamentais`;

/*
Linha	registros	transacoes
1	150200	150200
*/


--Detectar transações repetidas
SQL
SELECT
id_transacao,
COUNT(*) qtd
FROM `unipds-511721.FraudesGB.scores_comportamentais`
GROUP BY id_transacao
HAVING COUNT(*) > 1;


SELECT
COUNT(DISTINCT score_1) cardinalidade
FROM `unipds-511721.FraudesGB.scores_comportamentais`;

Todos os Scores
SQL
SELECT
COUNT(DISTINCT score_1) score_1,
COUNT(DISTINCT score_2) score_2,
COUNT(DISTINCT score_4) score_4,
COUNT(DISTINCT score_5) score_5,
COUNT(DISTINCT score_7) score_7
FROM `unipds-511721.FraudesGB.scores_comportamentais`;

Objetivo:

Verificar score constante.
Verificar score com baixa variabilidade.
Detectar possíveis problemas de geração dos scores.
Cardinalidade da variável Fraude

Essa é uma das análises mais importantes do trabalho.

SQL
SELECT
fraude,
COUNT(*) qtd
FROM `unipds-511721.FraudesGB.scores_modelo`
GROUP BY fraude;

Normalmente você espera algo como:

Plain Text
fraude = TRUE 2% a 10%
fraude = FALSE 90% a 98%

Isso demonstra desbalanceamento da classe.

Linha	fraude	qtd
1	0	142690
2	1	7510



--------------------------------------------------------------------------------
-- DISTRIBUIÇÃO DE PAÍSES
--------------------------------------------------------------------------------

SELECT
  pais,
  COUNT(*) qtd,
  ROUND(
      100 * COUNT(*) /
      SUM(COUNT(*)) OVER(),2
  ) perc
FROM `unipds-511721.FraudesGB.transacoes`
GROUP BY pais
ORDER BY qtd DESC;

/*
Linha	pais	qtd	perc
1	BR	111767	74.41
2	AR	32013	21.31
3	UY	2972	1.98
4	US	2278	1.52
5	SE	359	0.24
6	MX	237	0.16
7	null	194	0.13
8	RU	73	0.05
9	ES	69	0.05
10	CO	64	0.04
11	GB	43	0.03
12	FR	18	0.01
13	IT	14	0.01
14	PT	13	0.01
15	CL	9	0.01
16	DE	9	0.01
17	PE	5	0.0
18	EC	4	0.0
19	PY	4	0.0
20	NZ	3	0.0
21	AU	3	0.0
22	PA	3	0.0
23	CH	3	0.0
24	UA	3	0.0
25	CA	3	0.0
26	CN	3	0.0
27	BE	3	0.0
28	NL	2	0.0
29	CR	2	0.0
30	LB	2	0.0
31	PR	2	0.0
32	AE	2	0.0
33	BO	2	0.0
34	PH	1	0.0
35	EG	1	0.0
36	HN	1	0.0
37	TR	1	0.0
38	KR	1	0.0
39	TW	1	0.0
40	GE	1	0.0
41	JP	1	0.0
42	GR	1	0.0
43	NI	1	0.0
44	IL	1	0.0
45	ZA	1	0.0
46	NO	1	0.0
47	AD	1	0.0
48	FI	1	0.0
49	IN	1	0.0
50	DO	1	0.0
51	GH	1	0.0
52	BS	1	0.0

*/
--------------------------------------------------------------------------------
-- DISTRIBUIÇÃO DE CATEGORIAS
--------------------------------------------------------------------------------

SELECT
  categoria_produto,
  COUNT(*) qtd,
  ROUND(
      100 * COUNT(*) /
      SUM(COUNT(*)) OVER(),2
  ) perc
FROM `unipds-511721.FraudesGB.transacoes`
GROUP BY categoria_produto
ORDER BY qtd DESC limit 10;
/*
Linha	categoria_produto	qtd	perc
1	cat_43b9c10	2334	1.55
2	cat_d69bed9	1801	1.2
3	cat_604df77	1787	1.19
4	cat_6c4cfdc	1449	0.96
5	cat_4249bd8	1192	0.79
6	cat_3203c7c	1094	0.73
7	cat_be0af8e	1043	0.69
8	cat_0820fab	939	0.63
9	cat_8ef7164	911	0.61
10	cat_d5975ae	882	0.59
*/
--------------------------------------------------------------------------------
-- DISTRIBUIÇÃO DE API
--------------------------------------------------------------------------------

SELECT
  versao_api,
  COUNT(*) qtd,
  ROUND(
      100 * COUNT(*) /
      SUM(COUNT(*)) OVER(),2
  ) perc
FROM `unipds-511721.FraudesGB.transacoes`
GROUP BY versao_api
ORDER BY qtd DESC;

/*

Linha	versao_api	qtd	perc
1	v3	67655	45.04
2	v2.1	44900	29.89
3	v2	30062	20.01
4	v1	7583	5.05
*/
--------------------------------------------------------------------------------
-- DISTRIBUIÇÃO DE CANAL
--------------------------------------------------------------------------------

SELECT
  canal_venda,
  COUNT(*) qtd,
  ROUND(
      100 * COUNT(*) /
      SUM(COUNT(*)) OVER(),2
  ) perc
FROM `unipds-511721.FraudesGB.transacoes`
GROUP BY canal_venda
ORDER BY qtd DESC;

/*

Linha	canal_venda	qtd	perc
1	api_parceiro	30323	20.19
2	app_ios	30228	20.13
3	web_mobile	30010	19.98
4	app_android	29951	19.94
5	web_desktop	29688	19.77
*/
--------------------------------------------------------------------------------
-- PERFIL ESTATÍSTICO
--------------------------------------------------------------------------------

SELECT
  COUNT(*) qtd,
  AVG(valor_compra) media,
  MIN(valor_compra) minimo,
  MAX(valor_compra) maximo,
  STDDEV(valor_compra) desvio,
  APPROX_QUANTILES(valor_compra,100)[OFFSET(25)] p25,
  APPROX_QUANTILES(valor_compra,100)[OFFSET(50)] p50,
  APPROX_QUANTILES(valor_compra,100)[OFFSET(75)] p75,
  APPROX_QUANTILES(valor_compra,100)[OFFSET(95)] p95,
  APPROX_QUANTILES(valor_compra,100)[OFFSET(99)] p99
FROM `unipds-511721.FraudesGB.transacoes`;


/*

Linha	qtd	media	minimo	maximo	desvio	p25	p50	p75	p95	p99
1	150200	43.51457529960051	0.02	3696.35	91.51814681698016	9.38	20.63	40.68	157.49	417.29


*/

--------------------------------------------------------------------------------
-- HISTOGRAMA DE VALOR_COMPRA
--------------------------------------------------------------------------------

SELECT
  RANGE_BUCKET(
    valor_compra,
    ARRAY(
      SELECT CAST(x AS FLOAT64)
      FROM UNNEST(GENERATE_ARRAY(0, 10000, 100)) AS x
    )
  ) AS faixa,
  COUNT(*) AS qtd
FROM `unipds-511721.FraudesGB.transacoes`
GROUP BY faixa
ORDER BY faixa;

/*
Linha	faixa	qtd
1	1	137468
2	2	7128
3	3	2686
4	4	1291
5	5	590
6	6	363
7	7	227
8	8	133
9	9	85
10	10	59
11	11	40
12	12	20
13	13	16
14	14	14
15	15	17
16	16	14
17	17	8
18	18	7
19	19	7
20	20	2
21	21	4
22	22	3
23	23	2
24	24	3
25	25	2
26	27	4
27	28	1
28	29	1
29	30	1
30	32	1
31	35	1
32	36	1
33	37	1
*/


--------------------------------------------------------------------------------
-- DATA QUALITY
--------------------------------------------------------------------------------

SELECT
  COUNTIF(id_transacao IS NULL) id_null,
  COUNTIF(valor_compra IS NULL) valor_null,
  COUNTIF(pais IS NULL) pais_null,
  COUNTIF(produto IS NULL) produto_null,
  COUNTIF(categoria_produto IS NULL) categoria_null,
  COUNTIF(canal_venda IS NULL) canal_null,
  COUNTIF(versao_api IS NULL) api_null
FROM `unipds-511721.FraudesGB.transacoes`;
/*
Linha	id_null	valor_null	pais_null	produto_null	categoria_null	canal_null	api_null
1	0	0	194	0	0	0	0

*/

--------------------------------------------------------------------------------
-- VAZIOS
--------------------------------------------------------------------------------

SELECT
  COUNTIF(TRIM(pais)='') pais_vazio,
  COUNTIF(TRIM(produto)='') produto_vazio,
  COUNTIF(TRIM(categoria_produto)='') categoria_vazia,
  COUNTIF(TRIM(canal_venda)='') canal_vazio
FROM `unipds-511721.FraudesGB.transacoes`;
--nao retornou nada vazio
--------------------------------------------------------------------------------
-- DADOS ABSURDOS
--------------------------------------------------------------------------------

SELECT *
FROM `unipds-511721.FraudesGB.transacoes`
WHERE valor_compra < 0;
--nao ha resultados
--------------------------------------------------------------------------------
-- COMPRAS ZERADAS
--------------------------------------------------------------------------------

SELECT
  COUNT(*) qtd
FROM `unipds-511721.FraudesGB.transacoes`
WHERE valor_compra = 0;
--nao ha zeradas
--------------------------------------------------------------------------------
-- OUTLIERS (P99)
--------------------------------------------------------------------------------
--por que definiu autliers p99?
WITH limites AS (
SELECT
APPROX_QUANTILES(valor_compra,100)[OFFSET(99)] p99
FROM `unipds-511721.FraudesGB.transacoes`
)
SELECT *
FROM `unipds-511721.FraudesGB.transacoes`
WHERE valor_compra > (SELECT p99 FROM limites)
and is_teste = 0 limit 10;
/*
Linha	id_transacao	data_compra	valor_compra	pais	produto	categoria_produto	entrega_doc_1	entrega_doc_2	entrega_doc_3	canal_venda	is_teste	versao_api
1	29970	2020-04-01 14:42:24 UTC	561.8	BR	Batedeira Stand Mixer Proline 6,9 L - Candy Apple	cat_0175a99	1	null	true	api_parceiro	0	v2
2	5347	2020-04-15 17:18:44 UTC	786.6	BR	Alianças Ouro 18k 750 22g 8mm Grossas Promoção Tradicional	cat_01d9720	1	null	true	api_parceiro	0	v2.1
3	25737	2020-03-08 21:19:07 UTC	464.58	BR	Par Alianças Ouro 18k 7mm 10 Gramas  Casamento!	cat_01d9720	1	null	true	api_parceiro	0	v2
4	84641	2020-03-09 18:40:42 UTC	858.43	BR	Par Alianças 10mm Reta 18g Ouro 18k Friso Pedras Anatômicas	cat_01d9720	1	false	true	api_parceiro	0	v2
5	48267	2020-04-01 14:02:03 UTC	471.08	BR	Cpu Gamer Intel / Core I5 / 8gb / 1tb/ Geforce 2gb/ Wifi/led	cat_02711c1	1	null	true	api_parceiro	0	v2.1
6	62821	2020-04-10 12:26:53 UTC	509.87	AR	Pc Gamer Ryzen 3 Gabinete Coolers Rgb Ssd 8gb Ram Video Vega	cat_02711c1	0	null	false	api_parceiro	0	v3
7	90468	2020-03-19 16:08:23 UTC	511.15	BR	Cpu Gamer Intel/ Core I5/ 8gb/ 1tb/ Gt1030 / Wi-fi/ Led Gab	cat_02711c1	0	null	false	api_parceiro	0	v3
8	91987	2020-03-13 08:26:44 UTC	1184.89	BR	Cpu Gamer Core I7 16gb De Memoria 120gb Ssd 500gb Hd	cat_02711c1	1	null	true	api_parceiro	0	v3
9	102362	2020-04-12 01:39:22 UTC	830.05	BR	Pc Gamer I7, 32gb, Gf 6gb 1060 Gtx, 500gb, Ssd 240gb + Nfe	cat_02711c1	1	null	false	api_parceiro	0	v2.1
10	106321	2020-04-15 15:52:13 UTC	1147.14	BR
*/

--------------------------------------------------------------------------------
-- INTEGRIDADE REFERENCIAL
--------------------------------------------------------------------------------

SELECT
    COUNT(*) transacoes_sem_score_comportamental
FROM `unipds-511721.FraudesGB.transacoes` t
LEFT JOIN `unipds-511721.FraudesGB.scores_comportamentais` sc
ON t.id_transacao = sc.id_transacao
WHERE sc.id_transacao IS NULL
union all
SELECT
    COUNT(*) transacoes_sem_score_financeiro
FROM `unipds-511721.FraudesGB.transacoes` t
LEFT JOIN `unipds-511721.FraudesGB.scores_financeiros` sf
ON t.id_transacao = sf.id_transacao
WHERE sf.id_transacao IS NULL
union all
SELECT
    COUNT(*) transacoes_sem_score_modelo
FROM `unipds-511721.FraudesGB.transacoes` t
LEFT JOIN `unipds-511721.FraudesGB.scores_modelo` sm
ON t.id_transacao = sm.id_transacao
WHERE sm.id_transacao IS NULL
/*

Linha	transacoes_sem_score_comportamental
1	0
2	0
3	0
*/
--------------------------------------------------------------------------------
-- PAÍSES ÓRFÃOS
--------------------------------------------------------------------------------

SELECT
    pais,
    COUNT(*) qtd
FROM `unipds-511721.FraudesGB.transacoes` t
LEFT JOIN `unipds-511721.FraudesGB.dim_paises` p
ON t.pais = p.sigla_pais
WHERE p.sigla_pais IS NULL
GROUP BY pais;
/*

Linha	pais	qtd
1	null	194
*/
--------------------------------------------------------------------------------
-- CATEGORIAS ÓRFÃS
--------------------------------------------------------------------------------

SELECT
    categoria_produto,
    COUNT(*) qtd
FROM `unipds-511721.FraudesGB.transacoes` t
LEFT JOIN `unipds-511721.FraudesGB.dim_categorias` c
ON t.categoria_produto = c.id_categoria
WHERE c.id_categoria IS NULL
GROUP BY categoria_produto;
--Não há dados para exibir.
--------------------------------------------------------------------------------
-- KPIs DE FRAUDE
--------------------------------------------------------------------------------

SELECT
  fraude,
  COUNT(*) qtd,
  ROUND(
      100*COUNT(*)/
      SUM(COUNT(*)) OVER(),
      2
  ) percentual
FROM `unipds-511721.FraudesGB.scores_modelo`
GROUP BY fraude;
/*
Linha	fraude	qtd	percentual
1	0	142690	95.0
2	1	7510	5.0

*/
--------------------------------------------------------------------------------
-- TAXA DE FRAUDE
--------------------------------------------------------------------------------

SELECT
  ROUND(
      100*AVG(CAST(fraude AS FLOAT64)),
      2
  ) taxa_fraude
FROM `unipds-511721.FraudesGB.scores_modelo`;

/*
Linha	taxa_fraude
1	5.0
*/

--------------------------------------------------------------------------------
-- TICKET MÉDIO GERAL
--------------------------------------------------------------------------------

SELECT
  AVG(valor_compra) ticket_medio
FROM `unipds-511721.FraudesGB.transacoes`;

/*

Linha	ticket_medio
1	43.51457529960051
*/



--------------------------------------------------------------------------------
-- TICKET MÉDIO FRAUDE
--------------------------------------------------------------------------------

SELECT
  AVG(t.valor_compra) ticket_medio_fraude
FROM `unipds-511721.FraudesGB.transacoes` t
JOIN `unipds-511721.FraudesGB.scores_modelo` sm
ON t.id_transacao = sm.id_transacao
WHERE sm.fraude = 1;


/*
Linha	ticket_medio
1	43.51457529960051
*/

--------------------------------------------------------------------------------
-- FRAUDE POR PAÍS
--------------------------------------------------------------------------------

SELECT
  t.pais,
  COUNT(*) transacoes,
  SUM(sm.fraude) fraudes,
  ROUND(
      100*SUM(sm.fraude)/COUNT(*),
      2
  ) taxa_fraude
FROM `unipds-511721.FraudesGB.transacoes` t
JOIN `unipds-511721.FraudesGB.scores_modelo` sm
ON t.id_transacao = sm.id_transacao
GROUP BY t.pais
HAVING COUNT(*) >= 30
ORDER BY taxa_fraude DESC;

/*

Linha	pais	transacoes	fraudes	taxa_fraude
1	RU	73	6	8.22
2	null	194	15	7.73
3	ES	69	5	7.25
4	BR	111767	6169	5.52
5	SE	359	15	4.18
6	AR	32013	1181	3.69
7	US	2278	70	3.07
8	CO	64	1	1.56
9	MX	237	3	1.27
10	UY	2972	30	1.01
11	GB	43	0	0.0

*/


--------------------------------------------------------------------------------
-- FRAUDE POR CATEGORIA
--------------------------------------------------------------------------------

SELECT
  categoria_produto,
  COUNT(*) transacoes,
  SUM(sm.fraude) fraudes,
  ROUND(
      100*SUM(sm.fraude)/COUNT(*),
      2
  ) taxa_fraude
FROM `unipds-511721.FraudesGB.transacoes` t
JOIN `unipds-511721.FraudesGB.scores_modelo` sm
ON t.id_transacao = sm.id_transacao
GROUP BY categoria_produto
HAVING COUNT(*) >= 30
ORDER BY taxa_fraude DESC limit 10;

/*
Linha	categoria_produto	transacoes	fraudes	taxa_fraude
1	cat_eb8147e	49	31	63.27
2	cat_488a981	35	22	62.86
3	cat_440aeb1	96	49	51.04
4	cat_5211252	88	42	47.73
5	cat_41658ff	80	36	45.0
6	cat_acb7f4c	51	20	39.22
7	cat_38b827b	68	23	33.82
8	cat_5d1d957	71	24	33.8
9	cat_5cca8c4	33	9	27.27
10	cat_4c66089	54	14	25.93
*/

--------------------------------------------------------------------------------
-- FRAUDE POR API
--------------------------------------------------------------------------------

SELECT
  versao_api,
  COUNT(*) transacoes,
  SUM(sm.fraude) fraudes,
  ROUND(
      100*SUM(sm.fraude)/COUNT(*),
      2
  ) taxa_fraude
FROM `unipds-511721.FraudesGB.transacoes` t
JOIN `unipds-511721.FraudesGB.scores_modelo` sm
ON t.id_transacao = sm.id_transacao
GROUP BY versao_api
ORDER BY taxa_fraude DESC;

/*

Linha	versao_api	transacoes	fraudes	taxa_fraude
1	v3	67655	3431	5.07
2	v2	30062	1505	5.01
3	v2.1	44900	2210	4.92
4	v1	7583	364	4.8
*/

--------------------------------------------------------------------------------
-- VOLUME POR DIA
--------------------------------------------------------------------------------

SELECT
  DATE(data_compra) data,
  COUNT(*) qtd_transacoes,
  SUM(valor_compra) valor_total,
  AVG(valor_compra) ticket_medio
FROM `unipds-511721.FraudesGB.transacoes`
GROUP BY data
ORDER BY data limit 10;
/*
Linha	data	qtd_transacoes	valor_total	ticket_medio
1	2020-03-08	2843	123843.83999999831	43.560970805487166
2	2020-03-09	4176	204701.18000000034	49.01848180076627
3	2020-03-10	4109	200372.17000000036	48.764217571185114
4	2020-03-11	3904	204160.29999999964	52.29515881147539
5	2020-03-12	3792	177297.92000000013	46.755780590717364
6	2020-03-13	3232	156371.9800000002	48.38241955445541
7	2020-03-14	2565	109372.70000000006	42.64042884990248
8	2020-03-15	2777	115417.51000000046	41.561940943464116
9	2020-03-16	4206	203468.65999999942	48.375810746552496
10	2020-03-17	4284	205966.79999999996	48.07815126050425

*/
--------------------------------------------------------------------------------
-- WINDOW FUNCTION #1
-- SEQUÊNCIA DE TRANSAÇÕES POR PAÍS
--------------------------------------------------------------------------------

SELECT
  id_transacao,
  pais,
  data_compra,
  valor_compra,
  ROW_NUMBER() OVER(
      PARTITION BY pais
      ORDER BY data_compra
  ) sequencia
FROM `unipds-511721.FraudesGB.transacoes`
limit 10;
/*
Linha	id_transacao	pais	data_compra	valor_compra	sequencia
1	105372	null	2020-03-09 15:03:51 UTC	16.89	1
2	11889	null	2020-03-10 00:42:18 UTC	15.33	2
3	87715	null	2020-03-10 12:59:54 UTC	20.4	3
4	22618	null	2020-03-10 16:13:42 UTC	106.57	4
5	100598	null	2020-03-10 16:34:25 UTC	8.23	5
6	111069	null	2020-03-11 18:07:18 UTC	25.14	6
7	7302	null	2020-03-13 20:59:03 UTC	8.66	7
8	60559	null	2020-03-14 00:04:07 UTC	28.13	8
9	28271	null	2020-03-14 11:24:08 UTC	2.15	9
10	47995	null	2020-03-14 22:28:07 UTC	30.11
*/


--------------------------------------------------------------------------------
-- WINDOW FUNCTION #2
-- VARIAÇÃO DE VALOR DA COMPRA
--------------------------------------------------------------------------------

SELECT
  id_transacao,
  pais,
  data_compra,
  valor_compra,
  LAG(valor_compra)
      OVER(
          PARTITION BY pais
          ORDER BY data_compra
      ) valor_anterior,
  valor_compra -
      LAG(valor_compra)
      OVER(
          PARTITION BY pais
          ORDER BY data_compra
      ) diferenca
FROM `unipds-511721.FraudesGB.transacoes`
where is_teste = 0 limit 10;
/*
Linha	id_transacao	pais	data_compra	valor_compra	valor_anterior	diferenca
1	105372	null	2020-03-09 15:03:51 UTC	16.89	null	null
2	11889	null	2020-03-10 00:42:18 UTC	15.33	16.89	-1.5600000000000005
3	87715	null	2020-03-10 12:59:54 UTC	20.4	15.33	5.0699999999999985
4	22618	null	2020-03-10 16:13:42 UTC	106.57	20.4	86.16999999999999
5	100598	null	2020-03-10 16:34:25 UTC	8.23	106.57	-98.33999999999999
6	111069	null	2020-03-11 18:07:18 UTC	25.14	8.23	16.91
7	7302	null	2020-03-13 20:59:03 UTC	8.66	25.14	-16.48
8	60559	null	2020-03-14 00:04:07 UTC	28.13	8.66	19.47
9	28271	null	2020-03-14 11:24:08 UTC	2.15	28.13	-25.98
10	47995	null	2020-03-14 22:28:07 UTC	30.11

*/

C.1 Is Teste
SQL
SELECT
is_teste,
COUNT(*) qtd,
ROUND(
100 * COUNT(*) /
SUM(COUNT(*)) OVER(),
2
) percentual
FROM `unipds-511721.FraudesGB.transacoes`
GROUP BY is_teste;
/*
Linha	is_teste	qtd	percentual
1	0	150000	99.87
2	1	200	0.13

*/



C.2 Recalculado
SQL
SELECT
recalculado,
COUNT(*) qtd,
ROUND(
100 * COUNT(*) /
SUM(COUNT(*)) OVER(),
2
) percentual
FROM `unipds-511721.FraudesGB.scores_financeiros`
GROUP BY recalculado;

/*
Linha	recalculado	qtd	percentual
1	0	135069	89.93
2	1	15131	10.07
*/
--Verificar faixas inválidas.

SELECT
*
FROM `unipds-511721.FraudesGB.scores_modelo`
WHERE score_fraude_modelo < 0
OR score_fraude_modelo > 1 limit 10;


/*
Linha	id_transacao	score_8	score_fraude_modelo	fraude	experimento	threshold_decisao
1	473	0.00217102931604529	2	0	lgbm_v1	0.5
2	784	0.377018376378011	2	0	lgbm_v1	0.5
3	1118	0.174546884659516	2	0	lgbm_v1	0.5
4	2177	0.283070166637109	2	0	lgbm_v1	0.5
5	2930	0.951948820045046	2	0	lgbm_v1	0.5
6	3351	0.173864416297817	2	0	lgbm_v1	0.5
7	5284	0.0217056237955652	2	0	lgbm_v1	0.5
8	6094	0.103153121742494	2	0	lgbm_v1	0.5
9	6548	0.414538663387979	2	0	lgbm_v1	0.5
10	6748	0.398089965974183	2	0	lgbm_v1
*/

--1. Cardinalidade individual dos scores

--Objetivo: verificar variabilidade, detectar score constante ou com baixa cardinalidade.

SELECT
COUNT(DISTINCT score_1) score_1,
COUNT(DISTINCT score_2) score_2,
COUNT(DISTINCT score_3) score_3,
COUNT(DISTINCT score_4) score_4,
COUNT(DISTINCT score_5) score_5,
COUNT(DISTINCT score_6) score_6,
COUNT(DISTINCT score_7) score_7,
COUNT(DISTINCT score_8) score_8,
COUNT(DISTINCT score_9) score_9,
COUNT(DISTINCT score_10) score_10
FROM `unipds-511721.FraudesGB.transacoes` t
JOIN `unipds-511721.FraudesGB.scores_comportamentais` sc
ON t.id_transacao = sc.id_transacao
JOIN `unipds-511721.FraudesGB.scores_financeiros` sf
ON t.id_transacao = sf.id_transacao
JOIN `unipds-511721.FraudesGB.scores_modelo` sm
ON t.id_transacao = sm.id_transacao
WHERE COALESCE(t.is_teste,0)=0;

/*

Linha	score_1	score_2	score_3	score_4	score_5	score_6	score_7	score_8	score_9	score_10
1	4	7672	135090	51	43208	1338	59	150000	7297	1793

*/
--Complementar (mais importante)

--Distribuição individual por score.

SELECT
    'score_1' score,
    COUNT(DISTINCT score_1) cardinalidade,
    MIN(score_1) minimo,
    MAX(score_1) maximo
FROM `unipds-511721.FraudesGB.scores_comportamentais`

UNION ALL

SELECT
    'score_2',
    COUNT(DISTINCT score_2),
    MIN(score_2),
    MAX(score_2)
FROM `unipds-511721.FraudesGB.scores_comportamentais`

UNION ALL

SELECT
    'score_3',
    COUNT(DISTINCT score_3),
    MIN(score_3),
    MAX(score_3)
FROM `unipds-511721.FraudesGB.scores_financeiros`

UNION ALL

SELECT
    'score_4',
    COUNT(DISTINCT score_4),
    MIN(score_4),
    MAX(score_4)
FROM `unipds-511721.FraudesGB.scores_comportamentais`

UNION ALL

SELECT
    'score_5',
    COUNT(DISTINCT score_5),
    MIN(score_5),
    MAX(score_5)
FROM `unipds-511721.FraudesGB.scores_comportamentais`

UNION ALL

SELECT
    'score_6',
    COUNT(DISTINCT score_6),
    MIN(score_6),
    MAX(score_6)
FROM `unipds-511721.FraudesGB.scores_financeiros`

UNION ALL

SELECT
    'score_7',
    COUNT(DISTINCT score_7),
    MIN(score_7),
    MAX(score_7)
FROM `unipds-511721.FraudesGB.scores_comportamentais`

UNION ALL

SELECT
    'score_8',
    COUNT(DISTINCT score_8),
    MIN(score_8),
    MAX(score_8)
FROM `unipds-511721.FraudesGB.scores_modelo`

UNION ALL

SELECT
    'score_9',
    COUNT(DISTINCT score_9),
    MIN(score_9),
    MAX(score_9)
FROM `unipds-511721.FraudesGB.scores_financeiros`

UNION ALL

SELECT
    'score_10',
    COUNT(DISTINCT score_10),
    MIN(score_10),
    MAX(score_10)
FROM `unipds-511721.FraudesGB.scores_financeiros`

ORDER BY score;

/*
Linha	score	cardinalidade	minimo	maximo
1	score_1	4	1.0	4.0
2	score_10	1793	0.0	2225.0
3	score_2	7672	0.0	1.0
4	score_3	135090	0.16	1.387874371E7
5	score_4	51	0.0	50.0
6	score_5	43208	0.0	833.333333333333
7	score_6	1338	-5.0	145274.0
8	score_7	59	0.0	58.0
9	score_8	150000	4.17995448742658E-6	0.999994795541326
10	score_9	7297	0.0	7544.0


*/

que são FLOATs.

2. Fraude por departamento (mais útil que categoria)

Você já possui o Top Categories.

Mas para o README o mais explicativo é por departamento:

SQL
SELECT
c.departamento,
COUNT(*) transacoes,
SUM(sm.fraude) fraudes,
ROUND(
100 * SUM(sm.fraude) / COUNT(*),
2
) taxa_fraude
FROM `unipds-511721.FraudesGB.transacoes` t
JOIN `unipds-511721.FraudesGB.scores_modelo` sm
ON t.id_transacao = sm.id_transacao
JOIN `unipds-511721.FraudesGB.dim_categorias` c
ON t.categoria_produto = c.id_categoria
WHERE COALESCE(t.is_teste,0)=0
GROUP BY c.departamento
ORDER BY taxa_fraude DESC;

/*

Linha	departamento	transacoes	fraudes	taxa_fraude
1	Automotivo	18961	1158	6.11
2	Alimentos	17815	913	5.12
3	Brinquedos	21657	1104	5.1
4	Eletrônicos	15453	774	5.01
5	Casa & Jardim	20723	1035	4.99
6	Moda	22323	1069	4.79
7	Esportes	15269	677	4.43
8	Beleza & Saúde	17799	770	4.33
*/


Top Categorias de Maior Volume
SQL

SELECT
c.departamento,
COUNT(*) transacoes,
ROUND(
100 * COUNT(*) /
SUM(COUNT(*)) OVER(),
2
) percentual
FROM `unipds-511721.FraudesGB.transacoes` t
JOIN `unipds-511721.FraudesGB.dim_categorias` c
ON t.categoria_produto = c.id_categoria
WHERE COALESCE(t.is_teste,0)=0
GROUP BY c.departamento
ORDER BY transacoes DESC;

/*
Linha	departamento	transacoes	percentual
1	Moda	22323	14.88
2	Brinquedos	21657	14.44
3	Casa & Jardim	20723	13.82
4	Automotivo	18961	12.64
5	Alimentos	17815	11.88
6	Beleza & Saúde	17799	11.87
7	Eletrônicos	15453	10.3
8	Esportes	15269	10.18
*/
3. Ticket Médio Fraude (revalidado)

A query atual retornou exatamente a média global.

Vamos validar.

Ticket médio fraude
SQL
SELECT
ROUND(AVG(t.valor_compra),2) ticket_medio_fraude
FROM `unipds-511721.FraudesGB.transacoes` t
INNER JOIN `unipds-511721.FraudesGB.scores_modelo` sm
ON t.id_transacao = sm.id_transacao
WHERE sm.fraude = 1
AND COALESCE(t.is_teste,0)=0;

/*
Linha	ticket_medio_fraude
1	72.97
*/


Ticket médio não fraude
SQL
SELECT
ROUND(AVG(t.valor_compra),2) ticket_medio_nao_fraude
FROM `unipds-511721.FraudesGB.transacoes` t
INNER JOIN `unipds-511721.FraudesGB.scores_modelo` sm
ON t.id_transacao = sm.id_transacao
WHERE sm.fraude = 0
AND COALESCE(t.is_teste,0)=0;
/*
Linha	ticket_medio_nao_fraude
1	41.97
*/

Comparativo completo

Essa vai direto para o README.

SQL
SELECT
sm.fraude,
COUNT(*) qtd_transacoes,
ROUND(
AVG(t.valor_compra),
2
) ticket_medio,
ROUND(
MIN(t.valor_compra),
2
) menor_compra,
ROUND(
MAX(t.valor_compra),
2
) maior_compra
FROM `unipds-511721.FraudesGB.transacoes` t
JOIN `unipds-511721.FraudesGB.scores_modelo` sm
ON t.id_transacao = sm.id_transacao
WHERE COALESCE(t.is_teste,0)=0
GROUP BY sm.fraude;
/*
Linha	fraude	qtd_transacoes	ticket_medio	menor_compra	maior_compra
1	1	7500	72.97	0.21	3424.81
2	0	142500	41.97	0.02	3696.35	

*/
4. Registros completos onde score_fraude_modelo > 1

Esta análise merece uma seção própria chamada:

Inconsistências de Dados

Quantidade
SQL
SELECT
score_fraude_modelo,
COUNT(*) registros
FROM `unipds-511721.FraudesGB.scores_modelo`
GROUP BY score_fraude_modelo
ORDER BY score_fraude_modelo
/*
Linha	score_fraude_modelo	registros
1	0	4974
2	1	1036
3	2	1108
4	3	1261
5	4	1362
6	5	1442
7	6	1546
8	7	1575
9	8	1525
10	9	1501
11	10	1516
12	11	1467
13	12	1479
14	13	1564
15	14	1517
16	15	1482
17	16	1477
18	17	1476
19	18	1544
20	19	1512
21	20	1566
22	21	1494
23	22	1508
24	23	1469
25	24	1481
26	25	1451
27	26	1477
28	27	1497
29	28	1518
30	29	1489
31	30	1549
32	31	1501
33	32	1402
34	33	1494
35	34	1523
36	35	1556
37	36	1500
38	37	1573
39	38	1439
40	39	1448
41	40	1539
42	41	1526
43	42	1502
44	43	1520
45	44	1480
46	45	1593
47	46	1542
48	47	1438
49	48	1523
50	49	1456
*/


Quantos problemáticos
SQL
SELECT
COUNT(*) qtd_registros
FROM `unipds-511721.FraudesGB.scores_modelo`
WHERE score_fraude_modelo > 1;
/*
Linha	qtd_registros
1	144190
*/
Percentual
SQL
SELECT
COUNT(*) registros_invalidos,
ROUND(
100*COUNT(*)/
(SELECT COUNT(*)
FROM `unipds-511721.FraudesGB.scores_modelo`)
,4) percentual
FROM `unipds-511721.FraudesGB.scores_modelo`
WHERE score_fraude_modelo > 1;

/*
Linha	registros_invalidos	percentual
1	144190	95.9987
*/

Distribuição
SQL
SELECT
score_fraude_modelo,
COUNT(*) quantidade,
ROUND(
100 * COUNT(*) /
SUM(COUNT(*)) OVER(),
4
) percentual
FROM `unipds-511721.FraudesGB.scores_modelo`
GROUP BY score_fraude_modelo
ORDER BY score_fraude_modelo;
/*
--retornou 101 registro, peguei os 13 primeiros

Linha	score_fraude_modelo	quantidade	percentual
1	0	4974	3.3116
2	1	1036	0.6897
3	2	1108	0.7377
4	3	1261	0.8395
5	4	1362	0.9068
6	5	1442	0.9601
7	6	1546	1.0293
8	7	1575	1.0486
9	8	1525	1.0153
10	9	1501	0.9993
11	10	1516	1.0093
12	11	1467	0.9767
13	12	1479	0.9847
*/

Registros completos
SQL
SELECT *
FROM `unipds-511721.FraudesGB.scores_modelo`
WHERE score_fraude_modelo > 1
ORDER BY id_transacao limit 10;
/*
retornaram 144190 registros, peguei as 10 primeiras
Linha	id_transacao	score_8	score_fraude_modelo	fraude	experimento	threshold_decisao
1	1	0.883597898355453	66	0	lgbm_v2_final	0.5
2	2	0.376019059694055	72	0	lgbm_v2_final	0.5
3	3	0.516368128845808	95	0	lgbm_v2_final	0.5
4	4	0.154036420702482	2	0	xgb_v2_feat_eng	0.5
5	5	0.855798151189198	76	0	lgbm_v2_final	0.5
6	6	0.571501685900052	32	0	lgbm_v2_final	0.5
7	7	0.204991162783819	71	0	xgb_v2_feat_eng	0.5
8	8	0.569230211208452	81	0	xgb_v2_feat_eng	0.5
9	9	0.897001189457387	64	0	lgbm_v2_final	0.5
10	10	0.735789649906127	60	0	lgbm_v2_final	0.5

*/

5. Série temporal completa

A query que você executou estava limitada.

Vamos trazer a série completa.

SQL
SELECT
DATE(data_compra) data,
COUNT(*) qtd_transacoes,
ROUND(
SUM(valor_compra),
2
) valor_total,
ROUND(
AVG(valor_compra),
2
) ticket_medio
FROM `unipds-511721.FraudesGB.transacoes`
WHERE COALESCE(is_teste,0)=0
GROUP BY data
ORDER BY data;
/*
Linha	data	qtd_transacoes	valor_total	ticket_medio
1	2020-03-08	2838	123628.87	43.56
2	2020-03-09	4173	204676.36	49.05
3	2020-03-10	4105	200292.96	48.79
4	2020-03-11	3899	204069.03	52.34
5	2020-03-12	3787	177158.58	46.78
6	2020-03-13	3229	156179.98	48.37
7	2020-03-14	2560	109154.24	42.64
8	2020-03-15	2770	115206.08	41.59
9	2020-03-16	4202	203184.54	48.35
10	2020-03-17	4280	205880.2	48.1
11	2020-03-18	4041	188811.94	46.72
12	2020-03-19	3899	194911.7	49.99
13	2020-03-20	3316	153837.3	46.39
14	2020-03-21	2632	123676.88	46.99
15	2020-03-22	2829	124071.42	43.86
16	2020-03-23	3996	184894.61	46.27
17	2020-03-24	3868	173825.68	44.94
18	2020-03-25	3402	154906.8	45.53
19	2020-03-26	2841	127585.3	44.91
20	2020-03-27	2027	86235.86	42.54
21	2020-03-28	1972	81738.11	41.45
22	2020-03-29	1963	70158.69	35.74
23	2020-03-30	2364	85011.76	35.96
24	2020-03-31	1968	73344.81	37.27
25	2020-04-01	2582	121947.11	47.23
26	2020-04-02	2741	104446.02	38.11
27	2020-04-03	2608	104297.33	39.99
28	2020-04-04	2574	103517.97	40.22
29	2020-04-05	2597	98987.98	38.12
30	2020-04-06	3607	147480.54	40.89
31	2020-04-07	3573	146604.24	41.03
32	2020-04-08	3774	153683.05	40.72
33	2020-04-09	3964	157282.75	39.68
34	2020-04-10	3485	145399.35	41.72
35	2020-04-11	3098	114930.57	37.1
36	2020-04-12	2942	111802.44	38.0
37	2020-04-13	2218	82536.47	37.21
38	2020-04-14	4290	180223.44	42.01
39	2020-04-15	4473	195340.94	43.67
40	2020-04-16	3926	172577.9	43.96
41	2020-04-17	3604	150070.64	41.64
42	2020-04-18	3410	134753.46	39.52
43	2020-04-19	3411	138130.53	40.5
44	2020-04-20	5314	231564.29	43.58
45	2020-04-21	4848	210451.4	43.41
*/

Série temporal com fraudes (mais importante para os gráficos)
SQL
SELECT
DATE(t.data_compra) data,
COUNT(*) transacoes,
SUM(sm.fraude) fraudes,
ROUND(
100 * AVG(CAST(sm.fraude AS FLOAT64)),
2
) taxa_fraude,
ROUND(
AVG(t.valor_compra),
2
) ticket_medio
FROM `unipds-511721.FraudesGB.transacoes` t
JOIN `unipds-511721.FraudesGB.scores_modelo` sm
ON t.id_transacao = sm.id_transacao
WHERE COALESCE(t.is_teste,0)=0
GROUP BY data
ORDER BY data;

/*
Linha	data	transacoes	fraudes	taxa_fraude	ticket_medio
1	2020-03-08	2838	124	4.37	43.56
2	2020-03-09	4173	197	4.72	49.05
3	2020-03-10	4105	187	4.56	48.79
4	2020-03-11	3899	203	5.21	52.34
5	2020-03-12	3787	181	4.78	46.78
6	2020-03-13	3229	162	5.02	48.37
7	2020-03-14	2560	135	5.27	42.64
8	2020-03-15	2770	119	4.3	41.59
9	2020-03-16	4202	180	4.28	48.35
10	2020-03-17	4280	201	4.7	48.1
11	2020-03-18	4041	182	4.5	46.72
12	2020-03-19	3899	193	4.95	49.99
13	2020-03-20	3316	153	4.61	46.39
14	2020-03-21	2632	109	4.14	46.99
15	2020-03-22	2829	131	4.63	43.86
16	2020-03-23	3996	200	5.01	46.27
17	2020-03-24	3868	220	5.69	44.94
18	2020-03-25	3402	155	4.56	45.53
19	2020-03-26	2841	183	6.44	44.91
20	2020-03-27	2027	130	6.41	42.54
21	2020-03-28	1972	125	6.34	41.45
22	2020-03-29	1963	129	6.57	35.74
23	2020-03-30	2364	152	6.43	35.96
24	2020-03-31	1968	126	6.4	37.27
25	2020-04-01	2582	166	6.43	47.23
26	2020-04-02	2741	160	5.84	38.11
27	2020-04-03	2608	129	4.95	39.99
28	2020-04-04	2574	137	5.32	40.22
29	2020-04-05	2597	138	5.31	38.12
30	2020-04-06	3607	183	5.07	40.89
31	2020-04-07	3573	230	6.44	41.03
32	2020-04-08	3774	199	5.27	40.72
33	2020-04-09	3964	223	5.63	39.68
34	2020-04-10	3485	204	5.85	41.72
35	2020-04-11	3098	139	4.49	37.1
36	2020-04-12	2942	144	4.89	38.0
37	2020-04-13	2218	131	5.91	37.21
38	2020-04-14	4290	202	4.71	42.01
39	2020-04-15	4473	100	2.24	43.67
40	2020-04-16	3926	198	5.04	43.96
41	2020-04-17	3604	160	4.44	41.64
42	2020-04-18	3410	140	4.11	39.52
43	2020-04-19	3411	156	4.57	40.5
44	2020-04-20	5314	258	4.86	43.58
45	2020-04-21	4848	226	4.66	43.41
*/

Query extra que eu incluiria no README

Ela gera um dos melhores gráficos do trabalho:

SQL
SELECT
pais,
COUNT(*) transacoes,
ROUND(
AVG(valor_compra),
2
) ticket_medio,
SUM(fraude) fraudes,
ROUND(
100 * AVG(CAST(fraude AS FLOAT64)),
2
) taxa_fraude
FROM `unipds-511721.FraudesGB.vw_abt_fraude`
GROUP BY pais
HAVING COUNT(*) >= 30
ORDER BY taxa_fraude DESC;

/*

Linha	pais	transacoes	ticket_medio	fraudes	taxa_fraude
1	RU	73	51.62	6	8.22
2	ND	194	33.26	15	7.73
3	ES	69	62.54	5	7.25
4	BR	111628	37.74	6162	5.52
5	SE	358	22.4	15	4.19
6	AR	31964	62.32	1179	3.69
7	US	2273	50.73	70	3.08
8	CO	64	63.86	1	1.56
9	MX	236	34.58	3	1.27
10	UY	2967	55.83	29	0.98
11	GB	43	58.11	0	0.0
*/


SELECT COUNT(*) registros
FROM FraudesGB.vw_abt_fraude;


SELECT
fraude,
COUNT(*) qtd
FROM FraudesGB.vw_abt_fraude
GROUP BY fraude;



SELECT
COUNTIF(flag_outlier_valor = 1) qtd_outliers,
COUNTIF(flag_pais_raro = 1) qtd_paises_raros,
COUNTIF(flag_pais_nao_informado = 1) qtd_pais_nd
FROM FraudesGB.vw_abt_fraude;