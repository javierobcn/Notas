#Command Line

Existen distintos paquetes para emulación de terminales, uno muy chulo es [terminator](../Software/terminator.md)


##Prompt
El indicador en la parte izquierda donde podemos escribir:

```
linux@debian:~$ _
```

Normalmente el prompt se define como: username@hostname:path$

!!! note
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

##Atajos Bash - Básico

|Comando|Función|
|------|-------|
|Ctrl-a|    Mueve al principio de la linea|
|Ctrl-e|    Mueve al final de la linea.|
|Ctrl-b|    Move back one character.|
|Alt-b|     Move back one word.|
|Ctrl-f|    Move forward one character.|
|Alt-f|     Move forward one word.|
|Ctrl-] x|  Where x is any character, moves the cursor forward to the next occurance of x.|
|Alt-Ctrl-] x|  Where x is any character, moves the cursor backwards to the previous occurance of x.|
|Ctrl-u|    Delete from the cursor to the beginning of the line.|
|Ctrl-k |   Delete from the cursor to the end of the line.|
|Ctrl-w |   Delete from the cursor to the start of the word.|
|Esc-Del |  Delete previous word (may not work, instead try Esc followed by Backspace)|
|Ctrl-y|    Pastes text from the clipboard.|
|Ctrl-l |   Clear the screen leaving the current line at the top of the screen.|
|Ctrl-x Ctrl-u |    Undo the last changes. Ctrl-_ does the same|
|Alt-r |    Undo all changes to the line.|
|Alt-Ctrl-e |   Expand command line.|
|Ctrl-r |   Incremental reverse search of history.|
|Alt-p |    Non-incremental reverse search of history.|
|!! |   Execute last command in history|
|!abc|  Execute last command in history beginning with abc|
|!abc:p |   Print last command in history beginning with abc|
|!n|    Execute nth command in history|
|!$ |   Last argument of last command|
|!^ |   First argument of last command|
|^abc^xyz|  Replace first occurance of abc with xyz in last command and execute it |

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




## History Expansion

Cursores arriba/abajo navegar entre la historia

`History`  Ver el historial de comandos ejecutados

**Ctrl + R** y comienza a teclear un comando para ver los resultados

`ls /etc/passwd`

`^ls^vim^` → cambia el comando ls por vim en el último comando ejecutado

`!!` → ejecuta el último comando otra vez

`!34` → Ejecuta el comando 34 del historial

`!-5` → ejecuta el comando “hace 5 comandos”

`!?apache` → ejecuta el último comando que contiene apache

http://www.thegeekstuff.com/2011/08/bash-history-expansion/

## Recopilación de comandos Linux
###Información del sistema
|Comando|Función|
|------|-------|
|`arch`|mostrar la arquitectura de la máquina (1).
|uname -m | mostrar la arquitectura de la máquina (2).
|uname -r | mostrar la versión del kernel usado.
|uname -a | mostrar la información completa.
|lsb_release -a | mostrar la información completa de la distribución.
|cat /etc/issue | mostrar el nombre de la distribución
|dmidecode -q | mostrar los componentes (hardware) del sistema.
|hdparm -i /dev/hda | mostrar las características de un disco duro.
|hdparm -tT /dev/sda | realizar prueba de lectura en un disco duro.
|cat /proc/cpuinfo | mostrar información de la CPU.
|grep -c ^processor /proc/cpuinfo | mostrar número de procesadores.
|cat /proc/interrupts | mostrar las interrupciones.
|cat /proc/meminfo | verificar el uso de memoria.
|cat /proc/swaps | mostrar ficheros swap.
|cat /proc/version | mostrar la versión del kernel.
|cat /proc/net/dev | mostrar adaptadores de red y estadísticas.
|cat /proc/mounts | mostrar el sistema de ficheros montado.
|lscpu | mostrar información sobre el microprocesador.
|lspci -tv | mostrar los dispositivos PCI.
|lsusb -tv | mostrar los dispositivos USB.
|lshw | listar el hardware.
|discover | listar el hardware.
|date | mostrar la fecha del sistema.
|cal 2011 | mostrar el almanaque de 2011.
|cal 07 2011 | mostrar el almanaque para el mes julio de 2011.
|date 041217002011.00 | colocar (declarar, ajustar) fecha y hora.
|clock -w | guardar los cambios de fecha en la BIOS.
|blkid | mostrar información (nombre, etiqueta, UUID, tipo de partición) sobre los dispositivos de bloque (discos rígidos, etc.)

###Apagar, reiniciar o cerrar sesión
|Comando|Función|
|------|-------|
|shutdown -h now | apagar el sistema (1).
|init 0 | apagar el sistema (2).
|telinit 0 | apagar el sistema (3).
|halt | apagar el sistema (4).
|poweroff | apagar sistema (5).
|shutdown -h hours:minutes & | apagado planificado del sistema.
|shutdown -c | cancelar un apagado planificado del sistema.
|shutdown -r now | reiniciar (1).
|reboot | reiniciar (2).
|logout | cerrar sesión.
|skill nombre_de_usuario | cerrar sesión (2)1)
|exit | salir del intérprete de comandos (si solo hay uno, equivale a cerrar sesión).

###Gestionar archivos y directorios
|Comando|Función|
|------|-------|
|cd | ir al directorio personal.
|cd /home | cambiar al directorio “/home”.
|cd .. | retroceder un nivel.
|cd ../.. | retroceder 2 niveles.
|cd ~user1 | ir al directorio user1.
|cd - | ir (regresar) al directorio anterior.
|pwd | mostrar el camino del directorio actual.
|ls | listar el contenido de un directorio.
|ls -F | listar el contenido de un directorio (distinguiendo los directorios con una barra)
|ls -l | listar el contenido de un directorio, mostrando los detalles.
|ls -lh | listar el contenido de un directorio, mostrando los detalles (y el tamaño en un formato “humanizado”).
|ls -a | listar el contenido de un directorio, incluendo los ficheros ocultos.
|ls *[0-9] | listar los ficheros y carpetas que contienen números.
|ls -laR | less | listar recursivamente el contenido del directorio actual y todos los subdirectorios y archivos, incluyendo los ocultos, separados por página.
|tree | mostrar los ficheros y carpetas en forma de árbol comenzando por la raíz.(1)
|lstree | mostrar los ficheros y carpetas en forma de árbol comenzando por la raíz.(2)
|mkdir dir1 | crear un directorio de nombre ‘dir1’.
|mkdir dir1 dir2 | crear dos directorios a la vez (en la ubicación actual).
|mkdir -p /tmp/dir1/dir2 | crear una estructura de directorios, si no existe.
|rm file1 | eliminar el archivo ‘file1’.
|rm -f file1 | eliminar el archivo ‘file1’ en modo forzado.
|rmdir dir1 | borrar el directorio ‘dir1’.
|rm -rf dir1 | eliminar recursivamente y en modo forzado el directorio ‘dir1’ con todo lo que contenga.
|rm -rf dir1 dir2 | borrar dos directorios con su contenido de forma recursiva.
|mv dir1 new_dir | renombrar o mover un fichero o carpeta (directorio).
|cp file1 destino/ | copiar un fichero al destino elegido.
|cp file1 file2 destino/ | copiar a la vez dos ficheros a un mismo directorio.
|cp file1 file2 | copiar file1 en file2.
|cp dir /* . | copiar todos los ficheros de un directorio dentro del directorio de trabajo actual.
|cp -a /tmp/dir1 . | copiar un directorio dentro del directorio actual de trabajo.
|cp -a dir1 | copiar un directorio.
|cp -a dir1 dir2 | copiar dos directorio al unísono.
|ln -s file1 lnk1 | crear un enlace simbólico al fichero o directorio.
|ln file1 lnk1 | crear un enlace físico al fichero o directorio.
|touch file1 | actualizar la fecha de modificación de file1, o crearlo si no existe.
|touch -t 0712250000 file1 | modificar el tiempo real (tiempo de creación) de un fichero o directorio.
|file file1 | salida (volcado en pantalla) del tipo mime de un fichero texto.
|iconv -l | listas de cifrados conocidos.
|iconv -f fromEncoding -t toEncoding inputFile > outputFile | crea una nueva forma del fichero de entrada asumiendo que está codificado en fromEncoding y convirtiéndolo a ToEncoding.

###Encontrar archivos
|Comando|Función|
|------|-------|
|find / -name file1 | buscar fichero y directorio a partir de la raíz del sistema.
|find / -user user1 | buscar ficheros y directorios pertenecientes al usuario “user1”.
|find /home/user1 -name \*.bin | buscar ficheros con extensión ”. bin” dentro del directorio / home/user1.
|find /usr/bin -type f -atime +100 | buscar ficheros binarios no usados en los últimos 100 días.
|find /usr/bin -type f -mtime -10 | buscar ficheros creados o cambiados dentro de los últimos 10 días.
|find / -name \*.rpm -exec chmod 755 '{}' \; | buscar ficheros con extensión ”.rpm” y modificar permisos.
|find . -type f -print0 | xargs -0 chmod 644 | modificar recursivamente los permisos a todos los ficheros bajo el directorio actual.2)
|find / -xdev -name \*.rpm | Buscar ficheros con extensión ‘.rpm’ ignorando los dispositivos removibles como cdrom, pen-drive, etc.…
|find . -maxdepth 1 -name *.jpg -print -exec convert "{}" -resize 80×60 "thumbs/{}" \; | agrupar ficheros redimensionados en el directorio actual y enviarlos a directorios en vistas de miniaturas (requiere convertir desde Imagemagick).
|find /tmp/dir1 -depth -regextype posix-extended -regex '.*(\s+|:+|\\+|>+|<+|"+|\*+|\?+|\|+).*' -execdir rename 's/(\s+|:+|\\+|>+|<+|”+|\*+|\?+|\|+)/_/g' "{}" \; | renombrar recursivamente todos los directorios y ficheros bajo /tmp/dir1, cambiando los espacios y otros caracteres extraños por guiones bajos.
|locate \*.ps | encuentra ficheros con extensión ”.ps” ejecutados primeramente con el command updatedb.
|whereis halt | mostrar la ubicación de un fichero binario, de ayuda o fuente. En este caso pregunta dónde está el comando halt.
|which comando | mostrar la ruta completa a un comando.

###Montando un sistema de ficheros
|Comando|Función|
|------|-------|
|mount /dev/hda2 /mnt/hda2 | montar un disco llamado hda2. Verifique primero la existencia del directorio ‘/ mnt/hda2’; si no está, debe crearlo.
|umount /dev/hda2 | desmontar un disco llamado hda2. (Antes es necesario salir del punto ‘/mnt/hda2’.
|fuser -km /mnt/hda2 | forzar el desmontaje cuando el dispositivo está ocupado.
|umount -n /mnt/hda2 | correr el desmontaje sin leer el fichero /etc/mtab. Útil cuando el fichero es de solo lectura o el disco duro está lleno.
|mount /dev/fd0 /mnt/floppy | montar un disco flexible (floppy).
|mount /dev/cdrom /mnt/cdrom | montar un cdrom / dvdrom.
|mount /dev/hdc /mnt/cdrecorder | montar un cd regrabable o un dvdrom.
|mount /dev/hdb /mnt/cdrecorder | montar un cd regrabable / dvdrom (un dvd).
|mount -t udf,iso9660 -o loop file.iso /mnt/cdrom | montar un fichero de imagen de un medio óptico (como un CD o DVD en formato ISO).
|mount -t vfat /dev/hda5 /mnt/hda5 | montar un sistema de ficheros FAT32.
|mount -t ntfs-3g /dev/hda5 /mnt/hda5 | montar un sistema de ficheros NTFS.
|mount /dev/sda1 /mnt/usbdisk | montar un usb pen-drive o una memoria (sin especificar el tipo de sistema de ficheros).

###Espacio en disco
|Comando|Función|
|------|-------|
|df -h | mostrar una lista de las particiones montadas.
|ls -lSr | more | mostrar el tamaño de los ficheros y directorios ordenados por tamaño.
|du -sh dir1 | Estimar el espacio usado por el directorio ‘dir1’.
|du -sk * | sort -nr | mostrar en orden descendente el tamaño de los ficheros y subdirectorios en la ubicación actual, en KiB.
|du -h --max-depth=1 | sort -nr | mostrar en orden descendente el tamaño de todos los subdirectorios en la ubicación actual, usando unidades de medida adaptables.
|du -k --max-depth=1 | sort -k1 -nr | awk '{printf "%.3f GiB\t%s\n", $1/(1048576), $2}' | less | mostrar en orden descendente el tamaño de los directorios y archivos, en GiB.
|rpm -q -a --qf '%10{SIZE}t%{NAME}n' | sort -k1,1n | mostrar el espacio usado por los paquetes rpm instalados organizados por tamaño (Fedora, Redhat y otros).
|dpkg-query -W -f='${Package}\t${Installed-Size}\n' | sort -k 2 -nr | grep -v deinstall | head -n 25 | awk '{printf "%.3f MB\t%s\n", $2/(1024), $1}‘ | mostrar (en Debian o derivadas) un listado con los 25 paquetes instalados que más espacio consumen (en orden descendente).

###Usuarios y grupos
|Comando|Función|
|------|-------|
|groupadd nombre_del_grupo | crear un nuevo grupo.
|groupdel nombre_del_grupo | borrar un grupo.
|groupmod -n nuevo_nombre_del_grupo viejo_nombre_del_grupo | renombrar un grupo.
|adduser usuario1 | Crear un nuevo usuario, mediante un asistente.
|useradd -c "Nombre Apellido" -g admin -d /home/usuario1 -s /bin/bash usuario1 | Crear un nuevo usuario perteneciente al grupo “admin”.
|useradd usuario1 | crear un nuevo usuario.
|userdel -r usuario1 | borrar un usuario, eliminando su directorio Home.
|usermod -c "Usuario de FTP" -g system -d /ftp/usuario1 -s /sbin/nologin usuario1 | cambiar los atributos de un usuario.
|usermod -aG plugdev,dialout,pip user1 | agregar el usuario user1 a otros grupos existentes, para incrementar sus permisos (en este caso, agregar la posibilidad de conectar dispositivos, configurar y utilizar el modem)
|passwd | cambiar contraseña.
|passwd usuario1 | cambiar la contraseña de ‘usuario1’ (solamente ejecutable como superusuario).
|chage -E 2011-12-31 user1 | colocar un plazo para la contraseña del usuario. En este caso dice que la clave expira el 31 de diciembre de 2011.
|pwck | chequear la sintaxis correcta el formato de fichero de ‘/etc/passwd’ y la existencia de usuarios.
|grpck | chequear la sintaxis correcta y el formato del fichero ‘/etc/group’ y la existencia de grupos.
|newgrp grupo1 | registra a un nuevo grupo para cambiar el grupo predeterminado de los ficheros creados recientemente.

###Permisos en ficheros (usar «+» para colocar permisos y «-» para eliminar)
|Comando|Función|
|------|-------|
|ls -lh | Mostrar permisos.
|ls /tmp | pr -T5 -W$COLUMNS | dividir la terminal en 5 columnas.
|chmod ugo+rwx directory1 | colocar permisos de lectura ®, escritura (w) y ejecución(x) al propietario (u), al grupo (g) y a otros (o) sobre el directorio ‘directory1’.
|chmod go-rwx directory1 | quitar permiso de lectura ®, escritura (w) y (x) ejecución al grupo (g) y otros (o) sobre el directorio ‘directory1’.
|chown user1 file1 | cambiar el dueño de un fichero.
|chown -R user1 directory1 | cambiar el propietario de un directorio y de todos los ficheros y directorios contenidos dentro.
|chgrp group1 file1 | cambiar grupo de ficheros.
|chown user1:group1 file1 | cambiar usuario y el grupo propietario de un fichero.
|find / -perm -u+s | visualizar todos los ficheros del sistema con SUID configurado.
|chmod u+s /bin/file1 | colocar el bit SUID en un fichero binario. El usuario que corriendo ese fichero adquiere los mismos privilegios como dueño.
|chmod u-s /bin/file1 | deshabilitar el bit SUID en un fichero binario.
|chmod g+s /home/public | colocar un bit SGID en un directorio –similar al SUID pero por directorio.
|chmod g-s /home/public | desabilitar un bit SGID en un directorio.
|chmod o+t /home/public | colocar un bit STIKY en un directorio. Permite el borrado de ficheros solamente a los dueños legítimos.
|chmod o-t /home/public | desabilitar un bit STIKY en un directorio.

###Atributos especiales en ficheros (usar «+» para colocar permisos y «-» para eliminar)
|Comando|Función|
|------|-------|
|chattr +a file1 | permite escribir abriendo un fichero solamente modo append.
|chattr +c file1 | permite que un fichero sea comprimido / descomprimido automaticamente.
|chattr +d file1 | asegura que el programa ignore borrar los ficheros durante la copia de seguridad.
|chattr +i file1 | convierte el fichero en inmutable o invariable, por lo que no puede ser eliminado, alterado, renombrado, ni enlazado.
|chattr +s file1 | permite que un fichero sea borrado de forma segura.
|chattr +S file1 | asegura que un fichero sea modificado, los cambios son escritos en modo synchronous como con sync.
|chattr +u file1 | te permite recuperar el contenido de un fichero aún si este está cancelado.
|lsattr | mostrar atributos especiales.

###Archivos y ficheros comprimidos
|Comando|Función|
|------|-------|
|7za a -mx=9 -ms=on -mhe=on -p archivocomprimido directorio1 archivo1 archivo2 | comprimir un directorio y dos archivos en formato 7zip, con compresión sólida máxima, y protección por contraseña (la extensión 7z se agrega automáticamente).
|7za x archivocomprimido.7z | extraer un archivo comprimido en 7zip (7zip también permite descomprimir otros formatos, como por ejemplo, zip).
|bunzip2 file1.bz2 | descomprime in fichero llamado ‘file1.bz2’.
|bzip2 file1 | comprime un fichero llamado ‘file1’.
|gunzip file1.gz | descomprime un fichero llamado ‘file1.gz’.
|gzip file1 | comprime un fichero llamado ‘file1’.
|gzip -9 file1 | comprime con compresión máxima.
|rar a file1.rar test_file | crear un fichero rar llamado ‘file1.rar’.
|rar a file1.rar file1 file2 dir1 | comprimir ‘file1’, ‘file2’ y ‘dir1’ simultáneamente.
|rar x file1.rar | descomprimir archivo rar.
|unrar x file1.rar | descomprimir archivo rar.
|tar -cvf archive.tar file1 | crear un tarball descomprimido.
|tar -cvf archive.tar file1 file2 dir1 | crear un archivo conteniendo ‘file1’, ‘file2′ y’dir1’.
|tar -tf archive.tar | mostrar los contenidos de un archivo.
|tar -xvf archive.tar | extraer un tarball (si el archivo además está comprimido con gzip, bzip2 o xz, descomprimirlo automáticamente).
|tar -xvf archive.tar -C /tmp | extraer un tarball en /tmp.
|tar -cjvf archive.tar.bz2 dir1 | crear un tarball comprimido en bzip2.
|tar -xjvf archive.tar.bz2 | descomprimir un archivo tar comprimido en bzip2
|tar -cJvf archive.tar.xz dir1 | crear un tarball comprimido en xz.
|XZ_OPT=-9e tar -cJvf archive.tar.xz dir1 | crear un tarball comprimido en xz (con máxima compresión).
|tar -xJvf archive.tar.xz | descomprimir un archivo tar comprimido en xz.
|tar -czvf archive.tar.gz dir1 | crear un tarball comprimido en gzip.
|tar -I pigz -cf archive.tar.gz dir1 | crear un tarball comprimido en gzip, pero utilizando pigz, que comprime en paralelo aprovechando todos los núcleos de los microprocesadores del equipo.
|GZIP=-9 tar -czvf archive.tar.gz dir1 | crear un tarball comprimido en gzip (con máxima compresión).
|tar -xzvf archive.tar.gz | descomprimir un archive tar comprimido en gzip.
|zip file1.zip file1 | crear un archivo comprimido en zip.
|zip -r file1.zip file1 file2 dir1 | comprimir, en zip, varios archivos y directorios de forma simultánea.
|unzip file1.zip | descomprimir un archivo zip.

###Paquetes rpm (Red Hat, Fedora y similares)
|Comando|Función|
|------|-------|
|rpm -ivh package.rpm | instalar un paquete rpm.
|rpm -ivh --nodeeps package.rpm | instalar un paquete rpm ignorando las peticiones de dependencias.
|rpm -U package.rpm | actualizar un paquete rpm sin cambiar la configuración de los ficheros.
|rpm -F package.rpm | actualizar un paquete rpm solamente si este está instalado.
|rpm -e package_name.rpm | eliminar un paquete rpm.
|rpm -qa | mostrar todos los paquetes rpm instalados en el sistema.
|rpm -qa | grep httpd | mostrar todos los paquetes rpm con el nombre “httpd”.
|rpm -qi package_name | obtener información en un paquete específico instalado.
|rpm -qg "System Environment/Daemons" | mostar los paquetes rpm de un grupo software.
|rpm -ql package_name | mostrar lista de ficheros dados por un paquete rpm instalado.
|rpm -qc package_name | mostrar lista de configuración de ficheros dados por un paquete rpm instalado.
|rpm -q package_name --whatrequires | mostrar lista de dependencias solicitada para un paquete rpm.
|rpm -q package_name --whatprovides | mostar la capacidad dada por un paquete rpm.
|rpm -q package_name --scripts | mostrar los scripts comenzados durante la instalación /eliminación.
|rpm -q package_name --changelog | mostar el historial de revisions de un paquete rpm.
|rpm -qf /etc/httpd/conf/httpd.conf | verificar cuál paquete rpm pertenece a un fichero dado.
|rpm -qp package.rpm -l | mostrar lista de ficheros dados por un paquete rpm que aún no ha sido instalado.
|rpm --import /media/cdrom/RPM-GPG-KEY | importar la firma digital de la llave pública.
|rpm --checksig package.rpm | verificar la integridad de un paquete rpm.
|rpm -qa gpg-pubkey | verificar la integridad de todos los paquetes rpm instalados.
|rpm -V package_name | chequear el tamaño del fichero, licencias, tipos, dueño, grupo, chequeo de resumen de MD5 y última modificación.
|rpm -Va | chequear todos los paquetes rpm instalados en el sistema. Usar con cuidado.
|rpm -Vp package.rpm | verificar un paquete rpm no instalado todavía.
|rpm2cpio package.rpm | cpio --extract --make-directories *bin | extraer fichero ejecutable desde un paquete rpm.
|rpm -ivh /usr/src/redhat/RPMS/`arch`/package.rpm | instalar un paquete construido desde una fuente rpm.
|rpmbuild --rebuild package_name.src.rpm | construir un paquete rpm desde una fuente rpm.

###Actualizador de paquetes yum (Fedora, Redhat y otros)
|Comando|Función|
|------|-------|
|yum install package_name | descargar e instalar un paquete rpm.
|yum localinstall package_name.rpm | este instalará un RPM y tratará de resolver todas las dependencies para ti, usando tus repositorios.
|yum update | actualizar todos los paquetes rpm instalados en el sistema.
|yum update package_name | modernizar / actualizar un paquete rpm.
|yum remove package_name | eliminar un paquete rpm.
|yum list | listar todos los paquetes instalados en el sistema.
|yum search package_name | Encontrar un paquete en repositorio rpm.
|yum clean packages | limpiar un caché rpm borrando los paquetes descargados.
|yum clean headers | eliminar todos los ficheros de encabezamiento que el sistema usa para resolver la dependencia.
|yum clean all | eliminar desde los paquetes caché y ficheros de encabezado.

###Gestión de paquetes deb (Debian, Ubuntu y otros)
|Comando|Función|
|------|-------|
|dpkg -i elpaquete.deb | instalar / actualizar un paquete.
|dpkg -r elpaquete | eliminar un paquete deb del sistema.
|dpkg -l | mostrar todos los paquetes deb instalados en el sistema.
|dpkg -l | grep httpd | mostrar todos los paquetes deb con el nombre “httpd”
|dpkg -s elpaquete | obtener información en un paquete específico instalado en el sistema.
|dpkg -L elpaquete | mostar lista de ficheros utilizados por un paquete instalado en el sistema.
|dpkg -c elpaquete.deb | mostrar contenido de un paquete (no necesariamente instalado).
|dpkg -S /bin/ping | verificar a qué paquete pertenece un fichero dado.

###Actualizador de paquetes apt y aptitude (Debian, Ubuntu y otros)
|Comando|Función|
|------|-------|
|apt-get install package_name | instalar / actualizar un paquete deb.
|apt-cdrom install package_name | instalar / actualizar un paquete deb desde un cdrom.
|apt-get update | actualizar la lista de paquetes.
|apt-get upgrade | actualizar todos los paquetes instalados.
|apt-get remove package_name | eliminar un paquete deb del sistema.
|apt-get check | verificar la correcta resolución de las dependencias.
|apt-get clean | limpiar cache desde los paquetes descargados.
|apt-cache search searched-package | retorna lista de paquetes que corresponde a la serie «paquetes buscados».
|aptitude search paquete | busca un paquete por el nombre.
|aptitude search ~dpaquete | busca un paquete por la descripción.
|aptitude show paquete | less | muestra información sobre un paquete.
|aptitude install paquete1 paquete2 … | instala varios paquetes con sus dependencias y recomendaciones.
|aptitude -R install paquete | instala un paquete con sus dependencias, pero sin las recomendaciones.
|aptitude why paquete | lista las razones por las que se debería instalar el paquete.
|aptitude why-not paquete | lista las razones por las que no se puede instalar el paquete.
|aptitude -rsvW install paquete | simula la instalación de un paquete con sus dependencias y recomendaciones, detallando cada una.
|aptitude remove paquete | desinstala un paquete.
|aptitude purge paquete | desinstala un paquete y lo limpia de la cache.
|aptitude clean | limpia la cache de paquetes.
|apt-file -xi search 'sql‘ | busca todos los paquetes que contengan un archivo o directorio con la expresión sql (sin considerar mayúsculas o minúsculas).3)

###Ver el contenido de un fichero
|Comando|Función|
|------|-------|
|cat file1 | ver los contenidos de un fichero comenzando desde la primera línea.
|tac file1 | ver los contenidos de un fichero comenzando desde la última línea.
|more file1 | ver el contenido de un fichero de manera paginada.
|less file1 | parecido al commando ‘more’ pero permite avanzar, retroceder, y buscar (compatible con algunos comandos de vi).
|head -2 file1 | ver las dos primeras líneas de un fichero (ó 10, si no se especifica la cantidad de líneas).
|tail -2 file1 | ver las dos últimas líneas de un fichero (ó 10, si no se especifica la cantidad de líneas).

###Manipulación de texto
|Comando|Función|
|------|-------|
|cat file1 file2 … | command <> file1_in.txt_or_file1_out.txt | sintaxis general para la manipulación de texto utilizando PIPE, STDIN y STDOUT.
|cat file1 | command( sed, grep, awk, grep, etc…) > result.txt | sintaxis general para manipular un texto de un fichero y escribir el resultado en un fichero nuevo.
|cat file1 | command( sed, grep, awk, grep, etc…) >> result.txt | sintaxis general para manipular un texto de un fichero y añadir resultado en un fichero existente.
|grep Aug /var/log/messages | buscar palabras “Aug” en el fichero ‘/var/log/messages’.
|grep ^Aug /var/log/messages | buscar palabras que comienzan con “Aug” en fichero ‘/var/log/messages’
|grep [0-9] /var/log/messages | seleccionar todas las líneas del fichero ‘/var/log/messages’ que contienen números.
|grep Aug -R /var/log/ | buscar la cadena “Aug” en el directorio ‘/var/log’ y debajo.
|sed 's/string1/string2/g' ejemplo.txt | reemplazar en ejemplo.txt todas las ocurrencias de “string1” con “string2”
|sed '/^$/d' ejemplo.txt | eliminar todas las líneas en blanco desde el ejemplo.txt
|sed '/ *#/d; /^$/d' ejemplo.txt | eliminar comentarios y líneas en blanco de ejemplo.txt
|echo 'ejemplo' | tr '[:lower:]' '[:upper:]‘ | convertir “ejemplo” de minúsculas a mayúsculas.
|sed -e '1d' ejemplo.txt | elimina la primera línea del fichero ejemplo.txt
|sed -n '/string1/p‘ | visualizar solamente las líneas que contienen la palabra “string1”.
|sed -r 's/(cadena1)(cadena2)/\2\1/g‘ | utilizar expresiones regulares extendidas para intercambiar el orden de dos cadenas de texto, en todas las instancias que aparezcan.

###Establecer caracter y conversión de ficheros
|Comando|Función|
|------|-------|
|dos2unix filedos.txt fileunix.txt | convertir un formato de fichero texto desde MSDOS a UNIX.
|unix2dos fileunix.txt filedos.txt | convertir un formato de fichero de texto desde UNIX a MSDOS.
|recode ..HTML < page.txt > page.html | convertir un fichero de texto en html.
|recode -l | more | mostrar todas las conversiones de formato disponibles.

###Análisis del sistema de ficheros
|Comando|Función|
|------|-------|
|badblocks -v /dev/hda1 | Chequear los bloques defectuosos en el disco hda1.
|fsck /dev/hda1 | reparar / chequear la integridad del fichero del sistema Linux en el disco hda1.
|fsck.ext2 /dev/hda1 | reparar / chequear la integridad del fichero del sistema ext 2 en el disco hda1.
|e2fsck /dev/hda1 | reparar / chequear la integridad del fichero del sistema ext 2 en el disco hda1.
|e2fsck -j /dev/hda1 | reparar / chequear la integridad del fichero del sistema ext 3 en el disco hda1.
|fsck.ext3 /dev/hda1 | reparar / chequear la integridad del fichero del sistema ext 3 en el disco hda1.
|fsck.vfat /dev/hda1 | reparar / chequear la integridad del fichero sistema fat en el disco hda1.
|fsck.msdos /dev/hda1 | reparar / chequear la integridad de un fichero del sistema dos en el disco hda1.
|dosfsck /dev/hda1 | reparar / chequear la integridad de un fichero del sistema dos en el disco hda1.

###Formatear un sistema de ficheros
|Comando|Función|
|------|-------|
|mkfs /dev/hda1 | crear un fichero de sistema tipo Linux en la partición hda1.
|mke2fs /dev/hda1 | crear un fichero de sistema tipo Linux ext 2 en hda1.
|mke2fs -j /dev/hda1 | crear un fichero de sistema tipo Linux ext3 (periódico) en la partición hda1.
|mkfs -t vfat 32 -F /dev/hda1 | crear un fichero de sistema FAT32 en hda1.
|fdformat -n /dev/fd0 | formatear un disco flooply.
|mkswap /dev/hda3 | crear un fichero de sistema swap.

###Partición de sistema swap
|Comando|Función|
|------|-------|
|mkswap /dev/hda3 | crear fichero de sistema swap.
|swapon /dev/hda3 | activando una nueva partición swap.
|swapon /dev/hda2 /dev/hdb3 | activar dos particiones swap.

###Copias de seguridad
|Comando|Función|
|------|-------|
|dump -0aj -f /tmp/home0.bak /home | hacer una copia completa del directorio ‘/home’.
|dump -1aj -f /tmp/home0.bak /home | hacer una copia incremental del directorio ‘/home’.
|restore -if /tmp/home0.bak | restaurando una copia interactivamente.
|rsync -rogpav --delete /home /tmp | sincronización entre directorios.
|rsync -rogpav -e ssh --delete /home ip_address:/tmp | rsync a través del túnel SSH.
|rsync -az -e ssh --delete ip_addr:/home/public /home/local | sincronizar un directorio local con un directorio remoto a través de ssh y de compresión.
|rsync -az -e ssh --delete /home/local ip_addr:/home/public | sincronizar un directorio remoto con un directorio local a través de ssh y de compresión.
|dd bs=1M if=/dev/hda | gzip | ssh user@ip_addr 'dd of=hda.gz‘ | hacer una copia de un disco duro en un host remoto a través de ssh.
|dd if=/dev/sda of=/tmp/file1 | copiar el contenido de un disco duro a un fichero. (En este caso el disco duro es “sda” y el fichero “file1”).
|tar -Puf backup.tar /home/user | hacer una copia incremental del directorio ‘/home/user’.
|tar -czv --exclude=/root/dir1/* -f /var/copias/cfg_$(date +%F_%H%M).tgz /etc /root | copiar los directorios /etc y /root (excluyendo el contenido del subdirectorio /root/dir1/) en un archivo comprimido, cuyo nombre contenga la fecha y hora actual.
|( cd /tmp/local/ && tar c . ) | ssh -C user@ip_addr 'cd /home/share/ && tar x -p‘ | copiar el contenido de un directorio en un directorio remoto a través de ssh.
|( tar c /home ) | ssh -C user@ip_addr 'cd /home/backup-home && tar x -p‘ | copiar un directorio local en un directorio remoto a través de ssh.
|tar cf - . | (cd /tmp/backup ; tar xf - ) | copia local conservando las licencias y enlaces desde un directorio a otro.
|find /home/user1 -name '*.txt' | xargs cp -av --target-directory=/home/backup/ --parents | encontrar y copiar todos los ficheros con extensión ‘.txt’ de un directorio a otro.
|find ~/ -type f -not -iname '*.mp*' -not \( -iregex '.*\.mozilla/.*' -o -iregex '.*\.thumbnails/.*' \) -prune -mtime 14 -print0 | xargs -0 tar -czf /var/copias/myhome.tgz | realizar una copia de todos los archivos de nuestro perfil de usuario modificados dentro de los últimos 14 días, exceptuando los archivos mp3, mpg y similares, y los directorios .mozilla/ y .thumbnails/.
|find /var/log -name '*.log' | tar cv --files-from=- | bzip2 > log.tar.bz2 | encontrar todos los ficheros con extensión ‘.log’ y hacer un archivo bzip.
|dd if=/dev/hda of=/dev/fd0 bs=512 count=1 | hacer una copia del MRB (Master Boot Record) a un disco floppy.
|dd if=/dev/fd0 of=/dev/hda bs=512 count=1 | restaurar la copia del MBR (Master Boot Record) copiada en un floppy.

###CDROM
|Comando|Función|
|------|-------|
|cdrecord -v gracetime=2 dev=/dev/cdrom -eject blank=fast -force | limpiar o borrar un cd regrabable.
|mkisofs /dev/cdrom > cd.iso | crear una imagen iso de cdrom en disco.
|mkisofs /dev/cdrom | gzip > cd_iso.gz | crear una imagen comprimida iso de cdrom en disco.
|mkisofs -J -allow-leading-dots -R -V “Label CD” -iso-level 4 -o ./cd.iso data_cd | crear una imagen iso de un directorio.
|cdrecord -v dev=/dev/cdrom cd.iso | quemar una imagen iso.
|gzip -dc cd_iso.gz | cdrecord dev=/dev/cdrom - | quemar una imagen iso comprimida.
|mount -t udf,iso9660 -o loop cd.iso /mnt/iso | montar una imagen iso.
|cd-paranoia -B | llevar canciones de un cd a ficheros wav.
|cd-paranoia -- ”-3” | llevar las 3 primeras canciones de un cd a ficheros wav.
|cdrecord --scanbus | escanear bus para identificar el canal scsi.
|dd if=/dev/hdc | md5sum | hacer funcionar un md5sum en un dispositivo, como un CD.
|eject -v | expulsar un medio o disco extraíble, ofreciendo información adicional.

###Trabajo con la red (LAN Y WIFI)
|Comando|Función|
|------|-------|
|ifconfig eth0 | mostrar la configuración de una interfaz de red Ethernet.
|ifup eth0 | activar la interfaz eth0.
|ifdown eth0 | deshabilitar la interfaz eth0.
|ifconfig eth0 192.168.1.1 netmask 255.255.255.0 | configurar una dirección IP.
|ifconfig eth0 promisc | configurar eth0 en modo promiscuo para obtener los paquetes (sniffing).
|dhclient eth0 | activar la interface ‘eth0’ en modo dhcp.
|route -n | mostrar tabla de rutas.
|route add -net 0/0 gw IP_Gateway | configurar entrada predeterminada.
|ip route show | grep default | awk {'print $3'} | conocer la puerta de enlace predeterminada.
|route add -net 192.168.0.0 netmask 255.255.0.0 gw 192.168.1.1 | configurar ruta estática para buscar la red 192.168.0.0/16.
|route del 0/0 gw IP_gateway | eliminar la ruta estática.
|echo 1 > /proc/sys/net/ipv4/ip_forward | activar el redireccionamiento de paquetes ip.
|hostname | mostrar el nombre del host del sistema.
|host www.example.com | buscar el nombre del host para resolver el nombre a una dirección ip (1).
|nslookup www.example.com | buscar el nombre del host para resolver el nombre a una direccióm ip y viceversa (2).
|ip link show | mostar el estado de enlace de todas las interfaces.
|mii-tool eth0 | mostar el estado de enlace de eth0.
|ethtool eth0 | mostrar las estadísticas de la interfaz de red eth0.
|netstat -tup | mostrar todas las conexiones de red activas y sus PID.
|netstat -tupl | mostrar todos los servicios de escucha de red en el sistema y sus PID.
|netstat -punta | mostrar todas las conexiones activas por dirección IP y puerto.
|tcpdump tcp port 80 | mostrar todo el tráfico HTTP.
|iwlist scan | mostrar las redes inalámbricas.
|iwconfig eth1 | mostrar la configuración de una interfaz de red inalámbrica.
|whois www.example.com | buscar en base de datos Whois.
|iftop -nNP -i eth0 | mostrar en tiempo real las conexiones abiertas en eth0 y su tasa de transferencia.
|sockstat | mostrar información sobre las conexiones abiertas.
|arp-scan -l | descubrir en la red las direcciones IP y MAC.
|nm-tool | muestra configuración de red (en caso de usar Network Manager obtiene los DNS).

###Redes de Microsoft Windows (Samba)
|Comando|Función|
|------|-------|
|nbtscan ip_addr | resolución de nombre de red bios.
|nmblookup -A ip_addr | resolución de nombre de red bios.
|smbclient -L ip_addr/hostname | mostrar acciones remotas de un host en windows.

###Cortafuegos (iptables)
|Comando|Función|
|------|-------|
|iptables -t filter -L | mostrar todas las cadenas de la tabla de filtro.
|iptables -t nat -L | mostrar todas las cadenas de la tabla nat.
|iptables -t filter -F | limpiar todas las reglas de la tabla de filtro.
|iptables -t nat -F | limpiar todas las reglas de la tabla nat.
|iptables -t filter -X | borrar cualquier cadena creada por el usuario.
|iptables -t filter -A INPUT -p tcp --dport telnet -j ACCEPT | permitir las conexiones telnet para entar.
|iptables -t filter -A OUTPUT -p tcp --dport http -j DROP | bloquear las conexiones HTTP para salir.
|iptables -t filter -A FORWARD -p tcp --dport pop3 -j ACCEPT | permitir las conexiones POP a una cadena delantera.
|iptables -t filter -A INPUT -p tcp -m multiport --dports 80,443,8080 -m state --state NEW -m limit --limit 4/sec --limit-burst 8 -j ACCEPT | establecer un límite de 4 peticiones por segundo de nuevas conexiones, con posibles ráfagas ocasionales (útil para políticas de denegación por defecto).
|iptables -t filter -A INPUT -p tcp -m multiport --dports 80,443,8080 -m state --state ESTABLISHED,RELATED -m connlimit ! --conlimit-above 6 -j ACCEPT | establecer un límite de 6 conexiones simultáneas por equipo a nuestro servidor web (útil para políticas de denegación por defecto).
|iptables -t filter -A INPUT -j LOG --log-prefix “DROP INPUT” | registrando una cadena de entrada.
|iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE | configurar un PAT (Puerto de traducción de dirección) en eth0, ocultando los paquetes de salida forzada. (Indicado para enlaces tipo ppp)
|iptables -t nat -A POSTROUTING -s 192.168.0.127 -o eth0 -j SNAT --to-source 169.158.158.169 | enrutar los paquetes desde 192.168.0.127 hacia otras redes por eth0 y asignarles un dirección ip externa. (Indicado para enlaces tipo ADSL)
|iptables -t nat -A PREROUTING -d 192.168.0.1 -p tcp -m tcp --dport 22 -j DNAT --to-destination 10.0.0.2:22 | redireccionar los paquetes diriguidos de un host a otro.
|iptables -t nat -S | Listar todas las reglas activas en la tabla nat.
|iptables-save -c > archivo | copiar las reglas en un archivo (incluyendo los contadores de paquetes y bytes).
|iptables-restore -c < archivo | Restaurar las reglas desde un archivo (incluyendo los contadores de paquetes y bytes).

###Monitoreando y depurando
|Comando|Función|
|------|-------|
|`top` | mostrar en tiempo real las tareas de linux.
|`htop` | mostrar y gestionar las tareas con una interfaz amistosa.
|`ps -eafw` | muestra las tareas Linux.
|`ps -e -o pid,args --forest` | muestra las tareas Linux en un modo jerárquico.
|`ps -o pid,cmd -ww -C wget` | listar todas las instancias del comando wget con sus argumentos.
|`pstree` | mostrar un árbol sistema de procesos.
|pidof pppd | mostrar el pid del proceso pppd.
|kill -9 ID_Processo | forzar el cierre de un proceso y terminarlo.
|kill -1 ID_Processo | forzar un proceso para recargar la configuración.
|killall Nombre_Proceso | terminar un proceso por el nombre del comando y no por el ID.
|kill -HUP $(ps -A -o state,pid --no-header | grep -e '^[Zz]' | awk '{print $2}' | xargs) | terminar todos los procesos zombies.
|lsof -p $$ | mostrar una lista de ficheros abiertos por procesos.
|lsof /home/user1 | muestra una lista de ficheros abiertos en un camino dado del sistema.
|strace -c ls >/dev/null | mostrar las llamadas del sistema hechas y recibidas por un proceso.
|strace -f -e open ls >/dev/null | mostrar las llamadas a la biblioteca.
|watch -n1 'cat /proc/interrupts‘ | mostrar interrupciones en tiempo real.
|last reboot | mostrar historial de reinicio.
|lsmod | mostrar los módulos del kernel cargados.
|free -m | muestra el estado de la RAM en megabytes.
|smartctl -A /dev/hda | monitorear la fiabilidad de un disco duro a través de SMART.
|smartctl -i /dev/hda | chequear si SMART está activado en un disco duro.
|tail -f /var/log/dmesg | mostrar eventos inherentes al proceso de carga del kernel.
|tail -f /var/log/messages | mostrar los eventos del sistema.
|`multitail --follow-all /var/log/{dmesg,messages}` | mostrar dos registros de eventos en una misma pantalla.

###Seguridad y Cifrado
|Comando|Función|
|------|-------|
|base64 /home/archivo > /home/archivo-codificado | codifica “archivo” en ‘base64’ y lo guarda en /home
|base64 -d /home/archivo-codificado > /home/archivo | decodifica “archivo-codificado” y lo guarda en /home
|openssl req -x509 -nodes -days 3650 -newkey rsa:1024 -out /etc/millave.crt -keyout /etc/millave.key | crea un certificado auto-firmado para cifrar el tráfico web con SSL.
|htpasswd -c -m /etc/apache2/.htpasswd nombreusuario | genera un archivo ‘.htpasswd’ para proteger un sitio web con auntenticación.

##Otros comandos útiles
|Comando|Función|
|------|-------|
|apropos palabraclave | mostrar una lista de comandos que pertenecen a las palabras claves de un programa; son útiles cuando tú sabes qué hace tu programa, pero desconoces el nombre del comando.
|man ping | mostrar las páginas del manual on-line; por ejemplo, en un comando ping, usar la opción ‘-k’ para encontrar cualquier comando relacionado.
|man -t ping | ps2pdf - ping.pdf | convertir las páginas del manual del comando ping en un archivo pdf (para lo cual es necesario haber instalado Ghostscript).
|mkbootdisk --device /dev/fd0 `uname -r` | crear un floppy boteable.
|gpg -c file1 | codificar un fichero con guardia de seguridad GNU.
|gpg file1.gpg | decodificar un fichero con Guardia de seguridad GNU.
|wget -r www.example.com | descargar un sitio web completo.
|wget -c www.example.com/file.iso | descargar un fichero con la posibilidad de parar la descargar y reanudar más tarde.
|echo 'wget -c www.example.com/files.iso' | at 09:00 | Comenzar una descarga a cualquier hora. En este caso empezaría a las 9 horas.
|ldd /usr/bin/ssh | mostrar las bibliotecas compartidas requeridas por el programa ssh.
|alias hh='history‘ | colocar un alias para un commando. En este caso, para invocar el historial con hh.
|chsh | cambiar el comando Shell.
|chsh --list-shells | es un comando adecuado para saber si tienes que hacer remoto en otra terminal.
|who -a | mostrar quien está registrado, e imprimir hora del último sistema de importación, procesos muertos, procesos de registro de sistema, procesos activos producidos por init, funcionamiento actual y últimos cambios del reloj del sistema.
|echo "128*1024*1024" | bc | calcular desde la consola el tamaño en bytes de 128 MiB.
|sudo !! | ejecutar como superusuario el último comando tecleado.
|clear | limpiar la pantalla.
|uncomando > archivodesalida.txt 2>&1 | ejecuta un comando y redirige la salida a un archivo, combinando en este tanto STDOUT como STDERR.
|uncomando > archivodesalida.txt 2> archivoerrores.txt | ejecuta un comando, redirige la salida (STDOUT) a un archivo, y los errores (STDERR) a otro.
|`uncomando | tee archivodesalida.txt` | ejecuta un comando, muestra la salida en la pantalla y simultáneamente la escribe a un archivo.

1) Es preciso ejecutarlo con privilegios de root.

2) Para conocer el límite de argumentos que xargs admite, puede ejecutarse el comando echo | xargs --show-limits

3)Para que este comando funcione, después de instalado el paquete apt-file es necesario invocar el comando apt-file update

##Fish
###Sustituir bash por fish

sudo apt-get install fish

chsh -s /usr/bin/fish

