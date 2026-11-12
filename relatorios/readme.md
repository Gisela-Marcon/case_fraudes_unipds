Projeto SQL para Detecção de Fraudes
1. Objetivo

O objetivo deste projeto é construir uma Base Analítica de Dados (ABT - Analytical Base Table) para suporte à identificação de fraudes em transações de e-commerce, consolidando informações de transações, scores comportamentais, scores financeiros e resultados de modelos preditivos.

A solução foi desenvolvida utilizando BigQuery e segue uma arquitetura em camadas, possibilitando futuras análises, dashboards e utilização em projetos de Machine Learning.

2. Arquitetura da Solução
Plain Text
transacoes
+
scores_comportamentais
+
scores_financeiros
+
scores_modelo
+
dim_paises
+
dim_categorias
│
▼
 
vw_transacoes_tratadas
vw_scores_tratados
 
▼
 
vw_abt_fraude
 
▼
 
Views Analíticas
 
vw_fraude_pais
vw_fraude_categoria
vw_fraude_canal
vw_fraude_tempo
vw_ticket_medio_pais
vw_risco_pais
3. Fontes de Dados
Tabelas Utilizadas
Tabela	Descrição
transacoes	Dados das compras realizadas
scores_comportamentais	Variáveis de comportamento dos usuários
scores_financeiros	Variáveis financeiras
scores_modelo	Resultado do motor de fraude
dim_paises	Informações geográficas
dim_categorias	Informações das categorias de produtos
4. Volume das Tabelas
Objetivo

Validar a volumetria do ambiente e identificar possíveis inconsistências entre as tabelas antes da construção da ABT.

Query
SQL
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
Resultado
Tabela	Registros
transacoes	150.200
scores_comportamentais	150.200
scores_financeiros	150.200
scores_modelo	150.200
dim_paises	57
dim_categorias	8.374
Análise de Negócio

Todas as tabelas transacionais possuem exatamente o mesmo volume de registros, indicando forte evidência de relacionamento 1:1 através da chave id_transacao.

Isso reduz significativamente o risco de perdas durante os JOINs necessários para construção da ABT.

5. Cardinalidade dos Dados
Transações
Query
SQL
SELECT
COUNT(DISTINCT id_transacao) qtd_transacoes,
COUNT(DISTINCT pais) qtd_paises,
COUNT(DISTINCT categoria_produto) qtd_categorias,
COUNT(DISTINCT produto) qtd_produtos,
COUNT(DISTINCT canal_venda) qtd_canais,
COUNT(DISTINCT versao_api) qtd_apis
FROM `unipds-511721.FraudesGB.transacoes`;
Resultado
Métrica	Quantidade
Transações	150.200
Países	51
Categorias	8.324
Produtos	127.305
Canais	5
APIs	4
Análise de Negócio

A operação possui catálogo extremamente pulverizado, com mais de 127 mil produtos únicos distribuídos em mais de 8 mil categorias.

Isto sugere um ambiente típico de marketplace, aumentando a complexidade do monitoramento de fraude.

6. Qualidade dos Dados
Nulos em Transações
Query
SQL
SELECT
COUNTIF(pais IS NULL) pais_null,
COUNTIF(entrega_doc_2 IS NULL) entrega_doc_2_null
FROM `unipds-511721.FraudesGB.transacoes`;
Resultado
Campo	Nulos
pais	194
entrega_doc_2	108.999
Tratamentos Aplicados
SQL
COALESCE(pais,'ND')
SQL
COALESCE(entrega_doc_2,FALSE)
Análise de Negócio

O país é relevante para análise de risco geográfico. Por isso, optou-se por preservar a informação de ausência através do valor "ND" e da feature flag_pais_nao_informado.

7. Distribuição Geográfica
Resultado
País	Transações	%
BR	111.767	74,41
AR	32.013	21,31
UY	2.972	1,98
US	2.278	1,52
Análise de Negócio

Brasil e Argentina representam mais de 95% de todo o volume transacional da empresa.

Essa concentração geográfica influencia diretamente o treinamento de modelos de fraude.

8. Perfil Estatístico
Query
SQL
SELECT
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
Resultado
Métrica	Valor
Média	43,51
Mínimo	0,02
Máximo	3.696,35
P25	9,38
P50	20,63
P75	40,68
P95	157,49
P99	417,29
Análise de Negócio

A distribuição é altamente assimétrica.

50% das compras estão abaixo de R$ 20,63.
Apenas 1% supera R$ 417,29.

Isso motivou a criação da feature:

SQL
flag_outlier_valor

calculada dinamicamente através do percentil 99.

9. Cardinalidade dos Scores
Resultado
Score	Cardinalidade
score_1	4
score_2	7.672
score_3	135.090
score_4	51
score_5	43.208
score_6	1.338
score_7	59
score_8	150.000
score_9	7.297
score_10	1.793
Análise de Negócio

O score_8 possui um valor único para cada transação, indicando elevado poder discriminatório.

Já score_1, score_4 e score_7 apresentam comportamento categórico e provavelmente representam grupos de risco ou classificações discretas.

10. Análise de Fraude
Distribuição da Classe
Fraude	Quantidade	Percentual
Não Fraude	142.500	95%
Fraude	7.500	5%
Análise de Negócio

A base é fortemente desbalanceada.

Esse comportamento é esperado em problemas reais de detecção de fraude e exige técnicas específicas de modelagem.

11. Ticket Médio: Fraude x Não Fraude
Resultado
Tipo	Transações	Ticket Médio
Fraude	7.500	R$ 72,97
Não Fraude	142.500	R$ 41,97
Análise de Negócio

As transações fraudulentas apresentam ticket médio 74% superior às transações legítimas.

Este foi um dos principais achados da análise e reforça a importância da variável valor_compra.

12. Fraude por Departamento
Resultado
Departamento	Taxa Fraude (%)
Automotivo	6,11
Alimentos	5,12
Brinquedos	5,10
Eletrônicos	5,01
Casa & Jardim	4,99
Moda	4,79
Esportes	4,43
Beleza & Saúde	4,33
Análise de Negócio

Automotivo apresentou o maior risco de fraude da operação.

Esse resultado sugere necessidade de monitoramento adicional para esse grupo de produtos.

13. Fraude por País
Resultado
País	Transações	Ticket Médio	Fraudes	Taxa (%)
RU	73	51,62	6	8,22
ND	194	33,26	15	7,73
ES	69	62,54	5	7,25
BR	111.628	37,74	6.162	5,52
SE	358	22,40	15	4,19
AR	31.964	62,32	1.179	3,69
Análise de Negócio

Países com menor volume apresentaram maiores taxas de fraude, validando a criação da feature:

SQL
flag_pais_raro
14. Evolução Temporal da Fraude
Principais Datas
Data	Taxa Fraude (%)
2020-03-26	6,44
2020-03-27	6,41
2020-03-29	6,57
2020-03-30	6,43
2020-04-07	6,44
Análise de Negócio

Foi identificado um período de aumento consistente da taxa de fraude entre o final de março e início de abril.

Esse comportamento justifica o monitoramento temporal contínuo.

15. Features Criadas na ABT
Feature	Objetivo
flag_risco_comportamental	Score comportamental elevado
flag_alta_probabilidade	score_8 ≥ 0,80
acima_media_pais	Compra acima da média local
flag_outlier_valor	Compra acima do P99
flag_pais_raro	País com baixo histórico transacional
flag_pais_nao_informado	País originalmente nulo
ranking_valor_pais	Ranking da compra dentro do país
volume_transacoes_pais	Volume histórico do país
ticket_medio_pais	Ticket médio histórico
taxa_fraude_pais	Taxa histórica de fraude
taxa_fraude_canal	Taxa histórica por canal
taxa_fraude_departamento	Taxa histórica do departamento
16. Inconsistências Encontradas
score_fraude_modelo

A análise demonstrou que o campo não representa uma probabilidade.

Foram observados valores entre:

Plain Text
0 e 100

Portanto:

score_8 foi considerado a probabilidade do modelo.
score_fraude_modelo foi documentado como score bruto de classificação.

Nenhum tratamento corretivo foi aplicado.

17. Views Criadas
Plain Text
vw_transacoes_tratadas
vw_scores_tratados
vw_abt_fraude
 
vw_fraude_pais
vw_fraude_categoria
vw_fraude_canal
vw_fraude_tempo
vw_ticket_medio_pais
vw_risco_pais
18. Checklist de Entrega
Item	Status
Exploração inicial	✅
Volume das tabelas	✅
Dicionário de dados	✅
Cardinalidade	✅
Qualidade dos dados	✅
Integridade referencial	✅
Tratamento de nulos	✅
Remoção de registros de teste	✅
KPIs de fraude	✅
Outliers (P99)	✅
Window Functions	✅
Feature Engineering	✅
Construção da ABT	✅
Views analíticas	✅
Insights de negócio	✅
Documentação completa	✅
19. Conclusões Finais

✅ Base analítica consolidada com 150.000 transações válidas.

✅ Taxa geral de fraude de 5%.

✅ Brasil representa 74,41% das operações.

✅ Transações fraudulentas possuem ticket médio 74% maior.

✅ Departamento Automotivo apresentou o maior risco.

✅ Países raros apresentaram taxas superiores à média.

✅ Outliers foram tratados via P99 dinâmico.

✅ Estrutura pronta para dashboards, análises exploratórias e projetos de Machine Learning.