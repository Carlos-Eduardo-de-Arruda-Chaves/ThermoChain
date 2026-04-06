USE termochain;

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
    lv.status_lote
FROM lote_vacina lv
JOIN tipo_vacina tv 
    ON tv.id_vacina = lv.fk_vacina
WHERE lv.data_validade <= CURDATE() + 60
ORDER BY lv.data_validade;