#Command Line

Existen distintos paquetes para emulación de terminales, uno muy chulo es [terminator](../Software/terminal/terminator.md)


##Prompt
El indicador en la parte izquierda de donde podemos escribir:

```
linux@debian:~$ _
```

Normalmente el prompt se define como: username@hostname:path$

En el prompt podemos utilizar:

- **Ctrl + a** → inicio de la línea
- **Ctrl + e** → fin de la línea
- **Ctrl + w** → borra una palabra
- **Ctrl + y** → Pega esa palabra
- **Ctrl + l** → borra la pantalla
- **Ctrl + cursor dcha / izda** → avanza/retrocede por las palabras
- **Ctrl + k** → borra desde el cursor hasta el final de linea
- **Ctrl + u** → borra desde el cursor hasta el principio de linea
- **Ctrl + y** → pega lo  borrado
- **Ctrl + j** → equivale a la tecla Enter
- **Ctrl + d** → finaliza la sesión
- **Ctrl + c** → hace un “break” para interrumpir el proceso
- **Ctrl + z** → detiene un proceso y lo deja “congelado”
- **Ctrl + r** → busca en la historia del comando history
- **Shift + ret.pag/av.pag** → hace scroll
- [**Otros Atajos básicos en Bash**](Atajos Bash - Básico.md)

En el prompt, el símbolo ~ (altgr + ñ) indica siempre la home del usuario logueado.

La tecla tab rellena comandos, archivos, directorios etc, usarla para ayuda



##man
Para obtener ayuda acerca de un comando miramos las páginas del manual:
`man ls` → pág. del manual para el comando ls

Dentro de man podemos usar:
    
    q → Salir
    / → Buscar en páginas
        n → siguiente resultado
        Shift + n → buscar hacia atrás



##Estructura de una orden de comandos
```
ls -lisa *.*
|     |   |
|     |    \ args
\     \ flags
 \ Comando
```

##standard input, standard output y standard error

-  Stdin → 0 (Entrada) → normalmente el teclado
-  Stdout → 1 (Salida) → normalmente por pantalla
-  Stderr → 2 (Salida de error) → normalmente por pantalla

##Comandos Básicos

`ls`

**-l** formato de lista largo

```
    - indica que es un fichero
    d- indica que es un directorio
    l - links
    s - sockets
    p - pipes o tuberías
    c - character devices (teclado, ratón)
    b - block devices ( pendrive, hd)
```

-la imprime los nombres de ficheros ocultos por comenzar con un .

-lart ordena los ficheros por fecha y la r invierte dicho orden

`pwd` --> Indica el path absoluto de donde estamos en este momento.

    /home/linux 

En Linux todo cuelga del directorio raiz /

`cd` --> cambiar de directorio

`cd -` --> nos devuelve al directorio anterior donde estábamos

`cd` sin nada nos devuelve al home del usuario

`file <nombre del fichero>` --> Indica el tipo de fichero

`mkdir` / `rmdir` --> crear / eliminar directorios
    
    cd /tmp
    mkdir cesta/fruta/peras (No funciona)
    mkdir -p cesta/fruta/peras (El parametro -p de parent permite hacerlo)

pueden utilizarse rangos:

    mkdir -p cesta/fruta/{peras,manzanas}/kaka
    mkdir -p cesta/fruta/{1,2,3}/kaka

`cp` --> Copia de ficheros 
    
    cp origen destino

`mv` --> Elimina el fichero de origen

`touch filename` --> crea un archivo

`rm -rf <directory>` --> borra el directorio y todo lo que contiene de forma recursiva y forzada. !ojo!

Otros [comandos básicos relacionados con la gestión de archivos](/LPIC1/Comandos%20Linux/#gestionar-archivos-y-directorios)