USE TermoChain;

-- 1. EMPRESA
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


-- 2. USUARIO
INSERT INTO usuario
    (nome, email, senha, cpf, fk_empresa)
VALUES
    ('Guilherme Barbosa De Albuquerque',  'guilherme.albuquerque@butanta.com.br',  'lujUpn7&230', '12345678901', 1),
    ('Carlos Eduardo', 'carlos.eduardo@vaccinacold.com.br',   'siMgvw@@75', '23456789012', 1),
    ('Matheus Jacob',       'matheus.jacob@frigocargo.com.br',  'Amom3uempr3g0?', '34567890123', 2),
    ('Leonardo Werner',       'leonardo.Werner@frigocargo.com.br',  'Leozica#333', '44567890123', 2),
    ('Thiago Emidio',       'mariana.souza@immunocenter.com.br',  'psia893((', '54567890123', 3),
    ('Enzo Quinalha',       'roberto.alves@immunocenter.com.br','cialounge(@8794', '65678901234', 3);



-- 3. TIPO_VACINA
INSERT INTO tipo_vacina
    (nome, fabricante, temperatura_min, temperatura_max, fk_empresa)
VALUES
    ('Febre Amarela',           'Sinovac/Butantan',  2.00,  8.00, 1),
    ('Covid-19',	'Pfizer',           -10.00,	0.00, 1),
    ('Febre Amarela',         'AstraZeneca/Fiocruz', 2.00, 8.00, 2),
    ('Sarampo',             'Johnson & Johnson',   2.00, 8.00, 3),
    ('Influenza Trivalente',	'Sanofi Pasteur',       2.00, 8.00, 3);


-- 4. LOTE_VACINA
INSERT INTO lote_vacina
    (codigo, data_fabricacao, data_validade, peso, volume, quantidade, fk_vacina)
VALUES
    ('LOTE-CV-2025-001', '2025-01-10', '2026-01-10', 5.20, 2.50, 1000, 1),
    ('LOTE-CV-2025-002', '2025-02-15', '2026-02-15', 4.80, 2.30,  800, 1),
    ('LOTE-PF-2025-001', '2025-01-20', '2025-07-20', 3.10, 1.20,  500, 2),
    ('LOTE-AZ-2025-001', '2025-03-05', '2026-03-05', 6.00, 3.00, 1200, 3),
    ('LOTE-JJ-2025-001', '2025-04-01', '2026-04-01', 4.50, 2.10,  600, 4),
    ('LOTE-FLU-2025-001','2025-05-01', '2025-11-01', 3.80, 1.80,  900, 5);


-- 5. MICROCONTROLADOR
INSERT INTO microcontrolador
    (modelo, fabricante, tipo, numero_serie, local_instalacao, observacao)
VALUES
    ('Arduino Uno R3', 'Arduino', 'Arduino', 'SN-ESP32-001', 'Câmara fria A – VaccinaCold', 'Principal'),
    ('Arduino Uno R3', 'Arduino', 'Arduino', 'SN-ESP32-002', 'Câmara fria B – VaccinaCold', NULL),
    ('Arduino Uno R3',	'Arduino',  'Arduino','SN-ARD-001',  'Veículo refrigerado 01 – FrigoCargo', NULL),
    ('ESP32-S3',        'Espressif', 'ESP32', 'SN-ESP32-003', 'Depósito central – ImunoCenter', 'Backup ativo');


-- 6. SENSOR
INSERT INTO sensor
    (modelo, fabricante, tipo, local_instalacao, faixa_min, faixa_max, observacao)
VALUES
    ('LM35', 'Bosch', 'Temperatura LM35', 'Câmara fria A – Rack 1', -55.00, 150.00, 'Calibrado em 01/2025'),
    ('LM35', 'Siemens', 'Temperatura LM35', 'Câmara fria A – Rack 2', -55.00, 150.00, NULL),
    ('LM35', 'NXP', 'Temperatura LM35', 'Câmara fria B – Rack 1', -55.00, 150.00, NULL),
    ('LM35', 'Denso', 'Temperatura LM35', 'Veículo 01 – FrigoCargo',  -40.00, 110.00, 'Sensor veicular'),
    ('LM35', 'Texas Instruments', 'Temperatura LM35', 'Depósito ImunoCenter',     -55.00, 150.00, NULL);


-- 7. ALOCACAO_LOTE
INSERT INTO alocacao_lote
    (fk_lote, fk_sensor, inicio_monitoramento, fim_monitoramento)
VALUES
    (1, 1, '2025-01-10 08:00:00', NULL),           -- Lote CoronaVac 001 no sensor 1 (em andamento)
    (2, 2, '2025-02-15 08:00:00', '2025-06-01 18:00:00'), -- Lote CoronaVac 002 no sensor 2 (encerrado)
    (3, 3, '2025-01-20 07:00:00', NULL),           -- Lote Pfizer no sensor 3
    (4, 4, '2025-03-05 09:00:00', NULL),           -- Lote AZ no sensor 4 (veículo)
    (5, 5, '2025-04-01 08:00:00', NULL),           -- Lote Janssen no sensor 5
    (6, 1, '2025-05-01 08:00:00', NULL);           -- Lote Influenza também no sensor 1


-- 8. LEITURA_TEMPERATURA
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