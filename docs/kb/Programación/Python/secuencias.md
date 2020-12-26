# Secuencias

Listas y Tuplas son objetos que contienen listas de datos a los que se accede mediante un índice, son similares a los arrays en otros lenguajes. Perteneecen a un tipo de datos que Python llama "Secuencias" y que incluye también a las cadenas de texto.

Todas las secuencias tienen algunas características comunes:

* No hay un límite a la cantidad de elementos que pueden contener.
* Pueden contener cualquier tipo de objeto, incluyendo otras secuencias. Por ejemplo, la forma de crear una matriz en Python es crear una lista de listas.
* No es necesario saber el tamaño (cantidad de elementos) que tendrá la secuencia al momento de crearla.
* Soportan algunas funciones nativas de python:
  * ```len(secuencia)```: devuelve la cantidad de elementos de la lista, tupla o cadena.
  * ```max(secuencia)```: devuelve el mayor elemento.
  * ```min(secuencia)```: devuelve el menor elemento.

* Tienen dos métodos comunes:
  * ```secuencia.index(‘x’)```: devuelve el índice de la primera ocurrencia de ‘x’ en la secuencia.
  * ```secuencia.count(‘x’)```: devuelve el número de veces que aparece ‘x’ en la secuencia

* Los elementos de la secuencia se acceden vía subíndices, que se indican entre corchetes [] después del nombre de la variable que contiene a la secuencia:
  * ```secuencia[0]```: devuelve el primer elemento
  * ```secuencia[2]```: devuelve el tercer elemento (notar que se numeran desde 0 y no desde 1).
  * ```secuencia[i]```: devuelve el elemento i-1 de la secuencia.
  * ```secuencia[-1]```: devuelve el último elemento.

## Listas

Las listas en Python son equivalentes a los arreglos en PHP o en Javascript. Para crear una lista, simplemente se declaran sus elementos entre corchetes:

```python
mi_lista = [1, 'b', 'd', 23]
mi_lista_vacia = [] # crea una lista sin elementos
```

Para agregar elementos a una lista, se utiliza el método append:

```python
mi_lista.append(10)
print mi_lista
[1, 'b', 'd', 23, 10]
```

Para modificar un elemento particular de una lista, se asigna el nuevo valor al subíndice correspondiente:

```python
mi_lista[0] = 2
print mi_lista
[2, 'b', 'd', 23, 10]
```

Incluso se pueden reemplazar trozos de una lista con otra, o con trozos de otra, usando la notación de rebanadas (slices):

```python
mi_lista[0:2] = [3, 4] # reemplazar los dos primeros elementos de la lista con los elementos de [3, 4]
print mi_lista
[3, 4, 'd', 23, 10]
```

Es importante notar que lo anterior no es lo mismo que asignar una secuencia entera a un índice:

```python
mi_lista[0] = [3, 4] # el primer elemento de mi_lista es ahora la lista [3, 4]
print mi_lista
[[3, 4], 4, 'd', 23, 10]
```

Se puede comprobar si un elemento pertenece o no a una secuencia con los operadores in y not in.

```python
2 in lista
True
8 not in lista
True
```

Las listas poseen algunos métodos propios: se puede eliminar un elemento con mi_lista.remove(), reordenar la lista con mi_lista.sort(), o invertir el orden de sus elementos con mi_lista.reverse().

Todas las secuencias pueden ser transformadas a listas usando la función list().

## Tuplas

Las tuplas son como las listas, excepto que son inmutables (sus elementos no pueden ser modificados). Se identifican fácilmente porque en vez de usar corchetes, se definen entre paréntesis. En lo demás, funcionan igual a las listas y al resto de las secuencias.

## Diccionarios

Un Diccionario es una estructura de datos y un tipo de dato en Python con características especiales que nos permite almacenar cualquier tipo de valor como enteros, cadenas, listas e incluso otras funciones. Estos diccionarios nos permiten además identificar cada elemento por una clave (Key).

Para definir un diccionario, se encierra el listado de valores entre llaves. Las parejas de clave y valor se separan con comas, y la clave y el valor se separan con dos puntos.

```python
diccionario = {'nombre' : 'Carlos', 'edad' : 22, 'cursos': ['Python','Django','JavaScript'] }
```

## Recetas

### Crear variables independientes para cada elemento de una secuencia

```python
tupla = (1,2)
a,b = tupla
print(a,b)

lista = ['Python',3,(2,3,),'P']
a,b,c,d = lista
print(a,b,c,d)

```

### Obtener el resto de elementos de una secuencia

```python
tupla = (1,2,5,7)
a,b, *c = tupla
print(a,b,c)

1 2 [5, 7]

lenguaje = 'Python'
var1,var2,*var3 = lenguaje
print(var1, var2, var3)

```

### Obtener los elementos mas frecuentes en una lista

```python
from collections import Counter

numeros = [1,4,5,4,6,6,6,3,2,1,1,4,5,11,3,1]
contador = Counter(numeros)

print (contador.most_common(3))

[(1, 4), (4, 3), (6, 3)]

frase = "Python es extremadamente potente"
contador = Counter(frase)

print (contador.most_common(3))

[('e', 7), ('t', 5), ('n', 3)]

```

### Obtener una cantidad n de elementos mínimos o máximos

```python
import heapq

numeros = [1,4,5,6,11]

print (heapq.nsmallest(3, numeros))
print (heapq.nlargest(3, numeros))
[1, 4, 5]
[11, 6, 5]

productos = [
  {'nombre':'Mouse', 'precio':45},
  {'nombre':'Teclado', 'precio':145},
  {'nombre':'Monitor', 'precio':175},
  {'nombre':'Altavoces', 'precio':70},
  {'nombre':'Cable corriente', 'precio':30}
]

mas_barato = heapq.nsmallest(1, productos, key=lambda p: p['precio']) 
print (mas_barato)

mas_caro = heapq.nlargest(1, productos, key=lambda p: p['precio']) 
print (mas_caro)

mas_baratos = heapq.nsmallest(2, productos, key=lambda p: p['precio']) 
print (mas_baratos)

```

### Diccionario con orden mediante la clase OrderedDict

```python

from collections import OrderedDict

productos = {7:'Mouse', 5:'Teclado',8:'Monitor', 9:'Altavoces',2:'Cable corriente'}

print (OrderedDict(sorted(productos.items(), key=lambda p: p[0]))) # Ordenado por ID
print (OrderedDict(sorted(productos.items(), key=lambda p: p[1]))) # Ordenado por Nombre
print (OrderedDict(sorted(productos.items(), key=lambda p: len(p[1])))) # Ordenado por len(nombre)

OrderedDict([(2, 'Cable corriente'), (5, 'Teclado'), (7, 'Mouse'), (8, 'Monitor'), (9, 'Altavoces')])
OrderedDict([(9, 'Altavoces'), (2, 'Cable corriente'), (8, 'Monitor'), (7, 'Mouse'), (5, 'Teclado')])
OrderedDict([(7, 'Mouse'), (5, 'Teclado'), (8, 'Monitor'), (9, 'Altavoces'), (2, 'Cable corriente')])

```

### Obtener los elementos únicos de una lista

```python
numeros = [7,0,9,76,4,2,4,6,4,7,65,4,3,6,2]
numeros_sin_repetir = set(numeros)
print (numeros_sin_repetir)
print (type(numeros_sin_repetir))
numeros = list(numeros_sin_repetir)
print (numeros)
print (type(numeros))

{0, 65, 2, 3, 4, 6, 7, 9, 76}
<class 'set'>
[0, 65, 2, 3, 4, 6, 7, 9, 76]
<class 'list'>

```

### Uso de la clase UserString

Esta clase se encuentra en el módulo Collections y se utiliza para realizar herencia cuando queremos agregar nuevos comportamientos a la clase string.

```python
from collections import UserString

class StringPersonalizado (UserString):

    def invertir_capitalizacion(self):
        nueva_cadena = []
        
        for c in self:
            nueva_cadena.append(c.lower() if c.isupper() else c.upper())

        return ''.join(str(c) for c in nueva_cadena)

cadena = StringPersonalizado('Python')

print (cadena.invertir_capitalizacion())

pYTHON

```

### Ordenar una lista usando Diferentes Campos

```python

from operator import itemgetter

productos = [
    {'id':1, 'nombre': 'Mouse','precio':35},
    {'id':5, 'nombre': 'Teclado','precio':75},
    {'id':3, 'nombre': 'Altavoz','precio':55},
    {'id':6, 'nombre': 'Monitor','precio':335},
    {'id':4, 'nombre': 'Tablet','precio':435}
]

productos_id = sorted(productos,key=itemgetter('id'))

print (productos_id)

productos_precio = sorted(productos,key=itemgetter('precio'))

print (productos_precio)

[{'id': 1, 'nombre': 'Mouse', 'precio': 35}, {'id': 3, 'nombre': 'Altavoz', 'precio': 55}, {'id': 4, 'nombre': 'Tablet', 'precio': 435}, {'id': 5, 'nombre': 'Teclado', 'precio': 75}, {'id': 6, 'nombre': 'Monitor', 'precio': 335}]

[{'id': 1, 'nombre': 'Mouse', 'precio': 35}, {'id': 3, 'nombre': 'Altavoz', 'precio': 55}, {'id': 5, 'nombre': 'Teclado', 'precio': 75}, {'id': 6, 'nombre': 'Monitor', 'precio': 335}, {'id': 4, 'nombre': 'Tablet', 'precio': 435}]
```

### Ordenar objetos a partir de un campo arbitrario

```python
from operator import attrgetter

class Usuario:

    def __init__(self, identificador, nombre):
        self.identificador = identificador
        self.nombre = nombre

    def __repr__(self):
        return '{} - {}'.format(self.identificador, self.nombre)


usuarios = [Usuario(7,'Eduardo'), Usuario(3,'Daniela'),Usuario(5,'Juan'),Usuario(10,'Silvia')]

print (sorted(usuarios,key=attrgetter('identificador')))
print (sorted(usuarios,key=attrgetter('nombre')))


[3 - Daniela, 5 - Juan, 7 - Eduardo, 10 - Silvia]
[3 - Daniela, 7 - Eduardo, 5 - Juan, 10 - Silvia]

```

### Agrupar elementos de una lista especificando un campo de interés

```python
from operator import itemgetter
from itertools import groupby

productos = [

    {'nombre':'Mouse', 'precio':35, 'fecha_venta': '2020/12/20'},
    {'nombre':'Cable corriente', 'precio':15, 'fecha_venta': '2020/12/20'},
    {'nombre':'Monitor', 'precio':175, 'fecha_venta': '2020/12/22'},
    {'nombre':'Tablet', 'precio':335, 'fecha_venta': '2020/12/22'},
    {'nombre':'Impresora', 'precio':125, 'fecha_venta': '2020/12/22'},
    {'nombre':'Smartphone', 'precio':235, 'fecha_venta': '2020/12/23'},
    {'nombre':'Scanner', 'precio':95, 'fecha_venta': '2020/12/27'},
    {'nombre':'Altavoces', 'precio':95, 'fecha_venta': '2020/12/29'},
]

productos.sort(key=itemgetter('fecha_venta'))

for fecha, elementos in groupby(productos, key=itemgetter('fecha_venta')):
    print(fecha)

    for elemento in elementos:
            print ('    ', elemento)


2020/12/20
     {'nombre': 'Mouse', 'precio': 35, 'fecha_venta': '2020/12/20'}
     {'nombre': 'Cable corriente', 'precio': 15, 'fecha_venta': '2020/12/20'}
2020/12/22
     {'nombre': 'Monitor', 'precio': 175, 'fecha_venta': '2020/12/22'}
     {'nombre': 'Tablet', 'precio': 335, 'fecha_venta': '2020/12/22'}
     {'nombre': 'Impresora', 'precio': 125, 'fecha_venta': '2020/12/22'}
2020/12/23
     {'nombre': 'Smartphone', 'precio': 235, 'fecha_venta': '2020/12/23'}
2020/12/27
     {'nombre': 'Scanner', 'precio': 95, 'fecha_venta': '2020/12/27'}
2020/12/29
     {'nombre': 'Altavoces', 'precio': 95, 'fecha_venta': '2020/12/29'}


```

### Filtrar los elementos de una secuencia

```python
numeros = [5,4,-6,3,-9,8,0,12]

print (numeros)

numeros_positivos = [n for n in numeros if n > 0 ]

print (numeros_positivos)

```

### Extraer un subconjunto de elementos de un diccionario

```python
productos = {
    'Mouse':35,
    'Teclado':75,
    'Altavoz':55,
    'Monitor':335,
    'Tablet':435
}

productos_filtrados = {k:v for k, v in productos.items() if v > 50}

print (productos)
print (productos_filtrados)

{'Mouse': 35, 'Teclado': 75, 'Altavoz': 55, 'Monitor': 335, 'Tablet': 435}
{'Teclado': 75, 'Altavoz': 55, 'Monitor': 335, 'Tablet': 435}

```

### Nombrar los elementos de una tupla a través de namedtuple

```python
from collections import namedtuple

producto = ('Mouse',35)

print (producto[0])
print (producto[1])

Producto = namedtuple('Producto',['nombre','precio'])

producto_1 = Producto('Mouse',35)

print('---------')

print(producto_1.nombre)
print(producto_1.precio)

producto_2 = Producto(nombre='Mouse', precio=35)

nombre,precio = producto_2

print('')

print(producto_2.nombre)
print(producto_2.precio)
```
