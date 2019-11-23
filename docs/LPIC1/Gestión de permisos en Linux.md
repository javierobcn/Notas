##Algunos enlaces interesantes
http://www.ite.educacion.es/formacion/materiales/85/cd/linux/m1/permisos_de_archivos_y_carpetas.html

GRAPH explicativo sobre los permisos de los ficheros: 
http://mural.uv.es/oshuso/p1.jpg

##Ver permisos 

    :::bash
    ls -l 
    total 40
    drwxr-xr-x  2 root root  4096 jul  4 11:33 backups
    drwxr-xr-x 13 root root  4096 jun 24 13:13 cache
    drwxr-xr-x  2 root root  4096 jun 24 13:15 games
    drwxr-xr-x 61 root root  4096 jun 26 17:48 lib
    drwxrwsr-x  2 root staff 4096 may 30 06:18 local
    lrwxrwxrwx  1 root root     9 jun 24 12:26 lock -> /run/lock
    drwxr-xr-x 12 root root  4096 jul  4 11:33 log
    drwxrwsr-x  2 root mail  4096 jul  1 19:08 mail
    drwxr-xr-x  2 root root  4096 jun 24 12:26 opt
    lrwxrwxrwx  1 root root     4 jun 24 12:26 run -> /run
    drwxr-xr-x  8 root root  4096 jun 24 13:13 spool
    drwxrwxrwt 24 root root  4096 jul  4 12:12 tmp

En la primera columna: tipo de fichero puede ser d f o l (directorio, fichero o link)

A continuación hay 3 bloques de 3 caracteres con la siguiente correspondencia numérica:

r Lectura → 4

w Escritura → 2

x Ejecución → 1

1er bloque → Usuario propietario → o

2º bloque → grupo → g

3er bloque  → Resto del mundo → u

### Tabla de relaciones de taquigrafía numérica de permisos VS significado en binario: 

```
Cód Binario   Permisos efectivos
0   0 0 0       - - -                                      
1   0 0 1       - - x
2   0 1 0       - w -
3   0 1 1       - w x
4   1 0 0       r - -
5   1 0 1       r - x
6   1 1 0       r w -
7   1 1 1       r w x

r = lectura   ==  4                
w = escritura ==  2                
x = ejecución ==  1               
----------------------------------
        TOTAL =   7

- rwx rwx rwx
    \  \   \                                   
     \  \   \===>  permisos para resto de usuarios 
      \  \===> permisos para grupo del fichero
       \===> permisos para propietario del fichero

```

En el siguiente fichero:

    -rwxr-xr-x linux linux 5343 filename.blah

Vemos que tiene permisos de lectura, escritura y ejecución para el propietario, solo lectura y ejecución para el grupo al que pertenece y lo mismo para el resto de usuarios. 

###Permisos especiales: 

-  **+s** SUID Bit: Hara que ese fichero se ejecute como el propietario al que pertenece. Los programas SUID están indicados con una s en sus permisos de propietario: rwsr-xr-x, si aparece una S mayúscula es que no hay permisos de ejecución asignados al fichero ejecutable.

-  **+g** GID Bit:  Hara que ese fichero se ejecute como el grupo al que pertenece. Además si aplicamos este bit al directorio, cualquier archivo creado en dicho  directorio, tendrá asignado el grupo al que pertenece el directorio. Se indica mediante una s en la posición del bit de ejecución , si la S aparece mayúscula está indicando que el fichero no tiene permnisos de ejecución.

-  **+t** Sticky Bit: El Sticky bit se utiliza para permitir que cualquiera pueda escribir y  modificar sobre un archivo o directorio, pero que solo su propietario o  root pueda eliminarlo. Viene indicado por una t en la posición del bit de ejecución de los permisos para "otros usuarios" o generales.

##Cambiar los permisos de un fichero

###chmod

```bash
chmod a+rx <filename> 
chmod u+rw <filename> 
chmod ug+rwx <filename>
touch <file> # crea fichero en blanco
chmod 000 filename.txt # quita permisos a un fichero
chmod -R # recursivo 
chmod -R 755 /var/www/website.com/includes/ # recursivo
chmod -R 740 /etc/  → le cambia los permisos a la carpeta
chmod -R 740 /etc/* # le cambia los permisos a lo que contiene la carpeta, ojo con los ficheros .htaccess o . algo que no entrarían y deberiamos ejecutar a posteriori: 
chmod -R 740 /etc/.ht*
chmod -R 755 /path/to/dir # directorio y los archivos recursivo.
```

Otra forma de especificar permisos es nombrando con una letra el bloque de usuarios y especificando con + o -  si quitamos o agregamos el permiso, por ej.
    
    :::bash
    chmod u-rwx archivo
    chmod g+rwx archivov

-  u – dueño: dueño del fichero o directorio
-  g – grupo: grupo al que pertenece el fichero
-  o – otros: todos los demás usuarios que no son el dueño ni del grupo
-  a – todos: incluye al dueño, al grupo y a otros

chmod -r fichero le quita el permiso read a todos
chmod +x fichero le asigna el permiso execute a todos

###chown, chgrp
Cambiar el propietario y/o grupo de un fichero

chown -R www-data: /var/www/
chown www-data:ftpgroup /var/www/blabla.net/htdocs/


 
lsattr --> lista atributos de un fichero

chattr --> cambia atributos de un fichero

chgrp  --> para cambiar solo el grupo

chown user:group archivo → cambia el usuario y el grupo al archivo

chown user: fichero → cambia tanto el grupo como el usuario propietario a user


selinux → implementación de la NSA para máxima seguridad

###Permisos malos 
777, 666, 555

###Permisos bien o normales
700, 750, 644

###Permiso de ejecución en carpetas
El permiso de ejecución en una carpeta es el que define si un usuario puede hacer un cd a esa carpeta


stat filename →  el comando stat muestra un resumen de las fechas 

touch filename → modifica las fechas o crea el archivo si no existe



### Máscara de usuario (user mask)

umask --> es una orden y una función en entornos POSIX que establece los permisos por defecto para los nuevos archivos y directorios creados por el proceso actual. Actua a modo de resta. Cualquier bit definido en umask se elimina al crear los archivos.

Por ej. umask 044 aplica al usuario que cuando creamos ficheros se crearán con 666 - 044 = 622 Por defecto umask está establecido a 022

umask -S ver literalmente lo que va a quitar.

Samba tiene una máscara y es importante este umask

###Atributos

`lsattr` --> permite listar los atributos asignados a los ficheros de un sistema de ficheros Linux, mientras que chattr permite modificar dichos atributos, los cuales que utilizamos como complemento al sistema de ACLs (chmod, chown,setfacl…) permitiendo un control más férreo sobre los archivos del filesystem

Algunos ejemplos de atributos:

a  solo permite agregar datos

c el kernel comprime y descomprime datos al vuelo

A no modifica el tiempo de acceso a un fichero

chattr +i <file> lo hace inmutable, root no podrá borrar el fichero

si ejecutamos umask veremos algo como 0022 (el primer 0 se refiere a los permisos especiales:

SUID bit +S 

SGID  bit +G

Sticky bit +C - solo el propietario podrá borrar el fichero

ls -la /usr/bin/passwd
-rwsr-xr-x 1 root root 54256 mar 29  2016 /usr/bin/passwd

Tiene el +S seteado por lo que el binario se ejecutará como el propietario al que pertenece

por ej. /tmp/ tiene el +t seteado y esto indica que solo el propietario (root) podrá borrarlo.

Para scripts de usuarios que tiene que ejecutar un usuario pero ha de ejecutar comandos de root

en forensics se suele hacer Find de los suid en todos los usuarios


```