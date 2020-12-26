# Operaciones precisas

```python

from decimal import Decimal
from decimal import localcontext

# Operaciones Standard
numero_1 = 4.2
numero_2 = 2.1

suma = numero_1 + numero_2

print (suma)
print (suma == 6.3)

# Uso de la clase Decimal para operaciones precisas:
numero_1 = Decimal('4.2')
numero_2 = Decimal('2.1')

suma = numero_1 + numero_2

print(suma)
print(suma == Decimal('6.3'))

# Establecer precisión
numero_1 = Decimal('2.3')
numero_2 = Decimal('1.7')

division = numero_1 / numero_2

print(division)

with localcontext() as ctx:
    ctx.prec = 5
    division = numero_1 / numero_2
    print(division)

    ctx.prec = 75
    division = numero_1 / numero_2
    print(division)

6.300000000000001
False
6.3
True
1.352941176470588235294117647
1.3529
1.35294117647058823529411764705882352941176470588235294117647058823529411765


```

