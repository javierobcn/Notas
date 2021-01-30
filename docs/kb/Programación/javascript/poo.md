# POO Javascript

## Ejemplo de uso de clases, funciones y objetos

```javascript

class coche {
  constructor(marca, modelo, capacidad_deposito, gasolina_en_deposito) {
    this.marca = marca;
    this.modelo = modelo;
    this.capacidad_deposito = capacidad_deposito;
    this.gasolina_en_deposito = gasolina_en_deposito;
    this.viajes = [];
  }

  viaje(destino, gasolina_consumida) {
    this.viajes.push([destino, gasolina_consumida]);
    this.gasolina_en_deposito -= gasolina_consumida;
    console.log(
      "Se ha realizado un viaje a " +
        destino +
        " consumiendo " +
        gasolina_consumida +
        " l."
    );
    if (this.gasolina_en_deposito <= 0) {
      this.repostar();
    }
  }

  repostar() {
    console.log(this.marca + " " + this.modelo + " ha repostado");
    this.gasolina_en_deposito = this.capacidad_deposito;
  }
}

const divresults = document.getElementById("data");

let coche_a = new coche("Renault", "Clio", 42, 40);
let coche_b = new coche("Opel", "Astra", 52, 50);

coche_a.viaje("Lerida", 30);
coche_a.viaje("Zaragoza", 20);

divresults.innerHTML =
  coche_a.marca + " " + coche_a.modelo + " Viajes: " + coche_a.viajes;

```
