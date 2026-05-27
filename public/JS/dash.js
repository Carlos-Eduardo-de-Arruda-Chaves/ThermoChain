let graficoLinha = null;
let graficoPizza = null;

let valores = [];
let nome;
let dentro;
let fora;
let tempAtual;
let status;
let kpis = [];
let temperaturas = [];
let datas = [];
let primeira_verificacao = false;
let sensores = {};
let dados_alerta = [];
let alertasExibidos = [];

let lotes = [];
function verificar() {
    sensores = {};
    fetch("/avisos/listar").then(function (resposta) {

        temperaturas = []
        datas = []
        if (resposta.ok) {

            resposta.json().then(function (dados) {
                console.log(dados);
                if (!primeira_verificacao) {
                    sessionStorage.SENSOR = dados[0].fk_sensor
                    console.log(sessionStorage.SENSOR);
                    primeira_verificacao = true
                }
                for (let i = 0; i < dados.length; i++) {
                    if (dados[i].fk_sensor == sessionStorage.SENSOR) {
                        console.log(`Data da temperatura: ${dados[i].data_hora}`);
                        console.log(`Temperatura do sensor ${sessionStorage.SENSOR}: ${dados[i].temperatura}`);
                        temperaturas.push(dados[i].temperatura)
                        let dataFormatada = dados[i].data_hora
                            // split() divide a string de acordo com o parametro passado
                            .split('T')[1]
                            .split('-')
                            // reverse() inverte a ordem da array, para deixar o dia em forma de "20", "06", "2026" por exemplo
                            .reverse()
                            // join junta os elementos da array com "/", assim ficando correto e certo para ver a data do registro
                            .join('/');
                        datas.push(dataFormatada.substring(0, 8))
                    }
                }
                console.log(temperaturas);
                console.log(datas);

                let codigos = [];

                for (let i = 0; i < dados.length; i++) {

                    let check = false;

                    for (let j = 0; j < codigos.length; j++) {

                        if (codigos[j][0] == dados[i].codigo) {
                            check = true;
                            break;
                        }
                    }

                    if (!check) {
                        codigos.push([
                            dados[i].codigo,
                            dados[i].fk_lote
                        ]);
                    }
                }

                let indice = 0;

                for (let i = 0; i < dados.length; i++) {

                    let sensor = dados[i].fk_lote;

                    if (!sensores[sensor]) {
                        sensores[sensor] = [];
                    }

                    sensores[sensor].push(dados[i]);
                }

                lotes = codigos;

                const select = document.getElementById("selectSensor");

                if (select.options.length == 0) {
                    for (let i = 0; i < lotes.length; i++) {
                        let option = document.createElement("option");

                        option.value = lotes[i][1];
                        option.textContent = lotes[i][0];
                        option.dataset.nomeOriginal = lotes[i][0];

                        select.appendChild(option);
                    }
                }
                dados_alerta = dados;
                alertar();
                chamar(sessionStorage.SENSOR);

            });

        } else {
            throw ('Houve um erro na API!');
        }

    }).catch(function (erro) {
        console.error(erro);
    });
}

function fechar(nome) {
    if (!alertasExibidos.includes(nome)) {
        alertasExibidos.push(nome);
    }
    let alerta = document.getElementById(`alerta-${nome}`);
    if (alerta) {
        alerta.remove();
    }
}

function abrir(nome, desc) {
    if (alertasExibidos.includes(nome)) return;
    if (document.getElementById(`alerta-${nome}`)) return;

    let alerta = document.createElement("div");
    alerta.className = "alertaLote";
    alerta.id = `alerta-${nome}`;
    alerta.innerHTML = `
        <div class="textoAlerta">
            <h2>${nome}</h2>
            <p>${desc}</p>
        </div>
        <img src="../CSS/img/alerta.gif" class="gifAlerta" alt="Alerta">
        <button class="fecharAlerta" onclick="fechar('${nome}')">X</button>
    `;

    document.getElementById("containerAlertas").appendChild(alerta);
}

function alertar() {
    let ultimosLotes = {};

    for (let i = 0; i < dados_alerta.length; i++) {
        let dado = dados_alerta[i];
        let lote = dado.codigo;

        if (!ultimosLotes[lote]) {
            ultimosLotes[lote] = dado;
        } else {
            let dataAtual = dado.data_hora.replace('T', ' ').replace('.000Z', '');
            let ultimaData = ultimosLotes[lote].data_hora.replace('T', ' ').replace('.000Z', '');
            if (dataAtual > ultimaData) {
                ultimosLotes[lote] = dado;
            }
        }
    }

    let listaLotes = Object.keys(ultimosLotes);

    for (let i = 0; i < listaLotes.length; i++) {
        let registro = ultimosLotes[listaLotes[i]];
        let temperatura = Number(registro.temperatura);

        if (temperatura > 8) {
            abrir(registro.codigo, 'O lote está com a temperatura acima da média');
        } else if (temperatura < 2) {
            abrir(registro.codigo, 'O lote está com a temperatura abaixo da média');
        }
    }
}

function atualizarOpcoes() {
    const select = document.getElementById("selectSensor");
    const options = select.options;

    for (let i = 0; i < options.length; i++) {
        let sensor = options[i].value;
        let registros = sensores[sensor];
        let ultimaTemp = registros[registros.length - 1].temperatura;
        let nomeOriginal = options[i].dataset.nomeOriginal;

        if (ultimaTemp > 8 || ultimaTemp < 2) {
            options[i].text = `🔴 ${nomeOriginal}`;
        } else {
            options[i].text = nomeOriginal;
        }
    }
}

function pesquisarLote() {

    let pesquisa = document.getElementById("inputPesquisa").value.toLowerCase();

    let select = document.getElementById("selectSensor");
    let options = select.options;

    for (let i = 0; i < options.length; i++) {
        let texto = options[i].text.toLowerCase();
        if (texto.includes(pesquisa)) {
            select.value = options[i].value;
            chamar(options[i].value);
            break;
        }
    }
}

function chamar(sensor, local, perda) {

    nome = `Lote ${sensor}`;

    let registros = sensores[sensor];
    console.log('registro:', registros, sensor);

    valores = [];
    datas = [];

    for (let i = 0; i < registros.length; i++) {
        valores.push(Number(registros[i].temperatura));
        let dataFormatada = registros[i].data_hora.split('T')[1];
        datas.push(dataFormatada.substring(0, 8));
    }

    tempAtual = valores[valores.length - 1];
    if (valores[valores.length - 1] > 8) {
        status = "Temperatura acima da média";
        kpis = ['0', `${valores[valores.length - 1] > 8 || valores[valores.length - 1] < 2 ? "Sim" : "Não"}`, Math.abs(valores[valores.length - 1] - 8).toFixed(2), 0, "00:00:00", registros[0].quantidade, registros[0].local_instalacao] // abs pega o valor absoluto (-2) = 2
    } else if (valores[valores.length - 1] < 2) {
        status = "Temperatura abaixo da média";
        kpis = ['0', `${valores[valores.length - 1] > 8 || valores[valores.length - 1] < 2 ? "Sim" : "Não"}`, Math.abs(valores[valores.length - 1] - 2).toFixed(2), 0, "00:00:00", registros[0].quantidade, registros[0].local_instalacao]
    } else {
        status = "Temperatura normal";
        kpis = ['0', `${valores[valores.length - 1] > 8 || valores[valores.length - 1] < 2 ? "Sim" : "Não"}`, 0, 0, "00:00:00", registros[0].quantidade, registros[0].local_instalacao];
    }
    dentro = 67;
    fora = 33;

    atualizarOpcoes();

    document.getElementById("txtFora").textContent = `${fora}%`;
    document.getElementById("txtDentro").textContent = `${dentro}%`;
    document.getElementById("tempAtual").textContent = tempAtual;
    let statusEl = document.getElementById("statusText");

    statusEl.textContent = status;

    if (status.includes("acima") || status.includes("abaixo")) {
        statusEl.style.color = "red";
    } else {
        statusEl.style.color = "black";
    }

    document.getElementById("valor2").textContent = kpis[1];
    document.getElementById("valor3").textContent = kpis[2];
    document.getElementById("valor4").textContent = kpis[3];
    document.getElementById("valor5").textContent = kpis[4];
    document.getElementById("valor6").textContent = kpis[5];
    document.getElementById("cardLocalizacaoValue").textContent = kpis[6];
    document.getElementById("cardRisco").style.background = `${valores[valores.length - 1] > 8 || valores[valores.length - 1] < 2 ? '#ffc0c0' : '#a5b8ff'}`;
    document.getElementById("cardMedio").style.background = `${Number(kpis[2]) != 0 ? '#ffc0c0' : '#a5b8ff'}`;
    document.getElementById("cardOcorrencia").style.background = `${Number(kpis[3]) != 0 ? '#ffc0c0' : '#a5b8ff'}`;
    document.getElementById("cardTempo").style.background = `${kpis[4] != "00:00:00" ? '#ffc0c0' : '#a5b8ff'}`;

    let min = 0;

    for (let i = registros.length - 1; i >= 0; i--) {
        console.log(min, Number(registros[i].temperatura));

        if (min > registros[i].temperatura) {
            min = registros[i].temperatura;
        }
    }

    if (min != 0) {
        min -= 1;
        min = Math.floor(min);
    }

    if (graficoLinha != null) {
        graficoLinha.destroy();
    }

    if (graficoPizza != null) {
        graficoPizza.destroy();
    }

    graficoLinha = new Chart(document.getElementById("graficoLinha").getContext("2d"), {
        type: "line",
        data: {
            labels: datas,
            datasets: [
                {
                    label: '',
                    borderColor: 'transparent',
                    backgroundColor: 'transparent',
                    data: [12, 12, 12, 12, 12, 12, 12, 12, 12, 12]
                },
                {
                    label: 'Temperatura Máxima',
                    borderColor: '#E53935',
                    backgroundColor: '#E53935',
                    data: [8, 8, 8, 8, 8, 8, 8, 8, 8, 8],
                    borderWidth: 2,
                    borderDash: [5, 5],
                    tension: 0.1
                },
                {
                    label: 'Temperatura Minima',
                    borderColor: '#00BFFF',
                    backgroundColor: '#00BFFF',
                    data: [2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
                    borderWidth: 2,
                    borderDash: [5, 5],
                    tension: 0.1
                },
                {
                    label: nome,
                    borderColor: '#F5A623',
                    data: valores,
                    fill: true,
                    tension: 0.3,
                    pointRadius: 5,
                    pointBackgroundColor: '#F5A623',
                    pointBorderColor: '#fff'
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    min: min
                }
            }
        }
    });

    graficoPizza = new Chart(document.getElementById("graficoPizza").getContext("2d"), {
        type: "pie",
        data: {
            datasets: [{
                data: [fora, dentro],
                backgroundColor: ["#D3D3D3", "#4A78D1"]
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false }
            }
        }
    });
}

function trocar() {
    let sensor = Number(document.getElementById("selectSensor").value);
    sessionStorage.SENSOR = selectSensor.value;
    alertasExibidos = [];
    verificar();
}