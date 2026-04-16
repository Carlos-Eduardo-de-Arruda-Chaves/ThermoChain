var sensorAnalogico = new Chart(document.getElementById('sensorAnalogico').getContext('2d'), {
    type: 'line',
    data: {
        labels: ['13:00', '13:01', '13:02', '13:03', '13:04'],
        datasets: [

            {
                label: '',
                borderColor: 'white',
                backgroundColor: 'white',
                data: [12, 12, 12 , 12, 12]
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
                label: 'Sensor1',
                borderColor: '#F5A623',
                backgroundColor: '#F5A623',
                data: [2, 3, 4, 4, 4]
            },
            {
                label: 'Sensor2',
                borderColor: '#9B59B6',
                backgroundColor: '#9B59B6',
                data: [4, 6, 8, 5, 6]
            },
            {
                label: 'Sensor3',
                borderColor: '#8BC34A',
                backgroundColor: '#8BC34A',
                data: [6, 4, 2, 0, 0]
            },
            {
                label: '',
                borderColor: 'white',
                backgroundColor: 'white',
                data: [-2, -2, -2 , -2, -2]
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