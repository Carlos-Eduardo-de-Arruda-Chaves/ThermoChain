let sensorAnalogico = null;
let graficoPizza = null;
let sensor = 1;
function chamar(sensor) {
    let nome = `Sensor${sensor}`;
    let valores = [];

    if (sensor == 1) {
        valores = [2, 3, 6, 4, 5];
        dentro = 80;
        fora = 20;
    }
    if (sensor == 2) {
        valores = [6, 7, 2, 3, 3];
        dentro = 65;
        fora = 35;
    }
    if (sensor == 3) {
        valores = [2, 3, 5, 7, 9];
        dentro = 93.6;
        fora = 7.4;
    }

    if (sensorAnalogico != null) {
        sensorAnalogico.destroy();
    }

    if (graficoPizza != null) {
        graficoPizza.destroy();
    }


    sensorAnalogico = new Chart(document.getElementById('sensorAnalogico').getContext('2d'), {
        type: 'line',
        data: {
            labels: ['13:00', '13:01', '13:02', '13:03', '13:04'],
            datasets: [

                {
                    label: '',
                    borderColor: 'transparent',
                    backgroundColor: 'transparent',
                    data: [12, 12, 12, 12, 12]
                }
                ,
                {
                    label: 'Temperatura Máxima',
                    borderColor: '#E53935',
                    backgroundColor: '#E53935',
                    data: [8, 8, 8, 8, 8],
                    borderWidth: 2,
                    borderDash: [5, 5],
                    tension: 0.1
                }, {
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
            ],
        },
        options: {
            scales: {
                x: {
                    title: {
                        display: true,
                        text: 'Horário'
                    },
                    beginAtZero: true,
                },
                y: {
                    title: {
                        display: true,
                        text: 'Temperatura'
                    },
                    beginAtZero: true,
                },
            },
        }
    });

    graficoPizza = new Chart(document.getElementById('graficoPizza').getContext('2d'), {
        type: 'pie',
        data: {
            labels: [
                `Tempo fora da temperatura ${fora}%`,
                `Tempo dentro da temperatura ${dentro}%`
            ],
            datasets: [{
                data: [fora, dentro],
                backgroundColor: [
                    '#D3D3D3',
                    '#4A78D1' 
                ],
                borderWidth: 1
            }]
        },
        options: {
            plugins: {
                legend: {
                    position: 'bottom'
                }
            }
        }
    });
}

// última linha do arquivo
chamar(1);