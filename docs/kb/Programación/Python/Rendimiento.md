# Rendimiento

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

```

12.958271980285645 Segundos Total Suma: 4999999950000000
1.2130687236785889 Segundos Total Suma: 4999999950000000
0.6307775974273682 Segundos Total Suma: 4999999950000000

Las funciones integradas o específicas tienen la ventaja de que la mayor parte
de los cálculos se realizan en C siendo mucho mas rápidas que si nosotros hacemos
los cálculos en python.

