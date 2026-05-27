var database = require("../database/config");

function listar() {
    console.log("ACESSEI O AVISO  MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function listar()");
    var instrucaoSql = `
        SELECT l.temperatura, l.data_hora, l.fk_sensor, l.fk_lote, lv.codigo, 
        s.local_instalacao, lv.quantidade FROM leitura_temperatura l JOIN lote_vacina lv ON lv.id_lote=l.fk_lote 
        join alocacao_lote al on al.fk_lote = lv.id_lote join sensor s on s.id_sensor = al.fk_sensor ORDER BY fk_lote, data_hora ASC;
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

module.exports = {
    listar
}