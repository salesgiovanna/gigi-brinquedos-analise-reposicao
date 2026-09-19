-- GIGI BRINQUEDOS | PROCESSAMENTO DOS DADOS

/* Este script transforma as tabelas brutas (_raw) nas tabelas
 processadas utilizadas na análise e no dashboard do Power BI.*/


-- 1. PRODUTOS

/* Limpeza de caracteres indesejados na tabela auxiliar
 utilizada para tradução dos produtos e categorias.*/

UPDATE traducao_produtos
SET
    ID_Produto = REPLACE(ID_Produto, '"', ''),
    Categoria_Produto = REPLACE(Categoria_Produto, '"', '');


-- Criação da tabela processada de produtos.
-- Os nomes e categorias são obtidos da tabela de tradução.
-- Custo e preço são convertidos de texto para valores numéricos.

CREATE TABLE produtos_processed AS
SELECT
    p.Product_ID AS ID_Produto,
    t.Nome_Produto,
    t.Categoria_Produto,
    CAST(REPLACE(p.Product_Cost, '$', '') AS REAL) AS Custo_Produto,
    CAST(REPLACE(p.Product_Price, '$', '') AS REAL) AS Preco_Produto
FROM produtos_raw AS p
LEFT JOIN traducao_produtos AS t
    ON p.Product_ID = t.ID_Produto;


-- ============================================================
-- 2. LOJAS

-- Criação da tabela processada de lojas.
/* A tabela auxiliar de tradução adapta as lojas originais
 para o contexto fictício brasileiro da Gigi Brinquedos.*/

CREATE TABLE lojas_processed AS
SELECT
    l.Store_ID AS ID_Loja,
    t.Nome_Loja,
    t.Cidade_Loja,
    t.Estado_Loja,
    t.Data_Abertura_Loja
FROM lojas_raw AS l
LEFT JOIN traducao_lojas AS t
    ON l.Store_ID = t.ID_Loja;


-- Padronização da data de abertura para o formato YYYY-MM-DD.

UPDATE lojas_processed
SET Data_Abertura_Loja =
    SUBSTR(Data_Abertura_Loja, 7, 4)
    || '-' ||
    SUBSTR(Data_Abertura_Loja, 4, 2)
    || '-' ||
    SUBSTR(Data_Abertura_Loja, 1, 2);


-- ============================================================
-- 3. INVENTÁRIO

-- Criação da tabela processada de inventário.
/* Os identificadores e a quantidade em estoque são convertidos
 para valores inteiros.*/

CREATE TABLE inventario_processed AS
SELECT
    CAST(Store_ID AS INTEGER) AS ID_Loja,
    CAST(Product_ID AS INTEGER) AS ID_Produto,
    CAST(Stock_on_hand AS INTEGER) AS Estoque_Atual
FROM inventario_raw;


-- ============================================================
-- 4. VENDAS

-- Criação da tabela processada de vendas.
/* Os identificadores e a quantidade vendida são convertidos
 para valores inteiros.*/

CREATE TABLE vendas_processed AS
SELECT
    CAST(Sale_ID AS INTEGER) AS ID_Venda,
    Date AS Data_Venda,
    CAST(Store_ID AS INTEGER) AS ID_Loja,
    CAST(Product_ID AS INTEGER) AS ID_Produto,
    CAST(Units AS INTEGER) AS Quantidade
FROM vendas_raw;


-- ============================================================
-- 5. CALENDÁRIO

-- Criação da tabela processada de calendário.
-- A data original é convertida para o formato YYYY-MM-DD.

CREATE TABLE calendario_processed AS
SELECT
    SUBSTR(Date, -4)
    || '-' ||
    printf(
        '%02d',
        CAST(SUBSTR(Date, 1, INSTR(Date, '/') - 1) AS INTEGER)
    )
    || '-' ||
    printf(
        '%02d',
        CAST(
            SUBSTR(
                SUBSTR(Date, INSTR(Date, '/') + 1),
                1,
                INSTR(SUBSTR(Date, INSTR(Date, '/') + 1), '/') - 1
            ) AS INTEGER
        )
    ) AS Data
FROM calendario_raw;
