CREATE DATABASE TermoChain;
USE TermoChain;

-- EMPRESA
CREATE TABLE empresa(
	id_empresa INT PRIMARY KEY AUTO_INCREMENT,
	razao_social VARCHAR(150) NOT NULL,
	nome_fantasia VARCHAR(150),
	cnpj CHAR(18) NOT NULL UNIQUE,
	email VARCHAR(150) NOT NULL UNIQUE,
	endereco VARCHAR(150) NOT NULL,
	estado CHAR(2) NOT NULL,
	cep CHAR(8) NOT NULL,
	telefone VARCHAR(20),
	segmento VARCHAR(60) NOT NULL,
	dt_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- USUARIO
CREATE TABLE usuario(
	id_usuario INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(80) NOT NULL,
	email VARCHAR(120) NOT NULL UNIQUE,
	senha VARCHAR(255) NOT NULL,
	cpf CHAR(14) NOT NULL UNIQUE,
	status_usuario VARCHAR(20) NOT NULL DEFAULT 'Ativo',
	dt_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	fk_empresa INT NOT NULL,
	
	CONSTRAINT fk_usuario_empresa
	FOREIGN KEY (fk_empresa) REFERENCES empresa(id_empresa)
);

-- VACINA
CREATE TABLE vacina(
	id_vacina INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(80) NOT NULL,
	marca VARCHAR(80) NOT NULL,
	temp_min DECIMAL(5,2) NOT NULL,
	temp_max DECIMAL(5,2) NOT NULL,
	fk_empresa INT NOT NULL,
	
	CONSTRAINT fk_vacina_empresa
	FOREIGN KEY (fk_empresa) REFERENCES empresa(id_empresa)
);

-- LOTE VACINA
CREATE TABLE lote_vacina(
	id_lote INT PRIMARY KEY AUTO_INCREMENT,
	codigo VARCHAR(60) NOT NULL UNIQUE,
	data_validade DATE NOT NULL,
	peso DECIMAL(10,2) NOT NULL,
	volume DECIMAL(10,2) NOT NULL,
	fk_vacina INT NOT NULL,
	
	CONSTRAINT fk_lote_vacina
	FOREIGN KEY (fk_vacina) REFERENCES vacina(id_vacina)
);

-- MICROCONTROLADOR
CREATE TABLE microcontrolador(
	id_micro INT PRIMARY KEY AUTO_INCREMENT,
	modelo VARCHAR(60) NOT NULL,
	tipo VARCHAR(60) NOT NULL,
	local_instalacao VARCHAR(150),
	status_micro VARCHAR(20) NOT NULL DEFAULT 'Ativo',
	dt_instalacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	fk_lote INT NOT NULL,
	
	CONSTRAINT fk_micro_lote
	FOREIGN KEY (fk_lote) REFERENCES lote_vacina(id_lote)
);

-- SENSOR
CREATE TABLE sensor(
	id_sensor INT PRIMARY KEY AUTO_INCREMENT,
	tipo_sensor VARCHAR(60) NOT NULL,
	unidade_medida VARCHAR(20) NOT NULL,
	status_sensor VARCHAR(20) NOT NULL DEFAULT 'Ativo',
	fk_micro INT NOT NULL,
	
	CONSTRAINT fk_sensor_micro
	FOREIGN KEY (fk_micro) REFERENCES microcontrolador(id_micro)
);

-- REGISTRO TEMPERATURA
CREATE TABLE registro_temperatura(
	id_registro INT PRIMARY KEY AUTO_INCREMENT,
	temp_atual DECIMAL(5,2) NOT NULL,
	data_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	status_temp VARCHAR(20) NOT NULL,
	alerta BOOLEAN NOT NULL DEFAULT FALSE,
	segundos_alerta INT NOT NULL DEFAULT 0,
	fk_sensor INT NOT NULL,
	
	CONSTRAINT fk_registro_sensor
	FOREIGN KEY (fk_sensor) REFERENCES sensor(id_sensor)
);