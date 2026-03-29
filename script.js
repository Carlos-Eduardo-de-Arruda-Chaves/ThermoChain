const registrosMensais = [
    { mes: "Janeiro", total: 19, ideal: 16, fora: 3, registrosDiarios: [["02/01/2025", 3, "ideal", 0, "N/A"], ["05/01/2025", 2, "ideal", 0, "N/A"], ["07/01/2025", 12, "acima", 6, "43m"], ["09/01/2025", 7, "ideal", 0, "N/A"], ["11/01/2025", 6, "ideal", 0, "N/A"], ["13/01/2025", 4, "ideal", 0, "N/A"], ["15/01/2025", 3, "ideal", 0, "N/A"], ["16/01/2025", 7, "ideal", 0, "N/A"], ["17/01/2025", -2, "abaixo", 9, "50m"]] },
    { mes: "Fevereiro", total: 2, ideal: 1, fora: 1, registrosDiarios: [["03/02/2025", 5, "ideal", 0, "N/A"], ["18/02/2025", 14, "acima", 4, "35m"]] },
    { mes: "Março", total: 1, ideal: 1, fora: 0, registrosDiarios: [["07/03/2025", 1, "ideal", 0, "N/A"]] },
    { mes: "Abril", total: 3, ideal: 1, fora: 2, registrosDiarios: [["04/04/2025", 9, "ideal", 0, "N/A"], ["11/04/2025", 15, "acima", 3, "27m"], ["23/04/2025", -1, "abaixo", 5, "40m"]] }
];

const containerRegistros = document.getElementById("LogsRegistros");

for (let i = 0; i < registrosMensais.length; i++) {
    const registroMes = registrosMensais[i];

    containerRegistros.innerHTML += `
        <div class="mesTitulo">${registroMes.mes}</div>

        <div class="mesContainer">
            <div class="logLinha">
                <div class="logInfo">
                    <span class="total">${registroMes.total} registros</span>
                    <span class="ideal">${registroMes.ideal} registros ideais</span>
                    <span class="fora">${registroMes.fora} fora da média</span>
                </div>

                <button class="botaoExpandir" id="btn${i}" onclick="expandir(${i})">+</button>
            </div>

            <div class="expandDiv" id="expand${i}"></div>
        </div>
    `;
}

function montarLinhaDia(registroDia) {
    const data = registroDia[0];
    const temperaturaMedia = registroDia[1];
    const situacao = registroDia[2];
    const quantidadeAlertas = registroDia[3];
    const tempoForaIdeal = registroDia[4];

    let textoSituacao = "";
    let classeSituacao = "";

    if (situacao === "ideal") {
        textoSituacao = "ideal";
        classeSituacao = "ideal";
    } else {
        textoSituacao = situacao;
        classeSituacao = "fora";
    }

    return `
        <div class="expandLinha">
            <span class="colData">${data}</span>
            <span class="colMedia">média: ${temperaturaMedia}°C</span>
            <span class="colStatus ${classeSituacao}">${textoSituacao}</span>
            <span class="colAlertas">alertas: ${quantidadeAlertas}</span>
            <span class="colTempo">
                Tempo: ${tempoForaIdeal}
                <small>fora da temperatura ideal</small>
            </span>
        </div>
    `;
}

function expandir(indice) {
    const containerExpansao = document.getElementById("expand" + indice);
    const botaoExpandir = document.getElementById("btn" + indice);

    if (containerExpansao.innerHTML == "") {
        let conteudoHTML = "";

        for (let i = 0; i < registrosMensais[indice].registrosDiarios.length; i++) {
            conteudoHTML += montarLinhaDia(registrosMensais[indice].registrosDiarios[i]);
        }

        containerExpansao.innerHTML = conteudoHTML;
        containerExpansao.style.display = "block";
        botaoExpandir.textContent = "-";
    } else {
        containerExpansao.innerHTML = "";
        containerExpansao.style.display = "none";
        botaoExpandir.textContent = "+";
    }
}