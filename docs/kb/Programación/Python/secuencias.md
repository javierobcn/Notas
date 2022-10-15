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
