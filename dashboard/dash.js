let graficoLinha = null;
let graficoPizza = null;

let valores = [];
let nome;
let dentro;
let fora;
let tempAtual;
let status;
let kpis = [];

fechar();
alertar();

function fechar() {
    document.getElementById("alertaLote").style.display = 'none';
}

function abrir(nome, desc) {
    document.getElementById("alertaTitulo").textContent = nome;
    document.getElementById("alertaDesc").textContent = desc;

    document.getElementById("alertaLote").style.display = 'block';
}

function alertar() {
    if (valores[valores.length - 1] > 8) {
        abrir(nome, 'O lote está com a temperatura acima da média');
    } else if (valores[valores.length - 1] < 2) {
        abrir(nome, 'O lote está com a temperatura abaixo da média');
    }

    setTimeout(alertar, 2000);
}

function atualizarOpcoes() {
    const select = document.getElementById("selectSensor");
    const options = select.options;

    for (let i = 1; i <= 3; i++) {
        let valoresTemp = [];

        if (i == 1) valoresTemp = [2, 3, 6, 4, 5];
        if (i == 2) valoresTemp = [6, 7, 2, 3, 3];
        if (i == 3) valoresTemp = [2, 3, 5, 7, 9];

        const ultimo = valoresTemp[valoresTemp.length - 1];

        if (ultimo > 8 || ultimo < 2) {
            options[i - 1].text = `🔴 ABCD${i}`;
        } else {
            options[i - 1].text = `ABCD${i}`;
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

function chamar(sensor) {

    nome = `Lote ${sensor}`;

    if (sensor == 1) {
        valores = [2, 3, 6, 4, 5];
        dentro = 100;
        fora = 0;
        tempAtual = "5ºC";
        status = "Temperatura normal";
        kpis = ["3", `${valores[valores.length - 1] > 8 || valores[valores.length - 1] < 2 ? 'Sim' : 'Não'}`, "0", "0", "00:00:00", "R$3.840", "José Carvalho Pinto - SA/BH"];
    }

    if (sensor == 2) {
        valores = [6, 7, 2, 1, 3];
        dentro = 80;
        fora = 20;
        tempAtual = "3ºC";
        status = "Temperatura normal";
        kpis = ["3", `${valores[valores.length - 1] > 8 || valores[valores.length - 1] < 2 ? 'Sim' : 'Não'}`, "0", "1", "00:03:41", "R$1.275", "Rua Haddock Lobo 595 - SP/SP"];
    }

    if (sensor == 3) {
        valores = [4, 2, 1, 9, 11];
        dentro = 40;
        fora = 60;
        tempAtual = "11ºC";
        status = "Temperatura acima da média";
        kpis = ["3", `${valores[valores.length - 1] > 8 || valores[valores.length - 1] < 2 ? 'Sim' : 'Não'}`, "1.2", "3", "00:04:32", "R$2.583", "Rua Maneira Legal Divertida e Feliz - 67"];
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

    if (graficoLinha != null) {
        graficoLinha.destroy();
    }

    if (graficoPizza != null) {
        graficoPizza.destroy();
    }

    graficoLinha = new Chart(document.getElementById("graficoLinha").getContext("2d"), {
        type: "line",
        data: {
            labels: ["15:40", "15:50", "16:00", "16:10", "16:20"],
            datasets: [
                {
                    label: '',
                    borderColor: 'transparent',
                    backgroundColor: 'transparent',
                    data: [12, 12, 12, 12, 12]
                },
                {
                    label: 'Temperatura Máxima',
                    borderColor: '#E53935',
                    backgroundColor: '#E53935',
                    data: [8, 8, 8, 8, 8],
                    borderWidth: 2,
                    borderDash: [5, 5],
                    tension: 0.1
                },
                {
                    label: 'Temperatura Minima',
                    borderColor: '#00BFFF',
                    backgroundColor: '#00BFFF',
                    data: [2, 2, 2, 2, 2],
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
                    min: 0
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
    let sensor = document.getElementById("selectSensor").value;
    chamar(sensor);
}

chamar(1);