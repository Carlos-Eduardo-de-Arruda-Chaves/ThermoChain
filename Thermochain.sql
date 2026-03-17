CREATE DATABASE thermochain;
USE thermochain;

CREATE TABLE empresa (
	id_empresa INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(40) NOT NULL,
    cnpj CHAR(14) NOT NULL,
    telefone VARCHAR(30) NOT NULL,
    dt_inicio_contrato DATE NOT NULL DEFAULT (CURDATE()),
    dt_fim_contrato DATE
);

INSERT INTO empresa (nome, cnpj, telefone, dt_inicio_contrato) VALUES
('Instituto ThermoChain', '12098345000199', '11940028922', '2026-02-28');


CREATE TABLE vacina (
	id_vacina INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(40),
    temp_min DECIMAL(3, 1),
    temp_max DECIMAL(3, 1)
);

INSERT INTO vacina (nome, temp_min, temp_max) VALUES
('Influenza', 2, 8);

CREATE TABLE registro_sensor (
	id_registro INT PRIMARY KEY AUTO_INCREMENT,
    temp_atual DECIMAL(3,1) NOT NULL,
    dt_atual DATETIME DEFAULT NOW()
);

INSERT INTO registro_sensor (temp_atual, dt_atual) VALUES
-- Período normal (30 min)
(5.2, '2026-02-27 08:00:00'),
(5.1, '2026-02-27 08:01:00'),
(5.0, '2026-02-27 08:02:00'),d
(4.9, '2026-02-27 08:03:00'),
(5.3, '2026-02-27 08:04:00'),
(5.4, '2026-02-27 08:05:00'),
(5.6, '2026-02-27 08:06:00'),
(5.5, '2026-02-27 08:07:00'),
(5.2, '2026-02-27 08:08:00'),
(5.0, '2026-02-27 08:09:00'),
(4.8, '2026-02-27 08:10:00'),
(5.1, '2026-02-27 08:11:00'),
(5.3, '2026-02-27 08:12:00'),
(5.4, '2026-02-27 08:13:00'),
(5.6, '2026-02-27 08:14:00'),
(5.5, '2026-02-27 08:15:00'),
(5.3, '2026-02-27 08:16:00'),
(5.1, '2026-02-27 08:17:00'),
(5.0, '2026-02-27 08:18:00'),
(4.9, '2026-02-27 08:19:00'),
(5.2, '2026-02-27 08:20:00'),
(5.3, '2026-02-27 08:21:00'),
(5.4, '2026-02-27 08:22:00'),
(5.6, '2026-02-27 08:23:00'),
(5.7, '2026-02-27 08:24:00'),
(5.5, '2026-02-27 08:25:00'),
(5.3, '2026-02-27 08:26:00'),
(5.1, '2026-02-27 08:27:00'),
(5.0, '2026-02-27 08:28:00'),
(4.9, '2026-02-27 08:29:00'),

-- Fora da faixa (frio) - 10 min
(1.5, '2026-02-27 08:30:00'),
(1.2, '2026-02-27 08:31:00'),
(1.0, '2026-02-27 08:32:00'),
(0.8, '2026-02-27 08:33:00'),
(0.5, '2026-02-27 08:34:00'),
(0.7, '2026-02-27 08:35:00'),
(1.0, '2026-02-27 08:36:00'),
(1.3, '2026-02-27 08:37:00'),
(1.6, '2026-02-27 08:38:00'),
(1.8, '2026-02-27 08:39:00'),

-- Normal novamente (50 min)
(4.0, '2026-02-27 08:40:00'),
(4.3, '2026-02-27 08:41:00'),
(4.6, '2026-02-27 08:42:00'),
(4.8, '2026-02-27 08:43:00'),
(5.0, '2026-02-27 08:44:00'),
(5.2, '2026-02-27 08:45:00'),
(5.4, '2026-02-27 08:46:00'),
(5.6, '2026-02-27 08:47:00'),
(5.5, '2026-02-27 08:48:00'),
(5.3, '2026-02-27 08:49:00'),
(5.2, '2026-02-27 08:50:00'),
(5.0, '2026-02-27 08:51:00'),
(4.9, '2026-02-27 08:52:00'),
(5.1, '2026-02-27 08:53:00'),
(5.3, '2026-02-27 08:54:00'),
(5.4, '2026-02-27 08:55:00'),
(5.6, '2026-02-27 08:56:00'),
(5.7, '2026-02-27 08:57:00'),
(5.5, '2026-02-27 08:58:00'),
(5.3, '2026-02-27 08:59:00'),
(5.2, '2026-02-27 09:00:00'),
(5.0, '2026-02-27 09:01:00'),
(4.9, '2026-02-27 09:02:00'),
(5.1, '2026-02-27 09:03:00'),
(5.3, '2026-02-27 09:04:00'),
(5.4, '2026-02-27 09:05:00'),
(5.6, '2026-02-27 09:06:00'),
(5.7, '2026-02-27 09:07:00'),
(5.5, '2026-02-27 09:08:00'),
(5.3, '2026-02-27 09:09:00'),
(5.2, '2026-02-27 09:10:00'),
(5.0, '2026-02-27 09:11:00'),
(4.9, '2026-02-27 09:12:00'),
(5.1, '2026-02-27 09:13:00'),
(5.3, '2026-02-27 09:14:00'),
(5.4, '2026-02-27 09:15:00'),
(5.6, '2026-02-27 09:16:00'),
(5.7, '2026-02-27 09:17:00'),
(5.5, '2026-02-27 09:18:00'),
(5.3, '2026-02-27 09:19:00'),
(5.2, '2026-02-27 09:20:00'),
(5.0, '2026-02-27 09:21:00'),
(4.9, '2026-02-27 09:22:00'),
(5.1, '2026-02-27 09:23:00'),
(5.3, '2026-02-27 09:24:00'),
(5.4, '2026-02-27 09:25:00'),
(5.6, '2026-02-27 09:26:00'),
(5.7, '2026-02-27 09:27:00'),
(5.5, '2026-02-27 09:28:00'),
(5.3, '2026-02-27 09:29:00'),

-- Fora da faixa (quente) - 10 min
(9.2, '2026-02-27 09:30:00'),
(9.6, '2026-02-27 09:31:00'),
(10.0, '2026-02-27 09:32:00'),
(10.4, '2026-02-27 09:33:00'),
(10.7, '2026-02-27 09:34:00'),
(10.5, '2026-02-27 09:35:00'),
(10.2, '2026-02-27 09:36:00'),
(9.8, '2026-02-27 09:37:00'),
(9.5, '2026-02-27 09:38:00'),
(9.1, '2026-02-27 09:39:00');

CREATE TABLE usuario (
	id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(40),
    email VARCHAR(80),
    senha VARCHAR(35),
    telefone VARCHAR(20)
);

INSERT INTO usuario (nome, email, senha, telefone) VALUES
('Bruno Rafael', 'bruno.goncalves@sptech.school', '123456', '11940028922'),
('Guilherme Gonçalves', 'guilherme.britto@sptech.school', '98765', '11943245678'),
('Karina Cupola', 'karina.alves@sptech.school', '546789', '1187654324'),
('Manuella Arantes', 'manuella.arantes@sptech.school', 'manu123', '11900020001'),
('Henrique Nakanishi', 'henrique.nakanishi@sptech.school', 'henrique123', '11987654321'),
('Maria Eduarda', 'maria.nogueiro@sptech.school', 'maria123', '11984561234'),
('Pedro Barros', 'pedro.barros@sptech.school', 'pedro123', '11983456789'),
('Livia Brito', 'livia.motta@sptech.school', 'livia123', '11982345678'),
('Luiz Duarte', 'luiz.duarte@sptech.school', 'luizinhodasilva', '119832824567');


-- Mostrar todos os registros do sensor em ordem cronologica
SELECT * FROM registro_sensor ORDER BY dt_atual;

-- Mostrar tdoos que estão dentro da faixa
SELECT * FROM registro_sensor WHERE temp_atual BETWEEN 2 AND 8;

-- Mostrar a data dos registros fora da faixa
SELECT dt_atual FROM registro_sensor WHERE temp_atual NOT BETWEEN 2 AND 8;

-- Manipular dados para dashboard por exemplo
SELECT temp_atual, DATE_FORMAT(dt_atual, '%H:%i') AS horario FROM registro_sensor ORDER BY dt_atual;



