var sensorAnalogico = new Chart(document.getElementById('sensorAnalogico').getContext('2d'), {
    type: 'line',
    data: {
        labels: ['13:00', '13:01', '13:02', '13:03', '13:04'],
        datasets: [
            {
                label: 'Temperatura Máxima',
                borderColor: '#000000',
                backgroundColor: '#000000',
                data: [8, 8, 8, 8, 8],
                borderWidth: 2,
                borderDash: [5, 5],
                tension: 0.1
            }, {
                label: 'Temperatura Minima',
                borderColor: '#000000',
                backgroundColor: '#000000',
                data: [2, 2, 2, 2, 2],
                borderWidth: 2,
                borderDash: [5, 5],
                tension: 0.1
            },
            {
                label: 'Sensor1',
                borderColor: '#0056B2',
                backgroundColor: '#0056B2',
                data: [2, 3, 4, 4, 4]
            },
            {
                label: 'Sensor2',
                borderColor: '#FF5722',
                backgroundColor: '#FF5722',
                data: [4, 6, 8, 5, 6]
            },
            {
                label: 'Sensor3',
                borderColor: '#8BC34A',
                backgroundColor: '#8BC34A',
                data: [6, 4, 2, 0, 0]
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