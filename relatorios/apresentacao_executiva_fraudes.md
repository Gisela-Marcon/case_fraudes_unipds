---
marp: true
title: Fraude em transações
paginate: true
---

# Fraude em transações

## Onde priorizar controles para reduzir exposição

Análise executiva para decisão de negócio

**150 mil transações · 7.500 fraudes · incidência de 5,0%**

**Valor exposto:** R$ 547.271,12

---

# Objetivo e foco da conversa

## A pergunta para o negócio

> Onde um controle adicional pode reduzir mais risco com o menor atrito possível?

A análise combina incidência, volume de ocorrências e valor exposto. Os resultados indicam prioridades para teste; não comprovam causalidade nem o efeito de uma regra antes do piloto.

### Roteiro

1. **Dimensionar:** qual é a escala financeira e operacional do problema?
2. **Localizar:** em quais países, valores e grupos a incidência se concentra?
3. **Agir e medir:** que controles testar e quais indicadores proteger?

---

# Dimensão do problema

## 7.500 fraudes representam R$ 547 mil em compras

| Indicador | Resultado |
|---|---:|
| Transações analisadas | 150.000 |
| Fraudes identificadas | 7.500 |
| Taxa de fraude | 5,0% |
| Valor exposto | R$ 547.271,12 |
| Ticket médio da fraude | R$ 72,97 |
| Ticket médio geral | R$ 43,52 |

### Composição das transações

- Não fraude: **142.500 (95%)** — ███████████████████
- Fraude: **7.500 (5%)** — █

Uma em cada 20 transações foi fraude. O ticket médio fraudulento supera o ticket geral. O valor exposto é o valor das compras classificadas como fraude, não uma perda líquida confirmada.

---

# País

## Brasil combina a maior taxa com o maior volume

| País | Taxa de fraude | Transações |
|---|---:|---:|
| Brasil | **5,52%** | **111.628** |
| Argentina | 3,69% | 31.964 |
| Estados Unidos | 3,08% | 2.273 |
| Uruguai | 0,98% | 2.967 |

```text
Taxa de fraude (linha por categoria, não série temporal)
Brasil 5,52% ─ Argentina 3,69% ─ Estados Unidos 3,08% ─ Uruguai 0,98%
```

O Brasil merece atenção primeiro: tem a maior taxa e concentra 111.628 transações. A incidência é cerca de 1,5 vez a da Argentina. A consulta considera apenas países com mil transações ou mais; os quatro países listados somam 148.832 registros.

---

# Risco da categoria

## O nível “alto” não se destaca na fraude observada

| Nível de risco | Taxa de fraude | Transações | Comparação |
|---|---:|---:|---|
| Médio | **5,21%** | 47.079 | █████████████████████ |
| Alto | 5,06% | 53.379 | ████████████████████ |
| Baixo | 4,74% | 49.542 | ███████████████████ |

**Diferença entre a maior e a menor taxa: 0,47 ponto percentual.**

Os resultados pouco diferem entre níveis. Curiosamente, “alto” não tem a maior incidência observada. Vale revisar a regra de classificação e abrir o resultado por categoria antes de usar esse nível para bloquear compras ou exigir autenticação.

---

# Faixa de valor

## A incidência cresce conforme aumenta o valor da compra

| Faixa de compra | Taxa de fraude | Transações | Barra de incidência |
|---|---:|---:|---|
| Até R$ 100 | 4,60% | 137.284 | ██████ |
| R$ 100–500 | 8,84% | 11.679 | ███████████ |
| Acima de R$ 500 | **14,95%** | 1.037 | ███████████████████ |

A fraude fica mais frequente conforme aumenta o valor: 4,60% até R$ 100, 8,84% entre R$ 100 e R$ 500 e 14,95% acima de R$ 500. A última faixa tem incidência 3,25 vezes maior que a primeira, mas reúne apenas 1.037 transações.

*As barras comparam grupos agregados definidos na consulta; não representam um histograma de observações individuais.*

---

# Concentração por valor

## Volume de casos e exposição financeira pedem controles diferentes

### Participação das fraudes

| Faixa | Casos | Participação |
|---|---:|---:|
| Até R$ 100 | 6.313 | **84,2%** |
| R$ 100–500 | 1.032 | 13,8% |
| Acima de R$ 500 | 155* | 2,1% |

### Participação do valor exposto

| Faixa | Valor exposto | Participação |
|---|---:|---:|
| Até R$ 100 | R$ 169.628,21 | 31,0% |
| R$ 100–500 | R$ 233.386,93 | 42,6% |
| Acima de R$ 500 | R$ 144.255,98* | 26,4% |

Até R$ 100 concentra a maior parte dos casos, então pequenas melhorias na detecção podem alcançar muitos eventos. Já compras acima de R$ 100 respondem por cerca de 69% do valor exposto, embora representem apenas 15,8% das fraudes. Vale combinar cobertura ampla nos valores baixos com revisão mais rigorosa nos valores altos.

\* **Estimativas derivadas dos totais:** a linha da faixa acima de R$ 500 na query foi enviada incompleta. Confirmar 155 fraudes e R$ 144.255,98 expostos na saída completa. A perda média derivada é R$ 930,68 por fraude.

---

# Desempenho do score

## D10 tem maior fraude; score ainda exige validação

| Decil | Taxa de fraude | Comparação com a média (5%) |
|---:|---:|---|
| D1 | 2,81% | ███ |
| D2 | 4,59% | █████ |
| D3 | 3,29% | ███ |
| D4 | 0,31% | ▏ |
| D5 | 0,62% | ▋ |
| D6 | 1,26% | █ |
| D7 | 1,96% | ██ |
| D8 | 5,24% | █████ |
| D9 | 8,60% | █████████ |
| D10 | **21,32%** | █████████████████████ |

Cada decis contém 15.000 transações. No D10, a taxa chega a 21,32% — 4,3 vezes a média da base. Isso pode ajudar a priorizar análises, desde que o score esteja ordenado no sentido esperado. Como os decis intermediários oscilam bastante, validar o cálculo e a direção do score antes de tirar conclusões sobre o modelo.

**Antes de usar em decisões automáticas:** confirmar a ordenação do `NTILE`, o sentido do score, a consistência do universo e a ausência de vazamento. Calcular fraudes e métricas de ranking/calibração por decis.

---

# Plano de ação em 90 dias

## Testar controles por valor e validar o score antes de ampliar regras

### 0–30 dias · Preparar e pilotar

**Responsáveis sugeridos:** Fraude e Operações

- Validar a saída completa da faixa acima de R$ 500 e a cobertura de países.
- Pilotar revisão reforçada ou autenticação adicional em compras acima de R$ 500.
- Definir baseline e limites de atrito: aprovação, falsos positivos e fila de análise.

### 31–60 dias · Medir e ajustar

**Responsáveis sugeridos:** Produto e Fraude

- Acompanhar exposição, fraude confirmada e conversão durante o piloto.
- Testar controles seletivos em R$ 100–500, faixa que concentra 42,6% do valor exposto.
- Investigar o Brasil em separado e revisar segmentos com o time local.

### 61–90 dias · Validar e decidir

**Responsáveis sugeridos:** Dados e Risco

- Recalcular fraude por decis e confirmar ordenação e calibração do score.
- Reavaliar níveis de risco por categoria; as taxas atuais são próximas.
- Ampliar, ajustar ou encerrar o piloto conforme benefício e impacto no cliente.

**Acompanhar em todas as fases:** taxa de fraude · valor exposto · aprovação/conversão · falsos positivos · volume de revisão manual.

---

# Decisões para iniciar o piloto

## Proposta para aprovação

1. **Autorizar o piloto** de revisão reforçada ou autenticação adicional em transações acima de R$ 500, com critérios claros de liberação.
2. **Escolher uma estratégia para R$ 100–500.** O segmento tem 8,84% de fraude e responde por 42,6% do valor exposto; testar controle de menor atrito.
3. **Priorizar o acompanhamento do Brasil**, que tem a maior taxa observada e o maior volume entre os países retornados.
4. **Condicionar o uso do score à validação** de direção, ordenação, calibração e desempenho.

### Como saber se funcionou

O piloto deve reduzir fraude ou valor exposto sem deteriorar de forma inaceitável a aprovação e a experiência do cliente. Fazer revisão semanal de:

- Fraudes confirmadas e taxa
- Valor exposto e perda líquida
- Aprovação e falsos positivos
- Fila e tempo de revisão

*Os resultados atuais definem prioridades para teste; o efeito dos controles será conhecido após o piloto.*
