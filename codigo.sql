-- Criação da tabela ralacao_de_operadoras_ativas
CREATE TABLE ralacao_de_operadoras_ativas (
    registro_ans int PRIMARY KEY,
    cnpj varchar(14),
    razao_social varchar(255),
    nome_fantasia varchar(255),
    modalidade varchar(255),
    logradouro varchar(255),
    numero varchar(50),
    complemento varchar(255),
    bairro varchar(50),
    cidade varchar(255),
    uf varchar(2),
    cep varchar(8),
    ddd varchar(2),
    telefone varchar(20),
    fax varchar(20),
    endereco_eletronico varchar(100),
    representante varchar(255),
    cargo_representante varchar(100),
    data_registro_ans date
);

-- Criação da tabela demonstracoes_contabeis
CREATE TABLE demonstracoes_contabeis (
    id serial PRIMARY KEY,
    data_data date,
    reg_ans int NOT NULL,
    cd_conta_contabil int,
    descricao varchar(150),
    vl_saldo_final double precision
);

-- Criação da tabela temporária para receber apenas as colunas relevantes
CREATE TEMPORARY TABLE tabela_temporaria (
    data_data date,
    reg_ans int,
    cd_conta_contabil int,
    descricao varchar(150),
    vl_saldo_final varchar(15)
);

-- Criação de uma tabela temporária genérica para lidar com arquivos CSV de formato variável
CREATE TEMPORARY TABLE tabela_temporaria_flexivel (
    col1 text,
    col2 text,
    col3 text,
    col4 text,
    col5 text,
    col6 text,
    col7 text,
    col8 text,
    col9 text,
    col10 text
);

-- Importação dos dados para a tabela ralacao_de_operadoras_ativas a partir de um arquivo CSV
COPY ralacao_de_operadoras_ativas 
FROM 'C:\projeto\postgreSQL_csvs\Relatorio_cadop.csv' 
DELIMITER ';' 
CSV HEADER 
ENCODING 'ISO-8859-1';

-- Importação dos dados para a tabela temporária tabela_temporaria a partir de arquivos CSV separados por trimestre e ano

-- 2023
COPY tabela_temporaria (data_data, reg_ans, cd_conta_contabil, descricao, vl_saldo_final) 
FROM 'C:\projeto\postgreSQL_csvs\tabelas\1T2023.csv' 
DELIMITER ';' 
CSV HEADER 
ENCODING 'ISO-8859-1' 
NULL AS '';

COPY tabela_temporaria (data_data, reg_ans, cd_conta_contabil, descricao, vl_saldo_final) 
FROM 'C:\projeto\postgreSQL_csvs\tabelas\2T2023.csv' 
DELIMITER ';' 
CSV HEADER 
ENCODING 'ISO-8859-1' 
NULL AS '';

COPY tabela_temporaria (data_data, reg_ans, cd_conta_contabil, descricao, vl_saldo_final) 
FROM 'C:\projeto\postgreSQL_csvs\tabelas\3T2023.csv' 
DELIMITER ';' 
CSV HEADER 
ENCODING 'ISO-8859-1' 
NULL AS '';

COPY tabela_temporaria (data_data, reg_ans, cd_conta_contabil, descricao, vl_saldo_final) 
FROM 'C:\projeto\postgreSQL_csvs\tabelas\4T2023.csv' 
DELIMITER ';' 
CSV HEADER 
ENCODING 'ISO-8859-1' 
NULL AS '';

-- 2024
COPY tabela_temporaria (data_data, reg_ans, cd_conta_contabil, descricao, vl_saldo_final) 
FROM 'caminho\1T2024.csv' 
DELIMITER ';' 
CSV HEADER 
ENCODING 'ISO-8859-1' 
NULL AS '';

COPY tabela_temporaria (data_data, reg_ans, cd_conta_contabil, descricao, vl_saldo_final) 
FROM 'caminho\2T2024.csv' 
DELIMITER ';' 
CSV HEADER 
ENCODING 'ISO-8859-1' 
NULL AS '';

COPY tabela_temporaria (data_data, reg_ans, cd_conta_contabil, descricao, vl_saldo_final) 
FROM 'caminho\3T2024.csv' 
DELIMITER ';' 
CSV HEADER 
ENCODING 'ISO-8859-1' 
NULL AS '';

COPY tabela_temporaria (data_data, reg_ans, cd_conta_contabil, descricao, vl_saldo_final) 
FROM 'caminho\4T2024.csv' 
DELIMITER ';' 
CSV HEADER 
ENCODING 'ISO-8859-1' 
NULL AS '';

-- Inserção dos dados da tabela temporária tabela_temporaria na tabela demonstracoes_contabeis, convertendo vl_saldo_final para o tipo double precision.
-- É necessário a conversão pois os valores de vl_saldo_final do csv estão com ',' para representar casas decimais. Logo é lido como string na tabela_temporaria.
INSERT INTO demonstracoes_contabeis (data_data, reg_ans, cd_conta_contabil, descricao, vl_saldo_final)
SELECT data_data, reg_ans, cd_conta_contabil, descricao, REPLACE(vl_saldo_final, ',', '.')::double precision
FROM tabela_temporaria;

-- Remoção da tabela temporária tabela_temporaria
DROP TABLE tabela_temporaria;

-- Consulta para obter as 10 operadoras que mais tiveram despesas com "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR" no último trimestre de 2024.
SELECT r.razao_social, SUM(d.vl_saldo_final)
FROM ralacao_de_operadoras_ativas AS r
JOIN demonstracoes_contabeis AS d ON r.registro_ans = d.reg_ans
WHERE d.descricao = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR'
  AND EXTRACT(YEAR FROM d.data_data) = 2024
  AND EXTRACT(MONTH FROM d.data_data) BETWEEN 10 AND 12
GROUP BY r.razao_social
ORDER BY SUM(d.vl_saldo_final) DESC
LIMIT 10;

-- Consulta para obter as 10 operadoras que mais tiveram despesas com "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR" no ano de 2023.
SELECT r.razao_social, SUM(d.vl_saldo_final)
FROM ralacao_de_operadoras_ativas AS r
JOIN demonstracoes_contabeis AS d ON r.registro_ans = d.reg_ans
WHERE d.descricao = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR'
  AND EXTRACT(YEAR FROM d.data_data) = 2023
GROUP BY r.razao_social
ORDER BY SUM(d.vl_saldo_final) DESC
LIMIT 10;
