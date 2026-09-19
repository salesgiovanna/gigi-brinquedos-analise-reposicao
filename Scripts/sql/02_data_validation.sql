-- GIGI BRINQUEDOS | VALIDAÇÃO E QUALIDADE DOS DADOS

/* Este script reúne verificações realizadas para identificar
 problemas de qualidade, como valores nulos, duplicidades,
 campos vazios e valores numéricos inválidos.*/


-- 1. PRODUTOS

-- Quantidade total de produtos.

SELECT COUNT(*) AS total_produtos
FROM produtos_raw;


-- Verificação de valores nulos nas principais colunas.

SELECT
    SUM(CASE WHEN Product_ID IS NULL THEN 1 ELSE 0 END) AS nulos_id,
    SUM(CASE WHEN Product_Name IS NULL THEN 1 ELSE 0 END) AS nulos_nome,
    SUM(CASE WHEN Product_Category IS NULL THEN 1 ELSE 0 END) AS nulos_categoria,
    SUM(CASE WHEN Product_Cost IS NULL THEN 1 ELSE 0 END) AS nulos_custo,
    SUM(CASE WHEN Product_Price IS NULL THEN 1 ELSE 0 END) AS nulos_preco
FROM produtos_raw;


-- Verificação de IDs duplicados.

SELECT
    Product_ID,
    COUNT(*) AS quantidade
FROM produtos_raw
GROUP BY Product_ID
HAVING COUNT(*) > 1;


-- Verificação de campos vazios.

SELECT
    SUM(CASE WHEN TRIM(Product_ID) = '' THEN 1 ELSE 0 END) AS vazios_id,
    SUM(CASE WHEN TRIM(Product_Name) = '' THEN 1 ELSE 0 END) AS vazios_nome,
    SUM(CASE WHEN TRIM(Product_Category) = '' THEN 1 ELSE 0 END) AS vazios_categoria,
    SUM(CASE WHEN TRIM(Product_Cost) = '' THEN 1 ELSE 0 END) AS vazios_custo,
    SUM(CASE WHEN TRIM(Product_Price) = '' THEN 1 ELSE 0 END) AS vazios_preco
FROM produtos_raw;


-- Verificação de custos ou preços inválidos.

SELECT
    SUM(
        CASE WHEN CAST(REPLACE(Product_Cost, '$', '') AS REAL) <= 0
        THEN 1 ELSE 0 END
    ) AS custos_invalidos,
    SUM(
        CASE WHEN CAST(REPLACE(Product_Price, '$', '') AS REAL) <= 0
        THEN 1 ELSE 0 END
    ) AS precos_invalidos
FROM produtos_raw;


-- ============================================================
-- 2. LOJAS

-- Verificação de valores nulos nas principais colunas.

SELECT
    SUM(CASE WHEN Store_ID IS NULL THEN 1 ELSE 0 END) AS nulos_id,
    SUM(CASE WHEN Store_Name IS NULL THEN 1 ELSE 0 END) AS nulos_nome,
    SUM(CASE WHEN Store_City IS NULL THEN 1 ELSE 0 END) AS nulos_cidade,
    SUM(CASE WHEN Store_Location IS NULL THEN 1 ELSE 0 END) AS nulos_localizacao,
    SUM(CASE WHEN Store_Open_Date IS NULL THEN 1 ELSE 0 END) AS nulos_data
FROM lojas_raw;


-- Verificação de IDs duplicados.

SELECT
    Store_ID,
    COUNT(*) AS quantidade
FROM lojas_raw
GROUP BY Store_ID
HAVING COUNT(*) > 1;


-- Verificação de nomes de lojas duplicados.

SELECT
    Store_Name,
    COUNT(*) AS quantidade
FROM lojas_raw
GROUP BY Store_Name
HAVING COUNT(*) > 1;


-- Verificação de campos vazios.

SELECT
    SUM(CASE WHEN TRIM(Store_ID) = '' THEN 1 ELSE 0 END) AS vazios_id,
    SUM(CASE WHEN TRIM(Store_Name) = '' THEN 1 ELSE 0 END) AS vazios_nome,
    SUM(CASE WHEN TRIM(Store_City) = '' THEN 1 ELSE 0 END) AS vazios_cidade,
    SUM(CASE WHEN TRIM(Store_Location) = '' THEN 1 ELSE 0 END) AS vazios_localizacao,
    SUM(CASE WHEN TRIM(Store_Open_Date) = '' THEN 1 ELSE 0 END) AS vazios_data
FROM lojas_raw;


-- Verificação do intervalo das datas de abertura.

SELECT
    MIN(Store_Open_Date) AS primeira_abertura,
    MAX(Store_Open_Date) AS ultima_abertura
FROM lojas_raw;


-- ============================================================
-- 3. INVENTÁRIO

-- Quantidade total de registros de inventário.

SELECT COUNT(*) AS total_registros
FROM inventario_raw;


-- Verificação de valores nulos.

SELECT
    SUM(CASE WHEN Store_ID IS NULL THEN 1 ELSE 0 END) AS nulos_loja,
    SUM(CASE WHEN Product_ID IS NULL THEN 1 ELSE 0 END) AS nulos_produto,
    SUM(CASE WHEN Stock_on_hand IS NULL THEN 1 ELSE 0 END) AS nulos_estoque
FROM inventario_raw;


-- Verificação de campos vazios.

SELECT
    SUM(CASE WHEN TRIM(Store_ID) = '' THEN 1 ELSE 0 END) AS vazios_loja,
    SUM(CASE WHEN TRIM(Product_ID) = '' THEN 1 ELSE 0 END) AS vazios_produto,
    SUM(CASE WHEN TRIM(Stock_on_hand) = '' THEN 1 ELSE 0 END) AS vazios_estoque
FROM inventario_raw;


-- Verificação de valores negativos de estoque.

SELECT
    COUNT(*) AS estoques_negativos
FROM inventario_raw
WHERE Stock_on_hand < 0;


-- Verificação de duplicidade na combinação loja + produto.

SELECT
    Store_ID,
    Product_ID,
    COUNT(*) AS quantidade
FROM inventario_raw
GROUP BY Store_ID, Product_ID
HAVING COUNT(*) > 1;


-- Verificação do intervalo dos níveis de estoque.

SELECT
    MIN(Stock_on_hand) AS estoque_minimo,
    MAX(Stock_on_hand) AS estoque_maximo
FROM inventario_raw;


-- ============================================================
-- 4. VENDAS

-- Quantidade total de registros de vendas.

SELECT COUNT(*) AS total_registros
FROM vendas_raw;


-- Verificação de valores nulos.

SELECT
    SUM(CASE WHEN Sale_ID IS NULL THEN 1 ELSE 0 END) AS nulos_venda,
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS nulos_data,
    SUM(CASE WHEN Store_ID IS NULL THEN 1 ELSE 0 END) AS nulos_loja,
    SUM(CASE WHEN Product_ID IS NULL THEN 1 ELSE 0 END) AS nulos_produto,
    SUM(CASE WHEN Units IS NULL THEN 1 ELSE 0 END) AS nulos_unidades
FROM vendas_raw;


-- Verificação de campos vazios.

SELECT
    SUM(CASE WHEN TRIM(Sale_ID) = '' THEN 1 ELSE 0 END) AS vazios_venda,
    SUM(CASE WHEN TRIM(Date) = '' THEN 1 ELSE 0 END) AS vazios_data,
    SUM(CASE WHEN TRIM(Store_ID) = '' THEN 1 ELSE 0 END) AS vazios_loja,
    SUM(CASE WHEN TRIM(Product_ID) = '' THEN 1 ELSE 0 END) AS vazios_produto,
    SUM(CASE WHEN TRIM(Units) = '' THEN 1 ELSE 0 END) AS vazios_unidades
FROM vendas_raw;


-- Verificação de IDs de venda duplicados.

SELECT
    Sale_ID,
    COUNT(*) AS quantidade
FROM vendas_raw
GROUP BY Sale_ID
HAVING COUNT(*) > 1;


-- Verificação do período coberto pela base de vendas.

SELECT
    MIN(Date) AS primeira_venda,
    MAX(Date) AS ultima_venda
FROM vendas_raw;


-- Verificação dos valores mínimo e máximo de unidades por venda.

SELECT
    MIN(Units) AS unidades_minimas,
    MAX(Units) AS unidades_maximas
FROM vendas_raw;


-- ============================================================
-- 5. CALENDÁRIO

-- Quantidade total de registros.

SELECT COUNT(*) AS total_registros
FROM calendario_raw;


-- Verificação de datas nulas.

SELECT COUNT(*) AS datas_nulas
FROM calendario_raw
WHERE Date IS NULL;


-- Verificação de datas vazias.

SELECT COUNT(*) AS datas_vazias
FROM calendario_raw
WHERE TRIM(Date) = '';


-- Verificação do período coberto pelo calendário.

SELECT
    MIN(Date) AS data_minima,
    MAX(Date) AS data_maxima
FROM calendario_raw;


-- ============================================================
-- 6. INTEGRIDADE ENTRE AS TABELAS

-- Produtos presentes em vendas, mas inexistentes no cadastro de produtos.

SELECT DISTINCT
    v.Product_ID
FROM vendas_raw AS v
LEFT JOIN produtos_raw AS p
    ON v.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;


-- Lojas presentes em vendas, mas inexistentes no cadastro de lojas.

SELECT DISTINCT
    v.Store_ID
FROM vendas_raw AS v
LEFT JOIN lojas_raw AS l
    ON v.Store_ID = l.Store_ID
WHERE l.Store_ID IS NULL;


-- Produtos cadastrados que não possuem correspondência no inventário.

SELECT DISTINCT
    p.Product_ID
FROM produtos_raw AS p
LEFT JOIN inventario_raw AS i
    ON p.Product_ID = i.Product_ID
WHERE i.Product_ID IS NULL;


-- Lojas presentes no inventário, mas inexistentes no cadastro de lojas.

SELECT DISTINCT
    i.Store_ID
FROM inventario_raw AS i
LEFT JOIN lojas_raw AS l
    ON i.Store_ID = l.Store_ID
WHERE l.Store_ID IS NULL;
