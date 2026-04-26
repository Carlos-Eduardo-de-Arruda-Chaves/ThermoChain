--  TERMOCHAIN — Script de Criação do Banco de Dados

CREATE DATABASE thermochain;

USE thermochain;

-- TABELA: empresa
CREATE TABLE empresa (
    id_empresa BIGINT AUTO_INCREMENT PRIMARY KEY,
    razao_social VARCHAR(150) NOT NULL,
    nome_fantasia VARCHAR(150),
    -- CNPJ armazenado apenas com dígitos numéricos
    cnpj CHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(150) UNIQUE,
    -- Endereço completo
    logradouro VARCHAR(150) NOT NULL,
    numero VARCHAR(10),
    complemento VARCHAR(100),
    bairro VARCHAR(100),
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    -- CEP armazenado apenas com dígitos numéricos 
    cep CHAR(8) NOT NULL,
    segmento VARCHAR(60) NOT NULL,
    status_empresa  ENUM('Ativo', 'Inativo') DEFAULT 'Ativo',
    dt_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- TABELA: usuario
-- Usuários vinculados a uma empresa
CREATE TABLE usuario (
    id_usuario BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    -- Armazenar sempre como hash (bcrypt)
    senha VARCHAR(255) NOT NULL,
    -- CPF armazenado apenas com dígitos numéricos (sem máscara)
    cpf CHAR(11) NOT NULL UNIQUE,
    status_usuario  ENUM('Ativo', 'Inativo') DEFAULT 'Ativo',
    dt_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fk_empresa BIGINT NOT NULL,
    CONSTRAINT fk_usuario_empresa
        FOREIGN KEY (fk_empresa)
        REFERENCES empresa(id_empresa)
);

-- TABELA: tipo_vacina
-- Catálogo de tipos de vacinas com faixas de temperatura segura
CREATE TABLE tipo_vacina (
    id_vacina INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    fabricante VARCHAR(120) NOT NULL,
    temperatura_min DECIMAL(5,2) NOT NULL,
    temperatura_max DECIMAL(5,2) NOT NULL,
    dt_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fk_empresa BIGINT NOT NULL,
    -- Garante que temperatura mínima é menor que a máxima
    CONSTRAINT chk_temperatura
        CHECK (temperatura_min < temperatura_max),

    CONSTRAINT fk_vacina_empresa
        FOREIGN KEY (fk_empresa)
        REFERENCES empresa(id_empresa)
);


-- TABELA: lote_vacina
-- Lotes físicos de vacinas com rastreio completo
CREATE TABLE lote_vacina (
    id_lote BIGINT AUTO_INCREMENT PRIMARY KEY,
    -- Código único do fabricante
    codigo VARCHAR(60) NOT NULL UNIQUE,
    data_fabricacao DATE,
    data_validade DATE NOT NULL,
    peso DECIMAL(10,2),
    volume DECIMAL(10,2),
    quantidade INT NOT NULL,
    status_lote ENUM('Ativo', 'Vencido', 'Descartado') DEFAULT 'Ativo',
    dt_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fk_vacina INT NOT NULL,
    -- Garante que a validade é posterior à fabricação
    CONSTRAINT chk_validade
        CHECK (data_fabricacao IS NULL OR data_validade > data_fabricacao),

    CONSTRAINT fk_lote_vacina
        FOREIGN KEY (fk_vacina)
        REFERENCES tipo_vacina(id_vacina)
);

-- TABELA: sensor
CREATE TABLE sensor (
    id_sensor BIGINT AUTO_INCREMENT PRIMARY KEY,
    modelo VARCHAR(100) NOT NULL,
    modelo_micro VARCHAR(100),
    fabricante VARCHAR(100),
    -- Tipo do sensor (ex: LM35, DHT22)
    tipo VARCHAR(40) NOT NULL,
    local_instalacao VARCHAR(150),
    status_sensor ENUM('Ativo', 'Inativo', 'Manutencao') DEFAULT 'Ativo',
    dt_instalacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- Faixa operacional do sensor
    faixa_min DECIMAL(5,2),
    faixa_max DECIMAL(5,2),
    observacao VARCHAR(255),

    -- Garante que faixa mínima é menor que a máxima quando ambas informadas
    CONSTRAINT chk_faixa_sensor
        CHECK (faixa_min IS NULL OR faixa_max IS NULL OR faixa_min < faixa_max)
);

-- TABELA: alocacao_lote
CREATE TABLE alocacao_lote (
    id_alocacao BIGINT AUTO_INCREMENT PRIMARY KEY,
    
    inicio_monitoramento DATETIME NOT NULL,
    fim_monitoramento DATETIME DEFAULT NULL,

    fk_sensor BIGINT NOT NULL,
    fk_lote BIGINT NOT NULL,

    CONSTRAINT fk_alocacao_sensor
        FOREIGN KEY (fk_sensor)
        REFERENCES sensor(id_sensor),

    CONSTRAINT fk_alocacao_lote
        FOREIGN KEY (fk_lote)
        REFERENCES lote_vacina(id_lote)
);


-- TABELA: leitura_temperatura
CREATE TABLE leitura_temperatura (

    id_leitura BIGINT AUTO_INCREMENT PRIMARY KEY,

    temperatura DECIMAL(5,2) NOT NULL,
    
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    fk_sensor BIGINT NOT NULL,
    fk_lote BIGINT NOT NULL,

    CONSTRAINT fk_leitura_sensor
        FOREIGN KEY (fk_sensor)
        REFERENCES sensor(id_sensor),

    CONSTRAINT fk_leitura_lote
        FOREIGN KEY (fk_lote)
        REFERENCES lote_vacina(id_lote)
);


-- ----> inserts

-- 1 EMPRESA
INSERT INTO empresa
    (razao_social, nome_fantasia, cnpj, telefone, email,
     logradouro, numero, complemento, bairro, cidade, estado, cep, segmento)
VALUES
    ('Butantã Distribuidora Ltda', 'VaccinaCold',
     '12345678000191', '(11) 91234-5678', 'contato@butanta.com.br',
     'Av. Paulista', '1000', NULL, 'Bela Vista', 'São Paulo', 'SP', '01310100',
     'Saúde'),

    ('FrigoCargo Transportes S.A.', 'FrigoCargo',
     '98765432000155', '(21) 93456-7890', 'ops@frigocargo.com.br',
     'Rua da Assembleia', '500', NULL, 'Centro', 'Rio de Janeiro', 'RJ', '20011001',
     'Logística'),

    ('ImunoCenter Farmacêutica Ltda', 'ImunoCenter',
     '11223344000177', '(31) 92345-6789', 'farma@immunocenter.com.br',
     'Av. Afonso Pena', '2500', 'Bloco 23', 'Funcionários', 'Belo Horizonte', 'MG', '30130005',
     'Farmacêutico');


-- 2 USUARIO
INSERT INTO usuario
    (nome, email, senha, cpf, fk_empresa)
VALUES
    ('Guilherme Barbosa De Albuquerque',  'guilherme.albuquerque@butanta.com.br',  'lujUpn7&230', '12345678901', 1),
    ('Carlos Eduardo', 'carlos.eduardo@vaccinacold.com.br',   'siMgvw@@75', '23456789012', 1),
    ('Matheus Jacob',       'matheus.jacob@frigocargo.com.br',  'Amom3uempr3g0?', '34567890123', 2),
    ('Leonardo Werner',       'leonardo.Werner@frigocargo.com.br',  'Leozica#333', '44567890123', 2),
    ('Thiago Emidio',       'mariana.souza@immunocenter.com.br',  'psia893((', '54567890123', 3),
    ('Enzo Quinalha',       'roberto.alves@immunocenter.com.br','cialounge(@8794', '65678901234', 3);


-- 3 TIPO_VACINA
INSERT INTO tipo_vacina
    (nome, fabricante, temperatura_min, temperatura_max, fk_empresa)
VALUES
    ('Febre Amarela','Sinovac/Butantan',  2.00,  8.00, 1),
    ('Covid-19', 'Pfizer', -10.00,	0.00, 1),
    ('Febre Amarela', 'AstraZeneca/Fiocruz', 2.00, 8.00, 2),
    ('Sarampo', 'Johnson & Johnson',   2.00, 8.00, 3),
    ('Influenza Trivalente', 'Sanofi Pasteur',2.00, 8.00, 3);


-- 4 LOTE_VACINA
INSERT INTO lote_vacina
    (codigo, data_fabricacao, data_validade, peso, volume, quantidade, fk_vacina)
VALUES
    ('LOTE-CV-2025-001', '2025-01-10', '2026-01-10', 5.20, 2.50, 1000, 1),
    ('LOTE-CV-2025-002', '2025-02-15', '2026-02-15', 4.80, 2.30,  800, 1),
    ('LOTE-PF-2025-001', '2025-01-20', '2025-07-20', 3.10, 1.20,  500, 2),
    ('LOTE-AZ-2025-001', '2025-03-05', '2026-03-05', 6.00, 3.00, 1200, 3),
    ('LOTE-JJ-2025-001', '2025-04-01', '2026-04-01', 4.50, 2.10,  600, 4),
    ('LOTE-FLU-2025-001','2025-05-01', '2025-11-01', 3.80, 1.80,  900, 5);



-- 5 SENSOR
INSERT INTO sensor
    (modelo, fabricante, tipo, local_instalacao, faixa_min, faixa_max, observacao)
VALUES
    ('LM35', 'Bosch', 'Temperatura LM35', 'Câmara fria A – Rack 1', -55.00, 150.00, 'Calibrado em 01/2025'),
    ('LM35', 'Siemens', 'Temperatura LM35', 'Câmara fria A – Rack 2', -55.00, 150.00, NULL),
    ('LM35', 'NXP', 'Temperatura LM35', 'Câmara fria B – Rack 1', -55.00, 150.00, NULL),
    ('LM35', 'Denso', 'Temperatura LM35', 'Veículo 01 – FrigoCargo',  -40.00, 110.00, 'Sensor veicular'),
    ('LM35', 'Texas Instruments', 'Temperatura LM35', 'Depósito ImunoCenter',     -55.00, 150.00, NULL);


-- 6. ALOCACAO_LOTE
INSERT INTO alocacao_lote
    (fk_lote, fk_sensor, inicio_monitoramento, fim_monitoramento)
VALUES
    (1, 1, '2025-01-10 08:00:00', NULL),           -- Lote CoronaVac 001 no sensor 1 (em andamento)
    (2, 2, '2025-02-15 08:00:00', '2025-06-01 18:00:00'), -- Lote CoronaVac 002 no sensor 2 (encerrado)
    (3, 3, '2025-01-20 07:00:00', NULL),           -- Lote Pfizer no sensor 3
    (4, 4, '2025-03-05 09:00:00', NULL),           -- Lote AZ no sensor 4 (veículo)
    (5, 5, '2025-04-01 08:00:00', NULL),           -- Lote Janssen no sensor 5
    (6, 1, '2025-05-01 08:00:00', NULL);           -- Lote Influenza também no sensor 1


-- 8. Exemplo de LEITURA_TEMPERATURA
INSERT INTO leitura_temperatura
    (temperatura, data_hora, fk_sensor, fk_lote)
VALUES
   
    ( 5.10, '2025-06-01 08:00:00', 0, 1, 1),
    ( 5.50, '2025-06-01 08:30:00', 0, 1, 1),
    ( 7.20, '2025-06-01 09:00:00', 0, 1, 1);


-- SELECTs

-- 1 Todos os lotes com o nome da vacina e status
SELECT
    lv.codigo AS lote,
    tv.nome AS vacina,
    tv.fabricante,
    lv.quantidade AS doses,
    lv.data_validade,
    lv.status_lote
FROM lote_vacina lv
JOIN tipo_vacina tv 
    ON tv.id_vacina = lv.fk_vacina
ORDER BY lv.data_validade;


-- 2 Leituras com alerta ou crítico, mostrando vacina e sensor
SELECT
    lt.data_hora,
    lt.temperatura,
    tv.nome AS vacina,
    lv.codigo AS lote,
    s.modelo AS sensor,
    s.local_instalacao
FROM leitura_temperatura lt
JOIN sensor s 
    ON lt.fk_sensor = s.id_sensor
JOIN lote_vacina lv 
    ON lt.fk_lote = lv.id_lote
JOIN tipo_vacina tv 
    ON lv.fk_vacina = tv.id_vacina
ORDER BY lt.data_hora DESC;


-- 3 Resumo de leituras por lote (min, max, média e total de alertas)
SELECT
    lt.data_hora,
    lt.temperatura,
    tv.nome AS vacina,
    lv.codigo AS lote,
    s.modelo AS sensor,
    s.local_instalacao
FROM leitura_temperatura lt
JOIN sensor s 
    ON s.id_sensor = lt.fk_sensor
JOIN lote_vacina lv 
    ON lv.id_lote = lt.fk_lote
JOIN tipo_vacina tv 
    ON tv.id_vacina = lv.fk_vacina
ORDER BY lt.data_hora DESC;


-- 4 Lotes atualmente monitorados (alocações sem fim)
SELECT
    al.id_alocacao,
    lv.codigo AS lote,
    tv.nome AS vacina,
    s.modelo AS sensor,
    s.local_instalacao,
    al.inicio_monitoramento
FROM alocacao_lote al
JOIN lote_vacina lv 
    ON lv.id_lote = al.fk_lote
JOIN tipo_vacina tv 
    ON tv.id_vacina = lv.fk_vacina
JOIN sensor s 
    ON s.id_sensor = al.fk_sensor
WHERE al.fim_monitoramento IS NULL
ORDER BY al.inicio_monitoramento;


-- 5 Usuários por empresa com total de usuários
SELECT
    e.razao_social AS empresa,
    e.segmento,
    COUNT(u.id_usuario) AS total_usuarios
FROM empresa e
LEFT JOIN usuario u 
    ON u.fk_empresa = e.id_empresa
GROUP BY e.id_empresa
ORDER BY total_usuarios DESC;
