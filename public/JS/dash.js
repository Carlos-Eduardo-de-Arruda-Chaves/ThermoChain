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

        temperaturas = [];
        datas = [];
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
                        temperaturas.push(dados[i].temperatura);
                        let dataFormatada = dados[i].data_hora.slice(11, 19);
                        datas.push(dataFormatada);
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
    document.getElementById("containerAlertas").innerHTML = "";
    let ultimosLotes = {};
    let existeAlerta = false;

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
            existeAlerta = true;
        } else if (temperatura < 2) {
            abrir(registro.codigo, 'O lote está com a temperatura abaixo da média');
            existeAlerta = true;
        }
    }

    if (!existeAlerta) {
        document.getElementById("containerAlertas").innerHTML = `
            <div class="alertaLote">
                <div class="textoAlerta">
                    <h2>Sem alertas</h2>
                    <p>Todos os lotes estão dentro da faixa ideal.</p>
                </div>
            </div>
        `;
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

function formatarHorario(hora) {
    let partes = hora.split(':');

    let horas = Number(partes[0]);
    let minutos = Number(partes[1]);
    let segundos = Number(partes[2]);

    return horas * 3600 + minutos * 60 + segundos;
}

function chamar(sensor) {
    let ocorrencia = 0;
    let tempBaixo = false;
    let tempAcima = false;

    nome = `Lote ${sensor}`;

    let registros = sensores[sensor];
    console.log('registro:', registros, sensor);
    console.log('oi', temperaturas);

    

    let alertar = false;
    let tempoInicioForaDaFaixa = 0;
    let tempoForaDaFaixa = 0;
    let foraDaFaixa = false;

    valores = [];
    datas = [];

    for (let i = 0; i < registros.length; i++) {
        valores.push(Number(registros[i].temperatura));
        let dataFormatada = registros[i].data_hora.slice(11, 19);
        datas.push(dataFormatada.substring(0, 8));
    }

    for (let i = 0; i < registros.length; i++) {
        if (registros[i].temperatura < 2 || registros[i].temperatura > 8) {
            if (!foraDaFaixa) {
                foraDaFaixa = true;
                tempoInicioForaDaFaixa = formatarHorario(datas[i]);
                ocorrencia++;
            }
        } else {
            tempAcima = false;
            tempBaixo = false;
            console.log(tempoInicioForaDaFaixa, 'alskdajksld');

            if (foraDaFaixa) {
                tempoForaDaFaixa += formatarHorario(datas[i]) - tempoInicioForaDaFaixa;
                foraDaFaixa = false;
            }
        }
    }
    if (foraDaFaixa) {
        tempoForaDaFaixa += formatarHorario(datas[datas.length - 1]) - tempoInicioForaDaFaixa;
    }

    let horasTempo = Math.floor(tempoForaDaFaixa / 3600);
    let minutosTempo = Math.floor((tempoForaDaFaixa % 3600) / 60);
    let segundosTempo = tempoForaDaFaixa % 60;

    let tempoFormatado = String(horasTempo).padStart(2, '0') + ':' + String(minutosTempo).padStart(2, '0') + ':' + String(segundosTempo).padStart(2, '0');

    tempAtual = valores[valores.length - 1];
    if (valores[valores.length - 1] > 8) {
        status = "Temperatura acima da média";
        kpis = ['0', `${valores[valores.length - 1] > 8 || valores[valores.length - 1] < 2 ? "Sim" : "Não"}`, Math.abs(valores[valores.length - 1] - 8).toFixed(2), ocorrencia, tempoFormatado, registros[0].quantidade, registros[0].local_instalacao] // abs pega o valor absoluto (-2) = 2
    } else if (valores[valores.length - 1] < 2) {
        status = "Temperatura abaixo da média";
        kpis = ['0', `${valores[valores.length - 1] > 8 || valores[valores.length - 1] < 2 ? "Sim" : "Não"}`, Math.abs(valores[valores.length - 1] - 2).toFixed(2), ocorrencia, tempoFormatado, registros[0].quantidade, registros[0].local_instalacao]
    } else {
        status = "Temperatura normal";
        kpis = ['0', `${valores[valores.length - 1] > 8 || valores[valores.length - 1] < 2 ? "Sim" : "Não"}`, 0, ocorrencia, tempoFormatado, registros[0].quantidade, registros[0].local_instalacao];
    }

    // bola
    let tempoTotal = formatarHorario(datas[datas.length - 1]) - formatarHorario(datas[0]);

    if (tempoTotal > 0) {
        fora = Math.round((tempoForaDaFaixa / tempoTotal) * 100);
        dentro = 100 - fora;
    } else {
        fora = 0;
        dentro = 100;
    }

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
    console.log(valores, 'carlos');
    
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
    console.log(datas, 'valores');
    console.log(valores.length);
    
    let valores_tratados = []
    let datas_tratadas = []
    if(valores.length > 10){
        for(i=10;i>0;i--){
            console.log(valores[valores.length - i]);
            valores_tratados.push(valores[valores.length - i])
            datas_tratadas.push(datas[datas.length - i])
        }
    } else {
        valores_tratados = valores
        datas_tratadas = datas
    }
    console.log(`xD`, datas_tratadas);
    
    graficoLinha = new Chart(document.getElementById("graficoLinha").getContext("2d"), {
        type: "line",
        data: {
            labels: datas_tratadas,
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
                    data: valores_tratados,
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
    verificar();
}

setInterval(verificar, 5000)