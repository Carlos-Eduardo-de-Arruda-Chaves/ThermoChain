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
