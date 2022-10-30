# Rendimiento

## Operaciones Matemáticas

```py

import time
import numpy as np

numbers = 100000000

## Peor rendimiento, el for en C pero la suma en Python

start = time.time()

suma=0

for i in range(1,numbers):
    suma += i

print (time.time()-start,"Segundos","Total Suma:", suma)

## Rendimiento medio, mejor con las funciones integradas

start = time.time()

suma=0

suma = sum(range(1,numbers)) 

print (time.time()-start,"Segundos","Total Suma:", suma)

## Alto rendimiento con funciones específicas de numpy - la mayor parte en C

start = time.time()

suma=0

suma = np.nansum(np.arange(1,numbers))

print (time.time()-start,"Segundos","Total Suma:", suma)


# 12.958271980285645 Segundos Total Suma: 4999999950000000
# 1.2130687236785889 Segundos Total Suma: 4999999950000000
# 0.6307775974273682 Segundos Total Suma: 4999999950000000


```

Las funciones integradas o específicas tienen la ventaja de que la mayor parte
de los cálculos se realizan en C siendo mucho mas rápidas que si nosotros hacemos
los cálculos en python.

## Métodos de acceso "punto" .

Al eliminar el método de acceso "punto" mejoramos el rendimiento

```py
import math
import time

def raices(numeros):
    resultado = []

    for numero in numeros:
        resultado.append(math.sqrt(numero))

    return resultado

def raices_mejorado(numeros):
    from math import sqrt
    raiz = sqrt # Dimensionamos variable local que tiene mejor rendimiento
    resultado = [] 
    add = resultado.append # Realizamos esta operación fuera del ciclo

    for numero in numeros:
        add(raiz(numero))

    return resultado


def main():
    timestart = time.time()
    numeros = range(1000000)
    
    for i in range(100):
        r = raices(numeros)

    print("Tiempo no optimizado: " + str(time.time()-timestart))

    timestart = time.time()

    for i in range(100):
        r = raices_mejorado(numeros)
    
    print("Tiempo optimizado: " + str(time.time()-timestart))

if __name__ == "__main__":
    main()    

# Tiempo no optimizado: 26.672093629837036
# Tiempo optimizado: 16.61163568496704
```
