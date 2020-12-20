# Eclipse

## Agregar diccionario ortográfico Español a Eclipse

Podemos aprovechar este diccionario

http://www.winedt.org/dict/es.zip

Lo descomprimimos en la carpeta de eclipse

Vamos a "Window", "Preferences", buscamos "Spell" en las preferencias

![Instalar Diccionario Español Eclipse](assets/Eclipse_spell_diccionario_espa.png)

* Seleccionamos "None" en "Platform dictionary" y en "User defined dictionary" hacemos "Browse" y seleccionamos el diccionario descargado.

## Activar pep8/pycodestyle en Eclipse Pydev

Si a pesar de activarlo en las opciones Settings -> PyDev -> Editor -> Code Analysis , sigue sin funcionar, probar esto:

* Project->Properties-> Pydev-Path-> seleccionar el subdirectorio del proyecto como "Source folder"
* Salir y reiniciar Eclipse

