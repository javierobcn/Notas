# Strings

## Interpolar variables sobre cadenas de caracteres

```python
texto_formato = 'La versión mas reciente de {lenguaje} hoy {fecha} es {version}'

lenguaje = 'Python'
fecha = '2020/12/26'
version = '3.9.1'

print(texto_formato.format(lenguaje=lenguaje,fecha=fecha,version=version))
```
