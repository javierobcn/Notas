# Formatear datos de fecha y hora
```python
import locale
from datetime import datetime
from locale import setlocale

# Esta línea especifica que los nombres de los meses y dias se mostrarán en el idioma definido por el usuario en sus preferencias locales
locale.setlocale(locale.LC_ALL, '')

ahora_mismo = datetime.now()
print(ahora_mismo)
print()

# formatear fechas
print(ahora_mismo.strftime('%Y'))
print(ahora_mismo.strftime('%m'))
print(ahora_mismo.strftime('%d'))
print(ahora_mismo.strftime('%H:%M:%S'))
print(ahora_mismo.strftime('%I:%M:%S'))
print(ahora_mismo.strftime('%Y-%m-%d, %H:%M:%S'))
print(ahora_mismo.strftime('%Y-%b-%A, %H:%M:%S'))

# 2020-12-28 00:03:09.567142

# 2020
# 12
# 28
# 00:03:09
# 12:03:09
# 2020-12-28, 00:03:09
# 2020-dic-lunes, 00:03:09

```

## Lista con todos los códigos de formato
https://docs.python.org/3/library/datetime.html?highlight=strftime#strftime-and-strptime-format-codes


