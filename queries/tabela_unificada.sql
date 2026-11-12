--2-criar tabela unica

create table `unipds-511721.FraudesGB.abt_fraude` as (
SELECT
tran.data_compra,
tran.entrega_doc_1,
tran.entrega_doc_2,
tran.entrega_doc_3,
tran.produto,
tran.pais,
tran.valor_compra,
tran.categoria_produto,
MO.score_8,
MO.score_fraude_modelo,
MO.fraude,
COMP.score_1,
COMP.score_2,
COMP.score_4,
COMP.score_5,
COMP.score_7,
FIN.score_3,
FIN.score_6,
FIN.score_9,
FIN.score_10
FROM `unipds-511721.FraudesGB.transacoes` tran
INNER JOIN
`unipds-511721.FraudesGB.scores_comportamentais` COMP ON tran.id_transacao = COMP.id_transacao
INNER JOIN
`unipds-511721.FraudesGB.scores_financeiros` FIN ON tran.id_transacao = FIN.id_transacao
INNER JOIN
`unipds-511721.FraudesGB.scores_modelo` MO ON tran.id_transacao = MO.id_transacao
WHERE tran.is_teste = 0);