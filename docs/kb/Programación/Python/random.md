# Random

```python
import random

numeros = [1,2,3,4,5,6]

# Seleccionar un elemento aleatorio (tirar el dado):
print (random.choice(numeros))
print (random.choice(numeros))
print (random.choice(numeros))

# Obtener una muestra
print (random.sample(numeros,2))
print (random.sample(numeros,3))
print (random.sample(numeros,3))
print (random.sample(numeros,3))

# Barajar
random.shuffle(numeros)
print (numeros)
random.shuffle(numeros)
print (numeros)

# Generar enteros aleatorios entre 0 y 10
print (random.randint(0,10))
print (random.randint(0,10))
print (random.randint(0,10))

# Generar reales aleatorios entre 0 y 1
print(random.random())
print(random.random())
print(random.random())

# Generar n bits aleatorios como entero:
print(random.getrandbits(128))
print(random.getrandbits(256))
print(random.getrandbits(512))
print(random.getrandbits(1024))
```