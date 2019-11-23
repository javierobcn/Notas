#Estructura de carpetas (FHS Filesystem Hierarchy Standard)
|Carpeta|Descripción|
|------|-------|
|**/bin**|binarios esenciales para que linux funcione|
|**/boot**| Imágenes de Kernel, datos del GRUB y todo lo necesario para que Linux arranque.|
|**/dev**|Son devices o dispositivos (si hacemos cat /dev/psaux y movemos el ratón veremos lo que este envía. Ojo aquí con root, un pipe al disco duro podría cepillarse los datos|
|**/etc**|configuraciones de todos los programas que afectan a todos los usuarios passwd → fichero de contraseñas y usuarios del sistema config de Apache, mySQL, Tomcat, Crons del sistema etc… |
|**/home**|directorios personales de cada usuario del sistema|
|**/lib** y **/lib64**|Librerías y librerías de 64 bits|
|**/lost + found**|Al hacer fsck, los trozos de ficheros que se encuentran van aquí|
|**/media** |Aquí se montan los ficheros de un pendrive o hd automaticamente|
|**/mnt**|Viene vacío por defecto y es para que el usuario pueda montar sistemas de archivos|
|**/opt**|Instalacion de programas sin repositorios|
|**/proc**|Es un directorio volatil, pseudo file-system Encontramos números que corresponden a los PID de los procesos por ej. cat /proc/cpuinfo nos dará info acerca de la CPU cat /proc/interrupts dentro de ACPI en un portatil tendremos battery e info de las baterías|
|**/root**|El usuario root es el único que tiene la home separada|
|**/run**|Algunos procesos guardan un PID en /run para evitar que se hagan operaciones simultaneas que puedan afectar al sistema. Por ej. apt-get guarda un fichero aquí para evitar que se ejecuten dos instancias simultaneas y evitar conflictos.|
|**/sbin**|Binarios de superusuario, por ej. subir el firewall, montar un disco etc. operaciones que un usuario raso no puede hacer.|
|**/srv**|Lugar específico de datos que son servidos por el sistema.|
|**/sys**|Una variante de /proc mas evolucionada|
|**/tmp**|un directorio temporal donde todo el mundo puede escribir, muchas apps lo usan para dejar datos temporales y lo podemos usar para dejar datos volátiles. Se borra de forma automática en cada reinicio.|
|**/usr**|Contiene varios subdirectorios:<br/>**/bin** → programas que instalamos adicionalmente.<br/>**/include** y **/lib** → Librerias que no son esenciales para el sistema<br/>**/sbin** → utilidades de red y otras utils sin interfaz por ej. tcpdump, ufw<br/>**/share** → Datos que utiliza el sistema para todos los programas que hemos instalado<br/>**/src** → Archivos de código fuente se colocan aquí<br/>**/local** - **/bin** → Archivos de script que creemos van aquí, datos locales de este servidor.|
|**/var**|almacena datos de caché, registro de apt-get, logs, ficheros físicos de bases de datos, permite diagnosticar el origen de un problema.Otras carpetas dentro de /var son:<br/><br/>**/lib/mysql** → ficheros físicos de la BD<br/>**/log** → Ficheros de registro<br/>**/daemon.log** → ¿Algo no arranca?<br/>**/mail** → correo interno <br/>**/spool** → Tareas a la espera de ser ejecutadas, pool de impresión, correos pendientes, Cron de usuarios|
