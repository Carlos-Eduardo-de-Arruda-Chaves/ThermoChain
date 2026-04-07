-- Cria o banco de dados chamado TermoChain
CREATE DATABASE termochain;

-- Seleciona o banco para uso
USE termochain;
 
-- TABELA EMPRESA
CREATE TABLE empresa (
    
    -- Identificador único da empresa (auto incremento)
    id_empresa BIGINT AUTO_INCREMENT PRIMARY KEY,
    
    -- Nome jurídico da empresa (obrigatório)
    razao_social VARCHAR(150) NOT NULL,
    
    -- Nome fantasia (opcional)
    nome_fantasia VARCHAR(150),
    
    -- CNPJ da empresa (apenas números, único)
    cnpj CHAR(14) NOT NULL UNIQUE,
    
    -- Telefone da empresa
    telefone VARCHAR(20),
    
    -- Email único da empresa
    email VARCHAR(150) UNIQUE,
    
    -- Endereço detalhado
    logradouro VARCHAR(150) NOT NULL, -- Rua/Avenida
    numero VARCHAR(10),               -- Número
    complemento VARCHAR(100),         -- Complemento (apto, sala, etc)
    bairro VARCHAR(100),              -- Bairro
    cidade VARCHAR(100) NOT NULL,     -- Cidade obrigatória
    estado CHAR(2) NOT NULL,          -- UF (ex: SP)
    cep CHAR(8) NOT NULL,             -- CEP sem máscara
    
    -- Segmento da empresa (ex: saúde, logística)
    segmento VARCHAR(60) NOT NULL,
    
    -- Status da empresa (ativo/inativo)
    status_empresa ENUM('Ativo', 'Inativo') DEFAULT 'Ativo',
    
    -- Data de cadastro automática
    dt_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- TABELA USUARIO
CREATE TABLE usuario (
    
    -- ID único do usuário
    id_usuario BIGINT AUTO_INCREMENT PRIMARY KEY,
    
    -- Nome completo
    nome VARCHAR(120) NOT NULL,
    
    -- Email único para login
    email VARCHAR(150) NOT NULL UNIQUE,
    
    -- Senha (armazenar hash futuramente)
    senha VARCHAR(255) NOT NULL,
    
    -- CPF único (somente números)
    cpf CHAR(11) NOT NULL UNIQUE,
    
    -- Status do usuário
    status_usuario ENUM('Ativo', 'Inativo') DEFAULT 'Ativo',
    
    -- Data de registro automática
    dt_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Chave estrangeira para empresa
    fk_empresa BIGINT NOT NULL,
    
    -- Relacionamento com empresa
    CONSTRAINT fk_usuario_empresa
        FOREIGN KEY (fk_empresa) 
        REFERENCES empresa(id_empresa)
);

-- TABELA VACINA
CREATE TABLE tipo_vacina (
    
    -- ID da vacina
    id_vacina INT AUTO_INCREMENT PRIMARY KEY,
    
    -- Nome da vacina
    nome VARCHAR(120) NOT NULL,
    
    -- Fabricante
    fabricante VARCHAR(120) NOT NULL,
    
    -- Temperatura mínima permitida
    temperatura_min DECIMAL(5,2) NOT NULL,
    
    -- Temperatura máxima permitida
    temperatura_max DECIMAL(5,2) NOT NULL,
    
    -- Data de cadastro
    dt_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Empresa responsável
    fk_empresa BIGINT NOT NULL,
    
    -- Garante que min < max
    CONSTRAINT chk_temperatura
        CHECK (temperatura_min < temperatura_max),
    
    -- Relacionamento com empresa
    CONSTRAINT fk_vacina_empresa
        FOREIGN KEY (fk_empresa)
        REFERENCES empresa(id_empresa)
);

-- TABELA LOTE DE VACINA
CREATE TABLE lote_vacina (
    
    -- ID do lote
    id_lote BIGINT AUTO_INCREMENT PRIMARY KEY,
    
    -- Código único do lote
    codigo VARCHAR(60) NOT NULL UNIQUE,
    
    -- Data de fabricação
    data_fabricacao DATE,
    
    -- Data de validade
    data_validade DATE NOT NULL,
    
    -- Peso do lote
    peso DECIMAL(10,2),
    
    -- Volume do lote
    volume DECIMAL(10,2),
    
    -- Quantidade de doses
    quantidade INT NOT NULL,
    
    -- Status do lote
    status_lote ENUM('Ativo', 'Vencido', 'Descartado') DEFAULT 'Ativo',
    
    -- Data de cadastro
    dt_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Vacina relacionada
    fk_vacina INT NOT NULL,
    
    -- Validação de datas
    CONSTRAINT chk_validade
        CHECK (data_validade > data_fabricacao),
    
    -- Relacionamento com vacina
    CONSTRAINT fk_lote_vacina
        FOREIGN KEY (fk_vacina)
        REFERENCES tipo_vacina(id_vacina)
);

-- TABELA ALOCAÇÃO DE LOTE
CREATE TABLE alocacao_lote(
    
    -- ID da alocação
	id_alocacao BIGINT PRIMARY KEY AUTO_INCREMENT,
    
    -- Lote monitorado
    fk_lote  BIGINT,
    
    -- Sensor utilizado
	fk_sensor BIGINT,
    
    -- Início do monitoramento
	inicio_monitoramento DATETIME NOT NULL,
    
    -- Fim do monitoramento (pode ser nulo)
    fim_monitoramento DATETIME DEFAULT NULL
);

-- TABELA MICROCONTROLADOR
CREATE TABLE microcontrolador (
    
    -- ID do dispositivo
    id_micro BIGINT AUTO_INCREMENT PRIMARY KEY,
    
    -- Modelo do microcontrolador
    modelo VARCHAR(100) NOT NULL,
    
    -- Fabricante
    fabricante VARCHAR(100),
    
    -- Tipo do dispositivo
    tipo ENUM('ESP32', 'Arduino', 'Raspberry', 'Outro') NOT NULL,
    
    -- Número de série único
    numero_serie VARCHAR(100) UNIQUE,
    
    -- Local onde está instalado
    local_instalacao VARCHAR(150),
    
    -- Status do dispositivo
    status_micro ENUM('Ativo', 'Inativo', 'Manutencao') DEFAULT 'Ativo',
    
    -- Data de instalação
    dt_instalacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Última manutenção
    dt_ultima_manutencao DATETIME,
    
    -- Observações gerais
    observacao VARCHAR(255)
);

-- TABELA SENSOR
CREATE TABLE sensor (
    
    -- ID do sensor
    id_sensor BIGINT AUTO_INCREMENT PRIMARY KEY,
    
    -- Modelo do sensor
    modelo VARCHAR(100) NOT NULL,
    
    -- Fabricante
    fabricante VARCHAR(100),
    
    -- Tipo do sensor
    tipo VARCHAR(40) NOT NULL,
    
    -- Local de instalação
    local_instalacao VARCHAR(150),
    
    -- Status do sensor
    status_sensor ENUM('Ativo', 'Inativo', 'Manutencao') DEFAULT 'Ativo',
    
    -- Data de instalação
    dt_instalacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Faixa mínima de operação
    faixa_min DECIMAL(5,2),
    
    -- Faixa máxima de operação
    faixa_max DECIMAL(5,2),
    
    -- Observações
    observacao VARCHAR(255),
    
    -- Validação da faixa
    CONSTRAINT chk_faixa_sensor
        CHECK (faixa_min IS NULL OR faixa_max IS NULL OR faixa_min < faixa_max)
);

-- TABELA LEITURA DE TEMPERATURA
CREATE TABLE leitura_temperatura (
    
    -- ID da leitura
    id_leitura BIGINT AUTO_INCREMENT PRIMARY KEY,
    
    -- Valor da temperatura
    temperatura DECIMAL(5,2) NOT NULL,
    
    -- Data e hora da leitura
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Status da temperatura (normal, alerta, crítico)
    status_temperatura ENUM('Normal', 'Alerta', 'Critico') NOT NULL DEFAULT 'Normal',
    
    -- Indica se houve alerta
    alerta BOOLEAN DEFAULT FALSE,
		
    -- Tempo acumulado em alerta (segundos)
    tempo_alerta_segundos INT DEFAULT 0,
    
    -- Sensor responsável pela leitura
    fk_sensor BIGINT NOT NULL,
    
    -- Lote monitorado
    fk_lote BIGINT NOT NULL,
    
    -- Relacionamento com sensor
    CONSTRAINT fk_leitura_sensor
        FOREIGN KEY (fk_sensor)
        REFERENCES sensor(id_sensor),

    -- Relacionamento com lote
    CONSTRAINT fk_leitura_lote
        FOREIGN KEY (fk_lote)
        REFERENCES lote_vacina(id_lote)
);

-- ============================================================
--  TermoChain – INSERTs e SELECTs de exemplo
--  Observação: o script de criação foi ajustado (bug da FK
--  vacina → tipo_vacina e FKs de alocacao_lote adicionadas).
-- ============================================================

USE TermoChain;

-- ============================================================
-- 1. EMPRESA
-- ============================================================
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


-- ============================================================
-- 2. USUARIO
-- ============================================================
INSERT INTO usuario
    (nome, email, senha, cpf, fk_empresa)
VALUES
    ('Guilherme Barbosa De Albuquerque',  'guilherme.albuquerque@butanta.com.br',  'lujUpn7&230', '12345678901', 1),
    ('Carlos Eduardo', 'carlos.eduardo@vaccinacold.com.br',   'siMgvw@@75', '23456789012', 1),
    ('Matheus Jacob',       'matheus.jacob@frigocargo.com.br',  'Amom3uempr3g0?', '34567890123', 2),
    ('Leonardo Werner',       'leonardo.Werner@frigocargo.com.br',  'Leozica#333', '44567890123', 2),
    ('Thiago Emidio',       'mariana.souza@immunocenter.com.br',  'psia893((', '54567890123', 3),
    ('Enzo Quinalha',       'roberto.alves@immunocenter.com.br','cialounge(@8794', '65678901234', 3);


-- ============================================================
-- 3. TIPO_VACINA
-- ============================================================
INSERT INTO tipo_vacina
    (nome, fabricante, temperatura_min, temperatura_max, fk_empresa)
VALUES
    ('Febre Amarela',           'Sinovac/Butantan',  2.00,  8.00, 1),
    ('Covid-19',	'Pfizer',           -10.00,	0.00, 1),
    ('Febre Amarela',         'AstraZeneca/Fiocruz', 2.00, 8.00, 2),
    ('Sarampo',             'Johnson & Johnson',   2.00, 8.00, 3),
    ('Influenza Trivalente',	'Sanofi Pasteur',       2.00, 8.00, 3);


-- ============================================================
-- 4. LOTE_VACINA
-- ============================================================
INSERT INTO lote_vacina
    (codigo, data_fabricacao, data_validade, peso, volume, quantidade, fk_vacina)
VALUES
    ('LOTE-CV-2025-001', '2025-01-10', '2026-01-10', 5.20, 2.50, 1000, 1),
    ('LOTE-CV-2025-002', '2025-02-15', '2026-02-15', 4.80, 2.30,  800, 1),
    ('LOTE-PF-2025-001', '2025-01-20', '2025-07-20', 3.10, 1.20,  500, 2),
    ('LOTE-AZ-2025-001', '2025-03-05', '2026-03-05', 6.00, 3.00, 1200, 3),
    ('LOTE-JJ-2025-001', '2025-04-01', '2026-04-01', 4.50, 2.10,  600, 4),
    ('LOTE-FLU-2025-001','2025-05-01', '2025-11-01', 3.80, 1.80,  900, 5);


-- ============================================================
-- 5. MICROCONTROLADOR
-- ============================================================
INSERT INTO microcontrolador
    (modelo, fabricante, tipo, numero_serie, local_instalacao, observacao)
VALUES
    ('Arduino Uno R3', 'Arduino', 'Arduino', 'SN-ESP32-001', 'Câmara fria A – VaccinaCold', 'Principal'),
    ('Arduino Uno R3', 'Arduino', 'Arduino', 'SN-ESP32-002', 'Câmara fria B – VaccinaCold', NULL),
    ('Arduino Uno R3',	'Arduino',  'Arduino','SN-ARD-001',  'Veículo refrigerado 01 – FrigoCargo', NULL),
    ('ESP32-S3',        'Espressif', 'ESP32', 'SN-ESP32-003', 'Depósito central – ImunoCenter', 'Backup ativo');


-- ============================================================
-- 6. SENSOR
-- ============================================================
INSERT INTO sensor
    (modelo, fabricante, tipo, local_instalacao, faixa_min, faixa_max, observacao)
VALUES
    ('LM35', 'Bosch', 'Temperatura LM35', 'Câmara fria A – Rack 1', -55.00, 150.00, 'Calibrado em 01/2025'),
    ('LM35', 'Siemens', 'Temperatura LM35', 'Câmara fria A – Rack 2', -55.00, 150.00, NULL),
    ('LM35', 'NXP', 'Temperatura LM35', 'Câmara fria B – Rack 1', -55.00, 150.00, NULL),
    ('LM35', 'Denso', 'Temperatura LM35', 'Veículo 01 – FrigoCargo',  -40.00, 110.00, 'Sensor veicular'),
    ('LM35', 'Texas Instruments', 'Temperatura LM35', 'Depósito ImunoCenter',     -55.00, 150.00, NULL);


-- ============================================================
-- 7. ALOCACAO_LOTE
--    (FKs fk_lote → lote_vacina e fk_sensor → sensor)
-- ============================================================
INSERT INTO alocacao_lote
    (fk_lote, fk_sensor, inicio_monitoramento, fim_monitoramento)
VALUES
    (1, 1, '2025-01-10 08:00:00', NULL),           -- Lote CoronaVac 001 no sensor 1 (em andamento)
    (2, 2, '2025-02-15 08:00:00', '2025-06-01 18:00:00'), -- Lote CoronaVac 002 no sensor 2 (encerrado)
    (3, 3, '2025-01-20 07:00:00', NULL),           -- Lote Pfizer no sensor 3
    (4, 4, '2025-03-05 09:00:00', NULL),           -- Lote AZ no sensor 4 (veículo)
    (5, 5, '2025-04-01 08:00:00', NULL),           -- Lote Janssen no sensor 5
    (6, 1, '2025-05-01 08:00:00', NULL);           -- Lote Influenza também no sensor 1


-- ============================================================
-- 8. LEITURA_TEMPERATURA
-- ============================================================
INSERT INTO leitura_temperatura
    (temperatura, data_hora, status_temperatura, alerta, tempo_alerta_segundos, fk_sensor, fk_lote)
VALUES
    -- Leituras normais – CoronaVac (faixa 2 a 8 °C)
    ( 5.10, '2025-06-01 08:00:00', 'Normal',  FALSE,   0, 1, 1),
    ( 5.50, '2025-06-01 08:30:00', 'Normal',  FALSE,   0, 1, 1),
    ( 7.20, '2025-06-01 09:00:00', 'Normal',  FALSE,   0, 1, 1),

    -- Alerta – temperatura subindo
    ( 8.80, '2025-06-01 09:30:00', 'Alerta',  TRUE,  120, 1, 1),
    (10.50, '2025-06-01 10:00:00', 'Critico', TRUE,  600, 1, 1),

    -- Volta ao normal
    ( 6.00, '2025-06-01 10:30:00', 'Normal',  FALSE,   0, 1, 1),

    -- Leituras – Pfizer (faixa -90 a -60 °C)
    (-75.00,'2025-06-01 08:00:00', 'Normal',  FALSE,   0, 3, 3),
    (-72.30,'2025-06-01 08:30:00', 'Normal',  FALSE,   0, 3, 3),
    (-58.00,'2025-06-01 09:00:00', 'Alerta',  TRUE,  300, 3, 3),

    -- Leituras – AstraZeneca (veículo)
    ( 4.50, '2025-06-01 10:00:00', 'Normal',  FALSE,   0, 4, 4),
    ( 5.00, '2025-06-01 10:30:00', 'Normal',  FALSE,   0, 4, 4),

    -- Leituras – Janssen
    ( 3.80, '2025-06-01 11:00:00', 'Normal',  FALSE,   0, 5, 5),
    ( 9.10, '2025-06-01 11:30:00', 'Alerta',  TRUE,   90, 5, 5);


-- ============================================================
-- SELECTs
-- ============================================================

-- ① Todos os lotes com o nome da vacina e status
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


-- ② Leituras com alerta ou crítico, mostrando vacina e sensor
SELECT
    lt.data_hora,
    lt.temperatura,
    lt.status_temperatura,
    lt.tempo_alerta_segundos AS seg_alerta,
    tv.nome AS vacina,
    lv.codigo AS lote,
    s.modelo AS sensor,
    s.local_instalacao
FROM leitura_temperatura lt
JOIN sensor s       USING (id_sensor)
JOIN lote_vacina lv USING (id_lote)
JOIN tipo_vacina tv USING (id_vacina)
WHERE lt.alerta
ORDER BY lt.data_hora DESC;


-- ③ Resumo de leituras por lote (min, max, média e total de alertas)
SELECT
    lt.data_hora,
    lt.temperatura,
    lt.status_temperatura,
    lt.tempo_alerta_segundos AS seg_alerta,
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
WHERE lt.alerta
ORDER BY lt.data_hora DESC;


-- ④ Lotes atualmente monitorados (alocações sem fim)
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

-- ⑤ Usuários por empresa com total de usuários
SELECT
    e.razao_social AS empresa,
    e.segmento,
    COUNT(u.id_usuario) AS total_usuarios
FROM empresa e
LEFT JOIN usuario u 
    ON u.fk_empresa = e.id_empresa
GROUP BY e.id_empresa
ORDER BY total_usuarios DESC;


-- ⑥ Lotes vencidos ou próximos do vencimento (próximos 60 dias)
SELECT
    lv.codigo,
    tv.nome AS vacina,
    lv.data_validade,
    DATEDIFF(lv.data_validade, CURDATE()) AS dias_restantes,
    lv.status_lote
FROM lote_vacina lv
JOIN tipo_vacina tv 
    ON tv.id_vacina = lv.fk_vacina
WHERE DATEDIFF(lv.data_validade, CURDATE()) <= 60
ORDER BY lv.data_validade;