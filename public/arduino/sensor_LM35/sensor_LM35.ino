//declaração da variavél do sensor e a porta Análogica onde está
const int PINO_SENSOR_TEMPERATURA = A5;

//Declaração da variável da temperatura em Celsius
float temperaturaCelsius;

// Conexão com o computador em milisegundos 
void setup() {
    Serial.begin(9600);
}


// função de loop
void loop() {
  // declração de variável do valor da leitura captada pelo senso
  int valorLeitura = analogRead(PINO_SENSOR_TEMPERATURA);

//  conversão da tensão para Celcius
  temperaturaCelsius = (valorLeitura * 5.0 / 1023.0) / 0.01;

// print da temperatura
  Serial.println(temperaturaCelsius);

// delay de 2000 milisegundo para o loop
  delay(2000);
}
