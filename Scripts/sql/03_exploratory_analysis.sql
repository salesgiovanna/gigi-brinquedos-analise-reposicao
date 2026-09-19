-- GIGI BRINQUEDOS | ANÁLISE EXPLORATÓRIA DE DADOS (EDA)

/* Este script reúne as principais análises exploratórias
 realizadas para compreender o desempenho comercial da
 Gigi Brinquedos e apoiar a construção do dashboard.*/


-- 1. VISÃO GERAL DAS VENDAS

-- Número de transações, unidades vendidas e faturamento total.

SELECT
    COUNT(*) AS total_vendas,
    SUM(v.Quantidade) AS unidades_vendidas,
    ROUND(SUM(v.Quantidade * p.Preco_Produto), 2) AS faturamento_total
FROM vendas_processed AS v
LEFT JOIN produtos_processed AS p
    ON v.ID_Produto = p.ID_Produto;


-- ============================================================
-- 2. EVOLUÇÃO MENSAL DAS VENDAS

-- Evolução mensal do volume vendido e do faturamento.

SELECT
    SUBSTR(v.Data_Venda, 1, 7) AS ano_mes,
    SUM(v.Quantidade) AS unidades_vendidas,
    ROUND(SUM(v.Quantidade * p.Preco_Produto), 2) AS faturamento
FROM vendas_processed AS v
LEFT JOIN produtos_processed AS p
    ON v.ID_Produto = p.ID_Produto
GROUP BY SUBSTR(v.Data_Venda, 1, 7)
ORDER BY ano_mes;


-- ============================================================
-- 3. DESEMPENHO DOS PRODUTOS

-- Desempenho dos produtos por volume vendido e faturamento.

SELECT
    p.Nome_Produto,
    SUM(v.Quantidade) AS unidades_vendidas,
    ROUND(SUM(v.Quantidade * p.Preco_Produto), 2) AS faturamento
FROM vendas_processed AS v
LEFT JOIN produtos_processed AS p
    ON v.ID_Produto = p.ID_Produto
GROUP BY p.ID_Produto, p.Nome_Produto
ORDER BY faturamento DESC;


-- ============================================================
-- 4. DESEMPENHO POR LOJA

-- Faturamento por loja, cidade e estado.

SELECT
    l.Nome_Loja,
    l.Cidade_Loja,
    l.Estado_Loja,
    ROUND(SUM(v.Quantidade * p.Preco_Produto), 2) AS faturamento
FROM vendas_processed AS v
LEFT JOIN produtos_processed AS p
    ON v.ID_Produto = p.ID_Produto
LEFT JOIN lojas_processed AS l
    ON v.ID_Loja = l.ID_Loja
GROUP BY
    l.ID_Loja,
    l.Nome_Loja,
    l.Cidade_Loja,
    l.Estado_Loja
ORDER BY faturamento DESC;


-- ============================================================
-- 5. DESEMPENHO POR CATEGORIA

-- Volume vendido e faturamento por categoria de produto.

SELECT
    p.Categoria_Produto AS categoria,
    SUM(v.Quantidade) AS unidades_vendidas,
    ROUND(SUM(v.Quantidade * p.Preco_Produto), 2) AS faturamento
FROM vendas_processed AS v
LEFT JOIN produtos_processed AS p
    ON v.ID_Produto = p.ID_Produto
GROUP BY p.Categoria_Produto
ORDER BY faturamento DESC;


-- ============================================================
-- 6. ESTOQUE X DEMANDA

/* Comparação entre a quantidade de lojas sem estoque
 e o volume histórico de vendas de cada produto.*/

SELECT
    p.Nome_Produto,
    e.lojas_sem_estoque,
    v.unidades_vendidas
FROM produtos_processed AS p

LEFT JOIN (
    SELECT
        ID_Produto,
        COUNT(*) AS lojas_sem_estoque
    FROM inventario_processed
    WHERE Estoque_Atual = 0
    GROUP BY ID_Produto
) AS e
    ON p.ID_Produto = e.ID_Produto

LEFT JOIN (
    SELECT
        ID_Produto,
        SUM(Quantidade) AS unidades_vendidas
    FROM vendas_processed
    GROUP BY ID_Produto
) AS v
    ON p.ID_Produto = v.ID_Produto

WHERE e.lojas_sem_estoque IS NOT NULL
ORDER BY
    e.lojas_sem_estoque DESC,
    v.unidades_vendidas DESC;
